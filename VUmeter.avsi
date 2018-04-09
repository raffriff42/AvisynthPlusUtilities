### analog VU meter emulator 
## 2018-04-06 raffriff42
## 2018-04-08 speedup, drop shadow, Asserts

## download this script from:
## https://forum.doom9.org/showthread.php?t=175370
## https://github.com/raffriff42/AvisynthPlusUtilities

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

global g_vu_dark = ScriptDir + "\VUmeter-blank-09.png" ## dark  BG
global g_vu_lite = ScriptDir + "\VUmeter-blank-11.png" ## white BG
#global g_vu_lite = ScriptDir + "\VUmeter-blank-05.png" ## white (vuplayer.com)

##################################
### show a VU meter
##
## @ C        - source of audio, framerate and duration (and nothing else)
##              (call GetChannel(n) to meter a single channel)
## @ name     - a short name; required - MUST be a valid AviSynth variable name, or "" (empty)
##              (suggest "L" for left channel, "R" for right, etc)
## @ cal      - set dbfs for "0" VU reading; default -14 
##              (aprox. IEC std: -4VU @ -18dbfs)
## @ dark     - default false, if true, show white-on-dark-background style meter
##            
## @ showcal  - default true; if false, do NOT note calibration on VU meter
## @ showname - default true; if false, do NOT show name on VU meter
## @ showpeak - always true
## @ shownums - default false; if true, show digital readout of peak level (like Histogram)
##
## NOTE - all options except 'name' apply to all meters in the script (due to reuse of global variables)
##
## @ returns 304x190 clip, RGB32
##
function VUmeter(clip C, string name, float "cal", bool "dark",
\               bool "showcal", bool "showname", bool "showpeak", bool "shownums")
{
    showcal  = Default(showcal,  true)
    showname = Default(showname, true)
    showpeak = Default(showpeak, true)
    
    global vu_dark = Default(dark, false)
    global vu_cal  = Default(cal,  -14.0)
    global vu_nums = Default(shownums, false)

    I = ImageSource(vu_dark ? g_vu_dark : g_vu_lite)

    frnum = C.FrameRateNumerator
    frnum = (C.FrameRate<22.0) ? 3 * frnum
    \     : (C.FrameRate<33.0) ? 2 * frnum
    \     : frnum

    I = I.Trim(0, length=1)
    \    .Loop(C.FrameCount)
    \    .ChangeFPS(frnum, C.FrameRateDenominator)
    \    .AudioDub(C)
    ## size 304x190
    ## pivot @ 150, 177
    Assert(IsClip(I), "VUmeter: internal error 3")

    global N_pre = needle_prerender(I, vu_dark)
    Assert(IsClip(N_pre), "VUmeter: internal error 4")
#return N_pre

    F_pre = 
    \   face_prerender(I, name, vu_cal, vu_dark, showcal, showname, showpeak, 0)
    \ + face_prerender(I, name, vu_cal, vu_dark, showcal, showname, showpeak, 1)
    \ + face_prerender(I, name, vu_cal, vu_dark, showcal, showname, showpeak, 2)
    \ + face_prerender(I, name, vu_cal, vu_dark, showcal, showname, showpeak, 3)
    Assert(IsClip(F_pre), "VUmeter: internal error 5")
    Eval("global " + name + "_F_pre = F_pre")
#return Eval("L_F_pre")

    ScriptClip(I, """
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

        Assert(IsClip, "VUmeter: internal error 7")
        xv0 = 0.0   xv1 = 0.0   xv2 = 0.0
        yv0 = 0.0   yv1 = 0.0   yv2 = 0.0
        alow = 0.0 ## lowpass result
        for (n=(-16), 0) {
            afrm = Slip(n).AudioRMS
            afrm = Pow(10.0, afrm/20.0) ## log to lin
            afrm = Pow(afrm, 0.5)       ## rms to avg

            ## Digital filter designed by mkfilter/mkshape/gencode A.J. Fisher
            ## Command line: /www/usr/fisher/helpers/
            ##    mkfilter -Bu -Lp -o 2 -a 1.95e-02 0.0 -l 
            ## (manually tweaked to obtain overshoot)
            xv0 = xv1
            xv1 = xv2
            xv2 = afrm / 289.849123
            yv0 = yv1
            yv1 = yv2
            yv2 = (xv0 + xv2)
            \     + 2 * xv1
            \     + (-0.8750 * yv0)
            \     + ( 1.8271 * yv1)
            alow = yv2
        }
        alow = Max(0.0, alow)
        alow = 20.0 * Log10(alow) ## lin to log

        ## calibrate: set 0 VU == 'cal' dbfs
        vu_level = 2*alow - vu_cal + 19.5 

        ## backgound "faceplate" with prerendered peak LED's
        amax = AudioMax
        B = (amax>(-1.99)) ? """ + name + """_F_pre.Trim(3, length=1)
        \ : (amax>(-3.99)) ? """ + name + """_F_pre.Trim(2, length=1)
        \ : (amax>(-5.99)) ? """ + name + """_F_pre.Trim(1, length=1)
        \                  : """ + name + """_F_pre.Trim(0, length=1)
        B = B.Loop(FrameCount)

        Assert(IsClip(B), "VUmeter: internal error 8")
        return vu_show(B, vu_level, amax, vu_nums)
    """)

    Assert(IsClip, "VUmeter: internal error 9")
    (FrameRateNumerator==C.FrameRateNumerator) ? Last
    \ : ChangeFPS(C)
    return Last.Trim(0, length=C.FrameCount)
}

