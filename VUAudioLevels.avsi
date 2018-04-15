### show VU levels on top of Histogram("audiolevels")
## 2018-04-11 raffriff42

## download this script from:
## https://github.com/raffriff42/AvisynthPlusUtilities

## requires MinMaxAudio
## http://wilbertdijkhof.com/
## http://forum.doom9.org/showthread.php?t=127530

## requires AVS+, Utils-r41.avsi
## https://github.com/raffriff42/AvisynthPlusUtilities

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

#######################################
### show VU levels on top of Histogram("audiolevels")
##
## @ C   - 2 audio channels
## @ label1, label2 - a short identifier; default "L", "R"
## @ cal - set dbfs for "0" VU reading; default -14 
##         (aprox. IEC std: -4VU @ -18dbfs)
##
## NOTE - 'cal' applies to all meters in the script (due to reuse of global variables)
##
## @ return levels added to right side, <=256 pixels wide
##
function VULevelsLeft(clip C, string "label1", string "label2", float "cal")
{
    C
    (C.IsYV24) 
    \ ? Last
    \ : ConvertToYV24
    VULevelsOnly(label1, label2, cal)

    ScaleSize(-1, C.Height, 2)
    MatchColorFormat(C)
    return StackHorizontal(Last, C)
}

#######################################
### show VU levels on top of Histogram("audiolevels")
##
## @ C   - 2 audio channels
## @ label1, label2 - a short identifier; default "L", "R"
## @ cal - set dbfs for "0" VU reading; default -14 
##         (aprox. IEC std: -4VU @ -18dbfs)
##
## NOTE - 'cal' applies to all meters in the script (due to reuse of global variables)
##
## @ return levels added to right side, <=256 pixels wide
##
function VULevelsRight(clip C, string "label1", string "label2", float "cal")
{
    C
    (C.IsYV24) 
    \ ? Last
    \ : ConvertToYV24
    VULevelsOnly(label1, label2, cal)

    ScaleSize(-1, C.Height, 2)
    MatchColorFormat(C)
    return StackHorizontal(C, Last)
}

#######################################
### show VU levels on top of Histogram("audiolevels")
##
## @ C       - 2 audio channels
## @ cal     - set dbfs for "0" VU reading; default -14 
##             (aprox. IEC std: -4VU @ -18dbfs)
## @ size    - if supplied set meter size relative to image height;
##             default auto; 'meter size' means the long dimension
## @ align   - set meter position in 'keypad notation'; default 1 (lower left corner)
## @ turn    - if true, rotate meter 90°; default false
## @ addmode - if true, set [[Overlay]] mode=="add"; default false
## @ opacity - set meter opacity; if 'addmode', default 0.7; else default 0.3 
##
## NOTE - 'cal' applies to all meters in the script (due to reuse of global variables)
##
## @ return Histogram("audiolevels") with VU indicator overlay
##
function VULevelsOverlay(clip C, float "cal", float "size", int "align", 
\           bool "turn", bool "addmode", float "opacity")
{
    C
    Assert(AudioChannels==2,
    \   "VULevelsOverlay: 2 audio channels are required")

    cal   = Default(cal, -14.0)
    asize = (Height<=320)  ? 1.0
    \     : (Height<=480)  ? 0.9
    \     : (Height<=720)  ? 0.7
    \                      : 0.5
    size  = Default(size, asize)
    align = Default(align, 1)
    turn  = Default(turn, false)
    mode  = Default(addmode, false) ? "add" : "blend"
    opac  = Default(opacity, (addmode ? 0.7 : 0.3))

    V = VULevelsOnly("", "", cal)
    
    V = (!turn) ? V 
    \ : V.CropLTRB(0, 0, 24, 42)
    
    V = V.ScaleSize(-1, size*Height, 16, sm="BilinearResize")
    
    V = (!addmode) 
    \ ? V.AddBorders(0, 4, 0, 0)
    \ : V.Limiter(max_luma=155)
    \    .ColorYUV(off_y=(-16), gain_y=0.5, f2c=true)
  
    V = (!turn) ? V : V.TurnRight

    return OverlayAligned(V, align=align, mode=mode, opacity=opac)
}

