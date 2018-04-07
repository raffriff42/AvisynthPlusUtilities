### analog VU meter emulator 
## 2018-04-06 raffriff42

## requires MinMaxAudio
## http://wilbertdijkhof.com/
## http://forum.doom9.org/showthread.php?t=127530

## VU meter references:
## https://en.wikipedia.org/wiki/VU_meter
## https://fr.wikipedia.org/wiki/VU-m%C3%A8tre
## http://www.aes.org/par/v/#VU_meter
## IEC 60268-17
## https://quod.lib.umich.edu/cgi/p/pod/dod-idx/audio-signal-visualisation-and-measurement.pdf
##     ?c=icmc;idno=bbp2372.2014.206;format=pdf
##
## meter ballistics emulated with a 2nd order Butterworth low-pass filter
## https://en.wikipedia.org/wiki/Butterworth_filter
## Digital filter designed by mkfilter/mkshape/gencode
## http://www-users.cs.york.ac.uk/~fisher/mkfilter

global g_vu_lite = ScriptDir + "\VUmeter-blank-05.png" ## white BG
global g_vu_dark = ScriptDir + "\VUmeter-blank-09.png" ## dark  BG

##################################
### show a VU meter
##
## @ C        - source of audio, framerate and duration (and nothing else)
##              (call GetChannel(n) to meter a single channel)
## @ name     - a short name; required
## @ showname - default true; if false, do NOT show name on VU meter
## @ showpeak - default true; if false, do NOT light peak-sensing "LEDs"
## @ shownums - default false; if true, show digital readout of peak level (like Histogram)
## @ dark     - default false, if true, show white-on-dark-background style meter
## @ cal      - set dbfs for "0" VU reading; default -18
##              (for IEC standard -4VU @ -18dbfs (?), set 'cal' to -22)
##
## @ returns 304x190 clip, RGB32
##
function VUmeter(clip C, string name, bool "showname", bool "showpeak", bool "shownums", bool "dark", float "cal")
{
    showname = Default(showname, true)
    seval = ("""
    global pxx = Default(showpeak, true)
    global nxx = Default(shownums, false)
    global dxx = Default(dark, false)
    global cxx = Default(cal,  -18.0)
    I = ImageSource(dxx ? g_vu_dark : g_vu_lite)
    """)
    \ .ReplaceStr("pxx", name+"_pxx")
    \ .ReplaceStr("nxx", name+"_nxx")
    \ .ReplaceStr("dxx", name+"_dxx")
    \ .ReplaceStr("cxx", name+"_cxx")
    Eval(seval)

    frnum = C.FrameRateNumerator
    frnum = (C.FrameRate<22.0) ? 3 * frnum
    \     : (C.FrameRate<33.0) ? 2 * frnum
    \     : frnum

    I = I.Trim(0, length=1)
    \    .Loop(C.FrameCount)
    \    .AssumeFPS(frnum, C.FrameRateDenominator)
    \    .AudioDub(C)
    ## size 304x190
    ## pivot @ 150, 177

    sscript = ("""
    ## specs: analog levels
    ## - Reference Level (typically +4dBu, valid with tones only)
    ## - Standard Output Level (10dB above Reference, typical peak levels)
    ## - Clip Level (6dB above Standard Output Level, "headroom")
    ## - average (sqrt of rms)

    ## specs: ballistics
    ## - rising to 99% of "0VU" w/ 1 kHz sine wave for 300 ms
    ## - fall time same as rise time
    ## - overshoot not less than 1% and not more than 1.5%
    ## (tr ~= 0.35/BW) 
    ## (BW ~= 0.35/tr ~= 1.167 Hz)

    xv0 = 0.0   xv1 = 0.0   xv2 = 0.0
    yv0 = 0.0   yv1 = 0.0   yv2 = 0.0
    alow = 0.0 ## lowpass result
    for (n=(-16), 0) {
        afrm = Slip(n).AudioRMS
        afrm = Pow(10.0, afrm/20.0) ## log to lin
        afrm = Pow(afrm, 0.5)       ## rms to avg

        ## Digital filter designed by mkfilter/mkshape/gencode A.J. Fisher
        ## Command line: /www/usr/fisher/helpers/
        ##    mkfilter -Bu -Lp -o 2 -a 1.9500000000e-02 0.0000000000e+00 -l 
        ## (manually tweaked to obtain overshoot)
        xv0 = xv1
        xv1 = xv2
        xv2 = afrm / 289.849123
        yv0 = yv1
        yv1 = yv2
        yv2 = (xv0 + xv2)
        \     + 2 * xv1
        \     + (-0.8800 * yv0)
        \     + ( 1.8271 * yv1)
        alow = yv2
    }
    alow = Max(0.0, alow)
    alow = 20.0 * Log10(alow) ## lin to log

    ## calibrate: set 0 VU == 'cal' dbfs
    zfs = -18.0
    vu_level = alow - zfs/2.0 + 28.7 + cxx

    amax = AudioMax
    return vu_show(vu_level, (pxx ? amax : 0.0), nxx, dxx)
    """)
    \ .ReplaceStr("pxx", name+"_pxx")
    \ .ReplaceStr("nxx", name+"_nxx")
    \ .ReplaceStr("dxx", name+"_dxx")
    \ .ReplaceStr("cxx", name+"_cxx")

    ScriptClip(I, sscript)

    (FrameRateNumerator==C.FrameRateNumerator) ? Last
    \ : ChangeFPS(C)

    ctxt = $707070   ## text
    cnul = $ff000000 ## transparent color

    (!showname) ? Last
    \ : Subtitle(name, size=36, x=24, y=100, 
    \       text_color=ctxt, halo_color=cnul)

    scal = String(Default(cal,  -18.0), "%0.0f dbfs = 0 VU")
    Subtitle(scal, size=12, x=24, y=Height-10,
    \       text_color=ctxt, halo_color=cnul)
    
    return Last
}