##################################
function vu_show(clip B, float avg, float peak, bool shownums)
{
    aavg   = Float(Min(Max(-40, avg), 20))
    apeak  = peak
    cnul   = $ff000000 ## transparent color

    B
    ## numeric readout
    anum = Max(-96.0, peak)
    (!shownums) ? Last
    \ : Subtitle(String(anum, "%0.1f"), size=28,
    \       text_color=$808080, halo_color=cnul,
    \       align=3, x=172, y=106)

    ## VU needle prerender
    ## (frame 0: 55deg left; frame 55: 0deg; frame 110: 55deg right)
    N = N_pre.Trim(-Round(db_to_deflection(aavg))+55, length=1)
    
    Overlay(N, mask=N.ShowAlpha)
    return Last
}

##################################
### creates an RGB32 animation of needle deflection
##
## frame 0: 55deg left; frame 55: 0deg; frame 110: 55deg right
##
function needle_prerender(clip C, bool dark)
{
    BlankClip(C, pixel_type="RGB32", color=$0)
    Animate(0, 110, "needle", 
    \   -55, dark, 
    \   55, dark)
    return Trim(0, length=111) #.ShowAlpha

    function needle(clip C, int angle, bool dark)
    {
        pivx = 150 ## pivot point
        pivy = 177 ##    ' ' 
        offx = 2   ## shadow offset
        offy = 6   ##    ' '

        cpt1 = (dark ? $c04040 : $0)        ## pointer color
        cpt2 = transparent_color(0.5, cpt1) ## pointer border
        cnul = $ff000000                    ## transparent

        ## needle
        N = C.subtitle_alpha("l", 
        \         size=210, font_width=3, align=5, x=pivx, y=pivy,
        \         text_color=cpt1, halo_color=cpt2,
        \         font_angle=Float(-angle))
        
        ## drop shadow
        DS = C.Subtitle("l", 
        \         size=210, font_width=20, align=5, x=pivx+offx, y=pivy+offy,
        \         text_color=$0, halo_color=cnul,
        \         font_angle=Float(-angle))
        \     .Blur(1.0).Blur(1.0).Blur(1.0)

        ## drop shadow alpha
        ds_alpha = (dark) ? $454545 : $454545
        DA = C.BlankClip(pixel_type="YV12")
        \     .Subtitle("l", 
        \         size=210, font_width=20, align=5, x=pivx+offx, y=pivy+offy,
        \         text_color=ds_alpha, halo_color=cnul,
        \         font_angle=Float(-angle))
        \     .Blur(1.0).Blur(1.0).Blur(1.0)
        \     .ColorYUV(levels="TV->PC")

        M = Overlay(
        \   N.ShowAlpha("YV12"), 
        \   DA, 
        \   mode="add")

        N2 = Overlay(DS, N, mode="lighten", mask=M)

        return MergeARGB(M, N2, N2, N2)
        #\ .Subtitle(String(angle))
    }
}

