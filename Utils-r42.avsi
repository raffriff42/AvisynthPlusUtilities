###############################
###############################

### basic utility functions part 2
## v2017-10-15 SuperSexyWidescreen
## v2017-11-15 GrayRadial, ColorRadial
## v2017-11-22 MergeFiveBand
## v2018-03-12 MergeLH, GammaCurve etc

## download latest:
##   https://raw.githubusercontent.com/raffriff42/AvisynthPlusUtilities/master/Utils-r42.avsi

## requires AddGrain (if calling AddGrainAG)
##    http://avisynth.nl/index.php/AddGrain

global giUUTrim = 0 

#######################################################################################
### TABLE OF CONTENTS 
#######################################################################################

### STRING FUNCTIONS

### NUMERIC FUNCTIONS 

### SOURCE FILTERS 

    ### simple wrapper for [[FFmpegSource]]
    #@ function myFFSource2(string path, int "atrack", 
    ##\               int "fpsnum", int "fpsden",
    ##\               bool "showtype",  bool "showframe",
    ##\               string "colorspace")

    #@ function myLibavSource2(string path, 
    ##\               string "colorspace", bool "stacked", bool "cache",
    ##\               string "vdecoder", string "adecoder", int "atrack")

    ### doesn't need to create an index file for its supported formats (MP4, MOV)
    #@ function mySmashSource(string path, int "atrack", 
    ##\               int "fpsnum", int "fpsden",
    ##\               bool "showtype",  bool "showframe",
    ##\               string "colorspace", bool "stacked")

### UTILITY FILTERS 

### TIMELINE FILTERS

    ### fade video and audio
    #@ function UUFadeAV(clip C, 
    ##\               int framesIn, framesOut,
    ##\               int "blankHead", int "blankTail")

    ### change speed over a wide range
    #@ function ChangeSpeed(
    ##\               clip C, float factor, bool "pitchfix", bool "noblend")

    ### audio only: change speed over a wide range 
    #@ function ChangeAudioSpeed(
    ##\               clip C, float factor, bool "pitchfix")

    ### cut to another, synchronized clip
    #@ function UUAppend(clip M, clip B, int "lastfr", int "dur", int "tr")

    ### (cut or dissolve to alternate clip and back again)
    #@ function UUInsertFade(clip A, clip B,
    ##\               int "markIn", int "markOut",
    ##\               int "fadeIn", int "fadeOut")

    ### dissolve to alternate clip
    #@ function UUDissolve(clip A, clip B, int "markIn", int "lenDissolve", int "tr") 

    ### dissolve to alternate clip
    #@ function UUDissolve2(clip A, clip B, 
    ##\               int "startfrm", int "fadedur",
    ##\               bool "B_sync", int "B_slip")

    ### like [[Dissolve]], but support [[Overlay]] modes
    #@ function DissolveMode(clip A, clip B, int ddur, string "mode", float "opacity")

    ### like [[Dissolve]], but go to a color at dissolve midpoint
    #@ function DipToColor(clip A, clip B, int ddur, int "color", int "cdur")

    ### [[AlignedSplice]] with soft (clickless) audio edit
    #@ function SoftSplice(clip A, clip B, int "overlap")

    ### attempted ConvertFPS workalike with expanded blend options
    #@ function InterpolateFPS(clip C, float fps, bool "smoother", 
    ##\               float "blendrange", bool "bidirectional")
    #@ function InterpolateFPS(clip C, clip T, bool "smoother", 
    ##\               float "blendrange", bool "bidirectional")
    #@ function InterpolateFPS(clip C, int fpsnum, int fpsden, bool "smoother", 
    ##\               float "blendrange", bool "bidirectional")

### MERGE & OVERLAY FILTERS

    ### Enhanced [[SGradation]]; semi-independent control of highlights & lowlights
    #@ function SGradation3(clip C, 
    ##\               float "gammaWht", float "gammaBlk",
    ##\               float "bluSat", float "yelSat",
    ##\               float "redSat", float "grnSat", bool "tvrange")

    ### overlay (blend) two RGB clips using mask + optional opacity
    #@ function mt_rgbmerge(clip C, clip D, clip M, float "opacity")

    ### simple edge mask
    #@ function EdgeMask(clip C, int "threshold", float "blur")

    ### merge 2 clips with edge mask (deprecated)
    #@ function EdgeMerge(clip N, clip M, clip E, 
    ##\               int "maskthr", float "maskblur",
    ##\               float "strength", bool "showmask")

    ### merge 2 clips with edge mask
    #@ function EdgeMerge2(clip C, clip E, clip "M", 
    ##\               int "maskthr", float "maskblur",
    ##\               float "strength", bool "showmask")

    ### [[Mask]]: force areas /out/side given rectangle to black
    #@ function BoxMaskExclude(clip C, 
    ##\               int "x1", int "y1", int "x2", int "y2",
    ##\               int "wid", int "hgt", float "outline_width",
    ##\               bool "preclear")

    ##### [[Mask]]: force area /in/side given rectangle to white
    #@ function BoxMaskInclude(clip C, 
    ##\               int "x1", int "y1", int "x2", int "y2",
    ##\               int "wid", int "hgt", float "outline_width",
    ##\               bool "preclear")

    ### [[Overlay]] a clip or solid color using [[BoxMaskExclude]]
    #@ function BoxMaskOverlay(clip C, 
    ##\               int "x1", int "y1", int "x2", int "y2",
    ##\               int "wid", int "hgt", int "outline_width",
    ##\               clip "over", int "color",
    ##\               string "mode", float "opacity", float "maskblur")

    ### merge 'Lo', 'Hi' clips based on clip 'T' luma
    #@ function MergeLH(clip T, clip Lo, clip Hi, float "bias")

    ### merge 'Lo', 'Mid', 'Hi' clips based on clip 'T' luma
    #@ function MergeLMH(clip T, clip Lo, clip Mid, clip Hi, float "bias",
    ##\               float "ctr_lo", float "ctr_hi", float "qfactor",
    ##\               bool "showmasks")

    ### merge five clips keyed on luma range of base clip
    #@ function MergeFiveBand(clip C, 
    ##\               clip "c1", clip "c2", clip "c3", clip "c4", clip "c5", 
    ##\               bool "luma", bool "chroma", bool "blend", int "output")

    ### mask a smooth range of source hues & saturation
    #@ function SmoothHueMask(
    ##\               clip C, int h, float d,
    ##\               int "maxSat", int "minSat",
    ##\               bool "showmap", bool "showargs")

    ### mask a range of source saturation; transform saturation->lightness
    #@ function SatMask(clip C, int "maxSat", int "minSat", float "sensitivity")

### ANTIALIAS FILTERS 

    ### alias [[UU_NQAA]] for backwards compatibility
    #@ function UU_NQAA(clip C, int "speed", bool "motionblur", int "wid", int "hgt", int "option")

    ### smooth certain types of aliasing artifacts with [[Nnedi3]] + [[QTGMC]]
    #@ function NQAA(clip C, int "speed", bool "motionblur", int "wid", int "hgt")

    ### alias [[pow2Qt]] for backwards compatibility
    #@ function AA_pow2Qt(clip C, float "sharpen", bool "cpoint", bool "doublesize")

    ### Antialiasing (AA) for game footage
    #@ function pow2Qt(clip C, float "sharpen", bool "doublesize", bool "motionblur")

    ### smooth certain types of aliasing artifacts (slow!)
    ### with [[YFRC2]]/[[FrameRateConverter]] + [[Nnedi3]] + [[QTGMC]] + [[FFT3DFilter]]
    #@ function FRAANQ(clip C, bool "faster", bool "nosmooth", bool "motionblur", bool "yfrc") 

### DEBLOCKING FILTERS

### DENOISE & SMOOTHING FILTERS

    ### delay blend: mix the current frame with the previous frame (see also InterpolateFPS)
    #@ function DelayBlend(clip C, int "frames", float "opacity", string "mode")

### MISC RESTORATION FILTERS

### COLORSPACE FILTERS

### LEVELS & CHROMA FILTERS

    ### call [[Tweak]] with user-supplied mask 'M' - see [[SmoothHueMask]], [[SatMask]]
    #@ function SmoothHueTweak(clip C, 
    ##\               int hue_adj, float sat_adj, int hue_select, 
    ##\               float "hue_width", int "maxSat", int "minSat",
    ##\               bool "coring", bool "show_mask")

    ### range limiter with soft 'knee' transition, 
    ### supports independent yellow, blue, green & red limits
    ### (not for secondary color correction)
    #@ function SmoothLimiter(clip C, 
    ##\               int ymin, int ymax,
    ##\               float "y", float "b",
    ##\               float "g", float "r",
    ##\               int "k")

    ### simple gamma adjustment (more = brighter lowlights)
    #@ function GammaCurve(clip C, float gamma, bool "tvrange")

    ### simple 'anti-gamma' adjustment (more = darker highlights)
    #@ function AntigammaCurve(clip C, float antigamma, bool "tvrange")

    ### merge GammaCurve and AntigammaCurve
    #@ function GammaScurve(clip C, float gamma, float antigamma, bool "tvrange")

    ### enhance contrast in lowlights (USM) & highlights (stretch)
    #@ function HighLowEnhancer(clip C, float "lowlights", float "highlights")

    ### [[Levels]]-type filter, with 'gammalo' & 'gammahi' arguments 
    #@ function UUCurves(clip C, 
    ##\               float "off", float "gamma", float "gain",
    ##\               float "gammalo", float "gammahi",
    ##\               bool "fullrange", bool "coring",
    ##\               bool "debug")

    ### Luma correction, "equalizer style"
    #@ function FiveBandLevels(clip C, 
    ##\               int "off1", int "off2", int "off3", int "off4", int "off5", 
    ##\               float "sBlk", float "sWht", bool "debug")

    ### Saturation adjustment by luma band, "equalizer style"
    #@ function FiveBandSaturation(clip C, 
    #\                float "sat1", float "sat2", float "sat3", float "sat4", float "sat5", 
    #\                bool "debug")
    
    ### Color temperature adjustment by luma band, "equalizer style"
    #@ function FiveBandColortemp(clip C, 
    #\                int "off1", int "off2", int "off3", int "off4", int "off5", 
    #\                bool "debug")

### SHARPEN & BLUR FILTERS

    ### Emulate [[VariableBlur/GaussianBlur]]
    #@ function GaussianBlur42(clip C, 
    ##\               float "var", float "rad",
    ##\               bool "gamma", float "p")

    ### NonlinUSM wrapper: local contrast
    #@ function NonlinLC(clip C, float "str", float "rad") 

    ### enhance contrast - like unsharp
    #@ function NonlinUSM(clip o, float "z", float "pow",  
    ##\               float "str", float "rad", float "ldmp")

    ### repair oversharpened edges
    #@ function EdgeDesharpen(clip C, int "threshold", 
    ##\               float "normalblur", float "edgeblur",
    ##\               float "postsharpen", bool "gamma")

    ### [[FineSharp]] wrapper with edge mask
    #@ function FineSharpEdge(clip C, float "sstr", float "cstr", 
    ##\               int "edges", int "mthr", float "nsharp",
    ##\               bool "showmask", bool "showargs")

    ### reduces chroma bleed somewhat
    #@ function ChromaWarpSharpener(clip C, int "strength", bool "yv24_ignored")

    ### subtle sharpening effect
    #@ function MultiSharpen(clip C, int multi, float "sharpen", float "blur")

### BORDER & CROP FILTERS

    ### crop to size with smooth pan & tilt (range -1.0_1.0; center @ 0, 0)
    #@ function CropPanTilt(clip C, int wid, int hgt, float "panRt", float "tiltDn",
    ##\               string "title", int "align", int "color", float "size")

    ### crop to size with smooth animated pan & tilt, expressed as pixels (center @ off_x=0, off_y=0)
    #@ function CropShift(clip C, int wid, int hgt, float "off_x", float "off_y")

    ### a nice Pillarbox effect - extends blurred source into left & right borders 
    #@ function SuperSexyWidescreen(
    ##\               float "edge", float "xblend", bool "pblend")

    ### symmetrically crop or expand a clip to ensure it is a certain size, 
    ### with size forced to mod-4, mod-8 etc
    #@ function QCropEx(clip C, float wid, float hgt, int "mod")

    ### [[Crop]], then resize to match template clip 'T';
    ### crop as needed to maintain aspect ratio
    #@ function CropMatch(clip C, clip T,
    ##\               int left, int top, int width, int height)

    ### shift a clip up-down and left-right (with sub-pixel precision);
    ### this results in repeated edge pixels
    #@ function Shift(clip C, float offh, float offv)

    ### shift Chroma relative to Luma
    #@ function ShiftUV(clip C, float "ux", float "uy", float "vx", float "vy")

    ### shift and/or resize Red and Blue relative to Green
    #@ function ShiftRedBlue(clip C, 
    ##\               float "rx", float "ry",
    ##\               float "bx", float "by",
    ##\               float "rxd", float "ryd",
    ##\               float "bxd", float "byd")

### RESIZE & TRANSFORM FILTERS

    ### high quality enlarge
    #@ function Nnedi3Enlarge2(clip C, int "wid", int "hgt",
    ##\               bool "slower", bool "draft")

    ### high quality enlarge (simplified version - YV12 only)
    #@ function Nnedi3EnlargeYV12(clip C, int "wid", int "hgt", int "speed")

### SUBTITLE FILTERS 

    ### TextSub/TextSubMod over deep color video; requires AviSynthPlus
    #@ function TextSubPlus(clip C, string path, int "charset", float "fps", string "vfr",
    ##\               bool "submod", bool "edgetrim")

### TRANSITION & EFFECT FILTERS

    ### Dissolve with a Wipe transition; adjustable soft edge.
    #@ function SoftWipe(clip A, clip B, float "overlap", 
    ##\               string "Mode", float "WindowSize",
    ##\               float "HardnessStart", float "HardnessEnd",
    ##\               bool "showmask")

    ### emulate color temperature changes in three luma ranges
    #@ function CheapColorTemp(clip C, 
    ##\               int offset_lo, int offset_mid, int offset_hi)

    ### apply ColorYUV U & V offsets to three luma ranges
    #@ function ColorYUVx3(clip C,
    ##\               float "off_u_lo",  float "off_u_mid",  float "off_u_hi",
    ##\               float "off_v_lo",  float "off_v_mid",  float "off_v_hi",
    ##\               bool "showmasks")

    ### Add grain; any bit depth 8_16; x86/x64
    #@ function AddGrainAG(clip C, int yn, int "cn", bool "fixed", float "hcorr", float "vcorr")

    #@ function watermark42(clip C, clip M, float opacity, bool "nofill")

### AUDIO FILTERS 

    #@ function AudioEchoes(clip A, int "repeats", float "interval", float "mix")

### DEBUGGING FILTERS

    ### show basic clip properties, a bit like [[Info]] but more compact
    #@ function ShowInfoString(clip C, string "label", string "font", float "size", 
    ##\               int "text_color", int "halo_color", int "align")

    ### return grayscale radial gradient clip w/ same specs as template clip 'T'
    #@ function GrayRadial(clip T, int "width", int "height", float "radius", float "gamma", bool "circle")

    ### return color radial gradient clip w/ same specs as template clip 'T'
    #@ function ColorRadial(clip T, int "inner_color", int "outer_color", 
    ##\                   bool "circle", int "noise")

    ### return motion vectors
    #@ function MVect2(clip C, clip "super", clip "manalyse", int "blksize", int "ascale", bool "isolated")

    ### return motion mask
    #@ function MMask2(clip C)

    ### add striped border on all sides
    #@ function stripe_border(clip C, int stripecount, 
    ##\               int "modx", int "mody", bool "inset",
    ##\               int "color1", int "color2")

    ### add rainbow border on all sides
    #@ function rainbow_border(clip C, int "modx", int "mody")

    ### colorbars designed to be stacked over clip 'C'; no audio
    #@ function MiniBars(clip C, int "height", bool "ontop", bool "inset", bool "label")

    ### make side-by-side split clip; crop input images to fit in original width
    #@ function StackTwoAcrossCropped(clip A, clip B, clip "S", 
    ##\               int "border", float "pan", int "wid",
    ##\               string "titleA", string "titleB", int "align")

    ### invert hue in a sweeping pattern (used to find a particular hue)
    #@ function HueSweep(clip C, int "hue_range", int "sweep_increment", int "sweep_start")

    ### show video waveform + vectorscope + audio scopes; YUV only
    #@ function TekScopes(clip clp) 

#######################################################################################
### STRING FUNCTIONS
#######################################################################################

#######################################################################################
### NUMERIC FUNCTIONS 
#######################################################################################

#######################################################################################
### SOURCE FILTERS 
#######################################################################################

##################################
### simple wrapper for [[FFmpegSource]]
##
## @ showtype  - if true, show FFPICT_TYPE (overrides 'showframe')                         
## @ showframe - if true, show file name & current frame
# 
function myFFSource2(string path, int "atrack", 
\               int "fpsnum", int "fpsden",
\               bool "showtype",  bool "showframe",
\               string "colorspace")
{ 
    atrack   = Default(atrack, -1)
    fpsnum   = default(fpsnum, -1)
    fpsden   = default(fpsden,  1)
    showtype = Default(showtype,  false)
    showfrm  = Default(showframe, false)
    colorspc = Default(colorspace, "") ## (YV12, YUY2, RGB24 or RGB32)

    #global gSourcePath = path
    #global gSourceName = GetNameFromPath(path)

    FFmpegSource(path, atrack=atrack, timecodes="",
    \      fpsnum=fpsnum, fpsden=fpsden, 
    \      colorspace=colorspc, threads=1) 

    ## cache a few frames of input - "dont ask, just do"
    ## http://forum.doom9.org/showthread.php?p=1473445#post1473445 
    #(showtype || showfrm) ? Last : ChangeFPS(Last, Last, true)

    return (showtype) ? ScriptClip(Last, """
              Subtitle("[ "+chr(FFPICT_TYPE)+" ]", 
              \       size=(Height*56.0/720), align=2, text_color=$80c0c000)  
          """, after_frame=true)
    \   : (showfrm) ? ScriptClip(Last, """
              Subtitle(String(current_frame), 
              \       size=(Height*36.0/720), align=7, text_color=$80c0c000)  
          """, after_frame=true)
    \   : Last
}

##
## FFInfo(clip C, bool framenum=true, bool frametype=true,
## \      bool cfrtime=true, bool vfrtime=true, string varprefix="")
##

##################################
function myLibavSource2(string path, 
\               string "colorspace", bool "stacked", bool "cache",
\               string "vdecoder", string "adecoder", int "atrack")
{
    atrack = Default(atrack, -1)
    try {
        return myLibavSource2(path, atrack, 
        \                   0, 1, 
        \                   false, false, 
        \                   colorspace, stacked, cache,
        \                   vdecoder, adecoder)
    }
    catch(err_msg) {
        return myLibavSource2(path, -2, 
        \                   0, 1, 
        \                   false, false, 
        \                   colorspace, stacked, cache,
        \                   vdecoder, adecoder)
    }
}

# http://avisynth.nl/index.php/LSMASHSource/LSMASHVideoSource
# http://avisynth.nl/index.php/LSMASHSource/LSMASHAudioSource
#LoadPlugin(pathBase + "LSMASH_Source\AviSynth\LSMASHSource.dll")
##################################
### doesn't need to create an index file for its supported formats (MP4, MOV)
##
function mySmashSource(string path, int "atrack", 
\               int "fpsnum", int "fpsden",
\               bool "showtype",  bool "showframe",
\               string "colorspace", bool "stacked")
{
    atrack   = Default(atrack, 0)
    fpsnum   = Default(fpsnum, 0)
    fpsden   = Default(fpsden,  1)
    showtype = Default(showtype,  false)
    showfrm  = Default(showframe, false)
    stacked  = Default(stacked, false)

    ## (most common spaces YUY2, YUV420P8, YUV422P16, RGB24, RGB32)
    colorspc = Default(colorspace, "")
    colorspc = (colorspc=="" && stacked==true) ? "YUV420P16" : ""

    video = LSMASHVideoSource(path, 
    \               fpsnum=fpsnum, fpsden=fpsden, 
    \               format=colorspc, stacked=stacked, threads=1)
    
    Last = (atrack==-2) ? video: AudioDub(video, 
    \    LSMASHAudioSource(path, track=atrack))

    ## cache a few frames of input - "dont ask, just do"
    ## http://forum.doom9.org/showthread.php?p=1473445#post1473445 
    ChangeFPS(Last, Last, true)  

    return (showtype) ? ScriptClip(Last, """
              Subtitle("[ ? ]", 
              \       size=(Height*56.0/720), align=2, text_color=$80c0c000)  
          """, after_frame=true)
    \   : (showfrm) ? ScriptClip(Last, """
              Subtitle(String(current_frame), 
              \       size=(Height*36.0/720), align=7, text_color=$80c0c000)  
          """, after_frame=true)
    \   : Last
}

#######################################################################################
### UTILITY FILTERS 
#######################################################################################

#######################################################################################
### TIMELINE FILTERS
#######################################################################################

#######################################
### fade video and audio
##
## @ framesIn, framesOut - fade duration
## @ blankHead - start fade up late
## @ blankTail - start fade out early
##
function UUFadeAV(clip C, 
\               int framesIn, framesOut,
\               int "blankHead", int "blankTail")
{
    blankHead = Default(blankHead, 0)
    blankTail = Default(blankTail, 0)
    B = BlankClip(C)

    C = (blankHead <= 0) ? C.FadeIn(framesIn) 
    \ : B.Trim(0, -blankHead) 
    \   + C.Trim(blankHead, 0).FadeIn(framesIn)

    C = (blankTail <= 0) ? C.FadeOut(framesOut) 
    \ : C.Trim(0, C.FrameCount-blankTail).FadeOut(framesOut) 
    \   + B.Trim(0, -blankTail)

    return C
}

#######################################
### change speed over a wide range, 
### with frame blending in fast forward by default.
##
## @ factor - 0.33 for 1/3 speed, etc; 
##    min = 0.001; max = min([[FrameCount]], 1000) 
##    (if > FrameCount, duration would be 0);
##    if argument is out of range, an error occurs.
##
## @ pitchfix - if true, maintain audio pitch with speed 
##    (default false; allow pitch to rise or fall)
##
## @ noblend - if true, never blend frames (default false)
##
## @ version 1.0 24-Feb-2014 raffriff42
##
function ChangeSpeed(
\               clip C, float factor, bool "pitchfix", bool "noblend")
{
    Assert(!C.IsYV411 && (C.IsYUV||C.IsYUVA), 
    \  "ChangeSpeed: RGB, YV411 not accepted") ## (cf. Overlay)
    Assert(factor>=0.001, 
    \  "ChangeSpeed bad argument: factor<0.001")
    Assert(factor<=1000.0, 
    \  "ChangeSpeed bad argument: factor>1000")
    Assert(factor<=C.FrameCount, 
    \  "ChangeSpeed bad argument: factor>FrameCount")

    pitchfix = Default(pitchfix, false)
    noblend  = Default(noblend, false)

    AS  = C.KillAudio.AssumeFPS(C.FrameRate * factor)
    ASI = C.KillAudio.AssumeFPS(C.FrameRate / factor)

    temprad = Round(0.5 * factor) 
    TS = (factor<1.0 || temprad==0 || noblend) 
    \  ? AS 
    \  : AS.Overlay(
    \       AS.TemporalSoften(temprad, 255, 255, 48, 2), 
    \       opacity=0.7)

    R  = (factor<1.5 && noblend==false)  
    \  ? AS.ConvertFPS(C) 
    \  : TS.ChangeFPS(C.Framerate, linear=(factor<10.0))

    return (Abs(factor-1.0) < (0.5/C.FrameCount)) ? C
    \  : (!C.HasAudio) ? R 
    \  : R.AudioDub( C.ChangeAudioSpeed(factor, pitchfix) )
}