##################################
function vu_show(clip C, float avg, float peak, bool shownums, bool dark)
{
    aavg    = Float(Min(Max(-40, avg), 20))
    apeak   = peak
    shownum = shownums
    #dark    = dark

    cpt1 = (dark ? $c04040 : $0)        ## pointer color
    cpt2 = transparent_color(0.5, cpt1) ## pointer border
    cred = $e00000   ## LED red
    cyel = $e0e000   ## LED yellow
    coff = $101030   ## LED off
    cnul = $ff000000 ## transparent color
    pksz = 14.0      ## LED size
    fcir = "n"       ## Marlett filled circle

    pivx = 150       ## pivot point, x
    pivy = 177       ## pivot point, y
    x1   = 220       ## LED's
    x2   = x1 + (1 * 22)
    x3   = x1 + (2 * 22)
    y1   = 116.5
    y2   = y1
    y3   = y1

    R = C

    ## numeric readout
    anum = Max(-96.0, peak)
    R = (!shownum) ? R
    \ : R.Subtitle(String(anum, "%0.1f"), size=28,
    \         text_color=$808080, halo_color=cnul,
    \         align=3, x=172, y=106)

    ## peak indicators     
    R = (peak<(-6)) ? R 
    \ : R.Subtitle(fcir, font="Marlett", size=pksz,
    \         text_color=cyel, halo_color=cnul,
    \         x=x1, y=y1, align=5)

    R = (peak<(-4)) ? R 
    \ : R.Subtitle(fcir, font="Marlett", size=pksz,
    \         text_color=cyel, halo_color=cnul,
    \         x=x2, y=y2, align=5)

    R = (peak<(-2)) ? R 
    \ : R.Subtitle(fcir, font="Marlett", size=pksz,
    \         text_color=cred, halo_color=cnul,
    \         x=x3, y=y3, align=5)

    ## VU needle
    R = R.Subtitle("l", 
    \         size=210, font_width=3, align=5, x=pivx, y=pivy,
    \         text_color=cpt1, halo_color=cpt2,
    \         font_angle=db_to_deflection(aavg))

    return R
}

##################################
## dB to deflection angle (HACK)
function db_to_deflection(float dblevel)
{
    return Spline(dblevel, 
    \    -40,  55, 
    \    -24,  50, 
    \    -20,  47, 
    \    -10,  34.5, 
    \     -7,  25, 
    \     -5,  16, 
    \     -3,   4, 
    \     -2,  -2.5, 
    \     -1, -10, 
    \      0, -19, 
    \      1, -28, 
    \      2, -38.5, 
    \      3, -49.5, 
    \      5, -54, 
    \     20, -55, 
    \    cubic=false)
}

## Library functions from Utils-r41.avsi
## https://raw.githubusercontent.com/raffriff42/AvisynthPlusUtilities/master/Utils-r41.avsi

#######################################
### "slip" (advance or delay) a clip in time.
##  Adds head or tail padding; clip is normally Trimmed later.
##
## @ C - clip to be advanced or delayed 
## @ offset - if positive, clip is advanced;
##            if negative, clip is delayed
##
function Slip(clip C, int offset)
{
    lenTrim = (offset > 0) ?  offset : 0
    lenPad  = (offset < 0) ? -offset : 0

    C = (lenPad==0) ? C 
    \ : C.Trim(0, -1).Loop(lenPad) + C.Trim(0, C.Framecount-lenPad)

    C = (lenTrim==0) ? C
    \ : C.Trim(lenTrim, 0) + C.Trim(C.Framecount-lenTrim, -1).Loop(lenTrim)
    return C
} 

#######################################
### given Avisynth color, set its transparency
## @ a - 0.0 = transparent, 1.0 = opaque.
##
function transparent_color(float a, int color) {
    a = 255 - Min(Max(0, Round(a * 256.0)), 255)
    return BitOr(a.BitLShift(24), BitAnd(color, $ffffff))
}

####

