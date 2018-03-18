### Simple 'equalizer' style interface for SmoothAdjust/SmoothCurves
## version 2018-03-10 raffriff42
## https://forum.doom9.org/showthread.php?t=175323

## download latest:
##   https://raw.githubusercontent.com/raffriff42/AvisynthPlusUtilities/master/SmoothPoints.avsi

## requires AviSynth+
# http://avisynth.nl/index.php/AviSynth+

### requires Utils-r41.avsi
# http://avisynth.nl/images/Utils-r41.avsi
    #Import("Utils-r41.avsi")

### requires SmoothAdjust
# http://forum.doom9.org/showthread.php?t=154971

    #(FindStr(VersionString, "x86_64") > 0)
    #\   ? LoadPlugin("x64\SmoothAdjust.dll")
    #\   : LoadPlugin("x86\SmoothAdjust.dll")

    #Import(pathBase + "LaTo\SmoothAdjust\SmoothAdjust_loadx64.avsi")

### SmoothCurves interface: Limiter with knee zone
#@ function SmoothPointsLimiter(clip C, 
##\               int "min_luma", int "max_luma", 
##\               int "min_chroma", int "max_chroma",
##\               float "max_sat", int "knee_zone")

### SmoothCurves interface: simple 'x'-point curve (2, 3, 5, 7 or 9 points)
#@ function SmoothPoints2(clip C, 
##\               int blk, 
##\               int wht,
##\               ...etc)
#@ function SmoothPoints3(clip C, 
##\               int blk, 
##\               int mid, 
##\               int wht,
##\               int "midpt",
##\               ...etc)
#@ function SmoothPoints5(clip C, 
##\               int blk, 
##\               int midL, 
##\               int mid, 
##\               int midH, 
##\               int wht,
##\               ...etc)
#@ function SmoothPoints7(clip C, 
##\               int blk, 
##\               int midLL, int midLM, 
##\               int mid, 
##\               int midMH, int midHH, 
##\               int wht,
##\               ...etc)
#@ function SmoothPoints9(clip C, 
##\               int blk, 
##\               int midLL, int midL, int midML, 
##\               int midM, 
##\               int midMH, int midH, int midHH, 
##\               int wht,
##\               ...etc)

## COMMON ARGUMENTS
##\               string "planes", 
##\               int "mode", bool "limiter", int "TVrange", 
##\               int "interp", int "dither", bool "HQ",
##\               int "useMT", int "useOPT", bool "debug", 
##\               int "screenW", int "screenH", bool "scale", bool "lsb"