#######################################
### audio only: change speed over a wide range 
##
## @ factor - 0.33 for 1/3 speed, etc; 
##    min = 0.01; max < 1000;
##    if argument is out of range, an error occurs.
##
## @ pitchfix - if true, maintain audio pitch with speed 
##    (default false; allow pitch to rise or fall)
##
## @ version 1.0 11-Apr-2017 ~ split from [[ChangeSpeed]]
##
function ChangeAudioSpeed(
\               clip C, float factor, bool "pitchfix")
{
    Assert(C.HasAudio, 
    \  "ChangeAudioSpeed bad argument: source has no audio")
    Assert(factor>=0.01, 
    \  "ChangeAudioSpeed bad argument: factor < 0.01")
    Assert(factor<=1000.0, 
    \  "ChangeAudioSpeed bad argument: factor > 1000")

    A = Default(pitchfix, false)
    \ ? C.ConvertAudioToFloat.TimeStretch(tempo = factor*100.0)
    \ : C.ConvertAudioToFloat.TimeStretch(rate  = factor*100.0)

    R = (Abs(factor-1.0) < 0.0001) ? C
    \ : (C.AudioDuration/factor < 0.001) ? C.AudioTrim(0.0, length=0.0)
    \ : (C.AudioBits==32) ? A.ConvertAudioTo32bit
    \ : (C.AudioBits==24) ? A.ConvertAudioTo24bit
    \ : (C.AudioBits==16) ? A.ConvertAudioTo16bit
    \ : (C.AudioBits==8)  ? A.ConvertAudioTo8bit
    \ : A ## (==float)

    return (factor > 0.99) ? R 
    \ : R.AudioTrim(0.0, length=C.AudioDuration)
}

/*
#######################################
### EDL SUPPORT ###

cut (V, A, AV, Split)
    #TODO

dissolve (V, A, AV, Split)
    #TODO

key  (V, A, AV, Split)
    #TODO

cut to synchronized B-roll [assemble]
    UUAppend

cut to synchronized B-roll [insert]
    UUInsert

dissolve to synchronized B-roll [assemble]
    UUDissolve

*/

#######################################
### cut to another, synchronized clip
##   add the new clip at the end (assemble mode)
##
## @ M       - master clip
## @ B       - angle 2 (synchronized with clip 'M')
## @ lastfr  - see "lastfr vs. dur", below
## @ dur     - see "lastfr vs. dur", below
## @ tr      - positive number advances 'B', negative delays 'B'
##             NOTE: affects master sync
##
## 'lastfr' vs. 'dur' - rules in determining last frame of edit:
##     if      (dur == 0 && lastfr >  0), use "lastfr" value
##     else if (dur >  0 && lastfr == 0), use (first + dur) 
##     else if (dur == 0 && lastfr == 0), use 0 [ie, use B to the end]
##     else, throw an error
##
## @ version 1.0   02-Aug-2011 LB
##
function UUAppend(clip M, clip B, int "lastfr", int "dur", int "tr")
{
    lastfr = Default(lastfr, 0)
    dur = Default(dur, 0)
    tr = Default(tr, 0)
    
    global giUUTrim = giUUTrim + tr
    first = M.FrameCount + giUUTrim
    
    lastfr = (dur == 0 && lastfr >  0) ? lastfr
         \ : (dur >  0 && lastfr == 0) ? (first + dur) 
         \ : (dur == 0 && lastfr == 0) ? 0 
         \ : Assert(0)

    return M + Trim(B, first, lastfr) 
}

### aka "sceneinsert"
# http://atlas.kennesaw.edu/~dhirschl/avisynth.html
### buggy! use UUInsertFade
# http://forum.doom9.org/showthread.php?p=1757172#post1757172
# http://forum.doom9.org/showthread.php?t=58358
#######################################
### insert an alternate clip
##
## @ A  - main movie
## @ B  - angle 2 (synchronized with clip 'A')
## @ tr - positive number advances 'B', negative delays 'B'
##        NOTE: master sync not affected
##
#function UUInsert(clip A, clip B, int markIn, int markOut, int "tr") 
#{ 
#    tr = Default(tr, 0)
#    
#    segment = B.trim(markIn + tr, markOut + tr) 
#    return A.Trim(0, markIn - 1) + segment + A.Trim(markOut + 1, 0)
#} 

#######################################
## UUInsertFade demo

## default: show clip 'B' always
#return UUInsertFade(C, O)

## cut in, cut out
#return UUInsertFade(C, O, markIn=30, markOut=90)

## fade in
#return UUInsertFade(C, O, markIn=30, fadeIn=15)

## fade out
#return UUInsertFade(C, O, markOut=90, fadeOut=35)

#######################################
### insert an alternate clip
### (cut or dissolve to alternate clip and back again)
##
## @ A       - main movie
## @ B       - alternate clip (synchronized with clip 'A')
## @ markIn  - frame where 'A'->'B' fade begins
##             (default 0; start of clip 'A')
## @ markOut - frame where 'B'->'A' fade begins
##             (default 0; 'B' remains 'on' until end of clip 'A')
##             (negative 'markOut' sets duration)
## @ fadeIn  - number of frames for 'A'->'B' fade
##             (default 0; cut to clip 'B' at frame 'markIn')
## @ fadeOut - number of frames for B->A fade
##             (default 0; cut to clip 'A' at frame 'markOut'+1)
##
## DISALLOWED INPUTS:
## * if A.FrameCount < markIn+fadeIn+1, an error occurs
## * if B.FrameCount < markOut+fadeOut+1, an error occurs
## * if markOut>=0 and markIn > markOut, an error occurs
## * if duration is negative, an error occurs
##
function UUInsertFade(clip A, clip B,
\               int "markIn", int "markOut",
\               int "fadeIn", int "fadeOut")
{
    markIn  = Max(0, Default(markIn,  0))
    markOut = Default(markOut, 0)
    fadeIn  = Max(0, Default(fadeIn,  0))
    fadeOut = Max(0, Default(fadeOut, 0))

    Assert(markIn>0 || Abs(markOut)!=1,
    \   "UUInsertFade: markOut cannot be +/-1 if markIn=0")

    markOut = (markOut>=0) ? markOut : (markIn - markOut - 1)

    Assert(A.FrameCount>=markIn+fadeIn+1,
    \   "UUInsertFade: clip A too short"+Chr(10)
    \ + "(FrameCount < markIn+fadeIn+1)")
    Assert(B.FrameCount>=markOut+fadeOut+1,
    \   "UUInsertFade: clip B too short"+Chr(10)
    \ + "(FrameCount < markOut+fadeOut+1)")
    Assert(markIn<=markOut,
    \   "UUInsertFade: duration is negative")

    R = ((markIn+fadeIn)==0) ? B
    \ : Dissolve(A.Trim(0, ((markIn+fadeIn)==1) ? -1 : markIn+fadeIn-1),
    \            B.Trim(markIn, 0), 
    \            fadeIn)

    R = ((markOut+fadeOut)==0) ? R
    \ : Dissolve(R.Trim(0, markOut+fadeOut),
    \            A.Trim(markOut+1, 0), 
    \            fadeOut) 
    
    return R
}
/*
    #\ .Subtitle("markIn="+String(markIn)+"\n"
    #\         + "markOut="+String(markOut)+"\n"
    #\         + "fadeIn="+String(fadeIn)+"\n"
    #\         + "fadeOut="+String(fadeOut), align=4, lsp=0)
*/

## BUGGY - use UUDissolve2
#######################################
### dissolve to alternate clip
## http://web.archive.org/web/20120202132116/http://atlas.kennesaw.edu:80/~dhirschl/avisynth.html
##
## @ A     - main movie
## @ B     - angle 2 (synchronized with clip 'A')
## @ lenDissolve - number of frames for dissolve;
##           make sure 'lenDissolve' is not too high
## @ tr    - positive number advances 'B', negative delays 'B'
##           NOTE: master sync not affected
##
function UUDissolve(clip A, clip B, int "markIn", int "lenDissolve", int "tr") 
{ 
    markIn = Default(markIn, 0)
    lenDissolve = Default(lenDissolve, 0)
    tr = Default(tr, 0)

    return Dissolve(A.Trim(0, markIn + lenDissolve),
    \               B.Trim(markIn + tr, 0), lenDissolve) 
}

#######################################
### dissolve to alternate clip
##
## @ A        - main movie
## @ B        - angle 2 (synchronized with clip 'A')
## @ startfrm - start frame
## @ fadedur  - number of frames for dissolve (default 1 sec)
## @ B_sync   - if true (default), maintain sync relationship; basically call 
##                 'B'.Trim(('startfrm' + 'fadedur'), 0) 
## @ B_slip   - if 'B_sync', fine-tunes sync relationship;
##                 (positive number advances 'B', negative delays it)
##
function UUDissolve2(clip A, clip B, 
\               int "startfrm", int "fadedur",
\               bool "B_sync", int "B_slip")
{ 
    fadedur  = Min(Max(0, Default(fadedur, Round(1*A.FrameRate))), A.FrameCount-1)
    startfrm = Min(Max(0, Default(startfrm, 0)), A.FrameCount-fadedur)
    B_sync   = Default(B_sync, true)
    B_slip   = Default(B_slip, 0)

    return Dissolve(
    \       A.Trim(0, startfrm + fadedur-1), 
    \       ((B_sync) ? B.Slip(B_slip).Trim(startfrm, 0) : B), 
    \       fadedur) 
}

#######################################
### like [[Dissolve]], but support [[Overlay]] modes
##
## @ ddur - duration of the transition (minimum allowed value 3 frames)
## @ mode - overlay effect at transition center (see [[Overlay]]: mode)
## @ opacity - overlay opacity at transition center (see Overlay: opacity) (default 0.5)
##
## @ version 1.0 raffriff42 10-Oct-2015
##
function DissolveMode(clip A, clip B, int ddur, string "mode", float "opacity")
{
    Assert(A.IsClip && A.HasVideo
    \   && B.IsClip && B.HasVideo,
    \   "DissolveMode: both clips must contain video")
    Assert(A.PixelType==B.PixelType,
    \   "DissolveMode: clip color formats do not match")
    Assert(A.FramerateNumerator==B.FramerateNumerator
    \   && A.FramerateDenominator==B.FramerateDenominator, 
    \   "DissolveMode: clip frame rates do not match")
    Assert(A.Width==B.Width
    \   && A.Height==B.Height,
    \   "DissolveMode: clip frame sizes do not match")
    Assert(A.IsInterleaved==B.IsInterleaved
    \   && (A.IsInterleaved==false || A.GetParity==B.GetParity),
    \   "DissolveMode: clip interlacing properties do not match")
    Assert(A.AudioRate==B.AudioRate 
    \   && A.AudioBits==B.AudioBits   
    \   && A.IsAudioInt==B.IsAudioInt,
    \   "DissolveMode: clip audio formats do not match")
    Assert(A.AudioChannels==B.AudioChannels,
    \   "DissolveMode: clip audio channel counts do not match")
    Assert(!A.IsYV411 && !B.IsYV411, 
    \  "DissolveMode: YV411 not accepted") ## (cf. Overlay)

    ddur  = Min(Max(3, ddur), A.Framecount-1)
    mode  = Default(mode, "blend")
    opac  = Default(opacity, 0.5)
    #cdur  = Min(Max(0, Default(cdur, 0)), ddur-2)
    
    cdur  = 0 #Min(cdur, ddur-2)
    ddur  = ddur-cdur
    dur_a = ddur/2
    dur_b = Max(0, ddur-dur_a)

    dbg = "ddur  " + String(ddur)  + "\n"
    \   + "cdur  " + String(cdur)  + "\n"
    \   + "dur_a " + String(dur_a) + "\n"
    \   + "dur_b " + String(dur_b) + "\n"
    
    #A = A.bigsub("A")
    #B = B.bigsub("B")

    C = Overlay(A.Trim(A.Framecount-ddur+1, 0), B, opacity=opac, mode=mode) 
        ## (C.FrameCount == ddur-1)

    R = A.Trim(0, A.Framecount-ddur) 
    \ ++ Dissolve(
    \       A.Trim(A.Framecount-ddur+1, -dur_a), 
    \       C,
    \       dur_a).Trim(0, -dur_a)
    \ ++ Dissolve(
    \       C.Trim(dur_a+1, 0), 
    \       B.Trim(dur_a+1, 0), 
    \       dur_b)

    R = R.AudioDub(Dissolve(A, B, ddur).KillVideo)

    return R #.Subtitle(dbg, align=4, lsp=0)
}

#######################################
### like [[Dissolve]], but go to a color at dissolve midpoint
##
## @ ddur  - duration of the transition (minimum allowed value 3 frames)
## @ color - color to dissolve to at transition center (default black)
## @ cdur  - number of frames to hold on the color (min 0; max 'ddur'-2; default 0)
##
## Example - fade between sync'ed clips
## | DipToColor(A.Trim(0, center+ddur/2), B.Trim(center-ddur/2, 0), 'ddur') 
##
## @ version 1.0 raffriff42 10-Oct-2015
##
function DipToColor(clip A, clip B, int ddur, int "color", int "cdur")
{
    Assert(A.IsClip && A.HasVideo
    \   && B.IsClip && B.HasVideo,
    \   "DipToColor: both clips must contain video")
    Assert(A.PixelType==B.PixelType,
    \   "DipToColor: clip color formats do not match")
    Assert(A.FramerateNumerator==B.FramerateNumerator
    \   && A.FramerateDenominator==B.FramerateDenominator, 
    \   "DipToColor: clip frame rates do not match")
    Assert(A.Width==B.Width
    \   && A.Height==B.Height,
    \   "DipToColor: clip frame sizes do not match")
    Assert(A.IsInterleaved==B.IsInterleaved
    \   && (A.IsInterleaved==false || A.GetParity==B.GetParity),
    \   "DipToColor: clip interlacing properties do not match")
    Assert(A.AudioRate==B.AudioRate 
    \   && A.AudioBits==B.AudioBits   
    \   && A.IsAudioInt==B.IsAudioInt,
    \   "DipToColor: clip audio formats do not match")
    Assert(A.AudioChannels==B.AudioChannels,
    \   "DipToColor: clip audio channel counts do not match")

    ddur  = Min(Max(3, ddur), A.Framecount-1)
    cdur  = Min(Max(0, Default(cdur, 0)), ddur-2)
    color = Default(color, $0)
    
    cdur  = Min(cdur, ddur-2)
    ddur  = ddur-cdur
    dur_a = ddur/2
    dur_b = Max(0, ddur-dur_a)

    dbg = "ddur  " + String(ddur)  + "\n"
    \   + "cdur  " + String(cdur)  + "\n"
    \   + "dur_a " + String(dur_a) + "\n"
    \   + "dur_b " + String(dur_b) + "\n"

    A2 = A.Trim(0, A.Framecount-cdur-dur_b)
    \     .FadeOut0(dur_a, color)
    \     .Trim(0, A.Framecount)
    
    B2 = B.Trim(dur_a+cdur, 0)
    \     .FadeIn0(dur_b, color)
    \     .Trim(1, 0)

    R = (cdur<=0) 
    \ ? A2 ++ B2
    \ : A2 ++ BlankClip(A, length=cdur, color=color)
    \      ++ B2
    
    R = R.AudioDub(Dissolve(A, B, ddur).KillVideo)

    return R #.Subtitle(dbg, align=4, lsp=0)
}

#######################################
### [[AlignedSplice]] with soft (clickless) audio edit
### (performs audio-only [[Dissolve]])
##
## @ A  - First  clip to be joined.
## @ B  - Second clip to be joined; will be trimmed at head by 'overlap' frames.
## @ overlap - crossfade duration; minimum & default 1
##
## Both clips must have matching video & audio Properties - cf. [[Splice]]
##
function SoftSplice(clip A, clip B, int "overlap")
{
    overlap = Max(1, Default(overlap, 1))
    try {
        RV = A.KillAudio 
        \  + B.KillAudio.Trim(overlap, 0)
    }
    catch (errmsg) {
        Assert(false,
        \   "SoftSplice Video error: " + errmsg)
    }

    try {
        RA = Dissolve(
        \       A.KillVideo, 
        \       B.KillVideo, 
        \       overlap, A.FrameRate) 
    }
    catch (errmsg) {
        Assert(false,
        \   "SoftSplice Audio error: " + errmsg)
    }

    return AudioDub(RV, RA)
}

# https://forum.doom9.org/showthread.php?p=1833258#post1833258
##################################
### attempted ConvertFPS workalike with expanded blend options
##
## @ C             - source; bit depth >= 10 suggested
## @ fps           - target FrameRate
## @ smoother      - if true, the default 'blendrange' is a little larger; default false
##                   (with 'smoother'=false, the result looks like ConvertFPS)
## . . . . . . . . . . . . . . . . . . . .
## @ blendrange    - range of frames to be blended in each direction;
##                   it is possible to specify a huge range; performance will be terrible.
##                   Note, all frames may not be visible; frames farther from 
##                   the current frame are given less weight (aka strength aka opacity).
##                   Default is "auto" - a value determined by (new fps) / (old fps).
##                   If 'blendrange' is set, it overrides 'smoother'.
## @ bidirectional - if true (default), blend both earlier and later frames;
##                   if false, only blend earlier frames, for a bad motion trails effect.
##
## @ version 0.1.6 2018-02-09
##
## TODO: sometimes a little brighter or darker than the source (fixed?)
## TODO: needs thorough stress testing
## TODO: maybe constrain max diff-per-pixel (like TemporalSoften, LimitedSharpen, SeeSaw)
##
function InterpolateFPS(clip C, float fps, bool "smoother", 
\               float "blendrange", bool "bidirectional")
{
    C
    KillAudio
    
    ## default 'blendrange' - interpolation of empirically determined values:
    rnge = Default(smoother, false)
    \ ? Spline(fps/C.FrameRate, 
    \       0.1,  1.0,
    \       0.2,  2.0,
    \       0.5,  1.5,
    \       0.7,  1.8,
    \       1.0,  3.0,
    \       2.0,  5.0,
    \      10.0, 20.0,
    \      false)
    \ : Spline(fps/C.FrameRate, 
    \       0.1,  0.2,
    \       0.2,  0.5,
    \       0.5,  1.0,
    \       0.7,  1.0,
    \       1.0,  1.2,
    \       2.0,  3.0,
    \      10.0, 15.0,
    \      false)  

    rnge = Default(blendrange, Min(Max(0.1, rnge), 10.0))
    bidi = Default(bidirectional, true)

    global gifps_C    = Last
    global gifps_rng  = rnge
    global gifps_bidi = bidi

    ## "destination" clip, will become the output (no audio until later)
    BlankClip(Last, audio_rate=0, fps=fps, length=Round(C.FrameCount*fps/C.FrameRate))

    #################################
    ScriptClip(Last, """
        
        ## c... = clip
        ## n... = frame number
        ## r... = frame rate
        ## t... = time

        csrc  = gifps_C             ## source clip
        cdst  = Last                ## dest clip: start w/ BlankClip
        ndst  = current_frame 
        rdst  = cdst.FrameRate      ## output framerate
        rsrc  = csrc.FrameRate      ## source   ' '
        trng  = (gifps_rng / rdst)  ## interp range

        ## get time @ current destination frame and ± range extremes
        t0    = Float(ndst) / rdst
        tfrst = t0 - trng
        tlast = t0 + trng

        ## get source frame numbers @ current time and ± range extremes
        ns0    = Round(t0 * rsrc)
        nsfrst = Round(tfrst * rsrc)
        nsfrst = Min(Max(0, nsfrst), csrc.FrameCount-1)
        nslast = Round(tlast * rsrc)
        nslast = (gifps_bidi)
        \      ? Min(Max(0, nslast), csrc.FrameCount-1)
        \      : Min(Max(0, ns0),    csrc.FrameCount-1)

        #############################
        ## loop 1: get sum of all frame weights
        tot_wgt = 0.0
        subtot  = 1.0
        for (n=nsfrst, nslast) {
 
            ## time corresponding to source frame 'n'
            tsrc = Float(n) / rsrc

            ## assign a weight based on distance from current frame
            wgt = Max(0.0, 1.0 - (Abs(t0 - tsrc) / trng))
            
            ## adjust weight for position in blend loop
            ## (earlier frames get more weight)
            subtot = subtot + wgt
            wgt    = wgt / subtot
 
            ## accumulate sum of weights
            tot_wgt = tot_wgt + wgt
        }

        #############################
        ## loop 2: merge the frames
        Last   = cdst
        cprev  = Trim(0, ndst-1) ## previous frames
        cpost  = Trim(ndst+1, 0) ## subsequent frames
        subtot = 1.0
        for (n=nsfrst, nslast) {

            ## time corresponding to source frame 'n'
            tsrc = Float(n) / rsrc
            
            ## re-calc weights (same as above)
            wgt = Max(0.0, 1.0 - (Abs(t0 - tsrc) / trng))
            
            subtot = subtot + wgt
            wgt    = wgt / subtot
            
            ## adjust weight for aprox. equal brightness to input
            ## (HACK) (seems to reduce added flicker)
            wgt = 3.0 * wgt / tot_wgt 
            wgt = Min(Max(0.0, wgt), 1.0)

            ## add this frame to the output, using weight value
            csrc1 = csrc.Trim(n, length=1)
            cdst1 = Trim(ndst, length=1)            
            (wgt<0.0005) ? Last
            \  : cprev + cdst1.Merge(csrc1, wgt) + cpost
            
            ## (you can try something like this instead, but it's not amazing)
            #\  : cprev + cdst1.Overlay(csrc1, mode="softight", opacity=wgt) + cpost
        }
        return Last
    """)
    (C.HasAudio) ? AudioDub(C) : Last
    return Last
}
##################################
### attempted ConvertFPS workalike with expanded blend options
##
## alternate signature - set framerate to match template clip 'T'
##
function InterpolateFPS(clip C, clip T, bool "smoother", 
\               float "blendrange", bool "bidirectional")
{
    R = C.InterpolateFPS(T.Framerate, smoother, blendrange, bidirectional)
    return R.AssumeFPS(T)
}
##################################
### attempted ConvertFPS workalike with expanded blend options
##
## alternate signature - set framerate to numerator/denominator
##
function InterpolateFPS(clip C, int fpsnum, int fpsden, bool "smoother", 
\               float "blendrange", bool "bidirectional")
{
    R = C.InterpolateFPS(Float(fpsnum)/Float(fpsden), smoother, blendrange, bidirectional)
    return R.AssumeFPS(fpsnum, fpsden)
}

#######################################################################################
### MERGE & OVERLAY FILTERS
#######################################################################################