#######################################
### show VU levels on top of Histogram("audiolevels")
##
## @ C   - 2 audio channels; set video framerate etc
## @ label1, label2 - a short identifier; default "L", "R"
## @ cal - set dbfs for "0" VU reading; default -14 
##         (aprox. IEC std: -4VU @ -18dbfs)
##
## NOTE - 'cal' applies to all meters in the script (due to reuse of global variables)
##
## @ return histogram + vu levels over black, YV12, 256x480
##
function VULevelsOnly(clip C, string "label1", string "label2", float "cal")
{
    label1 = Default(label1, "L")
    label2 = Default(label2, "R")
    global vu_cal = Default(cal, -14.0)

    Assert(C.AudioChannels==2,
    \   "VULevelsOnly: 2 audio channels are required")

    H = BlankClip(C, width=220, height=480, pixel_type="YV12")
    \   .AudioDub(C)
    \   .Histogram("audiolevels")
    \   .Tweak(sat=0.5)
#return H

    global vu_fps = 30 ## (60|30)

    frnum = C.FrameRateNumerator
    if (vu_fps==60) {
        frnum = (C.FrameRate<22.0) ? 3 * frnum
        \     : (C.FrameRate<33.0) ? 2 * frnum
        \     : frnum
    }
    else {
        ## 30 FPS
        frnum = C.FrameRateNumerator
        frnum = (C.FrameRate<22.0) ? frnum * 2
        \     : (C.FrameRate>44.0) ? frnum / 2
        \     : frnum
    }
    H = H.ChangeFPS(frnum, C.FrameRateDenominator)

    global vu_ch1x =  48
    global vu_midx =  90
    global vu_ch2x = 134

    global vu_size1   = 18.0  ## label fontsize
    global vu_size2   = 24.0  ## indicator fontsize
    global vu_size3   = 60.0  ## indicator fontwidth
    global vu_yoffset = 0
    
    global vu_ind_pre = vu_indicator_prerender(H)
#return vu_ind_pre

    ScriptClip(H, """

        dbfs    =  96.0
        maxluma = 168.0

        xv10 = 0.0   xv11 = 0.0   xv12 = 0.0
        yv10 = 0.0   yv11 = 0.0   yv12 = 0.0
        xv20 = 0.0   xv21 = 0.0   xv22 = 0.0
        yv20 = 0.0   yv21 = 0.0   yv22 = 0.0

        alow1 = 0.0  ## lowpass result
        alow2 = 0.0  ##      ' '

        init_n = (vu_fps==60) ? -16 : -8
        for (n=init_n, 0) {

            cc    = Slip(n)
            afrm1 = cc.GetChannel(1).AudioRMS
            afrm2 = cc.GetChannel(2).AudioRMS

            afrm1 = Pow(10.0, afrm1/20.0) ## log to lin
            afrm2 = Pow(10.0, afrm2/20.0) ##   ' '
            afrm1 = Pow(afrm1, 0.5)       ## rms to avg
            afrm2 = Pow(afrm2, 0.5)       ##   ' '

            ## Digital filter designed by mkfilter/mkshape/gencode A.J. Fisher
            ## Command line: /www/usr/fisher/helpers/
            ##    mkfilter -Bu -Lp -o 2 -a 1.95e-02 0.0 -l 
            if (vu_fps==60) {
                ffg = 289.849123
                ffa = 1.04 * -0.840909 ## tweak for overshoot
                ffb = 1.82711
            }
            else {
                ## 30 FPS
                ffg = 78.8066346
                ffa = 1.18 * -0.707778 ## tweak for overshoot
                ffb = 1.65702
            }
            
            xv10 = xv11
            xv11 = xv12
            xv12 = afrm1 / ffg
            yv10 = yv11
            yv11 = yv12
            yv12 = (xv10 + xv12)
            \     + 2 * xv11
            \     + (ffa * yv10)
            \     + (ffb * yv11)
            alow1 = yv12

            xv20 = xv21
            xv21 = xv22
            xv22 = afrm2 / ffg
            yv20 = yv21
            yv21 = yv22
            yv22 = (xv20 + xv22)
            \     + 2 * xv21
            \     + (ffa * yv20)
            \     + (ffb * yv21)
            alow2 = yv22
        }
        alow1 = Max(0.0, alow1)
        alow2 = Max(0.0, alow2)
        alow1 = 20.0 * Log10(alow1) ## lin to log
        alow2 = 20.0 * Log10(alow2) ##   ' '

        ## calibration
        if (vu_fps==60) {
            vu_lvl1  = Max(-dbfs, 2*alow1 + 20.0 - vu_cal) 
            vu_lvl2  = Max(-dbfs, 2*alow2 + 20.0 - vu_cal) 
        }
        else {
            ## 30 FPS
            vu_lvl1  = Max(-dbfs, 2*alow1 + 18.0 - vu_cal) 
            vu_lvl2  = Max(-dbfs, 2*alow2 + 18.0 - vu_cal) 
        }

        ## VU reading
        ch1mark = vu_ind_pre.Trim(Round(2.0*vu_lvl1)+192, length=1)
        ch2mark = vu_ind_pre.Trim(Round(2.0*vu_lvl2)+433, length=1)
        
        Overlay(ch1mark, mask=ch1mark.ExtractA)
        Overlay(ch2mark, mask=ch2mark.ExtractA)
        return Last
    """)

    (FrameRateNumerator==C.FrameRateNumerator) ? Last
    \ : ChangeFPS(C)

    CropLTWH(0, 0, 256, 0)

    ## add VU scale
    scale = VUbase(C, vu_cal).Loop(-1)
    Overlay(scale, mode="lighten")

    return Last
}