#######################################
### SmoothCurves interface: Limiter with knee zone
##
## @ C          - source clip; YUV(A) only, 8-16bit. (A is passed unchanged)
## @ min_luma   - Y (luma) lower bound. Default 16d.
## @ max_luma   - Y (luma) upper bound. Default 235d.
## @ min_chroma - U & V (chroma) lower bound. Default 16d.
## @ max_chroma - U & V (chroma) upper bound. Default 240d.
## @ max_sat    - overrides min_chroma, max_chroma: limits maximum ± excursion from 128d.
##                maximum = 1.0, minimum = 0.4; no default.
## @ knee_zone  - Depth of soft-clipping zone. Range 10-32; default 16.
##
## @ lsb        - set to true for Stack16 source; default false
##                 (high bit depth sources processed in Stack16 internally)
##
function SmoothPointsLimiter(clip C, 
\               int "min_luma", int "max_luma", 
\               int "min_chroma", int "max_chroma",
\               float "max_sat", int "knee_zone", bool "lsb")
{
    Assert(C.IsYUV||C.IsYUVA,
    \   "SmoothPointsLimiter: source must be YUV(A)")
    C
    (C.IsYUVA) ? RemoveAlphaPlane : Last

    bits    = BitsPerComponent
    is8bit  = bits==8
    lsb     = Default(lsb, false) && is8bit
    dither  = (is8bit && !lsb) ? 75 : -1

    sat = Min(Max(0.4, Default(max_sat, 1.0)), 1.0)
    cab = Round(sat*128)
    kne = Min(Max(10, Default(knee_zone, 16)), 32)

    yp1 = Min(Max(0, Default(min_luma, 16)), 64)
    yp2 = yp1 + kne
    yp5 = Min(Max(255-64, Default(max_luma, 235)), 255)
    yp4 = yp5 - kne
    yp3 = 126

    cp1 = Min(Max(0, Default(min_chroma, 16)), 64)
    cp1 = !Defined(max_sat) ? cp1 : Min(Max(0, 128-cab), 128-40)
    cp2 = cp1 + kne
    cp5 = Min(Max(255-64, Default(max_chroma, 240)), 255)
    cp5 = !Defined(max_sat) ? cp5 : Min(Max(128+40, 128+cab), 255)
    cp4 = cp5 - kne
    cp3 = 128

    if (is8bit && !lsb) 
    {
        sy = ("0-$p1;$p2-$p2;$p3-$p3;$p4-$p4;255-$p5")
        sy = sy.ReplaceStr("$p1", String(yp1))
        \      .ReplaceStr("$p2", String(yp2))
        \      .ReplaceStr("$p3", String(yp3))
        \      .ReplaceStr("$p4", String(yp4))
        \      .ReplaceStr("$p5", String(yp5))

        sc = ("0-$p1;$p2-$p2;$p3-$p3;$p4-$p4;255-$p5")
        sc = sc.ReplaceStr("$p1", String(cp1))
        \      .ReplaceStr("$p2", String(cp2))
        \      .ReplaceStr("$p3", String(cp3))
        \      .ReplaceStr("$p4", String(cp4))
        \      .ReplaceStr("$p5", String(cp5))

        SmoothCurve(sy, sc, sc,
        \           100, false, 0, 100, dither)
    }
    else 
    {
        (lsb) ? Last : To16bit
        O16=Last
        (lsb) ? Last : ToStack16(swap_planes=true)

        sy = ("0-$p1;$p2-$p2;$p3-$p3;$p4-$p4;65535-$p5")
        sy = sy.ReplaceStr("$p1", Strx257(yp1))
        \      .ReplaceStr("$p2", Strx257(yp2))
        \      .ReplaceStr("$p3", Strx257(yp3))
        \      .ReplaceStr("$p4", Strx257(yp4))
        \      .ReplaceStr("$p5", Strx257(yp5))
#Assert(false, InfoString(sy, "sy"))

        sc = ("0-$p1;$p2-$p2;$p3-$p3;$p4-$p4;65535-$p5")
        sc = sc.ReplaceStr("$p1", Strx257(cp1))
        \      .ReplaceStr("$p2", Strx257(cp2))
        \      .ReplaceStr("$p3", Strx257(cp3))
        \      .ReplaceStr("$p4", Strx257(cp4))
        \      .ReplaceStr("$p5", Strx257(cp5))

        SmoothCurve16(sy, sc, sc,
        \           100, false, 0, 100, dither)

        (lsb) ? Last : FromStack16(O16, swap_planes=true)
        (lsb) ? Last : MatchColorFormat(C)
    }
    (C.IsYUVA) ? AddAlphaPlane(C) : Last
    return Last
}

#######################################
### SmoothCurves interface: simple 2-point 'curve'
##
## @ C       - source clip: RGB(A) or YUV(A) Planar, 8-16bit 
##              (alpha information passed through unchanged)
## @ blk     - black clipping point: < 0 is darker, > 0 is brighter
## @ wht     - white clipping point:  (ditto)
##
## -- A D V A N C E D   A R G U M E N T S -----
## (see SmoothPts for explanation of the other arguments)
##
function SmoothPoints2(clip C, int blk, int wht,
\               string "planes", 
\               int "mode", bool "limiter", int "TVrange", 
\               int "interp", int "dither", bool "HQ",
\               int "useMT", int "useOPT", bool "debug", 
\               int "screenW", int "screenH", bool "scale", bool "lsb")
{
    C
    bits    = BitsPerComponent
    is8bit  = bits==8
    lsb     = Default(lsb, false) && is8bit

    ## de-normalize
    blk     =   0-blk
    wht     = 255-wht

    ## prevent reverse curves
    wht     = Max(blk+8, wht)

    s = ""
    if (is8bit && !lsb) 
    {
        s = (blk<0)   ? "0-$blk"
        \ : (blk>0)   ? "0-0;$blk-0"
        \ :             "0-0"
        s = (wht<255) ? s + ";$wht-255;255-255"
        \ : (wht>255) ? s + ";255-$wh2"
        \ :             s + ";255-255"
        s = s.ReplaceStr("$blk", String(Abs(blk)))
        \    .ReplaceStr("$wht", String(wht))
        \    .ReplaceStr("$wh2", String((255-wht)+255))
    }
    else 
    {
        s = (blk<0)   ? "0-$blk"
        \ : (blk>0)   ? "0-0;$blk-0"
        \ :             "0-0"
        s = (wht<255) ? s + ";$wht-65535;65535-65535"
        \ : (wht>255) ? s + ";65535-$wh2"
        \ :             s + ";65535-65535"
        s = s.ReplaceStr("$blk", Strx257(Abs(blk)))
        \    .ReplaceStr("$wht", Strx257(wht))
        \    .ReplaceStr("$wh2", Strx257((255-wht)+255))
    }
    SmoothPts("SmoothPoints2", s, planes,
    \   mode, limiter, TVrange, interp, dither, HQ, 
    \   useMT, useOPT, debug, screenW, screenH, scale)
    return Last
}