/*
##################################
### compatibility wrapper: version 2C
##
## @ gammaWht - if > 1, stretch upper midrange (darker highlights);  
##              if < 1, squeeze upper midrange (darker highlights)
## @ gammaBlk - if > 1, stretch lower midrange (darker lowlights);  
##              if < 1, squeeze lower midrange (darker highlights)
##
function SGradation2C(clip C, 
\               float "gammaWht", float "gammaBlk")
{
    gWht = Max(0.05, Float(Default(gammaWht, 1.0)))
    gBlk = Max(0.05, Float(Default(gammaBlk, 1.0)))
    return C.SGradation3(gBlk, gWht)
}

##################################
### compatibility wrapper: version 2D
##
## @ loBoost, hiCut *
##           - if < 1, stretch mids, squeeze extremes (darker lowlights, brighter highlights)
##             if > 1, squeeze mids, stretch extremes (brighter lowlights, darker highlights)
##             ('loBoost' is gamma, restricted to 0_128d; 'hiCut' is the inverse)
## * Values less than 1 increase midrange contrast and "crush" the extremes; 
##   values greater than 1 bring out detail at the extremes at the expense of the midrange. 
##
## @ bluSat, yelSat, redSat, grnSat, tvrange - cf. [[#SGradation3]]
##
function SGradation2D(clip C, 
\               float loBoost, float hiCut,
\               float "bluSat", float "yelSat",
\               float "redSat", float "grnSat", bool "tvrange")
{
    Assert(!C.IsYV411 && (C.IsY||C.IsYUV||C.IsYUVA), 
    \  "SGradation2D: RGB, YV411 not accepted") ## (cf. Overlay)
    gBlk = Max(0.05, loBoost)
    gWht = Max(0.05, hiCut)
    return C.SGradation3(1.0/gBlk, 1.0/gWht)
}
*/

# based on http://avisynth.nl/index.php/SGradation
# (sometimes misspelled "SGraduation")
##################################
### Enhanced [[SGradation]]; semi-independent control of highlights & lowlights
## supports YUV, YUVA (A = passthrough), Y-only
##
## @ gammaWht - if > 1, stretch upper midrange (squeeze highlights);  
##              if < 1, squeeze upper midrange (stretch highlights)
## @ gammaBlk - if > 1, stretch lower midrange (squeeze lowlights);  
##              if < 1, squeeze lower midrange (stretch lowlights)
## * Values greater than 1 increase midrange contrast and "crush" the extremes; 
##   values less than 1 bring out detail at the extremes at the expense of the midrange. 
## * It's best to keep the two values close to one another to avoid a glitch at midpoint.
##
## @ bluSat, yelSat, redSat, grnSat (U+, U-, V+, V-)
##            - if > 1.0, increase color, especially at mid-saturation
##              if < 1.0, decrease color, especially at mid-saturation
##              ('gamma-like' curves)
##
## @ tvrange - if true (default), try to hold black 16d, white 235d
##
## Example: increasing red & blue but leaving yellow & green alone:
## |SGradation3(1.0, 1.0, 1.5, 1.0, 1.5, 1.0, tvrange=1>0)
## |##..........blk..wht..blu..yel..red..grn...........
##
function SGradation3(clip C, 
\               float "gammaWht", float "gammaBlk",
\               float "bluSat", float "yelSat",
\               float "redSat", float "grnSat", bool "tvrange")
{
    Assert(!C.IsYV411 && (C.IsY||C.IsYUV||C.IsYUVA), 
    \  "SGradation3: RGB, YV411 not accepted") ## (cf. Overlay)
    gWht = Max(0.05, Float(Default(gammaWht, 1.0)))
    gBlk = Max(0.05, Float(Default(gammaBlk, 1.0)))
    bluSat = Max(0.05, Float(Default(bluSat, 1.0))) ## Blu =   0°, U+
    yelSat = Max(0.05, Float(Default(yelSat, 1.0))) ## Yel = 180°, U-
    redSat = Max(0.05, Float(Default(redSat, 1.0))) ## Red =  90°, V+
    grnSat = Max(0.05, Float(Default(grnSat, 1.0))) ## Grn = 270°, V-
    tvrg = Default(tvrange, true)
    
    Yproc = C.IsY  && (Abs(1.0 - gBlk) > 0.001)   || (Abs(1.0 - gWht) > 0.001)
    Uproc = !C.IsY && (Abs(1.0 - bluSat) > 0.001) || (Abs(1.0 - yelSat) > 0.001)
    Vproc = !C.IsY && (Abs(1.0 - redSat) > 0.001) || (Abs(1.0 - grnSat) > 0.001)

    DK = (!Yproc) ? C
    \  : (tvrg) 
    \     ? C.Levelss( 16, 1/gBlk, 127, 16, 127, coring=false, chroma=false)
    \     : C.Levelss(  0, 1/gBlk, 127,  0, 127, coring=false, chroma=false)
    LT = (!Yproc) ? C
    \  : (tvrg)  [* note inverted lo-hi inputs! *]
    \     ? C.Levelss(235, 1/gWht, 127, 108,  0, coring=false, chroma=false)
    \     : C.Levelss(255, 1/gWht, 127, 128,  0, coring=false, chroma=false)
    Y  = (!Yproc) ? C
    \  : Overlay(DK, LT, mode="add")

    U = (!Uproc)  
    \  ? (C.IsY) ? C : C.ExtractU
    \  : C.ExtractU.SGradation3(yelSat, bluSat) 
    V = (!Vproc) 
    \  ? (C.IsY) ? C : C.ExtractV
    \  : C.ExtractV.SGradation3(grnSat, redSat) 

    return (C.IsY) ? Y
    \ : (C.IsYUVA)
    \ ?  CombinePlanes(
    \       C.ExtractY
    \        .SGradation3(gWht, gBlk, 1.0, 1.0, 1.0, 1.0, tvrange),
    \       U, V, C.ExtractA, "YUVA", pixel_type=C.PixelType)
    \ :  CombinePlanes(
    \       C.ExtractY
    \        .SGradation3(gWht, gBlk, 1.0, 1.0, 1.0, 1.0, tvrange),
    \       U, V, "YUV", pixel_type=C.PixelType)
}

#######################################
### overlay (blend) two RGB clips using mask + optional opacity
##
function mt_rgbmerge(clip C, clip D, clip M, float "opacity")
{
    Assert(C.IsRGB && D.IsRGB,
    \   "mt_rgbmerge: sources 'C' and 'D' must be RGB")
    Assert(M.IsYUV,
    \   "mt_rgbmerge: mask 'M' must be YUV")

    opacity = Min(Max(0.0, Default(opacity, 1.0)), 1.0)
    M = (opacity>0.999) ? M
    \ : Merge(BlankClip(M), M, opacity)

    return YUV2GBR(mt_merge(C.GBR2YUV, D.GBR2YUV, M, luma=true))
}

##################################
### simple edge mask
##
## @ mthr - edge detection threshold (default 128d)
## @ blur - amount of postblur (default 0.6)
##
function EdgeMask(clip C, int "threshold", float "blur")
{
    thr = Default(threshold, 128)
    blr = Default(blur, 0.6)

    thr = C.sc8x(threshold)
    return C.mt_edge("hprewitt", thY1=thr, thY2=thr, chroma=C.sc8s(-128))
    \       .Blur(blr)
}

##################################
### merge 2 clips with edge mask (deprecated)
function EdgeMerge(clip N, clip M, clip E, 
\               int "maskthr", float "maskblur",
\               float "strength", bool "showmask")
{
    return EdgeMerge2(N, E, M, maskthr, maskblur, strength, showmask)
}

# https://forum.doom9.org/showthread.php?p=1835903#post1835903
##################################
### merge 2 clips with edge mask
##
## @ C        - source clip for non-edges
## @ E        - source clip for edges in result as determined by edge mask
## @ M        - edge mask; overrides internally generated mask 
##              (if supplied, 'maskthr' and 'maskblur' have no effect)
## @ maskthr  - edge mask threshold (0~255, default 128)
## @ maskblur - amount of mask blur (0.0~1.0, default 0.6)
## @ strength - strength of clip 'E' blend (0.0~1.0, default 1.0)
## @ showmask - if true, return the edge mask
## 
function EdgeMerge2(clip C, clip E, clip "M", 
\               int "maskthr", float "maskblur",
\               float "strength", bool "showmask")
{
    Assert(C.Is420||C.Is422||C.Is444, 
    \  "EdgeMerge clip 'C' - YUV 420/422/444 only")
    Assert(E.Is420||E.Is422||E.Is444, 
    \  "EdgeMerge clip 'E' - YUV 420/422/444 only")
    maskthr  = Min(Max(0, Default(maskthr, 128)), 255) ## autoscaled
    maskblur = Min(Max(0.0, Default(maskblur, 0.6)), 1.0)
    strength = Min(Max(0.0, Default(strength,  1.0)), 1.0)
    showmask = Default(showmask, false)

    M = (Defined(M) && IsClip(M)) ? M
    \ : C.mt_edge("hprewitt", thY1=maskthr, thY2=maskthr, chroma=C.sc8s(-128))
    \     .Blur(maskblur)

    return (showmask) ? M 
    \ : Overlay(C, E, mask=M, opacity=strength)
}

### fka BoxMask3
##################################
### [[Mask]]: force areas /out/side given rectangle to black
##
## @ x1, y1        - left,  top of rectangle mask
## @ x2, y2        - right, bottom of rectangle mask
## @ wid, hgt      - width, height of rectangle mask; 'x2', 'y2' have priority
## @ outline_width - if zero (default), draw a filled rectangle; else draw outline
## @ preclear      - if true (default), start with a pure white (opaque) clip, 
##                     else keep 'C' inside rect & set to black outside
##
function BoxMaskExclude(clip C, 
\               int "x1", int "y1", int "x2", int "y2",
\               int "wid", int "hgt", float "outline_width",
\               bool "preclear")
{
    preclear = Default(preclear, true)
    w  = C.Width
    h  = C.Height
    x1 = Default(x1, 0)
    y1 = Default(y1, 0)
    x2 = Default(x2, x1+Default(wid, w))
    y2 = Default(y2, y1+Default(hgt, h))
    o  = Default(outline_width, 0.0)
    o  = 0.1 * Round(10.0 * Default(outline_width, 0.0))
    o2 = o / 2.0    

    C = (preclear==false) ? C.ConvertToY8
    \ : BlankClip(C.ConvertToY8, color=$ffffff)

    ## arg validation v2:
    x1 = Min(Max( 0  , x1), C.Width-2)
    x2 = Min(Max(x1+1, x2), C.Width-1)
    y1 = Min(Max( 0  , y1), C.Height-2)
    y2 = Min(Max(y1+1, y2), C.Height-1)

    ## letterbox args:
    llft = x1
    ltop = y1
    lrgt = Min(Max(0, w-x2), C.Width-(llft+1))
    lbot = Min(Max(0, h-y2), C.Height-(ltop+1))

    return (o>0.1) 
    \ ? C.BoxMaskExclude(x1+Ceil(o2),  y1+Ceil(o2),  x2-Floor(o2), y2-Floor(o2)).Invert
    \    .BoxMaskExclude(x1-Floor(o2), y1-Floor(o2), x2+Ceil(o2),  y2+Ceil(o2), preclear=false) 
    \ : C.Letterbox(ltop, lbot, llft, lrgt, color=$0).ColorYUV(levels="TV->PC")
}

### fka BoxMask4
##################################
##### [[Mask]]: force area /in/side given rectangle to white
##
## @ x1, y1        - left,  top of rectangle mask
## @ x2, y2        - right, bottom of rectangle mask
## @ wid, hgt      - width, height of rectangle mask; 'x2', 'y2' have priority
## @ outline_width - if zero (default), draw a filled rectangle; else draw outline
## @ preclear      - if true (default), start with a pure black clip, 
##                     else keep 'C' outside rect & set to white inside
##
function BoxMaskInclude(clip C, 
\               int "x1", int "y1", int "x2", int "y2",
\               int "wid", int "hgt", float "outline_width",
\               bool "preclear")
{
    preclear = Default(preclear, true)

    C = (preclear==false) ? C.ConvertToYUY2
    \ : BlankClip(C, pixel_type="YUY2", color=$0)

    return C.Layer(
    \           C.BoxMaskExclude(
    \               x1, y1, x2, y2, 
    \               wid, hgt, outline_width, 
    \               preclear=true).ConvertToYUY2,
    \           op="lighten"
    \      )   
}

#######################################
### [[Overlay]] a clip or solid color using [[BoxMaskExclude]]
##
## @ x1, y1         - left, top of rectangle mask
## @ x2, y2         - right, bottom of rectangle mask
## @ wid, hgt       - width, height of rectangle mask; 'x2', 'y2' have priority
## @ outline_width  - if zero, draw a filled rectangle; else draw outline 
##                    (default 0)
## @ over           - if supplied, use for overlay fill, overriding 'color'
## @ color          - default black
## @ mode, opacity  - cf. [[Overlay]]
## @ maskblur       - mask blur
##
function BoxMaskOverlay(clip C, 
\               int "x1", int "y1", int "x2", int "y2",
\               int "wid", int "hgt", int "outline_width",
\               clip "over", int "color",
\               string "mode", float "opacity", float "maskblur")
{
    Assert(!C.IsYV411, 
    \  "BoxMaskOverlay: YV411 not accepted") ## (cf. Overlay)
    color   = Default(color, $0)
    mode    = Default(mode, "blend")
    opacity = Float(Min(Max(0,  Default(opacity, 1)), 1))
    a_blur  = Default(maskblur, 0.0)

    w  = C.Width
    h  = C.Height
    x1 = Default(x1, 0)
    y1 = Default(y1, 0)
    x2 = Default(x2, x1+Default(wid, w))
    y2 = Default(y2, y1+Default(hgt, h))
    o  = Min(Default(outline_width, 0), w/8)

    over = (IsClip(over) && over.Width==C.Width && over.Height==C.Height) 
    \ ? over /*.AssumeFPS(C).Loop*/
    \ : BlankClip(C, color=color)

    return (opacity<0.001) ? C
    \ : C.Overlay(over, 
    \           mask=C.BoxMaskExclude(x1, y1, x2, y2, outline_width=o, preclear=true)
    \                 .Blur(a_blur),
    \           mode=mode, 
    \           opacity=opacity)
}

#######################################
### merge 'Lo', 'Hi' clips based on clip 'T' luma
##
## @ T      - control clip: PC range, color format must match Lo, Hi.
## @ Lo, Hi - source clips: properties must be compatible with one another
## @ bias   - if < 0, favor 'Lo' clip; if > 0, favor 'Hi' clip; default 0.0
## 
function MergeLH(clip T, clip Lo, clip Hi, float "bias")
{
    Assert(Lo.Width==Hi.Width && Lo.Height==Hi.Height
    \   && Lo.Width==T.Width && Lo.Height==T.Height,
    \   "MergeLH: 'Lo', 'Hi' and 'T' height and width must match")
    Assert(Lo.PixelType==Hi.PixelType
    \   && Lo.PixelType==T.PixelType,
    \   "MergeLH: 'Lo', 'Hi' and 'T' color format and bit depth must match")

    bias = Default(bias, 0.0)

    T = (Abs(bias)<0.01) ? T
    \ : (   bias < 0.00) ? T.Gammacurve(1.0/(-bias+1.0), tvrange=false)
    \                    : T.Gammacurve(bias+1.0, tvrange=false)

    ## eq. (z * (x / range_size)) + (y * (1 - (x / range_size)))
    ##
    s = "x range_size / z * 1 x range_size / - y * + "

    return (Lo.HasAlpha)
    \ ? Expr(T, Lo, Hi, s, s, s, s, format=Lo.PixelType)
    \ : Expr(T, Lo, Hi, s, s, s,    format=Lo.PixelType)
}

## old version here: http://forum.doom9.org/showthread.php?p=1691736#post1691736
#######################################
### merge 'Lo', 'Mid', 'Hi' clips based on clip 'T' luma
##
## @ T         - control clip: PC range; color format must match Lo/Mid/Hi
## @ Lo, Mid, Hi - source clips: properties must be compatible with one another
## @ bias      - if < 0, favor 'Lo' clip; if > 0, favor 'Hi' clip; default 0.0
##
## @ ctr_lo    - peak response luminance for low mask 'bandpass';
##               range = -127d_127d; default 0d
##
## @ ctr_hi    - peak response luminance for high mask;
##               range = 127d_383d; default 255d
##
## @ qfactor   - sharpness of the 'bandpass filter'; 
##               higher values result in steeper slope, narrower 'passband'
##               range = 0.0(sharp)_40.0(broad); default 0.7;
##               "useable" range = 0.0_1.4
##             
## @ showmasks - if true, show original + 3 masks in quad split
##
## Example - black & white desaturate
## | MergeLMH(Last, Grayscale, Last, Grayscale)
##
## version 2017-05-19 AVS+, MaskTools 2.2.x deep color
##
function MergeLMH(clip T, clip Lo, clip Mid, clip Hi, float "bias",
\               float "ctr_lo", float "ctr_hi", float "qfactor",
\               bool "showmasks")
{
    Assert(Lo.Width==Mid.Width && Lo.Height==Mid.Height
    \   && Lo.Width==Hi.Width && Lo.Height==Hi.Height
    \   && Lo.Width==T.Width && Lo.Height==T.Height,
    \   "MergeLH: 'Lo', 'Mid', 'Hi' and 'T' height and width must match")
    Assert(Lo.PixelType==Mid.PixelType 
    \   && Lo.PixelType==Hi.PixelType
    \   && Lo.PixelType==T.PixelType,
    \   "MergeLH: 'Lo', 'Mid', 'Hi' and 'T' color format and bit depth must match")

    bias = Default(bias, 0.0)
    show = Default(showmasks, false)

    T = (Abs(bias)<0.01) ? T
    \ : (   bias < 0.00) ? T.Gammacurve(1.0/(-bias+1.0), tvrange=false)
    \                    : T.Gammacurve(bias+1.0, tvrange=false)

    cLo  = Min(Max( -127, Default(ctr_lo,   0.0)), 127)
    cHi  = Min(Max(  127, Default(ctr_hi, 255.0)), 383)
    q    = Min(Max(0.001, Default(qfactor, 0.7)),  40.0)
    
    wid  = T.sc8f(60)
    ramp = T.sc8f(Min(Max(0, 59.82 * Pow(q, -0.76)),  512))

    ## equation:
    ## 255 * ((1 + ((wid/fs1x2) * (fs1/ramp)) ) - ( (abs(x-ctr)/fs1) * (fs1/ramp) ))
    ## RPN:
    s = ("255 @F 1 $wid 256 @F 2 * / 256 @F $ramp / * + x $ctr - abs 256 @F / 256 @F $ramp / * - * ")
    \       .ReplaceStr("$wid",   StrinF(wid))
    \       .ReplaceStr("$ramp",  StrinF(ramp))

    sLo  = s.ReplaceStr("$ctr", T.sc8s(cLo)) 
    sHi  = s.ReplaceStr("$ctr", T.sc8s(cHi)) 
    m128 = T.sc8s(-128)

    mask_lo = T.mt_lut(sLo, chroma=m128)
    mask_hi = T.mt_lut(sHi, chroma=m128)

    ## equation:
    ## 255 - (x + y)
    ## RPN:
    sMid = "256 @B x y + - "

    mask_mid = mt_lutxy(mask_lo, mask_hi, sMid)

    R = T.mt_merge(Lo,  mask_lo,  luma=true)
    \    .mt_merge(Mid, mask_mid, luma=true)
    \    .mt_merge(Hi,  mask_hi,  luma=true) 

    return (!show) ? R
    \  : StackVertical(
    \       StackHorizontal(T.AddBorders(0,0,8,0), mask_lo).AddBorders(0,0,0,8),
    \       StackHorizontal(mask_mid.AddBorders(0,0,8,0), mask_hi)
    \    ).BilinearResize(T.Width, T.height)
    \     .Subtitle("Low",    align=9)
    \     .Subtitle("\nMid",  align=4, lsp=0)
    \     .Subtitle("\nHigh", align=6, lsp=0)
}

##################################
### merge five clips keyed on luma range of base clip
##
## All clips 'C' & 'c1' through 'c5':
##   - color format should match
##   - YV411 not accepted
##   - YUV444, 10-bits or better recommended
##
## @ C       - source of luma key data; video does NOT appear in the result, but the audio does.
## @ c1 - c5 - input clips for five luma 'bands'; all default to 'C'; 
##                 (1=lowlights; 2=mid-lows; 3=mids; 4=mid-highs; 5=highlights)
##             same size, color format as 'C' recommended
## @ luma    - if true (default), process  luma   (Y),   else copy 'C'  luma  to output
## @ chroma  - if true (default), process chroma (U, V), else copy 'C' chroma to output
## @ blend   - if true, use 'blend' mode like MergeLMH; default false, use 'add' mode
## @ output  - if 0 (default), return the five-way merge;
##             if 1 through 5, return the corresponding mask; 
##             else if < 0, 
##                 Interleave the five masks w/ ShowMask(mode="cyan");
##
function MergeFiveBand(clip C, 
\               clip "c1", clip "c2", clip "c3", clip "c4", clip "c5", 
\               bool "luma", bool "chroma", bool "blend", int "output")
{
    Assert(!C.IsYV411 && !C.IsRGB, 
    \  "MergeFiveBand: RGB, YV411 not accepted") ## (cf. Overlay)
    c1   = Default(c1, C)
    c2   = Default(c2, C)
    c3   = Default(c3, C)
    c4   = Default(c4, C)
    c5   = Default(c5, C)
    luma = Default(luma, true)
    chrm = Default(chroma, true)
    blnd = Default(blend, false)
    outp = Default(output, 0)
    m128 = C.sc8s(-128)

    ## magic! (or hack?)
    s0 = ("256 @F 1 $wid 256 @F 2 * / 256 @F $ramp / * + x $ctr - abs 256 @F / 256 @F $ramp / * - * ")

    C
    ## caution - these numbers are critical to accurate reconstruction of the bands;
    ##           if you change them, test thoroughly.
    M1 = mt_lut( 
    \       yexpr=s0.ReplaceStr("$ctr",  sc8s(25))
    \               .ReplaceStr("$wid",  sc8s(30))
    \               .ReplaceStr("$ramp", sc8s(40)),
    \       chroma=m128)

    M3 = mt_lut( 
    \       yexpr=s0.ReplaceStr("$ctr",  sc8s(128)) 
    \               .ReplaceStr("$wid",  sc8s(20))
    \               .ReplaceStr("$ramp", sc8s(40)),
    \       chroma=m128)

    M5 = mt_lut( 
    \       yexpr=s0.ReplaceStr("$ctr",  sc8s(230)) 
    \               .ReplaceStr("$wid",  sc8s(30))
    \               .ReplaceStr("$ramp", sc8s(40)),
    \       chroma=m128)

    MB = mt_lut("x 128 @F > 0 255 @F ? ", chroma=m128)
    MT = mt_lut("x 128 @F > 255 @F 0 ? ", chroma=m128)

    M2 = M1.mt_lutxy(M3, "255 @F x y + - ", chroma=m128)
    \      .mt_lutxy(MB, "x y min",         chroma=m128)

    M4 = M5.mt_lutxy(M3, "255 @F x y + - ", chroma=m128)
    \      .mt_lutxy(MT, "x y min",         chroma=m128)

    (blnd)
    \ ? C.mt_merge(c1, M1, luma=true)
    \    .mt_merge(c2, M2, luma=true)
    \    .mt_merge(c3, M3, luma=true) 
    \    .mt_merge(c4, M4, luma=true) 
    \    .mt_merge(c5, M5, luma=true) 
    \ : BlankClip(C, color_yuv=$008080) [* y=0, not 16 here *]
    \    .Overlay(c1, mask=M1, mode="add")
    \    .Overlay(c2, mask=M2, mode="add")
    \    .Overlay(c3, mask=M3, mode="add")
    \    .Overlay(c4, mask=M4, mode="add")
    \    .Overlay(c5, mask=M5, mode="add")
    # NG: use444=false 

    Y = (luma) ? ExtractY : C.ExtractY
    U = (chrm) ? ExtractU : C.ExtractU
    V = (chrm) ? ExtractV : C.ExtractV
    (C.IsYUVA)
    \ ? CombinePlanes(
    \       Y, U, V, C.ExtractA, "YUVA", pixel_type=C.PixelType)
    \ : CombinePlanes(
    \       Y, U, V, "YUV", pixel_type=C.PixelType)

    (outp<0) 
    \ ? Interleave(
    \     ShowFrameNumberAligned(align=5),
    \     C.ShowMask(M1, "cyan").Subtitle("M1", align=8),
    \     C.ShowMask(M2, "cyan").Subtitle("M2", align=8),
    \     C.ShowMask(M3, "cyan").Subtitle("M3", align=8),
    \     C.ShowMask(M4, "cyan").Subtitle("M4", align=8),
    \     C.ShowMask(M5, "cyan").Subtitle("M5", align=8)
    \   ).SelectRangeEvery(36, 6).AssumeFPS(C)
    \ : (outp==1) ? M1
    \ : (outp==2) ? M2
    \ : (outp==3) ? M3
    \ : (outp==4) ? M4
    \ : (outp==5) ? M5
    \ : Last
[*
    !(dbg) ? Last
    \ : Interleave(
    \     M1.Subtitle("M1", align=8),
    \     M2.Subtitle("M2", align=8),
    \     M3.Subtitle("M3", align=8),
    \     M4.Subtitle("M4", align=8),
    \     M5.Subtitle("M5", align=8)
    \   ).SelectRangeEvery(25, 5).AssumeFPS(C)
*]
    return (C.HasAudio)
    \ ? AudioDub(C) 
    \ : Last
}