##################################
### creates an RGB32 animation of indicator position for later use
##
## channel 1: r = Trim(Round(2.0*vu_lvl)+192, length=1)
##   frame   0: -96 VU
##   frame 192:   0 VU 
##   frame 240: +24 VU
## channel 2: r = Trim(Round(2.0*vu_lvl)+433, length=1)
##   frame 241: -96 VU
##   frame 433:   0 VU 
##   frame 481: +24 VU
##
function vu_indicator_prerender(clip C)
{
    BlankClip(C, pixel_type="RGB32", color=$0)
    R = Animate(0, 240, "vu_indicator", 1, -96.0, 1, 24.0).Trim(0, length=241)
    \ + Animate(0, 240, "vu_indicator", 2, -96.0, 2, 24.0).Trim(0, length=241)
    return R #.ShowAlpha

    function vu_indicator(clip C, int channel, float vu_lvl)
    {
        #global vu_cal     = 
        #global vu_size1   = 
        #global vu_size2   =   ## indicator fontsize
        #global vu_size3   =   ## indicator fontwidth
        #global vu_yoffset = 
        #global vu_ch1x    = 
        #global vu_ch2x    = 

        ## pointer color
        cptr = (vu_lvl<0.5) ? $e0e0e0   
        \    : (vu_lvl<3.5) ? $f0f000 
        \                   : $ff8c00
        #tcolr = $e0e0e0
        #tcolr_red = $ff8c00
        #tcolr_yel = $e0e000
        cnul = $ff000000 ## transparent  

        indy = vu_yposition(C, vu_lvl, vu_cal)
        indx = (channel==2) ? vu_ch2x : vu_ch1x

        C
        ## indicator
        Subtitle("-", size=vu_size2, font_width=vu_size3, 
        \   x=indx, y=indy-vu_yoffset,
        \   text_color=cptr, halo_color=cnul)

        ## indicator mask/alpha
        M = C.BlankClip(pixel_type="YV12")
        \    .Subtitle("-", size=vu_size2, font_width=vu_size3, 
        \         x=indx, y=indy-vu_yoffset,
        \         text_color=$ffffff, halo_color=cnul)
        \     .ColorYUV(levels="TV->PC")

        return (vu_lvl<=(-60)) ? C
        \ : MergeARGB(M, Last, Last, Last)
        \   .Subtitle(String(vu_lvl, "%0.1f"))
    }
}

#############################################
### static clip with scale labels
##
## @ vu_cal   - set 0 VU == 'cal' dbfs
##
function VUbase(clip C, float vu_cal)
{
    BlankClip(C, length=1, width=256, pixel_type="YV24")    

    xpos  = 24 + vu_midx
    align = 5
    scalehgt = Float(C.Height)
    yadj  = (vu_size2-vu_size1)*0.67 + 16.0
    tcolr = $e0e0e0
    tcolr_grn = $8cf08c
    
    Subtitle("+12", size=vu_size1, x=xpos, align=align, 
    \   y=vu_yposition(12.0, vu_cal)+yadj,
    \   text_color=tcolr, halo_color=$0)

    Subtitle("+6", size=vu_size1, x=xpos, align=align, 
    \   y=vu_yposition(6.0, vu_cal)+yadj,
    \   text_color=tcolr, halo_color=$0)
    
    Subtitle("0VU", size=vu_size1, x=xpos, align=align,
    \   y=vu_yposition(0.0, vu_cal)+yadj,
    \   text_color=tcolr_grn, halo_color=$0)

    Subtitle("-6", size=vu_size1, x=xpos, align=align,
    \   y=vu_yposition(-6.0, vu_cal)+yadj,
    \   text_color=tcolr, halo_color=$0)
    
    Subtitle("-12", size=vu_size1, x=xpos, align=align,
    \   y=vu_yposition(-12.0, vu_cal)+yadj,
    \   text_color=tcolr, halo_color=$0)
    
    Subtitle("-24", size=vu_size1, x=xpos, align=align,
    \   y=vu_yposition(-24.0, vu_cal)+yadj,
    \   text_color=tcolr, halo_color=$0)
    
    Subtitle("-36", size=vu_size1, x=xpos, align=align,
    \   y=vu_yposition(-36.0, vu_cal)+yadj,
    \   text_color=tcolr, halo_color=$0)
    
    Subtitle("-48", size=vu_size1, x=xpos, align=align,
    \   y=vu_yposition(-48.0, vu_cal)+yadj,
    \   text_color=tcolr, halo_color=$0)
    
    Subtitle("-60", size=vu_size1, x=xpos, align=align,
    \   y=vu_yposition(-60.0, vu_cal)+yadj,
    \   text_color=tcolr, halo_color=$0)

    return Last
}

#############################################
function vu_yposition(clip C, float vu_lvl, float vu_cal) 
{
    scalehgt = 480.0
    ptr_cal = -6.5
    return scalehgt - ((scalehgt + 5.0*vu_cal) + (5.0*(vu_lvl + ptr_cal)))
}

__END__