#######################################
### SmoothCurves interface: simple 3-point curve
##
## @ C       - source clip: RGB(A) or YUV(A) Planar, 8-16bit 
##              (alpha information passed through unchanged)
## @ blk     - black clipping point: < 0 is darker, > 0 is brighter
## @ mid     - mid level adjust:      (ditto)
## @ wht     - white clipping point:  (ditto)
## @ midpt   - luma level of max. mid adjustment; default 128.
##             (gently warp the curve towards dark or light)
##
## -- A D V A N C E D   A R G U M E N T S -----
## (see SmoothPts for explanation of the other arguments)
##
function SmoothPoints3(clip C, int blk, int mid, int wht, 
\               int "midpt", string "planes", 
\               int "mode", bool "limiter", int "TVrange", 
\               int "interp", int "dither", bool "HQ",
\               int "useMT", int "useOPT", bool "debug", 
\               int "screenW", int "screenH", bool "scale", bool "lsb")
{
    C
    bits    = BitsPerComponent
    is8bit  = bits==8
    lsb     = Default(lsb, false) && is8bit
    midpt   = Min(Max(40, Default(midpt, 128)), 255-40)

    ## de-normalize
    blk     =   0-blk
    mid     = midpt-mid
    wht     = 255-wht

    ## prevent reverse curves
    mid     = Max(blk+4, mid) 
    wht     = Max(mid+4, wht)

    s = ""
    if (is8bit && !lsb) 
    {
        s = (blk<0)   ? "0-$blk"
        \ : (blk>0)   ? "0-0;$blk-0"
        \ :             "0-0"
        s = s + ";$mid-$mpt"
        s = (wht<255) ? s + ";$wht-255;255-255"
        \ : (wht>255) ? s + ";255-$wh2"
        \ :             s + ";255-255"
        s = s.ReplaceStr("$blk", String(Abs(blk)))
        \    .ReplaceStr("$mid", String(mid))
        \    .ReplaceStr("$mpt", String(midpt))
        \    .ReplaceStr("$wht", String(wht))
        \    .ReplaceStr("$wh2", String((255-wht)+255))
    }
    else 
    {
        s = (blk<0)   ? "0-$blk"
        \ : (blk>0)   ? "0-0;$blk-0"
        \ :             "0-0"
        s = s + ";$mid-$mpt"        
        s = (wht<255) ? s + ";$wht-65535;65535-65535"
        \ : (wht>255) ? s + ";65535-$wh2"
        \ :             s + ";65535-65535"
        s = s.ReplaceStr("$blk", Strx257(Abs(blk)))
        \    .ReplaceStr("$mid", Strx257(mid))
        \    .ReplaceStr("$mpt", Strx257(midpt))
        \    .ReplaceStr("$wht", Strx257(wht))
        \    .ReplaceStr("$wh2", Strx257((255-wht)+255))
    }
    SmoothPts("SmoothPoints3", s, planes,
    \   mode, limiter, TVrange, interp, dither, HQ, 
    \   useMT, useOPT, debug, screenW, screenH, scale)
    return Last
}