# http://forum.doom9.org/showthread.php?p=1670559#post1670559
##################################
### mask a smooth range of source hues & saturation
##
## @ h        - the middle hue to select
## @ d        - approximate range (clamped to 3° min, 90° max)
## @ maxSat, minSat - see [[#SatMask]] (default 255, 0) (autoscaling)
## @ showmap  - if true, show active hue-to-luma map
## @ showargs - if true, show arguments for debugging
##
## @ raffriff42 Feb-2014
##
function SmoothHueMask(
\               clip C, int h, float d,
\               int "maxSat", int "minSat",
\               bool "showmap", bool "showargs")
{
    Assert(C.IsYUV && (C.Is420 || C.Is444), 
    \   "SmoothHueMask: source must be YUV420 or YUV444")
    Assert(h>(-36000), 
    \   "SmoothHueMask: argument 'h' too small (min value -36000)")
    
    h        = (h + 36000) % 360
    d        = Min(Max(3, d), 90)
    xlo      = Min(Max(    0, Default(minSat,   0)), 250) * 3.0 / 256
    xhi      = Min(Max(xlo+5, Default(maxSat, 255)), 255) * 3.0 / 256
    showmap  = Default(showmap, false)
    showargs = Default(showargs, false)

    xlo   = C.sc8f(xlo)
    xhi   = C.sc8f(xhi)
    m128  = C.sc8s(-128)

    ## ** build expression(s) to convert U,V to hue **

    ## /atd/ == arctan(V/U) in degrees
    atd = ("y $m - x $m - / atan 180 * pi / ")
    ## ("$m" == "mid scale")

    ## /tr0/ == boolean test + result if true
    ## /r78/ == default result if all tests are false
    ## /mm/ == map mask string (translate hue to luma with offset)
    ## result hue(0)=luma(0); hue(180)=luma(180)±; hue(359)=luma(359)±; etc
    mm = "x $m == y $m == & -1 "              [* undefined       *]
    \  + "y $m == x $m > & 0 "                [*   0 degrees exactly (no arctan) *]
    \  + "x $m == y $m > & 90 "               [*  90   ''        *]
    \  + "y $m == x $m < & 180 "              [* 180   ''        *]
    \  + "x $m == y $m < & 270 "              [* 270   ''        *]
    \  + "x $m > y $m < & " + atd + "360 + "  [* Quadrant 1  *]
    \  + "x $m > y $m > & " + atd             [* Quadrant 2  *]
    \  + atd + "180 + "                       [* Quadrants 3, 4 *]
    \  + "? ? ? ? ? ? "

    ## /hc/ == "hue center", 180° from wrap/rollover; gray in final mask
    ## allowed values = (0|90|180|270); default = 180
    hc = (h>=315 || h<45)  ? 0
    \  : (h>=45  && h<135) ? 90
    \  : (h>=135 && h<225) ? 180
    \  : (h>=225 && h<315) ? 270
    \  : 180 ## not reached

    ## apply wrapped offset to put hue center at midrange
    ra = (hc==0)   ? "180 + "
    \  : (hc==90)  ?  "90 + "
    \  : (hc==270) ? "270 + "
    \  : " "
    mm = mm + ra + "360 % " ## modulo 360 (0-359)

    ## translate hue to adjusted luma (0-359 scale)
    hl = (h>=315) ? h - 180
    \  : (h<45)   ? h + 180
    \  : (h>=45  && h<135) ? h + 90
    \  : (h>=135 && h<225) ? h
    \  : (h>=225 && h<315) ? h - 90
    \  : h ## not reached

    ## create soft hue mask; scale to 0-255d
    sm = (showmap)
    \  ? mm + " "+C.sc8s(255)+" * 360 / "
    \  : mm + String(hl)
    \  + " - abs "+String(-230/d) + " * 360 + "
    \  + " "+C.sc8s(256)+" * 360 / "

    ## "$m" == "mid scale"
    sm = sm.ReplaceStr("$m", C.sc8s(128))

    mc = mt_lutxy(C.ExtractU, C.ExtractV, sm, chroma=m128)
    \    .BilinearResize(C.Width, C.Height)

    ms = SatMask(C, maxSat, minSat)

    mcs = (xlo<=0 && xhi>=C.sc8x(255*3.0/256)) ? mc 
    \   : mt_lutxy(mc, ms, "x y min", chroma=m128)

    return (showargs==false) ? mcs
    \  : mcs.Subtitle("SmoothHueMask: h="+String(h)
    \             +"; d="+String(d, "%1.0f")
    \             +"; max="+String(maxSat)
    \             +"; min="+String(minSat),
    \             align=8, size=mc.Height/20)
}

## see MergeLMH http://forum.doom9.org/showthread.php?p=1691736#post1691736
## http://forum.doom9.org/showthread.php?p=1745641#post1745641
##################################
### mask a range of source saturation; transform saturation->lightness
##
## @ maxSat, minSat - see [[MaskHS]] (default 255, 0) (autoscaling)
## @ sensitivity    - increase saturation->lightness in output (default 1.5)
##                    note "unity" transform would be about 1.42 (~256/180)
##
function SatMask(clip C, int "maxSat", int "minSat", float "sensitivity")
{
    Assert(C.IsYUV && (C.Is420 || C.Is444), 
    \   "SatMask: source must be YUV420 or YUV444")

    xlo   = Min(Max(    0, Default(minSat,   0)), 250) * 3.0 / 256
    xhi   = Min(Max(xlo+5, Default(maxSat, 255)), 255) * 3.0 / 256
    sens  = Default(sensitivity, 1.5)

    xlo   = C.sc8f(xlo)
    xhi   = C.sc8f(xhi)
    m128  = C.sc8s(-128)

    mask_sat = mt_lutxy(C.ExtractU, C.ExtractV, 
    \       yexpr=mt_polish(
    \           ("((((x-$m)^2)+((y-$m)^2))^0.5)*$s")
    \            .ReplaceStr("$m", C.sc8s(128))
    \            .ReplaceStr("$s", StrinF(2.0*sens, 3))), 
    \       chroma=m128)
    \    .BilinearResize(C.Width, C.Height)

    mask_lo = mask_sat.mt_lut(
    \       yexpr=mt_polish(
    \           ("((-0.01 * x) + $lo) * 256")
    \            .ReplaceStr("$lo", String(xlo))),
    \       chroma=m128)

    mask_hi = mask_sat.mt_lut(
    \       yexpr=mt_polish(
    \           ("1 - ((-0.01 * x) + $hi) * 256")
    \            .ReplaceStr("$hi", String(xhi))),
    \       chroma=m128)
    
    mask_mid = mt_lutxy(mask_lo, mask_hi, 
    \       yexpr=mt_polish(
    \           ("-1 * (x + y) + $fs") 
    \            .ReplaceStr("$fs", C.sc8s(256))),
    \       chroma=m128)

    return (xlo<=0 && xhi>=C.sc8x(255*3.0/256)) ? mask_sat
    \ : mt_lutxy(mask_sat, mask_mid, 
    \       yexpr=mt_polish("min(x, y)"), 
    \       chroma=m128)
}

#######################################################################################
### ANTIALIAS FILTERS 
#######################################################################################

#include "E:\Programs\Avisynth_Plugins\plugins-NOT\_misc\Utils-r43.avsi"
#Import(pathMisc + "Utils-r43.avsi")
#include "E:\Programs\Avisynth_Plugins\plugins-NOT\QTGMC\QTGMC_loadx64.avsi"
#Import(pathBase + "QTGMC\QTGMC_loadx64.avsi") ## loads latest QTGMC
##################################
### alias [[UU_NQAA]] for backwards compatibility
##
## @ option - 0 for [[Nnedi3]] before [[QTGMC]] (smoother); 
##            else Nnedi3 after; default 0
##            (no effect if 'speed' >= 0)
##
function UU_NQAA(clip C, int "speed", bool "motionblur", int "wid", int "hgt", int "option")
{
    Assert(C.IsYV12, "UU_NQAA: source must be YV12")
    speed  = Default(speed, 0)
    blur   = Default(motionblur, false)
    wid    = Default(wid, C.Width)
    hgt    = Default(hgt, C.Height)
    option = Default(option, 0) 

    R = (speed>=0 || option!=0) 
    \ ? C 
    \ : C.Nnedi3EnlargeYV12(wid, hgt, speed)

    R = R.QTGMC(InputType=1, 
    \  Preset=(speed < 0 ? "Very Slow"
    \        : speed > 0 ? "Medium" 
    \        : "Slower"), 
    \  ShutterBlur=(blur ? 3 : 0),
    \  ShutterAngleSrc=(blur ? 120 : 180), 
    \  ShutterAngleOut=(blur ? 270 : 180))

    return (speed>=0 || option==0) 
    \ ? R 
    \ : R.Nnedi3EnlargeYV12(wid, hgt, speed)
}

## http://forum.doom9.org/showthread.php?p=1761280#post1761280 posted 19th March 2016
##### (deleted thread: "Removing the Jaggies" OP: ingoldie)
## http://avisynth.nl/index.php/QTGMC
#include "E:\Programs\Avisynth_Plugins\plugins-NOT\_misc\Utils-r43.avsi"
#Import(pathMisc + "Utils-r43.avsi")
#include "E:\Programs\Avisynth_Plugins\plugins-NOT\QTGMC\QTGMC_loadx64.avsi"
#Import(pathBase + "QTGMC\QTGMC_loadx64.avsi") ## loads latest QTGMC
## also requires Nnedi3EnlargeYV12, nnedi3
##################################
### smooth certain types of aliasing artifacts with [[Nnedi3]] + [[QTGMC]]
### (less "twinkling")
##
## QTGMC  = anti-shimmer (slightly slow) 
## Nnedi3 = spatial AA (very slow) 
##
## @ speed      - if > 0, tune for speed; if < 0, enable Nnedi3;
##                default = 0 (medium)
## @ motionblur - true for moderate motion blur; default false
## @ wid, hgt   - only used if speed < 0
##
function NQAA(clip C, int "speed", bool "motionblur", int "wid", int "hgt")
{
    Assert(C.Is420, "NQAA: source must be YUV420")
    speed  = Default(speed, 0)
    blur   = Default(motionblur, false)
    wid    = Default(wid, C.Width)
    hgt    = Default(hgt, C.Height)

    R = (speed>=0) ? C 
    \ : C.Nnedi3EnlargeYV12(wid, hgt, speed)

    R = R.QTGMC(InputType=1, 
    \  Preset=(speed < -1 ? "Very Slow"
    \        : speed > 0 ? "Medium" 
    \        : "Slower"), 
    \  ShutterBlur=(blur ? 3 : 0),
    \  ShutterAngleSrc=(blur ? 120 : 180), 
    \  ShutterAngleOut=(blur ? 270 : 180))

    return R 
}

#QTGMC(InputType=1, Preset="Slower")
#QTGMC(InputType=1, Preset="Very Slow", ShutterBlur=3, ShutterAngleSrc=120, ShutterAngleOut=270)

#include "E:\Programs\Avisynth_Plugins\plugins-NOT\QTGMC\QTGMC_loadx64.avsi"
#Import(pathBase + "QTGMC\QTGMC_loadx64.avsi") ## loads latest QTGMC
##################################
### alias [[pow2Qt]] for backwards compatibility
##
function AA_pow2Qt(clip C, float "sharpen", bool "cpoint", bool "doublesize")
{
    Assert(C.IsRGB||C.IsYV12||C.IsY8, 
    \   "AA_pow2Qt: source must be RGB, YV12 or Y8")

    shp = Default(sharpen, 0.3)
    cpt = Default(cpoint, false)
    dbl = Default(doublesize, false)

    return pow2Qt(C, sharpen, doublesize, cpoint) 
}

#include "E:\Programs\Avisynth_Plugins\plugins-NOT\QTGMC\QTGMC_loadx64.avsi"
#Import(pathBase + "QTGMC\QTGMC_loadx64.avsi") ## loads latest QTGMC
#include "E:\Programs\Avisynth_Plugins\plugins-NOT\Nnedi3\nnedi3 - Readme.txt"
# http://forum.doom9.org/showthread.php?p=1737201#post1737201
##################################
### Antialiasing (AA) for game footage
### (blending [[nnedi3_rpow2]] & [[QTGMC]]) 
### (sharper than [[NQAA]](-1), but slow)
##
## @ sharpen - post-process Sharpen to mitigate QTGMC smoothing
##             (on double-size image, so apparent effect is 1/2)
##             (0.2-0.3 best in initial tests; default 0.3)
## @ doublesize - 2x enlargement, but AA less effective
##
## v0.42.02 - support RGB32, RGB24, Y8 (and YV12 as before)
## v0.42.03 - drop 'cpoint'
##
function pow2Qt(clip C, float "sharpen", bool "doublesize", bool "motionblur")
{
    Assert(C.IsRGB||C.IsYV12||C.IsY8, 
    \   "pow2Qt: source must be RGB, YV12 or Y8")

    shp  = Default(sharpen, 0.0)
    dbl  = Default(doublesize, false)
    blur = Default(motionblur, false)
    ## @ cpoint  - if source is YUV, upscale pass2 chroma with PointResize (sharper)
    #cpt = Default(cpoint, false)

    return 
    \   (C.IsYV12) ? C._pow2QtYV12(sharpen, doublesize, motionblur)
    \ : (C.IsY8)   ? C._pow2QtY   (sharpen, doublesize, motionblur)
    \ :              C._pow2QtRGB (sharpen, doublesize, motionblur)
    ## Y8   : 25 fps
    ## YV12 : 13 fps
    ## RGB24:  8 fps
    ## RGB32:  7 fps
}
##################################
function _pow2QtYV12(clip C, float "sharpen", bool "doublesize", bool "motionblur")
{
    Assert(C.IsYV12, "_pow2QtYV12: source must be YV12")

    shp  = Default(sharpen, 0.3)
    dbl  = Default(doublesize, false)
    blur = Default(motionblur, false)
    #cpt = Default(cpoint, false)

    C
    wid = Width
    hgt = Height

    ## pass 1-A: double size nnedi3(Y), XXResize(C)
    Y  = nnedi3_rpow2(rfactor=2, nsize=0, nns=3, qual=2, 
    \                 cshift="Spline64Resize")    
    #UV = (cpt) 
    #\  ? PointResize(2*wid, 2*hgt, src_top=0.25)
    #\  : Spline64Resize(2*wid, 2*hgt, src_left=+0.5, src_top=+0.5)
    UV = Spline64Resize(2*wid, 2*hgt, src_left=+0.5, src_top=+0.5) 
    YToUV(UV.UToY, UV.VToY, Y.ConvertToY8)

    ## pass 1-B: scale back
    BicubicResize(wid, hgt, b=-1, c=0, src_left=-0.5, src_top=+0.5)

    ## pass 2-A: double size nnedi3(Y), XXResize(C)
    Y = nnedi3_rpow2(rfactor=2, nsize=0, nns=3, qual=2, 
    \                 cshift="Spline64Resize") 
    #UV = (cpt) 
    #\  ? PointResize(2*wid, 2*hgt, src_top=0.25)
    #\  : Spline64Resize(2*wid, 2*hgt, src_left=-0.5, src_top=-0.5)
    UV = Spline64Resize(2*wid, 2*hgt, src_left=-0.5, src_top=-0.5) 
    YToUV(UV.UToY, UV.VToY, Y.ConvertToY8)
    
    ## pass 2-B: QTGMC de-shimmer, sharpen
    QTGMC(preset="Medium", InputType=1,
    \  ShutterBlur=(blur ? 3 : 0),
    \  ShutterAngleSrc=(blur ? 160 : 180), 
    \  ShutterAngleOut=(blur ? 240 : 180))
    Sharpen(shp)

    ## pass 2-C: if doublesize=false, scale back
    return (dbl) 
    \  ? Last 
    \  : BicubicResize(wid, hgt, b=-1, c=0, src_left=0.5, src_top=-0.5)
}
##################################
function _pow2QtY(clip C, float "sharpen", bool "doublesize", bool "motionblur")
{
    Assert(C.IsY8 || C.IsYV12, "_pow2QtY: source must be Y8 or YV12")

    shp = Default(sharpen, 0.3)
    dbl  = Default(doublesize, false)
    blur = Default(motionblur, false)
    isYV12 = C.IsYV12

    C
    wid = Width
    hgt = Height

    ## pass 1-A: double size nnedi3(Y), XXResize(C)
    isYV12 ? Last : ConvertToYV12
    nnedi3_rpow2(rfactor=2, nsize=0, nns=3, qual=2, 
    \            cshift="Spline64Resize")    

    ## pass 1-B: scale back
    BicubicResize(wid, hgt, b=-1, c=0) #, src_left=-0.5, src_top=+0.5)

    ## pass 2-A: double size nnedi3(Y), XXResize(C)   
    nnedi3_rpow2(rfactor=2, nsize=0, nns=3, qual=2, 
    \             cshift="Spline64Resize") 

    ## pass 2-B: QTGMC de-shimmer, sharpen
    QTGMC(preset="Medium", InputType=1, RepChroma=false,
    \  ShutterBlur=(blur ? 3 : 0),
    \  ShutterAngleSrc=(blur ? 120 : 180), 
    \  ShutterAngleOut=(blur ? 270 : 180))
    isYV12 ? Last : ConvertToY8
    Sharpen(shp)

    ## pass 2-C: if doublesize=false, scale back
    return (dbl) 
    \ ? Last 
    \ : BicubicResize(wid, hgt, b=-1, c=0) #, src_left=0.5, src_top=-0.5)
}
##################################
function _pow2QtRGB(clip C, float "sharpen", bool "doublesize", bool "motionblur")
{
    Assert(C.IsRGB, "_pow2QtRGB: source must be RGB")

    shp  = Default(sharpen, 0.3)
    dbl  = Default(doublesize, false)
    blur = Default(motionblur, false)

    return (C.IsRGB32) 
    \ ? MergeARGB(
    \       C.ShowAlpha("YV12")._pow2QtY(sharpen, doublesize, motionblur),
    \       C.ShowRed  ("YV12")._pow2QtY(sharpen, doublesize, motionblur),
    \       C.ShowGreen("YV12")._pow2QtY(sharpen, doublesize, motionblur),
    \       C.ShowBlue ("YV12")._pow2QtY(sharpen, doublesize, motionblur)
    \   )
    \ : MergeRGB(
    \       C.ShowRed  ("YV12")._pow2QtY(sharpen, doublesize, motionblur),
    \       C.ShowGreen("YV12")._pow2QtY(sharpen, doublesize, motionblur),
    \       C.ShowBlue ("YV12")._pow2QtY(sharpen, doublesize, motionblur),
    \       pixel_type="RGB24"
    \   )
} 

##################################
### smooth certain types of aliasing artifacts (slow!)
### with [[YFRC2]]/[[FrameRateConverter]] + [[Nnedi3]] + [[QTGMC]] + [[FFT3DFilter]]
##
## @ faster      - if true, use faster, lower quality settings (default false)
## @ nosmooth    - if true, do not use FFT3DFilter edge-filtering (default false)
## @ motionblur  - if true, add slight motion blur (default false)
## @ yfrc        - if true, use YFRC2; else (default) use FrameRateConverter
##
## @ version 0.42.01 28-Sep-2017
## @ version 0.42.04 add FFT3DFilter 
## @ version 0.42.05 yfrc
##
function FRAANQ(clip C, bool "faster", bool "nosmooth", bool "motionblur", bool "yfrc") 
{
    Assert(C.Is444 || C.Is420, 
    \   "FRAANQ: source must be YUV444 or YUV420")
    fast = Default(faster, false)
    nosm = Default(nosmooth, false)
    blur = Default(motionblur, false)
    yfrc = Default(yfrc, false)
    
    C
    yfrc = (0>0)
    (yfrc)
    \ ? Eval(""" YFRC2(weakmask=1>0) """, 
    \       name="FRAANQ (yfrc=true)")
    \ : Eval(""" FrameRateConverter(Preset=(fast ? "fast" : "normal")) """,
    \       name="FRAANQ (yfrc=false)")
    
    SelectOdd
    
    nnedi3_rpow2(2, nsize=0, nns=3, qual=1, 
    \   cshift="Spline64Resize", 
    \   fwidth=C.Width, fheight=C.Height)

    ## QTGMC presets: (slower|slow|medium|fast|faster)
    QTGMC(
    \   InputType       = 1, 
    \   Preset          = (fast ? "faster" : "fast"), 
    \   ShutterBlur     = (blur ? 3 : 0),
    \   ShutterAngleSrc = (blur ? 120 : 180), 
    \   ShutterAngleOut = (blur ? 270 : 180)
    \ )

    S = (nosm) ? Nop
    \ : FFT3DFilter(sigma=20, sigma4=20, bw=24, bh=24, 
    \       bt=3, ow=8, oh=8, sharpen=0.5, ncpu=2)
    
    E = (nosm) ? Nop
    \ : mt_edge("laplace", thY1=16, thY2=16, chroma=C.sc8s(-128))
    \   .Levels(0, 1.0, 128, 0, 255)
    \   .TemporalSoften(2, 255, 255, 255, 2)

    return (nosm) ? Last 
    \ : mt_merge(Last, S, E)
}

#######################################################################################
### DEBLOCKING FILTERS
#######################################################################################

#######################################################################################
### DENOISE & SMOOTHING FILTERS
#######################################################################################

#######################################
### delay blend: mix the current frame with the previous frame (see also InterpolateFPS)
##
## @ frames  - amount of delay (1 to 3 frames)
## @ opacity - amount of delayed video (from 0.0 to 1.0; default=0.5)
## @ mode    - [[Overlay]] mode (default "blend")
##
function DelayBlend(clip C, int "frames", float "opacity", string "mode")
{
    Assert(!C.IsYV411, 
    \  "DelayBlend: YV411 not accepted") ## (cf. Overlay)
    frames  = Min(Max(1, Default(frames, 1)), 3) 
    opacity = Float(Default(opacity, 0.5))
    mode    = Default(mode, "blend")

    return (opacity<0.001) ? C
    \    : (opacity>0.999) ? C.Slip(-frames)
    \    : (mode=="blend") ? Merge(C, C.Slip(-frames), weight=opacity)
    \    : Overlay(C, C.Slip(-frames), opacity=opacity, mode=mode)
}