##################################
### 1-frame clip showing the "faceplate" with selected number of peak LED's lit
##
## @ showpeak - always TRUE (to support FALSE, need to create faceplate images without bezels)
##
function face_prerender(clip C, string name, float cal, bool dark, 
\           bool showcal, bool showname, bool showpeak, int peak)
{
    ctxt = $707070   ## text
    cnul = $ff000000 ## transparent color

    cred = $e00000   ## LED red
    cyel = $e0e000   ## LED yellow
    coff = $101030   ## LED off

    pksz = 14.0      ## LED size
    fcir = "n"       ## Marlett filled circle

    x1   = 220       ## LED positions
    x2   = x1 + (1 * 22)
    x3   = x1 + (2 * 22)
    y1   = 116.5
    y2   = y1
    y3   = y1

    C
    ## channel name
    (!showname) ? Last
    \ : Subtitle(name, size=36, x=24, y=100, 
    \       text_color=ctxt, halo_color=cnul)

    ## calibration
    scal = String(cal, "%0.0f dbfs = 0 VU")
    (!showcal) ? Last
    \ : Subtitle(scal, size=12, x=24, y=Height-12,
    \       text_color=ctxt, halo_color=cnul)

    ## peak indicators     
    (peak<1) ? Last
    \ : Subtitle(fcir, font="Marlett", size=pksz,
    \       text_color=cyel, halo_color=cnul,
    \       x=x1, y=y1, align=5)

    (peak<2) ? Last
    \ : Subtitle(fcir, font="Marlett", size=pksz,
    \       text_color=cyel, halo_color=cnul,
    \       x=x2, y=y2, align=5)

    (peak<3) ? Last
    \ : Subtitle(fcir, font="Marlett", size=pksz,
    \       text_color=cred, halo_color=cnul,
    \       x=x3, y=y3, align=5)
    return Trim(0, length=1)
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

##################################
### Like Subtitle, but with alpha information
## All arguments are identical to Subtitle, except:
## @ C          - must be RGB32
## @ halo_width - if < 1, halo is disabled;
##                 if >= 1, same as standard Subtitle halo. 
##                 (default = 1)
##
## @ returns RGB32 subtitle with mask channel
##
function subtitle_alpha(clip C, string text, float "x", float "y", 
\                int "first_frame", int "last_frame", 
\                string "font", int "size",
\                int "text_color", int "halo_color", 
\                int "align", int "spc", int "lsp", 
\                float "font_width", float "font_angle",
\                bool "interlaced", int "halo_width") 
{
    Assert(C.IsRGB32, 
    \   "subtitle_alpha: source clip must be RGB32") 

    text_color  = Default(text_color, $ffff00)
    halo_color  = Default(halo_color, $0)
    halo_width  = Default(halo_width, 1)

    text_alpha = text_color.BitRShiftU(24).BitAnd($ff)
    halo_alpha = halo_color.BitRShiftU(24).BitAnd($ff)

    R = C.Subtitle(text, x, y, first_frame, last_frame, 
    \           font, size, text_color, halo_color, align, 
    \           spc, lsp, font_width, font_angle, interlaced)

    text_color  = MakeRGBA(text_alpha, text_alpha, text_alpha, $0)
    halo_color  = MakeRGBA(halo_alpha, halo_alpha, halo_alpha, $0)
    
    M = C.BlankClip(pixel_type="YV12")
    \    .Subtitle(text, x, y, first_frame, last_frame,
    \           font, size, $ffffff, (halo_width<1 ? $0 : $ffffff), align, 
    \           spc, lsp, font_width, font_angle, interlaced)
    \    .ColorYUV(levels="TV->PC")

    return MergeARGB(M, R, R, R)
}

#######################################
### given 'R', 'G', 'B', 'A' return an Avisynth color
##
function MakeRGBA(int r, int g, int b, int a) {

    r = Min(Max(0, r), 255)
    g = Min(Max(0, g), 255)
    b = Min(Max(0, b), 255)
    a = Min(Max(0, a), 255)

    return   a.BitLShift(24)
    \ .BitOr(r.BitLShift(16))
    \ .BitOr(g.BitLShift(8))
    \ .BitOr(b)
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

#####