#######################################
### SmoothCurves interface: simple 5-point curve
##
## @ C       - source clip: RGB(A) or YUV(A) Planar, 8-16bit 
##              (alpha information passed through unchanged)
## @ blk     - black clipping point: < 0 is darker, > 0 is brighter
## @ midL    - low  ( 64) adjust:     (ditto)
## @ mid     - mid  (128) adjust:     (ditto)
## @ midH    - high (192) adjust:     (ditto)
## @ wht     - white clipping point:  (ditto)
##
## -- A D V A N C E D   A R G U M E N T S -----
## (see SmoothPts for explanation of the other arguments)
##
function SmoothPoints5(clip C, 
\               int blk, int midL, int mid, int midH, int wht,
\               string "planes", 
\               int "mode", bool "limiter", int "TVrange", 
\               int "interp", int "dither", bool "HQ",
\               int "useMT", int "useOPT", bool "debug", 
\               int "screenW", int "screenH", bool "scale", bool "lsb")
{
    C
    bits   = BitsPerComponent
    is8bit = bits==8
    lsb    = Default(lsb, false) && is8bit

    ## de-normalize
    blk   =   0-blk
    midL  =  64-midL
    mid   = 128-mid
    midH  = 192-midH
    wht   = 255-wht

    ## prevent reverse curves
    midL  = Max(blk+2,  midL)
    mid   = Max(midL+2, mid)
    midH  = Max(mid+2,  midH)
    wht   = Max(midH+2, wht)

    s = ""
    if (is8bit && !lsb) 
    {
        s = (blk<0)   ? "0-$blk"
        \ : (blk>0)   ? "0-0;$blk-0"
        \ :             "0-0"
        s = s + ";$midL-64;$midM-128;$midH-192"
        s = (wht<255) ? s + ";$wht-255;255-255"
        \ : (wht>255) ? s + ";255-$wh2"
        \ :             s + ";255-255"
        s = s.ReplaceStr("$blk",  String(Abs(blk)))
        \    .ReplaceStr("$midL", String(midL))
        \    .ReplaceStr("$midM", String(mid))
        \    .ReplaceStr("$midH", String(midH))
        \    .ReplaceStr("$wht",  String(wht))
        \    .ReplaceStr("$wh2",  String((255-wht)+255))
#Assert(false, InfoString(s, "s"))
    }
    else 
    {
        s = (blk<0)   ? "0-$blk"
        \ : (blk>0)   ? "0-0;$blk-0"
        \ :             "0-0"
        s = s + ";$midL-16448;$midM-32896;$midH-49344"
        s = (wht<255) ? s + ";$wht-65535;65535-65535"
        \ : (wht>255) ? s + ";65535-$wh2"
        \ :             s + ";65535-65535"
        s = s.ReplaceStr("$blk",  Strx257(Abs(blk)))
        \    .ReplaceStr("$midL", Strx257(midL))
        \    .ReplaceStr("$midM", Strx257(mid))
        \    .ReplaceStr("$midH", Strx257(midH))
        \    .ReplaceStr("$wht",  Strx257(wht))
        \    .ReplaceStr("$wh2",  Strx257((255-wht)+255))
#Assert(false, InfoString(s, "s"))
    }
    SmoothPts("SmoothPoints5", s, planes,
    \   mode, limiter, TVrange, interp, dither, HQ, 
    \   useMT, useOPT, debug, screenW, screenH, scale)
    return Last
}