#######################################################################################
### MISC RESTORATION FILTERS
#######################################################################################

#######################################################################################
### COLORSPACE FILTERS
#######################################################################################

#######################################################################################
### LEVELS & CHROMA FILTERS
#######################################################################################

##################################
### call [[Tweak]] with user-supplied mask 'M' - see [[SmoothHueMask]], [[SatMask]]
##
function SmoothHueTweak(clip C, 
\               int hue_adj, float sat_adj, int hue_select, 
\               float "hue_width", int "maxSat", int "minSat",
\               bool "coring", bool "show_mask")
{
    hwid = Min(Max(   3.0, Default(hue_width, 20.0)), 90.0)
    mins = Round(Min(Max(     0, Default(minSat,    0)), 250))
    maxs = Round(Min(Max(mins+5, Default(maxSat,  255)), 255))
    core = Default(coring, false)
    show = Default(show_mask, false)

    M = C.SmoothHueMask(hue_select, hwid, 
    \          maxSat=maxs, minSat=mins, showmap=0>0, showargs=0>0)   

    return (show)
    \ ? M.MatchColorFormat(C)
    \ : C.mt_merge( 
    \          C.Tweak(hue=hue_adj, sat=sat_adj, coring=core),
    \          M [* .ConvertBits42(8).ConvertToY8 *] ,
    \          luma=true)
    #\          M.ConvertBits42(8).ConvertToY8,
}

# http://forum.doom9.org/showthread.php?p=1781642#post1781642 (26-Sep-2016)
## requires MaskTools
## converted to AVS+ 18-Apr-2017
## refined 3-Oct-2017
##################################
### range limiter with soft 'knee' transition, 
### supports independent yellow, blue, green & red limits
### (not for secondary color correction)
##
## @ ymin - black  limit; range 0 (no change) to max (extreme) (<=128 depending on 'k')
## @ ymax - white  limit; min (extreme) (>=128 depending on 'k') to 255 (no change)
## @ y    - 'yellow' (-u) max; range 0.0 (extreme) to 1.0 (default, no change)
## @ b    - 'blue'   (+u) max
## @ g    - 'green'  (-v) max (green/cyan)
## @ r    - 'red'    (+v) max
## @ k    - "knee" (transition zone); range 0 (none) to 9 (max); default 3
##
## Examples
## | ## all default arguments:
## | SmoothLimiter(0, 255, y=1.0, b=1.0, g=1.0, r=1.0)
## | ## restrict mainly blue:
## | SmoothLimiter(0, 255, y=0.5, b=0.24, g=0.5, r=0.5)
##
function SmoothLimiter(clip C, 
\               int ymin, int ymax,
\               float "y", float "b",
\               float "g", float "r",
\               int "k")
{
    k    = Min(Max(0, Default(k, 3)), 9)
    sk   = C.sc8f(k)

    mmax = 128 - (8 * k)
    mmin = 128 + (8 * k)

    ymin = C.sc8f(Min(Max(0,   ymin), mmax))
    ymax = C.sc8f(Min(Max(mmin, ymax), 255))

    umin = C.sc8f(Min(Max(0,   128-Round(128.0*Default(y, 1.0))), 124))
    umax = C.sc8f(Min(Max(132, 128+Round(128.0*Default(b, 1.0))), 255))
    
    vmin = C.sc8f(Min(Max(0,   128-Round(128.0*Default(g, 1.0))), 124))
    vmax = C.sc8f(Min(Max(132, 128+Round(128.0*Default(r, 1.0))), 255))

    s255 = C.sc8x(255)

    s  = "((x<"+C.sc8s(128)+") "
    \  +   "? ((x>LO_k) ? x : ((x * LO_s) + xMIN)) "
    \  +   ": ((x<HI_k) ? x : ((x-HI_k) * HI_s + HI_k)))"
    
    ymin_k = ymin + Round(sk / 16.0 * 128)                  ## '_k' = knee point
    ymax_k = ymax - Round(sk / 16.0 * 128)
    ymin_s = (ymin_k-ymin) / Max(0.001, Float(ymin_k))     ## '_s' = slope
    ymax_s = (ymax-ymax_k) / Max(0.001, s255-ymax_k)

    sy = (ymin==0 && ymax==s255) ? "x"
    \  : s.ReplaceStr("xMIN", String(ymin))
    \     .ReplaceStr("LO_k", String(ymin_k))
    \     .ReplaceStr("HI_k", String(ymax_k))       
    \     .ReplaceStr("LO_s", StrinF(ymin_s, 3))
    \     .ReplaceStr("HI_s", StrinF(ymax_s, 3))

    umin_k = umin + Round(sk / 16.0 * 128)
    umax_k = umax - Round(sk / 16.0 * 128)
    umin_s = (umin_k-umin) / Max(0.001, Float(umin_k))
    umax_s = (umax-umax_k) / Max(0.001, Float(s255-umax_k))

    su = (umin==0 && umax==s255) ? "x"
    \  : s.ReplaceStr("xMIN", String(umin))
    \     .ReplaceStr("LO_k", String(umin_k))
    \     .ReplaceStr("HI_k", String(umax_k))
    \     .ReplaceStr("LO_s", StrinF(umin_s, 3))
    \     .ReplaceStr("HI_s", StrinF(umax_s, 3))

    vmin_k = vmin + Round(sk / 16.0 * 128)
    vmax_k = vmax - Round(sk / 16.0 * 128)
    vmin_s = (vmin_k-vmin) / Max(0.001, Float(vmin_k))
    vmax_s = (vmax-vmax_k) / Max(0.001, Float(s255-vmax_k))

    sv = (vmin==0 && vmax==s255) ? "x"
    \  : s.ReplaceStr("xMIN", String(vmin))
    \     .ReplaceStr("LO_k", String(vmin_k))
    \     .ReplaceStr("HI_k", String(vmax_k))
    \     .ReplaceStr("LO_s", StrinF(vmin_s, 3))
    \     .ReplaceStr("HI_s", StrinF(vmax_s, 3))

    return C.mt_lut(
    \           yexpr=mt_polish(sy), 
    \           uexpr=mt_polish(su), 
    \           vexpr=mt_polish(sv), 
    \           chroma="process")
}

##################################
### simple gamma adjustment (more = brighter lowlights)
##
function GammaCurve(clip C, float gamma, bool "tvrange")
{
    tvrange = Default(tvrange, !C.IsRGB)
    if (tvrange) {
        return C.Levelss(16, gamma, 235, 16, 235, coring=false, chroma=false)
    }
    else {
        return C.Levelss(0, gamma, 255, 0, 255, coring=false, chroma=false)
    }
}

##################################
### simple 'anti-gamma' adjustment (more = darker highlights)
##
function AntigammaCurve(clip C, float antigamma, bool "tvrange")
{
    tvrange = Default(tvrange, !C.IsRGB)
    if (tvrange) {
        C
        Invert.ColorYUV(off_y=(-5))
        Levelss(16, antigamma, 235, 16, 235, coring=false, chroma=false)
        Invert.ColorYUV(off_y=(-5))
        return Last
    }
    else {
        C
        Invert
        Levelss(2, antigamma, 253, 2, 253, coring=false, chroma=false)
        Invert
        return Last
    }
}

###################################
### merge GammaCurve and AntigammaCurve
##
function GammaScurve(clip C, float gamma, float antigamma, bool "tvrange")
{
    tvrange = Default(tvrange, !C.IsRGB)
    C
    Lo = GammaCurve(gamma, tvrange)
    Hi = AntigammaCurve(antigamma, tvrange)
    #SmoothPoints2(Round(Min(0, -4.0*(gamma-1.0))), Round(Max(0, 16.0*(gamma-1.0)))) 
    #return Last
    return MergeLH(C, Lo, Hi)
}

##################################
### enhance contrast in lowlights (USM) & highlights (stretch)
## requires [[SGradation2D]]
##
## @ lowlights  - range 0.0_0.7; default 0.2 
## @ highlights - range 0.0_0.7; default 0.2
##
function HighLowEnhancer(clip C, float "lowlights", float "highlights")
{
    Assert(!C.IsYV411 && !C.IsRGB, 
    \  "HighLowEnhancer: RGB, YV411 not accepted") ## (cf. Overlay)
    lowlights  = Min(Max(0.0, Float(Default(lowlights, 0.2))), 0.7)
    highlights = Min(Max(0.0, Float(Default(highlights, 0.2))), 0.7)

    B = C.GaussianBlur42(32)  
    #B = C.QGaussBlur(32)  
    C = (highlights < 0.02) ? C 
    \ : C.SGradation2D(1.0, 1.0 - highlights)
    L = Overlay(C, B.Invert, opacity=0.4)
    \   .Tweak(bright=-275, cont=3.8)
    C = (lowlights < 0.02) ? C 
    \ : Overlay(C, L, opacity=lowlights, mode="luma")
    return C 
}

#include "D:\VideoProjects\test\White Balance\white-bal.avs"
#######################################
### [[Levels]]-type filter, with 'gammalo' & 'gammahi' arguments 
##
## @ off     - black level offset (default 0)
## @ gamma   - gamma correction (default 1.0)
## @ gain    - contrast adjustment (default 1.0)
## @ gammalo - gamma for dark areas (default 1.0)
## @ gammahi - gamma for light areas (default = 'gammalo')
##              (if not given, or <= 0, gammalo is used)
## @ fullrange - assume input/output range = 16_234
## @ coring  - if true, limit output to  16_234
## @ debug   - if true, show the [[mt_lut]] expression 
##               (prior to [[mt_polish]] transform)
##
## Note: 
## * Curves are tweaked to give more adjustment at the extreme 
##   ends of the luma range. This is done by inverting the 
##   gammahi curve; if this was not done, highlight adjustment 
##   would be weak, and there would be a discontinuity at the 
##   midrange transition.    
## * Values from 0.5 to 1.0 increase midrange contrast
##   and "crush" the extremes; values greater than 1.0
##   bring out detail at the extremes at the expense
##   of the midrange. It's best to keep the two gammas
##   close to one another to avoid a glitch at midpoint.
##   That's why gammahi defaults to gammalo.
##
## cf. [[SGradation2D]]
##
function UUCurves(clip C, 
\               float "off", float "gamma", float "gain",
\               float "gammalo", float "gammahi",
\               bool "fullrange", bool "coring",
\               bool "debug")
{
    off   = Float(Default(off, 0.0))
    gamma = Max(0.1, Float(Default(gamma, 1.0)))
    gain  = Max(0.0, Float(Default(gain,  1.0)))
    
    gammalo = Float(Default(gammalo, 1.0))
    gammalo = Max(0.1*gamma+0.5, gammalo)
    
    gammahi = Float(Default(gammahi, gammalo))
    gammahi = (gammahi>0) ? gammahi : gammalo 
    gammahi = Max(0.1*gamma+0.5, gammahi)
    
    pcr     = Default(fullrange,    false)
    cor     = Default(coring,       pcr==false)
    debug   = Default(debug,        false)

    #global 
    g_expr = 
    \ ( "min(max($clo, "
    \ + "($off) + "
    \ + "("
    \ +    "$gain * $max * "
    \ +    "("
    \ +       "(($x) ^ (1/$gamma)) + "
    \ +       "($x) - " 
    \ +       "("
    \ +          "(($x) <= 0.5) "
    \ +             "? (((($x) * 2) ^ (1 / $glo)) / 2) "
    \ +             ": (1 - 0.5 * ((2 - 2 * ($x)) ^ (1 / $ghi))) "
    \ +       ")"
    \ +    ")"
    \ + ")"
    \ + "), $chi)")
    \ .ReplaceStr("$gain",  String(gain))
    \ .ReplaceStr("$off",   C.sc8s(off+(pcr?0:16)))
    \ .ReplaceStr("$gamma", String(gamma))
    \ .ReplaceStr("$glo",   String(gammalo))
    \ .ReplaceStr("$ghi",   String(gammahi))
    \ .ReplaceStr("$max2",  C.sc8s(pcr?128:126))
    \ .ReplaceStr("$max",   C.sc8s(pcr?255:219))
    \ .ReplaceStr("$clo",   C.sc8s(cor?16:0))
    \ .ReplaceStr("$chi",   C.sc8s(cor?235:255))
    \ .ReplaceStr("$x", "(x - " + C.sc8s(pcr?0:16) + ") / " + C.sc8s(pcr?255:219))
    
    R = (C.IsRGB) 
    \ ? C.mt_lut( expr=g_expr.mt_polish, chroma="process")
    \ : C.mt_lut(yexpr=g_expr.mt_polish, chroma="copy")

    return (debug==false) ? R 
    \ : R.Subtitle(SplitLines(g_expr, 80), lsp=0)
}

##################################
### Luma correction, "equalizer style"
## (MergeFiveBand usage example)
##
## @ C          - YUV444, 10-bits or better recommended
## @ off1..5    - brightness adjustment for the 5 luma "bands"
##                (1=lowlights; 2=mid-lows; 3=mids; 4=mid-highs; 5=highlights)
## @ sBlk, sWht - adjust slope at black (162) and white (235d);
##                range +/-1.0; <0 darker, >0 brighter; default 0.0
## @ debug      - if true, show masks and internal arguments
##
function FiveBandLevels(clip C, 
\           int "off1", int "off2", int "off3", int "off4", int "off5", 
\           float "sBlk", float "sWht", bool "debug")
{
    Assert(C.IsYUV, 
    \  "FiveBandLevels: source must be YUV")
    Assert(!C.IsYV411, 
    \  "FiveBandLevels: YV411 not accepted") ## (cf. Overlay)
    off1 = Default(off1, 0) ## low
    off2 = Default(off2, 0) ## mid-low
    off3 = Default(off3, 0) ## mid
    off4 = Default(off4, 0) ## mid-high
    off5 = Default(off5, 0) ## high
    sBlk = 1.0 + 0.6 * Min(Max(-1.0, Default(sBlk, 0.0)), 1.0) ## low
    sWht = 1.0 + 0.6 * Min(Max(-1.0, Default(sWht, 0.0)), 1.0) ## high
    debug  = Default(debug, false)
    
    ## cross-couple the bands
    off1 = off1   + off2/3
    off2 = off1/3 + off2   + off3/3
    off3 = off2/3 + off3   + off4/3
    off4 = off3/3 + off4   + off5/3
    off5 =          off4/3 + off5

    C1 = C.Tweak(bright=off1)
    C2 = C.Tweak(bright=off2) 
    C3 = C.Tweak(bright=off3) 
    C4 = C.Tweak(bright=off4) 
    C5 = C.Tweak(bright=off5)
    
    C1 = (Abs(sBlk-1.0)<0.01) ? C1 : C1.SGradation2D(sBlk, 1.0)
    C5 = (Abs(sWht-1.0)<0.01) ? C5 : C5.SGradation2D(sWht, 1.0)

    MergeFiveBand(C, C1, C2, C3, C4, C5, chroma=false, output=(debug?-1:0))    

    return !(debug) ? Last
    \ : Subtitle(
    \       String(off1,     "b1=%0.0f, "  )+
    \       String(off2,     "b2=%0.0f, "  )+
    \       String(off3,     "b3=%0.0f, "  )+
    \       String(off4,     "b4=%0.0f, "  )+
    \       String(off5,     "b5=%0.0f; \n")+
    \       String(sBlk-1.0, "c1=%0.2f, "  )+
    \       String(sWht-1.0, "c5=%0.2f"),
    \       lsp=0)
}

##################################
### Saturation adjustment by luma band, "equalizer style"
## (MergeFiveBand usage example)
##
## @ C          - YUV444, 10-bits or better recommended
## @ sat1..5    - brightness adjustment for the 5 luma "bands"
##                (1=lowlights; 2=mid-lows; 3=mids; 4=mid-highs; 5=highlights)
## @ debug      - if true, show masks and internal arguments
##
function FiveBandSaturation(clip C, 
\           float "sat1", float "sat2", float "sat3", float "sat4", float "sat5", 
\           bool "debug")
{
#Assert(false, C.InfoString)
    Assert(C.IsYUV, 
    \  "FiveBandSaturation: source must be YUV (not YUVA)")
    Assert(!C.IsYV411, 
    \  "FiveBandSaturation: YV411 not accepted") ## (cf. Overlay)
    sat1 = Default(sat1, 1.0) ## low
    sat2 = Default(sat2, 1.0) ## mid-low
    sat3 = Default(sat3, 1.0) ## mid
    sat4 = Default(sat4, 1.0) ## mid-high
    sat5 = Default(sat5, 1.0) ## high
    debug = Default(debug, false)
    
    [*
    ## cross-couple the bands
    sat1 = sat1   + sat2/3
    sat2 = sat1/3 + sat2   + sat3/3
    sat3 = sat2/3 + sat3   + sat4/3
    sat4 = sat3/3 + sat4   + sat5/3
    sat5 =          sat4/3 + sat5
    *]

    C1 = C.Tweak(sat=sat1)
    C2 = C.Tweak(sat=sat2) 
    C3 = C.Tweak(sat=sat3) 
    C4 = C.Tweak(sat=sat4) 
    C5 = C.Tweak(sat=sat5)
    
    MergeFiveBand(C, C1, C2, C3, C4, C5, luma=false, chroma=true, output=(debug?-1:0))    

    return !(debug) ? Last
    \ : Subtitle(
    \       String(sat1,     "b1=%0.0f, "  )+
    \       String(sat2,     "b2=%0.0f, "  )+
    \       String(sat3,     "b3=%0.0f, "  )+
    \       String(sat4,     "b4=%0.0f, "  )+
    \       String(sat5,     "b5=%0.0f; \n")+
    \       String(sBlk-1.0, "c1=%0.2f, "  )+
    \       String(sWht-1.0, "c5=%0.2f"),
    \       lsp=0)
}

##################################
### Color temperature adjustment by luma band, "equalizer style"
## (MergeFiveBand usage example)
## 
## @ C        - YUV444, 10-bits or better recommended
## @ off1..5  - "temperature" adjustment; range -50_50; default 0. 
##              (1=lowlights; 2=mid-lows; 3=mids; 4=mid-highs; 5=highlights)
##              (arbitrary units; lower => output is 'warmer'; higher => 'cooler')
## @ debug    - if true, show masks and internal arguments
##
## Examples:
## | FiveBandColortemp(0,   0, -10,   0, 0) ## slightly warmer
## | FiveBandColortemp(0, -10, -30, -20, 0) ## strongly warmer
##
## | FiveBandColortemp(0,   0, +18,   0, 0) ## slightly cooler
## | FiveBandColortemp(0,  +7, +12, +12, 0) ## strongly cooler
##
## Normally only the middle 3 bands are adjusted for effect;
## the extreme bands are only used for black/white balance if rq'd.
##
function FiveBandColortemp(clip C, 
\           int "off1", int "off2", int "off3", int "off4", int "off5", 
\           bool "debug")
{
    Assert(C.IsYUV, 
    \  "FiveBandColortemp: source must be YUV")
    Assert(!C.IsYV411, 
    \  "FiveBandColortemp: YV411 not accepted") ## (cf. Overlay)
    off1  = Min(Max(-50, Default(off1, 0)), 50)
    off2  = Min(Max(-50, Default(off2, 0)), 50)
    off3  = Min(Max(-50, Default(off3, 0)), 50)
    off4  = Min(Max(-50, Default(off4, 0)), 50)
    off5  = Min(Max(-50, Default(off5, 0)), 50)
    debug = Default(debug, false)
    
    ## cross-couple the bands
    off1 = off1   + off2/3
    off2 = off1/3 + off2   + off3/3
    off3 = off2/3 + off3   + off4/3
    off4 = off3/3 + off4   + off5/3
    off5 =          off4/3 + off5

    C1 = C.ColorYUV(off_u=off1, off_v=Round(-0.7*off1))
    C2 = C.ColorYUV(off_u=off2, off_v=Round(-0.7*off2))
    C3 = C.ColorYUV(off_u=off3, off_v=Round(-0.7*off3))
    C4 = C.ColorYUV(off_u=off4, off_v=Round(-0.7*off4)) 
    C5 = C.ColorYUV(off_u=off5, off_v=Round(-0.7*off5))
    
    MergeFiveBand(C, C1, C2, C3, C4, C5, luma=false, chroma=true, output=(debug?-1:0))    

    return !(debug) ? Last
    \ : Subtitle(
    \       String(off1,     "o1=%0.0f, "  )+
    \       String(off2,     "o2=%0.0f, "  )+
    \       String(off3,     "o3=%0.0f, "  )+
    \       String(off4,     "o4=%0.0f, "  )+
    \       String(off5,     "o5=%0.0f; \n"),
    \       lsp=0)
}

#######################################################################################
### SHARPEN & BLUR FILTERS
#######################################################################################

##################################
### Emulate [[VariableBlur/GaussianBlur]]
##  For YUV, effective chroma blur varies depending on source 
##  color subsampling - YUV444 has *more* chroma blur, others less.
##
## @ var   - works like GaussianBlur's varY
## @ rad   - blur radius ('var' rescaled); overrides 'var'
## @ vvar  - vertical; default same as horizontal
## @ vrad  - vertical radius; overrides 'vvar'; default same as horizontal
## @ gamma - if true and if bit depth > 8, do linear-light processing 
##           (retains more highlights)
## @ p     - final [[GaussResize]] sharpness. Default 19
##           (if > 25, blockiness; if < 15, loss of contrast)
##
## version 2013-10-23 raffriff42 
## version 2014-05-31 discrete hor. and vert. args
## version 2017-05-21 bugfix: blockiness
## version 2017-05-27 gamma
##
function GaussianBlur42(clip C, 
\               float "var", float "rad",
\               float "vvar", float "vrad", 
\               bool "gamma", float "p")
{
    var  = Max(0.0, Float(Default(var, 1.0)))
    rad  = Max(1.0, Float(Default(rad, Pow(var, 0.5))))
    var  = Pow(Min(Max(0.0, rad), 60.0), 1.9) ## arbitrary max radius = 60

    vvar  = Max(0.0, Float(Default(vvar, var)))
    vrad  = Max(1.0, Float(Default(vrad, Pow(vvar, 0.5))))
    vvar  = Pow(Min(Max(0.0, vrad), 60.0), 1.9)
    gamma = Default(gamma, false)
    p     = Default(p, 19)

    w0 = C.Width
    h0 = C.Height
    w1 = Round(w0/rad)
    h1 = Round(h0/vrad) 

    B  = (gamma) ? C.remove_gamma : C

    B = B.BilinearResize(
    \         Min(Max(4, w1 + (w1 % 2)), w0), 
    \         Min(Max(4, h1 + (h1 % 2)), h0))

    B = B.Blur(1.0).Blur(1.0)
    
    B  = (gamma) ? B.restore_gamma : B

    return (var<0.01 && vvar<0.01)   ? C 
    \    : (var<1.5  && vvar<1.5)    ? C.Blur(0.85 * var, 0.85 * vvar)
    \    : (B.Width>8 && B.Height>8) ? B.GaussResize(w0, h0, p=p)
    \                                : B.BilinearResize(w0, h0)
}