#######################################
### SmoothCurves interface: 7-point curve
##
## @ C       - source clip: RGB(A) or YUV(A) Planar, 8-16bit 
##              (alpha information passed through unchanged)
## @ blk     - black clipping point: < 0 is darker, > 0 is brighter
## @ midLL   - low       ( 44) adjust:   (ditto)
## @ midLM   - low-mid   ( 86) adjust:   (ditto)
## @ mid     - mid       (128) adjust:   (ditto)
## @ midMH   - mid-high  (170) adjust:   (ditto)
## @ midHH   - high      (212) adjust:   (ditto)
## @ wht     - white clipping point:     (ditto)
##
## -- A D V A N C E D   A R G U M E N T S -----
## (see SmoothPts for explanation of the other arguments)
##
function SmoothPoints7(clip C, 
\               int blk, int midLL, int midLM, int mid, int midMH, int midHH, int wht,
\               string "planes", 
\               int "mode", bool "limiter", int "TVrange", 
\               int "interp", int "dither", bool "HQ",
\               int "useMT", int "useOPT", bool "debug", 
\               int "screenW", int "screenH", bool "scale", bool "lsb")
{
    C
    bits    = BitsPerComponent
    is8bit  = bits==8
    lsb     = Default(lsb, false) && is8bit

    ## de-normalize
    blk     =   0-blk
    midLL   =  44-midLL
    midLM   =  86-midLM
    mid     = 128-mid
    midMH   = 170-midMH
    midHH   = 212-midHH
    wht     = 255-wht

    ## prevent reverse curves
    midLL   = Max(blk+2,   midLL) 
    midLM   = Max(midLL+2, midLM) 
    mid     = Max(midLM+2, mid) 
    midMH   = Max(mid+2,   midMH) 
    midHH   = Max(midMH+2, midHH) 
    wht     = Max(midHH+2, wht)

    s = ""
    if (is8bit && !lsb) 
    {
        s = (blk<0)   ? "0-$blk"
        \ : (blk>0)   ? "0-0;$blk-0"
        \ :             "0-0"
        s = s + ";$midLL-44;$midLM-86;$midMM-128;$midMH-170;$midHH-212"
        s = (wht<255) ? s + ";$wht-255;255-255"
        \ : (wht>255) ? s + ";255-$wh2"
        \ :             s + ";255-255"
        s = s.ReplaceStr("$blk",   String(Abs(blk)))
        \    .ReplaceStr("$midLL", String(midLL))
        \    .ReplaceStr("$midLM", String(midLM))
        \    .ReplaceStr("$midMM", String(mid))
        \    .ReplaceStr("$midMH", String(midMH))
        \    .ReplaceStr("$midHH", String(midHH))
        \    .ReplaceStr("$wht",   String(wht))
        \    .ReplaceStr("$wh2",   String((255-wht)+255))
    }
    else 
    {
        s = (blk<0)   ? "0-$blk"
        \ : (blk>0)   ? "0-0;$blk-0"
        \ :             "0-0"
        s = s + ";$midLL-11308;$midLM-22102;$midMM-32896;$midMH-43690;$midHH-54484"
        s = (wht<255) ? s + ";$wht-65535;65535-65535"
        \ : (wht>255) ? s + ";65535-$wh2"
        \ :             s + ";65535-65535"
        s = s.ReplaceStr("$blk",   Strx257(Abs(blk)))
        \    .ReplaceStr("$midLL", Strx257(midLL))
        \    .ReplaceStr("$midLM", Strx257(midLM))
        \    .ReplaceStr("$midMM", Strx257(mid))
        \    .ReplaceStr("$midMH", Strx257(midMH))
        \    .ReplaceStr("$midHH", Strx257(midHH))
        \    .ReplaceStr("$wht",   Strx257(wht))
        \    .ReplaceStr("$wh2",   Strx257((255-wht)+255))
    }
    SmoothPts("SmoothPoints7", s, planes,
    \   mode, limiter, TVrange, interp, dither, HQ, 
    \   useMT, useOPT, debug, screenW, screenH, scale)
    return Last
}

#######################################
### SmoothCurves interface: 9-point curve (a little unwieldy TBH)
##
## @ C       - source clip: RGB(A) or YUV(A) Planar, 8-16bit 
##              (alpha information passed through unchanged)
## @ blk     - black clipping point: < 0 is darker, > 0 is brighter
## @ midLL   - low-low   ( 32) adjust:   (ditto)
## @ midL    - low       ( 64) adjust:   (ditto)
## @ midML   - low-mid   ( 96) adjust:   (ditto)
## @ midMM   - mid       (128) adjust:   (ditto)
## @ midMH   - high-mid  (160) adjust:   (ditto)
## @ midH    - high      (192) adjust:   (ditto)
## @ midHH   - high-high (224) adjust:   (ditto)
## @ wht     - white clipping point:     (ditto)
##
## -- A D V A N C E D   A R G U M E N T S -----
## (see SmoothPts for explanation of the other arguments)
##
function SmoothPoints9(clip C, 
\               int blk, int midLL, int midLM, int midML, 
\               int midMM, int midMH, int midHM, int midHH, int wht,
\               string "planes", 
\               int "mode", bool "limiter", int "TVrange", 
\               int "interp", int "dither", bool "HQ",
\               int "useMT", int "useOPT", bool "debug", 
\               int "screenW", int "screenH", bool "scale", bool "lsb")
{
    C
    bits    = BitsPerComponent
    is8bit  = bits==8
    lsb     = Default(lsb, false) && is8bit

    ## de-normalize
    blk      =   0-blk
    midLL    =  32-midLL
    midLM    =  64-midLM
    midML    =  96-midML
    midMM    = 128-midMM
    midMH    = 160-midMH
    midHM    = 192-midHM
    midHH    = 224-midHH
    wht      = 255-wht

    ## prevent reverse curves
    midLL    = Max(blk+2,   midLL) 
    midLM    = Max(midLL+2, midLM) 
    midML    = Max(midLM+2, midML) 
    midMM    = Max(midML+2, midMM) 
    midMH    = Max(midMM+2, midMH) 
    midHM    = Max(midMH+2, midHM) 
    midHH    = Max(midHM+2, midHH) 
    wht      = Max(midHH+2, wht)

    s = ""
    if (is8bit && !lsb) 
    {
        s = (blk<0)   ? "0-$blk"
        \ : (blk>0)   ? "0-0;$blk-0"
        \ :             "0-0"
        s = s + ";$midLL-32;$midLM-64;$midML-96;$midMM-128;$midMH-160;$midHM-192;$midHH-224"
        s = (wht<255) ? s + ";$wht-255;255-255"
        \ : (wht>255) ? s + ";255-$wh2"
        \ :             s + ";255-255"
        s = s.ReplaceStr("$blk",   String(Abs(blk)))
        \    .ReplaceStr("$midLL", String(midLL))
        \    .ReplaceStr("$midLM", String(midLM))
        \    .ReplaceStr("$midML", String(midML))
        \    .ReplaceStr("$midMM", String(midMM))
        \    .ReplaceStr("$midMH", String(midMH))
        \    .ReplaceStr("$midHM", String(midHM))
        \    .ReplaceStr("$midHH", String(midHH))
        \    .ReplaceStr("$wht",   String(wht))
        \    .ReplaceStr("$wh2",   String((255-wht)+255))
    }
    else 
    {
        s = (blk<0)   ? "0-$blk"
        \ : (blk>0)   ? "0-0;$blk-0"
        \ :             "0-0"
        s = s + ";$midLL-8224;$midLM-16448;$midML-24672;$midMM-32896"
        \ +     ";$midMH-41120;$midHM-49344;$midHH-57568"
        s = (wht<255) ? s + ";$wht-65535;65535-65535"
        \ : (wht>255) ? s + ";65535-$wh2"
        \ :             s + ";65535-65535"
        s = s.ReplaceStr("$blk",   Strx257(Abs(blk)))
        \    .ReplaceStr("$midLL", Strx257(midLL))
        \    .ReplaceStr("$midLM", Strx257(midLM))
        \    .ReplaceStr("$midML", Strx257(midML))
        \    .ReplaceStr("$midMM", Strx257(midMM))
        \    .ReplaceStr("$midMH", Strx257(midMH))
        \    .ReplaceStr("$midHM", Strx257(midHM))
        \    .ReplaceStr("$midHH", Strx257(midHH))
        \    .ReplaceStr("$wht",   Strx257(wht))
        \    .ReplaceStr("$wh2",   Strx257((255-wht)+255))
    }
    SmoothPts("SmoothPoints9", s, planes,
    \   mode, limiter, TVrange, interp, dither, HQ, 
    \   useMT, useOPT, debug, screenW, screenH, scale)
    return Last
}