##################################
### NonlinUSM wrapper: local contrast
##
## @ str - default 0.6 (mild:0.3; medium:0.7; strong:1.0) 
## @ rad - default 40  (mild:60; medium:30-50; strong:8-20) 
##
function NonlinLC(clip C, float "str", float "rad") 
{
    str = Float(Default(str, 0.9))
    rad = Float(Default(rad, 40.0))
    return C.NonlinUSM(z=1, pow=1, str=str, rad=rad)
}

##################################
### enhance contrast - like unsharp
## by Didée, Feb 2012
## http://forum.doom9.org/showthread.php?p=1555234#post1555234
## (modded Raffriff42 - lowered strength of effect if "str" < 1.0)
## following header comments by raffriff42
## https://forum.doom9.org/showthread.php?p=1821086#post1821086
## https://forum.doom9.org/showthread.php?p=1690165#post1690165
##
## @ z     - default 6     (3 = subtle; 16 = massive)  
## @ pow   - default 1.6   (1.0 = oversharp; 4.0 = mild)  
## @ str   - default 0.7   (3 = strong; 18 = massive) 
## @ rad   - default 9     (0.6 = sharpen; 18 = soft) 
## @ ldmp  - default 0.001 (block overlap? 0.01 = a little smoother?)
##
## EXAMPLES:
## | NonlinUSM(pow=4)                          ## enhance: for low bitrate sources
## | NonlinUSM(z=3, pow=4.0, str=1, rad=6)     ## enhance less
## | NonlinUSM(z=3, str=0.5, rad=9, pow=1)     ## enhance less+
## | 
## | NonlinUSM(z=6, str=1.5, rad=0.6).Sharpen(0.3)  ## sharpen: for hi-q sources
## | NonlinUSM(z=3, str=2.5, rad=0.6)          ## sharpen: less noise
## | NonlinUSM(z=6, pow=1, str=1, rad=6)       ## unsharp 
## | NonlinUSM(z=1, pow=1, str=0.6, rad=40)    ## local contrast (str mild:0.3; medium:0.7; strong:1.0) 
## | 
## | NonlinUSM(pow=1.0, rad=2, str=0.7)        ## smoothen: for noisy sources
## | NonlinUSM(pow=1.0, rad=18, str=0.5)       ## smear: soft glow
## | 
## | NonlinUSM(z=16, pow=4.0, str=18, rad=6)   ## B+W psycho 
## | NonlinUSM(z=16, pow=4.0, str=3,  rad=6)   ## sepia/artistic 
## | NonlinUSM(z=6,  pow=4.0, str=1,  rad=36)  ## local contrast 
## | NonlinUSM(z=6,  pow=1.0, str=1,  rad=36)  ## local contrast 
## | NonlinUSM(z=16, pow=2.0, str=2,  rad=36)  ## solarized
##
function NonlinUSM(clip C, float "z", float "pow",  
\               float "str", float "rad", float "ldmp")
{
    Assert(!C.IsYV411, 
    \  "NonlinUSM: YV411 not accepted") ## (cf. Overlay)
    z     = Float(Default(z,   6.0))    ## zero point
    pow   = Float(Default(pow, 1.6))    ## power
    str   = Float(Default(str, 0.7))    ## strength
    rad   = Float(Default(rad, 9.0))    ## radius for "gauss"
    ldmp  = Float(Default(ldmp, 0.001)) ## damping for very small differences

    G = C.BicubicResize(
    \           Max(16, modx(4, C.Width/rad)), 
    \           Max(16, modx(4, C.Height/rad)))
    \    .BicubicResize(
    \           C.Width, 
    \           C.Height, 
    \           1.0, 0.0)

    ## x + (abs(x-y)/$z)^(1/$p) 
    ## * $z * $s 
    ## * (x-y)^2 / ((x-y)^2 + $l)
    ## * (x-y) / (abs(x-y) + 0.001)
    ##
    sexpr = ("x x y - abs $z / 1 $p / ^ "
    \    + "$z * $s * "
    \    + "x y - 2 ^ x y - 2 ^ $l + / * "
    \    + "x y - x y - abs 0.001 + / * +")
    \ .ReplaceStr("$l", String(ldmp))
    \ .ReplaceStr("$p", String(pow))
    \ .ReplaceStr("$s", String(str))
    \ .ReplaceStr("$z", String(z))

    (C.IsRGB)  
    \ ? Expr(C, G, sexpr, sexpr, sexpr)
    \ : Expr(C, G, sexpr, "x",   "x")

    C.Overlay(Last, opacity=str)
    return Last
}

##################################
### repair oversharpened edges
##
## @ threshold   - edge detection threshold (default 128; lower values find more noise)
## @ normalblur  - overall blur (or sharpening if negative); default 0.0
## @ edgeblur    - edge-only blur (or sharpening if negative); default 0.6 
## @ postsharpen - post process overall sharpening (or blur if negative); default 0.2 
## @ gamma       - if true (default), do all processing in linear light (if bit depth > 8).
##
function EdgeDesharpen(clip C, int "threshold", 
\               float "normalblur", float "edgeblur",
\               float "postsharpen", bool "gamma")
{
    Assert(!C.IsYV411 && !C.IsRGB, 
    \  "EdgeDesharpen: RGB, YV411 not accepted") ## (cf. Overlay)
    mth = Default(threshold, 128)
    nbl = Min(Max(-1.0, Default(normalblur,  0.0)), 1.5)
    ebl = Min(Max(-1.0, Default(edgeblur,    0.6)), 1.5)
    psh = Min(Max(-1.5, Default(postsharpen, 0.2)), 1.0)
    gam = Default(gamma, true)

    C
    EM=ConvertToYUV420.EdgeMask(mth)
    remove_gamma(gam)

    EB=Blur(ebl)
    NB=Blur(nbl)
    Overlay(NB, EB, mask=EM)
    Sharpen(psh)
    
    restore_gamma(gam)
    return Last
}

## (see notes @ "Ringing free sharpening" test)
#Import(pathMisc + "FineSharp.avsi")
# @ Didée
##################################
### [[FineSharp]] wrapper with edge mask
##
## @ sstr     - sharpening strength (default 2.0)
## @ cstr     - strength of equalisation ('fine tuning') (default 1.5)
## @ edges    - if > 0, FineSharp ONLY edges (don't sharpen noise) (default)
##              if < 0, FineSharp all EXCEPT edges (kill ringing); 
##              if = 0, no edge masking (entire image sharpened);
## @ mthr     - edge mask threshold (default 128)
## @ nsharp   - sharpen (or blur) for non-FineSharp portion (default 0.0; try -0.5)
## @ showmask - if true, show the edge mask to aid setting threshold
## @ showargs - if true, show all arguments on screen
## 
function FineSharpEdge(clip C, float "sstr", float "cstr", 
\               int "edges", int "mthr", float "nsharp",
\               bool "showmask", bool "showargs")
{
    Assert(!C.IsYV411 && !C.IsRGB, 
    \  "FineSharpEdge: RGB, YV411 not accepted") ## (cf. Overlay)
    sstr     = Default(sstr,  2.0)
    cstr     = Default(cstr,  1.5)
    edges    = Default(edges, 1)
    mthr     = Default(mthr, 128)
    nsharp   = Default(nsharp, 0.0)
    showmask = Default(showmask, false)
    showargs = Default(showargs, false)

#    edgemask = C.mt_edge("hprewitt", thY1=mthr, thY2=mthr).Grayscale.Blur(0.6)
    edgemask = C.EdgeMask(mthr, 0.6)
    edgemask = (showmask) ? edgemask
    \        : (edges<0)  ? edgemask.Invert
    \        : (edges>0)  ? edgemask
    \        : BlankClip(C, color_yuv=$ff8080)

    R = (showmask)
    \ ? edgemask
    \ : C.Sharpen(nsharp).Overlay( 
    \       C.FineSharp(mode=2, sstr=sstr, 
    \           cstr=cstr, xstr=0.0, 
    \           lstr=1.49, pstr=1.472, ldmp=sstr+2.2),
    \       mask=edgemask, opacity=1.0)

    s = (showmask) 
    \ ? "FineSharpEdge(mthr="+String(mthr)+")"
    \ : "FineSharpEdge(mthr="+String(mthr)
    \            +", sstr="+String(sstr, "%0.2f")
    \            +", cstr="+String(cstr, "%0.2f")
    \            +", nsharp="+String(nsharp, "%0.2f")
    \            +", edges="+String(edges)+")"

    return (showargs) ? R.Subtitle(s, size=R.Width/42, align=5) : R
}

# http://forum.doom9.org/showthread.php?p=1751572#post1751572
# http://avisynth.nl/index.php/WarpSharp/WarpSharp
#Import(pathBase + "warpsharp\warpsharp_loadx64.avsi")
##################################
### reduces chroma bleed somewhat
##
## returns YV12 or YV24
##
## Example - reduce bleed; sharpen
## | ChromaWarpSharpener(64).ConvertYxxToYV24
##
function ChromaWarpSharpener(clip C, int "strength", bool "yv24_ignored")
{
    bits = C.BitsPerComponent
    str  = Default(strength, 64)  

    Assert(C.Is444 || C.Is420,
    \   "ChromaWarpSharpener: source must be YUV444 or YUV420")

    #C = (yv24)
    #\ ? C.ConvertBits42(8).ConvertToYV24 
    #\ : C.ConvertBits42(8).ConvertToYV12

    U = C.ExtractU
    \    .ConvertBits42(8).ConvertToYV12
    \    .WarpSharp(depth=str, blur=1, bump=Min(str, 128))
    \    .ConvertBits42(bits)
    V = C.ExtractV
    \    .ConvertBits42(8).ConvertToYV12
    \    .WarpSharp(depth=str, blur=1, bump=Min(str, 128))
    \    .ConvertBits42(bits)

    #? U = (yv24) ? U.BicubicResize(C.Width, C.Height) : U
    #? V = (yv24) ? V.BicubicResize(C.Width, C.Height) : V

    return CombinePlanes(C.ExtractY, U.ExtractY, V.ExtractY, "YUV",
    \       pixel_type="YUV" + (C.Is444?"444":"420") + "P" + String(bits))
}

##################################
### subtle sharpening effect
## based on an idea by videofred
##
## @ multi   - suggested range 1_5; no effect if <=0
## @ sharpen - strength of each Sharpen operation; default 0.6
## @ blur    - strength of each Blur    operation; default 0.3
##
function MultiSharpen(clip C, int multi, float "sharpen", float "blur")
{
    shrp = Min(Max(0.0, Default(sharpen, 0.6)), 1.0)
    blr  = Min(Max(0.0, Default(blur,    0.3)), 1.0)
    C
    for (i=multi, 1, -1) {
        Sharpen(shrp).Blur(blr)
    }
    return Last
}

#######################################################################################
### BORDER & CROP FILTERS
#######################################################################################

# http://forum.doom9.org/showthread.php?p=1737682#post1737682
##################################
### crop to size with smooth pan & tilt (range -1.0_1.0; center @ 0, 0)
## related: [[#CropShift]]
##                                                                  
## @ panRt  - -1=left, 0=center, +1=right; [default 0]
## @ tiltDn - -1=up,   0=center, +1=down;  [default 0]
## 
## @ title  - will be added as a [[Subtitle]] (used in eg, [[StackTwoAcrossCropped]]) 
## @ align  - see Subtitle: align
## @ color  - see Subtitle: text_color
## @ size   - see Subtitle: size
##
function CropPanTilt(clip C, int wid, int hgt, float "panRt", float "tiltDn",
\               string "title", int "align", int "color", float "size")
{
    C
    bdrWid = (wid - Width)
    bdrHgt = (hgt - Height)

    xctr  = Min(Max(-1.0, Default(panRt, 0.0)), 1.0) 
    yctr  = Min(Max(-1.0, Default(tiltDn, 0.0)), 1.0)

    bdrLt = Abs(Float(bdrWid) / 2.0)
    bdrLt = bdrLt + bdrLt * xctr
    bdrLt = Sign(bdrWid) * bdrLt
    
    bdrTp = Abs(Float(bdrHgt) / 2.0) 
    bdrTp = bdrTp + bdrTp * yctr
    bdrTp = Sign(bdrHgt) * bdrTp
    
    align = Default(align, 7) 
    color = Default(color, $ffff00) 
    size  = Default(size, Height/32) 

    Assert(bdrLt<=0 && bdrTp<=0, 
    \   "CropPanTilt: clip too small for target size")

    Spline36Resize(wid, hgt, -bdrLt, -bdrTp, wid, hgt)
    return (!defined(title)) ? Last 
    \  : Subtitle(String(title), size=size, text_color=color, align=align, lsp=0)
}

##==> see also function Shift
##################################
### crop to size with smooth animated pan & tilt, expressed as pixels (center @ off_x=0, off_y=0)
## (maximum shift in any direction restricted to number of cropped pixels on that side)
## related: CropPanTilt, CropEx
##
## @ off_x  <0=left, 0=center, >0=right; [default 0]
## @ off_y  <0=up,   0=center, >0=down;  [default 0]
##
function CropShift(clip C, int wid, int hgt, float "off_x", float "off_y")
{
    off_x = Default(off_x, 0.0)
    off_y = Default(off_y, 0.0)

    bdrWid = (wid - C.Width)
    bdrHgt = (hgt - C.Height)

    bdrLt = Abs(Float(bdrWid) / 2.0)
    bdrLt = bdrLt - off_x
    bdrLt = Sign(bdrWid) * bdrLt
    
    bdrTp = Abs(Float(bdrHgt) / 2.0) 
    bdrTp = bdrTp - off_y
    bdrTp = Sign(bdrHgt) * bdrTp

    (bdrLt<=0 && bdrTp<=0) ? Nop
    \ : Assert(false, "CropShift: clip too small for target size")

    return C.Spline36Resize(wid, hgt, -bdrLt, -bdrTp, wid, hgt)
} 

# cf. CropEx(mode="blur")
# https://forum.videohelp.com/threads/385341-avisynth-how-to-add-borders#post2498883
##################################
### a nice Pillarbox effect - extends blurred source into left & right borders 
##  also known as /SoftPillarbox/
##
## NOTE: 
##  * padding is 24 pixels minimum (12 per side), in steps of 4
##  * if at least 24 pixels of padding is not needed, source is returned unchanged
##  * this filter looks best if source has had any minor black bars cropped off beforehand
##
## @ aspect_num, aspect_den 
##  - defines the output ASPECT RATIO; default 16, 9
##      (the ratio determines the new, padded width, given source video height)
##      (the source picture is not resized, or changed in any way)
##  Examples: 
##  | SuperSexyWidescreen()           ## expand to 16:9 aspect ratio (default)
##  | SuperSexyWidescreen(16, 9)      ## expand to 16:9 
##  | SuperSexyWidescreen(4, 3)       ## expand to 4:3 
##  | SuperSexyWidescreen(48, 9)      ## expand to 3 x 16:9 (triple monitors!)
##  | SuperSexyWidescreen(2560, 1080) ## expand to true 21:9 (21.3333:9)
##  | SuperSexyWidescreen(Width+32, Height) ## expand to explicit width
##
## -- A D V N C E D   A R G U M E N T S -----------------------------------
## @ gain  - brightness of pillarbox portion; 
##              range 0.2_2.0; default 0.9 (slightly darker)
## @ sat   - saturation of pillarbox portion; 
##              range 0.0_2.0; default 0.6 (60%)
## @ blue  - amount of pillarbox blue shift; 
##              range -32_32; default 2 (subtle)
## @ noise - amount of pillarbox fixed-pattern noise; 
##              range 0_50; default 3 (subtle)
## @ pblur - amount of pillarbox spatial blur; 
##              range 0_100; default 100 (very heavy)
## @ tblur - radius of pillarbox temporal blur; 
##              range 0_9; 0=off; default 4 (moderate)
## @ scene - pillarbox temporal blur scene change threshold
##              range 0_255; default 32
##
## @ edge  - amount of picture on left & right to be stretched over pillarbox; 
##              range 0.02_0.5; default 0.03 (3%) (no need to touch this AFAICT)
## @ xblend - amount of cross-blending for pillarbox symmetry
##              range 0_1; default 0.0 (off)
## @ pblend - if true, try to blend program into pillars; default false
##
## @ version 2.3 (interface; add blend, scenechange; bypass if output too narrow)
## @ version 2.4 (AddGrain_DeepColor)
## @ version 2.5 (AddGrainF3K) [AVS+]
## @ version 2.6 (pblend)
## @ version 2.7 (AddGrainAG) [AVS+]
## requires AddGrain
##    http://avisynth.nl/index.php/AddGrain
##
function SuperSexyWidescreen(
\               clip C, int "aspect_num", int "aspect_den", 
\               float "gain", float "sat", int "blue", 
\               int "noise", int "pblur", int "tblur", int "scene", 
\               float "edge", float "xblend", bool "pblend")
{
    Assert(!C.IsYV411 && !C.IsRGB, 
    \  "SuperSexyWidescreen: RGB, YV411 not accepted") ## (cf. Overlay)
    C
    anum  = Default(aspect_num, 16)
    aden  = Default(aspect_den, 9)
    wid   = modx(4, (Float(anum) / Float(aden) * Height))

    gain  = Min(Max(0.0,  Default(gain,   0.9 )), 2.0)
    sat   = Min(Max(0.0,  Default(sat,    0.6 )), 2.0)
    blue  = Min(Max(-32,  Default(blue,   2   )), 32)
    pblur = Min(Max(0,    Default(pblur,  100 )), 100)
    noise = Min(Max(0,    Default(noise,  3   )), 50)
    tblur = Min(Max(0,    Default(tblur,  4   )), 9)
    scene = Min(Max(0,    Default(scene, 32   )), 255)
    edge  = Min(Max(0.02, Default(edge,   0.06)), 0.5)
    xblen = Min(Max(0,    Default(xblend, 0.0 )), 1.0)
    pblen = Default(pblend, false)

    nofx  = wid < (Width+24) ## if true, source is returned unchanged 
    
    ## TEMPORAL SOFTEN (done first as it adds artifacts)
    (tblur==0 || nofx) ? Nop 
    \ : TemporalSoften(tblur, 255, 255, scene, 2)

    ### EXTRACT LEFT & RIGHT EDGES
    L = (nofx) ? Nop : Crop(          0,               0, modx(2, edge*Width), 0) 
    R = (nofx) ? Nop : Crop(modx(2, (1.0-edge)*Width), 0, modx(2, edge*Width), 0)

    ## STRETCH
    ## p=19: softest w/o visible 'blockiness' 
    L = (nofx) ? Nop : L.GaussResize(modx( 2, 0.5*(wid-Width)), Height, p=19)
    R = (nofx) ? Nop : R.GaussResize(modx(-2, 0.5*(wid-Width)), Height, p=19)

    ## BLUR
    ## (almost can't have too much blur)
    L=(pblur<0.5 || nofx) ? L 
    \ : L.QGaussBlur(pblur, pblur).QGaussBlur(pblur, pblur)
    R=(pblur<0.5) || nofx ? R 
    \ : R.QGaussBlur(pblur, pblur).QGaussBlur(pblur, pblur)
    (nofx) ? Last : StackHorizontal(L, R)

    ## SYMMETRY
    (xblen<0.01 || nofx) ? Last 
    \ : Overlay(FlipHorizontal, opacity=xblen/2.0)

    ## DARKEN, DESATURATE, ADD BLUE SHIFT
    ## (differentiate from main program, but not too much)
    (nofx) ? Nop 
    \ : ColorYUV(gain_y=f2c(gain), off_u=blue, cont_u=f2c(sat), cont_v=f2c(sat))

    ## ADD FIXED NOISE ('FROSTED GLASS') 
    ## (enough to hide any banding from mega-blur)
    (noise==0 || nofx) ? Last
    \ : AddGrainAG(noise*8, fixed=true)

    ## REASSEMBLE THE PARTS
    L2 = (nofx) ? Nop : Crop(0, 0, modx(2, 0.5*Width), 0) 
    R2 = (nofx) ? Nop : Crop(modx(-2, 0.5*Width), 0, 0, 0)
    R  = (nofx) ? Nop : StackHorizontal(L2, C, R2)

    ## BLEND MASK
    bwid = modx(2, 2*edge*C.Width)
    M = (nofx || !pblen) ? R 
    \ : BlankClip(C, width=(C.Width - bwid))
    \   .AddBorders(bwid, 0, bwid, 0, color=$ffffff)
    \   .QCropEx(R.Width, R.Height)
    \   .QGaussBlur(0.5*edge*C.Width, 0)
    \   .ColorYUV(levels="TV->PC")

    return (nofx) ? C
    \ : (!pblen)  ? R
    \ : R.Overlay(R.QGaussBlur(0.6*edge*C.Width, 0), mask=M)
}

##################################
### symmetrically crop or expand a clip to ensure it is a certain size, 
### with size forced to mod-4, mod-8 etc
##
## cf. [[CropEx]] for a version with more features
##
## @ wid, hgt - new desired width & height (no mod requirement)
## @ mod      - mod value; one of (1|2|4|8|16|32); default 4
##
function QCropEx(clip C, float wid, float hgt, int "mod")
{
    mod = Max(1, Default(mod, 4))

    Assert((mod==1||mod==2||mod==4||mod==8||mod==16||mod==32), 
    \  "QCropEx: 'mod' argument not one of (1|2|4|8|16|32)")

    wid = Round(wid)
    hgt = Round(hgt)
    out_wid = wid - (wid % mod)
    out_hgt = hgt - (hgt % mod)

    C ## Last==C
    bdrX  = out_wid - Width
    bdrY  = out_hgt - Height
    bdrLt = Ceil(Float(bdrX) / 2.0)
    bdrTp = Ceil(Float(bdrY) / 2.0)
    bdrLt = bdrLt - (bdrLt % 2)
    bdrTp = bdrTp - (bdrTp % 2)
    bdrRt = (bdrX - bdrLt) 
    bdrBt = (bdrY - bdrTp)

    (bdrLt<=0 && bdrRt<=0 && bdrTp<=0 && bdrBt<=0) 
    \ ? Last 
    \ : AddBorders(
    \       Max(0, bdrLt), Max(0, bdrTp), 
    \       Max(0, bdrRt), Max(0, bdrBt)) 

    (bdrLt>=0 && bdrRt>=0 && bdrTp>=0 && bdrBt>=0) 
    \ ? Last 
    \ : Crop(
    \       ((bdrLt<0) ? -bdrLt : 0), 
    \       ((bdrTp<0) ? -bdrTp : 0), 
    \       ((bdrRt<0) ?  bdrRt : out_wid), 
    \       ((bdrBt<0) ?  bdrBt : out_hgt))
    return Last
}

# https://forum.videohelp.com/threads/385129-AviSynth-Cropping-a-specific-trim#post2496716
##################################
### [[Crop]], then resize to match template clip 'T';
### crop as needed to maintain aspect ratio
##
## @ C - Source clip. RGB or YUV444 recommended to avoid size modulus restrictions.
## @ T - Template clip. Output will match dimensions of clip 'T'.
## @ left, top, width, height - cf. [[Crop]]
##
## @ version 21-Sep-2017
##
function CropMatch(clip C, clip T,
\               int left, int top, int width, int height)
{
    tmpWid = (width>0)  ? (width)  : (C.Width-left+width)
    tmpHgt = (height>0) ? (height) : (C.Height-top+height)

    Assert(tmpWid<=C.Width, 
    \   "CropMatch: output width larger than input")
    Assert(tmpHgt<=C.Height, 
    \   "CropMatch: output height larger than input")

    scaleX = Float(T.Width)  / tmpWid
    scaleY = Float(T.Height) / tmpHgt

    tmpWid2 = (scaleX>=scaleY) ? Float(tmpWid) : (scaleX / scaleY * tmpWid)
    tmpHgt2 = (scaleY>=scaleX) ? Float(tmpHgt) : (scaleY / scaleX * tmpHgt)

    x   = (scaleX>=scaleY) ? Float(left)   : (left + 0.5 * (tmpWid - tmpWid2))
    y   = (scaleY>=scaleX) ? Float(top)    : (top  + 0.5 * (tmpHgt - tmpHgt2))
    wid = (scaleX>=scaleY) ? Float(tmpWid) : (tmpWid2)
    hgt = (scaleY>=scaleX) ? Float(tmpHgt) : (tmpHgt2)

    return C.Spline64Resize(T.Width, T.Height, x, y, wid, hgt)
}

##################################
### shift a clip up-down and left-right (with sub-pixel precision);
### this results in repeated edge pixels
##
function Shift(clip C, float offh, float offv)
{
    C 
    BilinearResize(Width, Height, -offh, -offv, Width, Height)
    return Last
}

## animated demo: https://forum.doom9.org/showthread.php?p=1774699#post1774699
##==> see also http://avisynth.nl/images/ChromaShiftSP.avsi
##################################
### shift Chroma relative to Luma
## (YUV, YUVA) 
##  
function ShiftUV(clip C, float "ux", float "uy", float "vx", float "vy")
{
    Assert(C.IsYUV || C.IsYUVA, 
    \  "ShiftUV: source must be YUV(A)")
    ux = Float(Default(ux, 0))
    uy = Float(Default(uy, 0))
    vx = Float(Default(vx, ux))
    vy = Float(Default(vy, uy))

    U = C.ExtractU
    V = C.ExtractV
    
    U = U.BilinearResize(U.Width, U.Height, -ux, -uy, U.Width, U.Height)
    V = V.BilinearResize(V.Width, V.Height, -vx, -vy, V.Width, V.Height)
    
    return (C.NumComponents==3)
    \ ? CombinePlanes(C.ExtractY, U, V, "YUV")
    \ : CombinePlanes(C.ExtractY, U, V, C.ExtractA, "YUVA")
}

# https://forum.doom9.org/showthread.php?p=1803247#post1803247
##################################
### shift and/or resize Red and Blue relative to Green
##  (RGB24, RGB32, RGB48, RGB64, RGB10/12/14/16/32, RGBA10/12/14/16/32)
##
## @ rx,  ry,  bx,  by  - ± "shift" red & blue position
## @ rxd, ryd, bxd, byd - ± "delta" width & height for advanced convergence
##
function ShiftRedBlue(clip C, 
\               float "rx", float "ry",
\               float "bx", float "by",
\               float "rxd", float "ryd",
\               float "bxd", float "byd")
{
    Assert(C.IsRGB, 
    \   "ShiftRedBlue: source must be RGB")
    rx  = Float(Default(rx,  0))
    ry  = Float(Default(ry,  0))
    bx  = Float(Default(bx,  0))
    by  = Float(Default(by,  0))
    rxd = Float(Default(rxd, 0))
    ryd = Float(Default(ryd, 0))
    bxd = Float(Default(bxd, 0))
    byd = Float(Default(byd, 0))

    R=C.ExtractR.Spline64Resize(C.Width, C.Height, -rx, -ry, C.Width-rxd, C.Height-ryd)
    B=C.ExtractB.Spline64Resize(C.Width, C.Height, -bx, -by, C.Width-bxd, C.Height-byd)

    R = (C.NumComponents==3)
    \ ? CombinePlanes(R, C.ExtractG, B, "RGB")
    \ : CombinePlanes(R, C.ExtractG, B, C.ExtractA, "RGBA")
    return R.MatchColorFormat(C)
}

#######################################################################################
### RESIZE & TRANSFORM FILTERS
#######################################################################################

##################################
### high quality enlarge
##
## @ wid, hgt - new width & height (2x enlargement by default)
## @ slower - if true, sets higher quality options in [[nnedi3]]
##  (does not seem to have much of an effect, if any)
## @ draft  - if true, skip Nedi3 and call [[Spline16Resize]]
##  (for fast previews)
##
## @version 1.2 Jun 2014 - alpha support; draft mode
## @version 1.3 Jul 2014 - improved quality
## @version 1.31 Jul 2014 - fixed broken backwards compatibility
## @version 1.32 Aug 2014 - fixed h-shift in YUV mode
## @version 2.01 Mar 2018 - AVS+ hi bit depth; YUV only for now
##
function Nnedi3Enlarge2(clip C, int "wid", int "hgt",
\               bool "slower", bool "draft")
{
    wid    = Max(16, Default(wid, 2*C.Width))
    hgt    = Max(16, Default(hgt, 2*C.Height))
    slower = Default(slower, false)
    draft  = Default(draft, false)

    Assert(C.IsRGB||C.Is420||C.Is444,
    \   "Nnedi3Enlarge2: source must be RGB(A) or YUV 420 or 444")
    Assert(wid>=C.Width && hgt>=C.Height,
    \   "Nnedi3Enlarge2: enlarging only")
    nns    = (slower) ? 4 : 3
    qual   = (slower) ? 2 : 1
    zfact  = Max(Float(wid)/C.Width, Float(hgt)/C.Height)
    rfact  = (zfact >32.0001) ? 64
    \      : (zfact >16.0001) ? 32
    \      : (zfact > 8.0001) ? 16
    \      : (zfact > 4.0001) ?  8
    \      : (zfact > 2.0001) ?  4
    \      : 2
    xshift = -(0.5 * rfact - 0.5)

    Y = (C.IsRGB ? C : C.ExtractY)

    Y = Y.nnedi3_rpow2(rfact, nns=nns, qual=qual,
    \       fwidth=wid, fheight=hgt, cshift="Spline64Resize", 
    \       range=0)
    UV = C.GaussResize(wid, hgt, p=50, src_left=xshift, src_top=-0.5)

    return (draft) ? C.Spline16Resize(wid, hgt)
    \ : (C.IsRGB) ? Y
    \ : CombinePlanes(Y, UV, "YUV", 
    \       source_planes="YUV", pixel_type=C.PixelType)
}

##==> see also....
#include "D:\VideoProjects\_scripts\LanczosRepairScaler_test.avs"
#
#LoadPlugin(pathBase + "QTGMC_Plugins\nnedi3.dll")  ## 0.9.4.0, 6/2011
##################################
### high quality enlarge (simplified version - YV12 only)
##
## @ wid, hgt - new width & height (1x by default)
## @ speed    - if > 0, tune for speed; if < 0, tune for quality;
##               default = 0 (medium)
##
## -->AVS+ see [[Nnedi316Resize]]
##
function Nnedi3EnlargeYV12(clip C, int "wid", int "hgt", int "speed")
{
    Assert((C.IsYV12),
    \  "Nnedi3EnlargeYV12: source must be YV12")
    Assert((wid>=C.Width && hgt>=C.Height),
    \   "Nnedi3EnlargeYV12: enlarging only")

    wid    = Max(16, Default(wid, C.Width))
    hgt    = Max(16, Default(hgt, C.Height))
    speed  = Default(speed, 0)

    nns    = (speed<0) ? 4 : ((speed>0) ? 2 : 3)
    qual   = (speed<0) ? 2 : 1
    zfact  = Max(Float(wid)/C.Width, Float(hgt)/C.Height)
    rfact  = (zfact >32.0001) ? 64
    \      : (zfact >16.0001) ? 32
    \      : (zfact > 8.0001) ? 16
    \      : (zfact > 4.0001) ?  8
    \      : (zfact > 2.0001) ?  4
    \      : 2
    xshift = -(0.5 * rfact - 0.5)

    ## avoid subtle color shift (only visible after many passes)
    Y  = C.nnedi3_rpow2(rfact, nns=nns, qual=qual, cshift="Spline64Resize", 
    \                   fwidth=wid, fheight=hgt)
    UV = C.Spline64Resize(wid, hgt, src_left=xshift, src_top=-0.5)
    return YToUV(UV.UToY, UV.VToY, Y.ConvertToY8)
}

[*
##################################
### high quality enlarge (simplified version - YV12 only)
##
function Nnedi3EnlargeYV12_2(clip C) #, int "wid", int "hgt", int "speed")
{
    Assert((C.IsYV12),
    \  "Nnedi3EnlargeYV12: source must be YV12")

    ## avoid subtle color shift (only visible after many passes)
    Y  = C.nnedi3_rpow2(2, nns=4, qual=2, cshift="Spline64Resize", 
    \                   fwidth=C.Width, fheight=C.Height)
    UV = C.Spline64Resize(C.Width, C.Height, src_left=-0.5, src_top=-0.5)
    return YToUV(UV.UToY, UV.VToY, Y.ConvertToY8)
}
*]

#######################################################################################
### SUBTITLE FILTERS 
#######################################################################################

# http://avisynth.org.ru/docs/english/externalfilters/vsfilter.htm
# https://en.wikipedia.org/wiki/DirectVobSub
# https://forum.doom9.org/showthread.php?p=1806888#post1806888
#######################################
### TextSub/TextSubMod over deep color video; requires AviSynthPlus
##
## @ C        - source clip; RGB 8, 10, 12, 14, 16-bit.  
## @ path     - subtitle file: *.sub, *.srt, *.ssa, *.ass, etc. (see [[TextSub]] docs)
## @ charset  - see TextSub docs
## @ fps      -  ''   ''    ''
## @ vfr      -  ''   ''    ''
## @ submod   - if true, call 'TextSubMod', else (default) call 'TextSub'
## @ edgetrim - if true, shrink & soften the edges of the subtitle mask;
##              use this if you see artifacts around the edges of the text
##              (not likely to occur; only seen in extreme testing)
##              requires [[MaskTools2]] v2.2.x
##
## version 1.0   raffriff42 May 2017
## version 1.0.1 add "vfr" argument, rename "mod"->"submod"
##
function TextSubPlus(clip C, string path, int "charset", float "fps", string "vfr",
\               bool "submod", bool "edgetrim")
{
    Assert(C.IsRGB, 
    \   "TextSubPlus: source must be RGB")

    submod   = Default(submod,   false)
    edgetrim = Default(edgetrim, false)
    
    bits = C.BitsPerComponent
    c8 = (bits==8) 
    \  ? C.ConvertToRGB32 
    \  : C.ConvertBits42(8).ConvertToRGB32

    #@ function TextSub(clip C, string "file", int "charset", float "fps", string "vfr")
    c8sub = (submod) 
    \  ? Eval("""c8.TextSubMod(path, charset, fps, vfr) """, "TextSubPlus_eval_1")
    \  : Eval("""c8.TextSub(path, charset, fps, vfr)    """, "TextSubPlus_eval_2")
    
    csub = (bits==8) 
    \  ? c8sub 
    \  : c8sub.ConvertToPlanarRGBA.ConvertBits42(bits)

    M = csub.ExtractA.Invert
    M = (!edgetrim) ? M : Eval("M.mt_inpand", "TextSubPlus_eval_3")

    return (bits==8)
    \  ? c8sub
    \  : Overlay(C, csub, mask=M)
}

#######################################################################################
### TRANSITION & EFFECT FILTERS
#######################################################################################

# https://forum.videohelp.com/threads/387798-Add-transition-to-overlay-in-AviSynth#post2510235
##################################
### Dissolve with a Wipe transition; adjustable soft edge.
##
## @ A            - starting clip 
## @ B            - ending clip
## @ overlap      - overlapped frames; if negative, overlapped seconds
## @ Mode         - (LeftToRight|RightToLeft|TopToBottom|BottomToTop)
## @ Hardness      - 2=soft; 10=medium; 100=hard; default 2
## @ HardnessStart - 1=blur; 100=sharp; default 50
## @ HardnessEnd   - 1=blur; 100=sharp; default 50
##
function SoftWipe(clip A, clip B, float "overlap", 
\               string "Mode", float "Hardness",
\               float "HardnessStart", float "HardnessEnd",
\               bool "showmask")
{
    Assert(!A.IsYV411, 
    \  "SoftWipe: clip 'A' is YV411 (not accepted)") ## (cf. Overlay)
    Assert(!B.IsYV411, 
    \  "SoftWipe: clip 'B' is YV411 (not accepted)")
    ## Set Defaults
    overlap       = Default(overlap, -30.0)
    wid           = A.Width
    hgt           = A.Height
    Mode          = Default(Mode, "LeftToRight")
    Hardness      = Float(Default(Hardness, 2.0))
    HardnessStart = Default(HardnessStart, 50.0)
    HardnessEnd   = Default(HardnessEnd, HardnessStart)
    showmask      = Default(showmask, false)

    ## try to make width of soft edge equal for hor & vert wipes:
    win_w   = Hardness * Pow(Float(wid) / hgt, 0.5) 
    win_h   = Hardness * Pow(Float(hgt) / wid, 0.5) 

    frms = (overlap>=0) 
    \ ? Round(overlap) 
    \ : -Round(overlap*A.FrameRate)
    AudioMix = Dissolve(A, B, frms).KillVideo
    A = A.KillAudio
    B = B.KillAudio

    A = (showmask) ? BlankClip(A, color=$000000) : A
    B = (showmask) ? BlankClip(B, color=$ffffff) : B

    ## Check Input
    Assert(Mode=="LeftToRight" || Mode=="RightToLeft" || Mode=="TopToBottom" || Mode=="BottomToTop", 
    \   "SoftWipe: allowed Mode values LeftToRight|RightToLeft|TopToBottom|BottomToTop.")
    Assert(frms < A.Framecount, 
    \   ("SoftWipe: overlap [$f] must be less than clip A length [$a]")
    \    .ReplaceStr("$f", String(frms))
    \    .ReplaceStr("$a", String(A.Framecount))
    \ )
    Assert(frms < B.Framecount, 
    \   ("SoftWipe: overlap [$f] must be less than clip B length [$b]")
    \    .ReplaceStr("$f", String(frms))
    \    .ReplaceStr("$b", String(B.Framecount))
    \ )

    ## Set Parameters
    aMid = Trim(A, FrameCount(A)-frms, 0)
    bMid = Trim(B, 0, -frms)
    (Mode=="RightToLeft") ? Eval("""
        BlankWidth = Int(4 / 2 * win_w)   
        BlankHeight = hgt
        startX1 = 1.5
        endX1 = BlankWidth + 0.5
        startY1 = 0
        endY1 = 0
        x2 = win_w * 2 - 2
        y2 = 0  
        ClipLeft = aMid
        ClipRight = bMid
    """)
    \ : (Mode=="TopToBottom") ? Eval("""
        BlankWidth = wid    
        BlankHeight = Int(6 / 2 * win_h)
        startX1 = 0
        endX1 = 0
        startY1 = BlankHeight + 0.5
        endY1 = 3.5
        x2 = 0
        y2 = win_h * 3 - 4 
        ClipLeft = bMid
        ClipRight = aMid
    """)
    \ : (Mode=="BottomToTop") ? Eval("""
        BlankWidth = wid    
        BlankHeight = Int(6 / 2 * win_h)
        startX1 = 0
        endX1 = 0
        startY1 = 3.5
        endY1 = BlankHeight + 0.5
        x2 = 0
        y2 = win_h * 3 - 4 
        ClipLeft = aMid
        ClipRight = bMid
    """) 
    \ : Eval(""" ## (Mode=="LeftToRight") 
        BlankWidth = Int(4 / 2 * win_w)   
        BlankHeight = hgt
        startX1 = BlankWidth + 0.5
        endX1 = 1.5
        startY1 = 0
        endY1 = 0
        x2 = win_w * 2 - 2
        y2 = 0  
        ClipLeft = bMid
        ClipRight = aMid
    """) 

    ## Make Mask
    BlackBar = BlankClip(A, length=frms+2, 
    \           width=BlankWidth, height=BlankHeight, 
    \           pixel_type="RGB32")
    WhiteBar = BlankClip(BlackBar, color=$FFFFFF)
    BWmask = (Mode=="LeftToRight" || Mode=="RightToLeft")
    \   ? StackHorizontal(BlackBar, WhiteBar) 
    \   : StackVertical  (BlackBar, WhiteBar) 
    BWmask = BWmask.Animate(0, frms+1, "GaussResize",
    \       wid, hgt, startX1, startY1, x2, y2, HardnessStart,
    \       wid, hgt, endX1,   endY1,   x2, y2, HardnessEnd
    \ ).Trim(1, frms)

    ## Glue it together
    Trim(A, 0, FrameCount(A)-frms-1)
    (frms > 0 )
    \   ? Last + Overlay(ClipLeft, ClipRight, mask=BWmask, pc_range=True) 
    \             [*  .Subtitle("win_w="+String(win_w)+"; win_h="+String(win_h)) *]
    \   : Last
    
    Last + Trim(B, frms, 0)
    HasAudio(AudioMix) 
    \   ? AudioDub(last, AudioMix) 
    \   : last
}

# http://forum.doom9.org/showthread.php?p=1671928#post1671928
#include "E:\Data\VideoAuxdata\test\White Balance\white-bal.avs"
# C:\Users\raff4\Dropbox\Public\Screenshots\mt_lut_calc_2.ods
## see also:
# https://github.com/ladipro/avisynth_filters/wiki/KelvinColorShift
# http://www.tannerhelland.com/4435/convert-temperature-rgb-algorithm-code/
#######################################
### emulate color temperature changes in three luma ranges
##
## @ offset_x - arbitrary units; <0 means lower temp (warmer colors)
##              (range -50_25; default 0)
##
function CheapColorTemp(clip C, 
\               int offset_lo, int offset_mid, int offset_hi)
{
    Assert(IsClip(C) && C.IsYUV, 
    \   "CheapColorTemp: source must be YUV")
    offset_lo  = Min(Max(-50, offset_lo),  25)
    offset_mid = Min(Max(-50, offset_mid), 25)
    offset_hi  = Min(Max(-50, offset_hi),  25)

    return C.ColorYUVx3(
    \          off_u_lo =offset_lo,  off_v_lo =Round(-0.7*offset_lo),
    \          off_u_mid=offset_mid, off_v_mid=Round(-0.7*offset_mid),
    \          off_u_hi =offset_hi,  off_v_hi =Round(-0.7*offset_hi))
}

# https://forum.doom9.org/showthread.php?p=1671928#post1671928
#######################################
### apply ColorYUV U & V offsets to three luma ranges
##
## @ cont_x, off_x - see [[ColorYUV]]
## @ showmasks     - if true, show original + 3 masks in quad split
##
## Example (null processing)
## | ColorYUVx3(
## | \   off_u_lo =0, off_v_lo =0,
## | \   off_u_mid=0, off_v_mid=0,
## | \   off_u_hi =0, off_v_hi =0)
##
function ColorYUVx3(clip C,
\               float "off_u_lo",  float "off_u_mid",  float "off_u_hi",
\               float "off_v_lo",  float "off_v_mid",  float "off_v_hi",
\               bool "showmasks")
{
    off_u_lo   = Float(Default(off_u_lo,   0.0))
    off_u_mid  = Float(Default(off_u_mid,  0.0))
    off_u_hi   = Float(Default(off_u_hi,   0.0))
    off_v_lo   = Float(Default(off_v_lo,   0.0))
    off_v_mid  = Float(Default(off_v_mid,  0.0))
    off_v_hi   = Float(Default(off_v_hi,   0.0))

    showmasks  = Default(showmasks, false)

    C_lo  = C.ColorYUV(
    \           off_u=off_u_lo,  off_v=off_v_lo)
    C_mid = C.ColorYUV(
    \           off_u=off_u_mid, off_v=off_v_mid)
    C_hi  = C.ColorYUV(
    \           off_u=off_u_hi,  off_v=off_v_hi)

    return MergeLMH(C, C_lo, C_mid, C_hi, showmasks=showmasks) 
}

##################################
### Add grain; any bit depth 8_16; x86/x64
##
## @ C     - YV12, YUY2, RGB24, RGB32; other formats converted and restored as required
## @ yn    - luma noise; 0=off 
##             3 = barely visible on scope
##            10 = typical dithering level
##            30 = subtle grain effect
##           100 = heavy  grain effect
##           ??? (upper limit ~ 100000)
## @ cn    - chroma noise; default == 1/2 luma
##
## @ fixed - if true, show a fixed noise pattern; default false
## @ hcorr, vcorr - horizontal and vertical correlation, which cause steaking effect. 
##           range 0.0_1.0; default 0.05  
##
function AddGrainAG(clip C, int yn, int "cn", bool "fixed", float "hcorr", float "vcorr")
{
    Assert(!C.IsYV411 && !C.IsRGB, 
    \  "AddGrainAG: RGB, YV411 not accepted") ## (cf. Overlay)
    lumn  = Max(0, yn)
    chrn  = Max(0, Default(cn, lumn/2))
    fixed = Default(fixed, false)
    hcorr = Default(hcorr, 0.05)
    vcorr = Default(vcorr, hcorr)

    C
    if (BitsPerComponent==8) 
    {
        lumn = Float(lumn)
        chrn = Float(chrn)
        (IsYV12 || IsYUY2 || IsRGB) ? Last 
        \ : To420(bits_out=8, alpha="none").ConvertToYV12        
        ## ('Eval' to avoid compile error if AddGrainC not installed) 
        Eval("""
          AddGrainC(var=0.01*(lumn*lumn), uvar=0.01*(chrn*chrn), 
          \         hcorr=hcorr, vcorr=vcorr, constant=fixed)
        """)
        MatchColorFormat(C)        
    }
    else if (lumn>=10 && chrn>=10)
    {
        To8bit(dither=true)
        (IsYV12 || IsYUY2 || IsRGB) ? Last 
        \ : ConvertToYV12        
        AddGrainAG(lumn, chrn, fixed, hcorr, vcorr)
        (C.IsRGB32) 
        \ ? MergeARGB(C, Last, Last, Last)
        \ : Last 
        MatchColorFormat(C)        
    }
    else 
    {
        To16bit
        T16 = Last
        hgt = Height
        swap_planes = false
        ToStack16(swap_planes)
        Assert(BitsPerComponent==8, "AddGrainAG: internal error")
        StackVertical(
        \   Crop(0, 0, 0, hgt)
        \    .AddGrainAG(lumn, chrn, fixed, hcorr, vcorr)
        \    .MatchColorFormat(Last),
        \   Crop(0, hgt, 0, 0))
        FromStack16(T16, swap_planes)
        (!C.HasAlpha) ? Last 
        \ : Last.AddAlphaPlane(C)
        MatchColorFormat(C)
    }
    return (lumn==0 && chrn==0) ? C : Last
}