#######################################
### arguments and code common to all the filters
##
## @ planes  - the color planes to be processed (applies to YUV mode only); default "Y"
##             (process chroma instead of luma with planes="U", "V" or "UV")  
##
## @ mode    - interpolation mode between control points; more = smoother; default 100 (max)
## @ limiter - clamp the output to 16-235 for luma & 16-240 for chroma; off by default.
## @ TVrange - convert the curves to TVrange (16-235/16-240) before applying conversion:
##              0 = off (default)
##              1 = on, clip values outside TVrange
##              2 = on, process values outside TVrange
## @ dither   - on by default for 8 bit, off for 10-16 bit
## @ screenW, screenH  
##            - set debug output screen size; default -2: same as 'C'
##              (set both to -1 for desktop resolution)
##
## (see SmoothAdjust docs for explanation of the other arguments)
##
## @ lsb     - set to true for Stack16 source; default false
##              (high bit depth sources processed in Stack16 internally)
##
function SmoothPts(clip C, string caller, string curve,
\               string "planes", 
\               int "mode", bool "limiter", int "TVrange", 
\               int "interp", int "dither", bool "HQ",
\               int "useMT", int "useOPT", bool "debug", 
\               int "screenW", int "screenH", bool "scale", bool "lsb")
{
    C
    bits    = BitsPerComponent
    is8bit  = bits==8
    lsb     = Default(lsb, false) && is8bit
    cisrgb  = IsRGB

    planes  = UCase(Default(planes, "Y"))
    enableY = FindStr(planes, "Y")>0
    enableU = FindStr(planes, "U")>0
    enableV = FindStr(planes, "V")>0

    mode    = Min(Max(0, Default(mode, 100)), 100)
    limiter = Default(limiter, false)
    TVrange = Min(Max(0, Default(TVrange, 0)), 2)

    interp  = Min(Max(0, Default(interp, 100)), 200)
    dither  = Min(Max(0, Default(dither, ((is8bit && !lsb) ? 75 : -1))), 100)
    HQ      = Default(HQ, false)

    useMT   = Min(Max(0, Default(useMT,  0)), 16)
    useOPT  = Min(Max(0, Default(useOPT, 0)), 3)

    debug   = Default(debug, false)
    wid     = Width
    hgt     = (lsb) ? Height/2 : Height
    screenW = Default(screenW, -2)  ## (orig. -1: size of Windows desktop)
    screenH = Default(screenH, -2)  ## (ditto)
    screenW = (screenW==(-1)) ? -1
    \       : (screenW==(-2)) ? Max(1280, wid)
    \                         : Max(1280, screenW)
    screenH = (screenH==(-1)) ? -1
    \       : (screenH==(-2)) ? Max( 768, hgt)
    \                         : Max( 768, screenH)
    scale   = Default(scale, true)

    if (is8bit && !lsb) 
    {
        defcurve = "0-0;255-255"
        (cisrgb) ? GBR2YUV : Last
        SmoothCurve(
        \   ((enableY || cisrgb) ? curve : defcurve),
        \   ((enableU || cisrgb) ? curve : defcurve),
        \   ((enableV || cisrgb) ? curve : defcurve),
        \   mode, limiter, TVrange, interp, dither, HQ, 
        \   useMT, useOPT, debug, screenW, screenH, scale)
        (cisrgb) ? YUV2GBR : Last
    }
    else 
    {
        defcurve = "0-0;65535-65535"
        (lsb) ? Last : To16bit
        O16=Last
        (lsb) ? Last : ToStack16(swap_planes=true)
        SmoothCurve16(
        \   ((enableY || cisrgb) ? curve : defcurve),
        \   ((enableU || cisrgb) ? curve : defcurve),
        \   ((enableV || cisrgb) ? curve : defcurve),
        \   mode, limiter, TVrange, interp, dither, HQ, 
        \   useMT, useOPT, debug, screenW, screenH, scale)
        (lsb) ? Last : FromStack16(O16, swap_planes=true)
        (lsb) ? Last : MatchColorFormat(C)
    }
    if (debug && screenW==(-2)  && screenH==(-2)) {        
        zx = Float(C.Width)  / Width
        zy = Float(C.Height) / Height
        ScaleZoom(Min(zx, zy), 4, gamma=false)
        CropEx(C.Width, C.Height)
    }
    (!debug) ? Last
    \ : Subtitle(caller + ": '" + curve + "'", size=Max(8.0, Height/32.0))
    (!C.HasAlpha) ? Last
    \ : AddAlphaPlane42(C)
    return Last
}

#######################################
### scale 0-255 => 0-65535 and stringify
function Strx257(int i) {
    return String(i*257)
}

####