# https://forum.doom9.org/showthread.php?p=1833943#post1833943
##################################################
function watermark42(clip C, clip M, float opacity, bool "nofill")
{
    nofill = Default(nofill, false)
    C

    ## 'CF' = 'fill' (white part of mask)
    ## this is one possible treatment: shift + low contrast
    CF=BilinearResize(Width, Height, -(-3), -(-3), Width, Height) [* shift left, up 3px *]
    \   .ColorYUV(cont_y=f2c(0.7))                                [* lower contrast *]
    \   .Trim(0, length=1).Loop
    #return CF    
    (nofill) ? Last : Overlay(CF, mask=M, opacity=opacity)

    ## 'MC' = mask + convolution (embossed effect)
    MC=M.ConvertToRGB32(matrix="PC.709")
    \ .GeneralConvolution(128, "
        -1 0 0
         0 0 0
         0 0 1")
    \ .Trim(0, length=1).Loop [* for performance - much faster *]

    ## 'MH' = highlight part of emboss
    MH=MC.Levels(128, 1, 255, 0, 255, coring=false)
    \    .Trim(0, length=1).Loop
    Overlay(ColorYUV(off_y=(60)), mask=MH, opacity=0.5*opacity)

    ## 'MS' = shadow part of emboss
    MS=MC.Levels(128, 1, 0, 0, 255, coring=false)
    \    .Trim(0, length=1).Loop
    #return MS
    Overlay(ColorYUV(off_y=(-60)), mask=MS, opacity=0.5*opacity)

    return Last

    ## scale ColorYUV args to a "normal" scale
    function f2c(float f) {
        return Round((f - 1.0) * 256.0) 
    }
}

#######################################################################################
### AUDIO FILTERS 
#######################################################################################

##################################
function AudioEchoes(clip A, int "repeats", float "interval", float "mix")
{                     
    A = A.KillVideo
    reps = Max(1, Default(repeats, 6))
    del  = Min(Max(0.01, Float(Default(interval, 0.08))), 5.0)
    mix  = Min(Max(0.0,  Float(Default(mix,   0.33))), 1.0)
    return (reps<=1) 
    \ ? A.MixAudio(A.AudioTrim(0, repeats*del)+A, (1.0-mix), mix)
    \ : A.AudioEchoes((reps-1), interval, mix)
}

#######################################################################################
### DEBUGGING FILTERS
#######################################################################################

##################################
### show basic clip properties, a bit like [[Info]] but more compact
##  no run-time properties like current_frame etc
##
## @ label - a short identifier string; optional
## @ font, size, text_color, halo_color, align 
##         - cf. [[Subtitle]], except default size=auto
##
function ShowInfoString(clip C, string "label", string "font", float "size", 
\               int "text_color", int "halo_color", int "align")
{
    size  = Default(size, Max(12.0, 18.0*C.Width/640.0))
    aln   = Default(align, 7)
    label = Default(label, "")

    s = SplitLines(InfoString(C, label))
    n = CountLines(s)
    C
    
    x = (aln==1||aln==4||aln==7) ? size
    \ : (aln==2||aln==5||aln==8) ? -1
    \                            : Width-size
    
    y = (aln==7||aln==8||aln==9) ? 0.5*size
    \ : (aln==4||aln==5||aln==6) ? (0.5*Height)-(0.5*n*size)
    \                            : Height-(n*size)
    
    Subtitle42(s, x, y, 0, FrameCount-1, font, size,  
    \                  text_color, halo_color, align, lsp=0)
    return Last
}

##################################
### return grayscale radial gradient clip w/ same specs as template clip 'T'
##
## Color: center White, edge Black.
##
## @ T      - determines default properties (including bit depth) 
## @ width  - minimum width  = 4; default T.Width
## @ height - minimum height = 4; default T.Height
## @ radius - portion of width/height occupied by gradient; 
##            range 0.01_100.0; default 1.0 (100%)
##            (NOTE aspect ratio of gradient follows source)
## @ gamma  - falloff linearity ("pinch" or "bulge" the gradient "cone")
##            range 0.01_10.0; default 1.0 (linear falloff)
## @ circle - if true, y-radius forced equal to x-radius
##
function GrayRadial(clip T, int "width", int "height", float "radius", float "gamma", bool "circle")
{
    wid  = Max(4, Default(width,  T.Width))
    hgt  = Max(4, Default(height, T.Height))
    rad  = Min(Max(0.01, Default(radius,  1.0)), 100.0)
    gam  = Min(Max(0.01, Default(gamma,   1.0)), 10.0)
    circ = Default(circle, false)

    BlankClip(T, width=wid, height=hgt, color=$0, pixel_type="YUV420P"+String(Max(10, T.BitsPerComponent)))

    ## (sqrt((0.5-y)^2 + (0.5-x)^2) * -2 + 1)^(1/gamma) * (fullscale)
    s = ("0.5 y - 2 ^ $ry / 0.5 x - 2 ^ $rx / + 0.5 ^ -2 * 1 + $g ^ 256 @B * ")
    \    .ReplaceStr("$rx", String(rad))
    \    .ReplaceStr("$ry", String(circ ? rad * (wid*wid) / (hgt*hgt) : rad))
    \    .ReplaceStr("$g", String(1.0/gam))
    mt_lutspa(yexpr=s, mode="relative", chroma=C.sc8s(-128)) 

    MatchColorFormat(T, dither=true)
    Trim(0, -1)
    Loop(T.FrameCount) 
    return Last
}

##################################
### return color radial gradient clip w/ same specs as template clip 'T'
##
## @ T           - RGB(A) or Y only (8, 10, 12, 14 or 16-bit);
##                 determines default properties.
## @ inner_color - any RGB color; default White
## @ outer_color - any RGB color; default Black
## @ width       - minimum width  = 4; default T.Width
## @ height      - minimum height = 4; default T.Height
## @ radius      - portion of width/height; 
##                 range 0.01_100.0; default 1.0 (100%)
##                 (NOTE aspect ratio of gradient follows source)
## @ circle      - if true, y-radius forced equal to x-radius
## @ gamma       - falloff rate adjustment ("pinch" or "bulge" the gradient "cone")
##                 range 0.01_10.0; default 1.0 (linear falloff)
## @ noise       - if > 0, add fixed, random noise; range 0_4, default 0
##
function ColorRadial(clip T, int "inner_color", int "outer_color", 
\                   int "width", int "height", float "radius", float "gamma", 
\                   bool "circle", int "noise")
{
    Assert(!C.IsYV411, 
    \  "ColorRadial: YV411 not accepted") ## (cf. Overlay)
    icc  = Default(inner_color,   $ffffff)
    occ  = Default(outer_color,   $000000)
    wid  = Max(4, Default(width,  T.Width))
    hgt  = Max(4, Default(height, T.Height))
    rad  = Min(Max(0.01, Default(radius,  1.0)), 100.0)
    gam  = Min(Max(0.01, Default(gamma,   1.0)), 10.0)
    circ = Default(circle, false)
    nzz = Min(Max(0, Default(noise, 0)), 4)

    Overlay(
    \   BlankClip(T, width=wid, height=hgt, color=occ),
    \   BlankClip(T, width=wid, height=hgt, color=icc),
    \   mask=GrayRadial(T, wid, hgt, rad, gam, circ)
    \ )

    (nzz==0) ? Last
    \ : AddGrainAG(nzz, fixed=true)

    Trim(0, -1)
    Loop(T.FrameCount)
    return Last
}

# E:\Programs\Avisynth_Plugins\plugins-NOT\MVTools2\v2.6.0.5\Sources\MVShow.cpp(85) 
#   'MVShow::GetFrame'
# E:\Programs\Avisynth_Plugins\plugins-NOT\MVTools2\v2.6.0.5\Sources\MVShow.cpp(211) 
#   'MVShow::DrawMV'
##################################
### return motion vectors
##
## @ blksize  - (4|8|16|32)
## @ ascale   - exaggerate size of motion arrows. range 1_('blksize'/2-1); default 2
## @ isolated - if true, show vectors only; else (default) show vectors as overlay
##
function MVect2(clip C, clip "super", clip "manalyse", int "blksize", int "ascale", bool "isolated")
{
    isolated = Default(isolated, false)
    blksize  = Default(blksize, 16) ## (4|8|16|32)
    ascale   = Min(Max(0, Default(ascale, 2)), (blksize/2-1))

    C ## Last==C 
    super = IsClip(super) ? super 
    \           : MSuper
    fvec  = IsClip(manalyse) ? manalyse 
    \           : MAnalyse(super, blksize=blksize, isb=false)

#V =  MStoreVect(fvec).Turn180.PointResize(C.Width/2, C.CalcHeight(C.Width/2)) 
#return StackVertical(V.ShowAlpha, V.ShowRed, V.ShowGreen, V.ShowBlue)
#return MStoreVect(fvec).Turn180#.BicubicResize(C.Width, C.Height)

    MShow(super, fvec, scale=ascale)
    #MShow(super, fvec, showsad=true, thSCD1=400, thSCD2=112, sil=1)

    BicubicResize(C.Width, C.Height, 
    \    src_left=8, src_top=8, 
    \    src_width=C.Width, src_height=C.Height)
    return (isolated) 
    \   ? Subtract(Last, C)
    \   : Last 
}

##################################
### return motion mask
##
function MMask2(clip C)
{
    C ## Last==C
    super = MSuper
    fvec  = MAnalyse(super, isb=false)
    MMask(super, fvec, ml=100, gamma=0.5, 
    \          kind=0, Ysc=0, thSCD1=400, thSCD2=130)
    Greyscale #.Info
    Crop(0, 2, C.Width, C.Height, true)
    return Last
}

##################################
### add striped border on all sides
##  helps spot where cropping or extending is taking place
##
## @ stripecount - number of color1/color2 stripe pairs
## @ modx  - width of left/right stripes; default 1 (RGB, 444, Y) or 2
## @ mody  - width of top/bottom stripes
## @ inset - if true, draw stripes /inside/ current frame (cf. [[Letterbox]])
##           else (default), /add to/ frame (cf. [[AddBorders]]).
##           Note size may increase with large 'stripecount' values;
##           if this is an issue, call [[CropEx]] afterward.
##
function stripe_border(clip C, int stripecount, 
\               int "modx", int "mody", bool "inset",
\               int "color1", int "color2")
{
    cnt  = stripecount
    modx = Max((C.IsRGB||C.IsY||C.Is444) ? 1 : 2, Default(modx, 1))
    mody = Max((C.IsRGB||C.IsY||C.Is444) ? 1 : 2, Default(mody, 1))
    ins  = Default(inset, false)
    col1 = BitAnd($ffffff, Default(color1, $666666))
    col2 = BitAnd($ffffff, Default(color2, $aaaaaa))

    if (cnt<=0) {
        return C
    } 
    
    ## "safe" CropLRTB
    cnt2 = cnt
    success = true
    CC = C
    while (ins && success && (cnt2 > 0)) {
        try {
            CC = CC.CropLRTB(2*modx, 2*mody, 2*modx, 2*mody)
#            \ .Subtitle(String(cnt2), y=CC.Height-((cnt2+1)*24))
        } catch (err_msg) {
            success = false
        }
        cnt2 = cnt2 - 1
    }
[*
return CC.CropEx(C.Width, C.Height)
\ .Subtitle("stripe_border("+String(stripecount)
\     +", "+String(modx)+", "+String(mody)
\     +", inset="+String(ins)+") (failcount="+String(cnt2)+")"
\     +"\n"+Splitlines(CC.InfoString("CC")), lsp=0)
*]

    (ins) ? CC : C
    AddBorders(modx, mody, modx, mody, col1)
    AddBorders(modx, mody, modx, mody, col2)
#    (ins) ? CropEx(C.Width, C.Height) : Last

    return stripe_border(
    \           (cnt-1), modx, mody,
    \           false, color1, color2)
#    \ .Subtitle(String(cnt), y=Height-((cnt+1)*12))
}

##################################
### add rainbow border on all sides
##  helps spot where cropping or extending is taking place
##
## @ modx - width of left/right stripes; default 1 (RGB, 444, Y) or 2
## @ mody - width of top/bottom stripes
##
function rainbow_border(clip C, int "modx", int "mody")
{
    modx = Max((C.IsRGB||C.IsY||C.Is444) ? 1 : 2, Default(modx, 1))
    mody = Max((C.IsRGB||C.IsY||C.Is444) ? 1 : 2, Default(mody, 1))
    C
    AddBorders(modx, mody, modx, mody, color_black  )
    AddBorders(modx, mody, modx, mody, color_white  )
    AddBorders(modx, mody, modx, mody, color_red    )
    AddBorders(modx, mody, modx, mody, color_orange )
    AddBorders(modx, mody, modx, mody, color_yellow )
    AddBorders(modx, mody, modx, mody, color_blue   )
    AddBorders(modx, mody, modx, mody, color_indigo )
    AddBorders(modx, mody, modx, mody, color_violet )
    return Last
}

##################################
### colorbars with HSL (not NTSC) colors designed to be stacked over clip 'C'; no audio
##
## @ C      - Any color format supported by [[BlankClip]];
##            determines all properties except height. 
## @ height - default 40; minimum 8; if 'ontop'==true, bottom 4 lines are black
## @ ontop  - if true (default), stack on top of clip 'C' with audio from 'C'
## @ inset  - if true and 'ontop'==true, crop 'C' so height is unchanged; default false
## @ label  - if true, show a label with 0_255 color values; default false
##            (height must be >= 20 to show labels)
##
function MiniBars(clip C, int "height", bool "ontop", bool "inset", bool "label")
{
    Assert(Defined(C) && IsClip(C) && C.Width>=32, 
    \   "MiniBars: clip 'C' must be at least 32 pixels wide")
    top  = Default(ontop, false)
    inst = Default(inset, false)
    hgt  = Default(height, 40)  
    hgt  = Max(8, modx(2, hgt))
    hgt  = hgt - (top ? 4 : 0)
    lbl  = Default(label, false)
    lbl  = lbl && (hgt>=20)
    wid  = modx(2, C.Width/10.5, dir=0)
    wid2 = C.Width - (9 * wid)

    Last = C.KillAudio

    R = StackHorizontal(
    \   BlankClip(Last, color=$ffffff, height=hgt, width=wid)._miniID("255", lbl), [* 100% wht *]
    \   BlankClip(Last, color=$bfbfbf, height=hgt, width=wid)._miniID("191", lbl), [*  75% wht *]
    \   BlankClip(Last, color=$bfbf00, height=hgt, width=wid)._miniID("191", lbl), [*  75% yel *]
    \   BlankClip(Last, color=$00bfbf, height=hgt, width=wid)._miniID("191", lbl), [*  75% cyn *]
    \   BlankClip(Last, color=$00bf00, height=hgt, width=wid)._miniID("191", lbl), [*  75% grn *]
    \   BlankClip(Last, color=$bf00bf, height=hgt, width=wid)._miniID("191", lbl), [*  75% mag *]
    \   BlankClip(Last, color=$bf0000, height=hgt, width=wid)._miniID("191", lbl), [*  75% red *]
    \   BlankClip(Last, color=$0000bf, height=hgt, width=wid)._miniID("191", lbl), [*  75% blu *]
    \   BlankClip(Last, color=$060606, height=hgt, width=wid)._miniID("006", lbl), [*   +4 blk *]
    \   BlankClip(Last, color=$000000, height=hgt, width=wid)._miniID("000", lbl), [*      blk *]
    \   BlankClip(Last, color=$000000, height=hgt, width=wid2-wid))
    R = R.Trim(0, length=1).Loop(C.FrameCount)
    
    R = (!top) ? R
    \ : StackVertical(
    \       R.Addborders(0, 0, 0, (top ? 4 : 0)), 
    \       (inst ? C.Crop(0, hgt+4, 0, 0) : C))

    R = (!top || !C.HasAudio) ? R : R.AudioDub(C)
    return R

    function _miniID(clip C, string msg, bool enable)
    {
        return (enable==false) ? C 
        \ : C.Subtitle42(msg, align=2, 
        \       size=Min(Max(8.0, Round(C.Width/4.0)), C.Height), 
        \       text_color=$80cccccc, halo_color=$80000000)
    }
}
    
### fka UUStackTwoAcrossCropped
##################################
### make side-by-side split clip; crop input images to fit in original width
##  (normally, for comparison or preview purposes)
##
## @ S         - sound source [default = 'A']
## @ border    - border subtracted from clips [default = 8]
## @ pan       - range = -1.0_1.0
##                   -1.0=left, 0.0=center, +1.0=right; [default = 0.0]
##
## @ wid       - output width [default = input width]
## @ titleA, B - short identifier strings for debugging
## @ align     - see [[Subtitle]]: align
##
## @version 1.0 28-May-2012 raffriff42
## @version 1.1 02-Apr-2014 (@ wid)
##
function StackTwoAcrossCropped(clip A, clip B, clip "S", 
\               int "border", float "pan", int "wid",
\               string "titleA", string "titleB", int "align")
{
    S = Default(S, A)

    inWid   = Default(wid, A.Width)
    inHgt   = Min(A.Height, B.Height)     
    border  = m4(Default(border, 8))
    border2 = Int(border / 2) 
    pan     = Min(Max(-1.0, Float(Default(pan, 0.0))), 1.0) #* 0.5
    cropWid = modx(2, Float(inWid) / 2.0)

    align = Default(align, 7) ## no default for labels

    A = A.CropPanTilt(cropWid-border2, inHgt, pan, 1.0, titleA, align)
    B = B.CropPanTilt(cropWid-border2, inHgt, pan, 1.0, titleB, align)
 
    A = A.AddBorders(0,       0, border2, 0)
    B = B.AddBorders(border2, 0, 0,       0)

    R = StackHorizontal(A, B) #.CropEx(inWid, inHgt)  

    return (!IsClip(S))  ? R 
    \    : (!S.HasAudio) ? R 
    \    : AudioDub(R, S)
}

##################################
### invert hue in a sweeping pattern (used to find a particular hue)
##
## @ hue_range       - range of affected hues; default 10 degrees (± 5)
## @ sweep_increment - hue change per frame; default 5 degrees
## @ sweep_start     - starting hue; default 0
##
function HueSweep(clip C, int "hue_range", int "sweep_increment", int "sweep_start")
{
    rnge = Min(Max(2, Default(hue_range, 10)), 180)
    hues = Max(0, Default(sweep_increment, 5))
    offs = Default(sweep_start, 0)

    C
    global grnge = rnge/2
    global ghues = hues
    global goffs = offs

    (hues<=0) ? Last : ScriptClip(C, """
      h = Float((goffs + ghues * current_frame) % 360)
      Tweak(hue=180.0, sat=1.0, 
      \       starthue=Max(0.01, Fmod(h-grnge+36000, 360.0)),
      \       endhue  =Max(0.01, Fmod(h+grnge+36000, 360.0)),
      \       coring=false)
      Subtitle("h="+String(h, "%0.0f"), size=56, align=5)
    """)

    return Last
}

#@ FranceBB
## aka VideoTek
# https://forum.doom9.org/showthread.php?t=175249
##################################
### show video waveform + vectorscope + audio scopes; YUV only
##
function TekScopes(clip C, bool "shrink") 
{
    Assert(C.Is420, 
    \   "TekScopes: source must be YUV420")
    Assert(C.Height>=260,
    \   "TekScopes: source clip minimum height = 260")
    shrink = Default(shrink, false)

    CS = C.BilinearResize(1280, C.CalcHeight(1280))
    \     .CropEx(1280, 720)
#    CS=Last
#return CS

    A = CS.GetChannel(1, 2)

    vids = CS
    \   .PointResize(704, 396)

    hist = CS.TurnRight
    \    ._Hist2
    \    .TurnLeft
    \    .PointResize(704, CS.CalcHeight(704))
    \    .BilinearResize(vids.Width, 396)
    #\    .BilinearResize(704, 396)
#return hist
    
#    vect = CS.Histogram("color2")
#    \   .Crop(1280, 0, -0, -460)
#    \   .FlipVertical

    vect = CS.Vector2()
    \   .Crop(1280, 0, -0, -460)
#return vect

    liss = A.Histogram("stereo")
    \   .BilinearResize(396, 396)
    \   .ColorYUV(off_y=(-20), gain_y=f2c(2.0))
#return liss
    
    #vids=Overlay(clean1)
    #\   .Crop(0, 0, -576, -324)
#    vids = CS
#    \   .PointResize(704, 396)
#return vids
    
    #myluma=Overlay(hist)
    #\   .Crop(0, 0, -576, -332)
#    myluma=hist
#   return myluma
    
#    vect = vids.Overlay(vect)
#    \   .Crop(0, 0, -1024, -460)
#    \   .BilinearResize(460, 460)
#return vect
    
    blnk = BlankClip(C, width=1480, height=920).AudioDub(A)
#return blnk
    
#    peraudiolevels = AudioDub(blnk, A)
#return peraudiolevels
    
    audm = blnk
    \   .Histogram("audiolevels")
    \   .CropLTWH(0, 0, 512, A.Height)
    \   .ScaleSize(340, 420, 4)
#return audm.Info.To8bit

#return CS ## org, 1280x720
#return Last ## == CS
#return blnk ## BlankClip, 1480x920
#return vids ## org, small
#return hist ## hist, 704x396
#return vect ## vector, 256x260
#return liss ## lissajou, 396x396
#return audm ## audio levels (overlay, cropped), 320x420
    blnk
    Overlay(vids)    
#    Overlay(hist, x=710)    
#    Overlay(vect, x=100, y=430)    
    Overlay(hist, y=vids.Height+32)    
    Overlay(vect, x=vids.Width+32, y=32)    
    Overlay(liss, x=1000, y=450)    
    Overlay(audm, x=vids.Width+32, y=450)

    if (shrink) {
        z=Max(Float(Width)/C.Width, Float(Height)/C.Height)
        ScaleZoom(1/z, 2)
        CropEx(C.Width, C.Height)
    }
    return Last.AudioDub(C)
}

__END__

/*
#@ FranceBB
## aka VideoTek
# https://forum.doom9.org/showthread.php?t=175249
##################################
### show video waveform + vectorscope + audio scopes; YUV only
##
function TekScopes(clip clp) 
{
    clean=clp.Converttoyv12
    \  .BilinearResize(1280, clp.CalcHeight(1280))
    \  .CropEx(1280, 720)
    clean
#return clean

    audio=GetChannel(clean, 1, 2)
    
    clean1=clean
    \   .PointResize(704, 396)
#return clean1.Info
    
[*
    luma=TurnRight
    \    .Histogram
    \    .TurnLeft
    \    .PointResize(704, 396)
    \    .Crop(0, 0, -0, -290)
    \    .BilinearResize(704, 396)
    \    .Tweak(sat=0.0625)
*]
    luma=clean.TurnRight
    \    ._Hist2
    \    .TurnLeft
    \    .PointResize(704, CalcHeight(704))
    \    .BilinearResize(704, 396)
#return luma
    
    chroma=Histogram("color2")
    \   .Crop(1280, 0, -0, -460)
    \   .FlipVertical
#return chroma

    lissajou=Histogram("stereo")
    \   .BilinearResize(396, 396)
    \   .ColorYUV(off_y=-20, gain_y=f2c(2.0))
#return lissajou
    
    #picture=Overlay(clean1)
    #\   .Crop(0, 0, -576, -324)
    picture=clean1
#return picture
    
    #myluma=Overlay(luma)
    #\   .Crop(0, 0, -576, -332)
    myluma=luma
#   return myluma
    
    mychroma=Overlay(chroma)
    \   .Crop(0, 0, -1024, -460)
    \   .BilinearResize(460, 460)
#return mychroma
                            
    nero=BlankClip(clp, width=1480, height=920, pixel_type="YV12") 
#return nero
    
    peraudiolevels=AudioDub(nero, audio)
#return peraudiolevels
    
    livelliaudio=peraudiolevels
    \   .Histogram("audiolevels")
    \   .Crop(0, 0, -736, -0)
    \   .ScaleSize(340, 420, 4)
#return livelliaudio.Info.To8bit
    
    Overlay(nero, picture)    
    Overlay(myluma, x=710)    
    Overlay(mychroma, x=100, y=430)    
    Overlay(lissajou, x=1000, y=450)    
    Overlay(livelliaudio, x=700, y=450)

    return Last.AudioDub(clp)
}
*/
