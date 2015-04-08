FUNCTION get_fastloc_inds__IMF_conds,clockStr

;                    CLOCKSTR          :  Interplanetary magnetic field clock angle.
;                                            Can be 'dawnward', 'duskward', 'bzNorth', 'bzSouth', 'all_IMF',
;                                            'dawn-north', 'dawn-south', 'dusk-north', or 'dusk-south'.
  defSatellite = "OMNI"    ;either "ACE", "wind", "wind_ACE", or "OMNI" (default, you see)
  defOmni_Coords = "GSM"             ; either "GSE" or "GSM"

  defDelay = 660

  defByMin = 5
  defBx_over_ByBz_Lim = 0       ;Set this to the max ratio of Bx / SQRT(By*By + Bz*Bz)
  defstableIMF = 1S             ;Set to a time (in minutes) over which IMF stability is required
  defSmoothWindow = 5           ;Set to a time over which to smooth IMF
  defIncludeNoConsecData = 0    ;Setting this to 1 includes Chaston data for which  
                                ;there's no way to calculate IMF stability
                                ;Only valid for stableIMF GE 1
  defCheckBothWays = 0          
  
  defClockStr = 'dawnward'
  
  defAngleLim1 = 45.0
  defAngleLim2 = 135.0

  defLun = -1 ;stdout
  defOutSummary = 1 ;for output plot summary

  ;;********************************************
  ;;satellite data options
  IF NOT KEYWORD_SET(satellite) THEN satellite = defSatellite          ;either "ACE", "wind", "wind_ACE", or "OMNI" (default, you see)
  IF NOT KEYWORD_SET(omni_Coords) THEN omni_Coords = defOmni_Coords    ; either "GSE" or "GSM"

  IF delay EQ !NULL THEN delay = defDelay                      ;Delay between ACE propagated data and ChastonDB data
                                                                       ;Bin recommends something like 11min
  
  IF stableIMF EQ !NULL THEN stableIMF = defStableIMF                    ;Set to a time (in minutes) over which IMF stability is required
  IF includeNoConsecData EQ !NULL THEN includeNoConsecData = defIncludeNoConsecData ;Setting this to 1 includes Chaston data for which  
                                                                       ;there's no way to calculate IMF stability
                                                                       ;Only valid for stableIMF GE 1
  IF NOT KEYWORD_SET(checkBothWays) THEN checkBothWays = defCheckBothWays       ;
  
  IF NOT KEYWORD_SET(Bx_over_ByBz_Lim) THEN Bx_over_ByBz_Lim = defBx_over_ByBz_Lim       ;Set this to the max ratio of Bx / SQRT(By*By + Bz*Bz)
  
  IF NOT KEYWORD_SET(lun) THEN lun = defLun

  IF NOT KEYWORD_SET(byMin) THEN byMin = defByMin

  IF NOT KEYWORD_SET(smoothWindow) THEN smoothWindow = defSmoothWindow  ;in Min

  IF clockStr NE "all_IMF" THEN BEGIN
     angleLim1=defAngleLim1               ;in degrees
     angleLim2=defAngleLim2              ;in degrees
  ENDIF ELSE BEGIN 
     angleLim1=180.0              ;for doing all IMF
     angleLim2=180.0 
  ENDELSE


  phiFastLoc = interp_mag_data_for_fastloc(satellite,SATDBDIR=satDBDir,OMNI_COORDS=omni_Coords,DELAY=delay, $
                                           FASTLOC_TIMES=fastLoc_Times,FASTLOCINTERP_I=fastLocInterp_i,SATDBINTERP_I=SATdbInterp_i, $
                                           MAG_UTC=mag_utc, PHICLOCK=phiClock,SMOOTHWINDOW=smoothWindow,BYMIN=byMin, $
                                           LUN=lun)
  phiImf_ii = check_imf_stability_for_fastloc(clockStr,angleLim1,angleLim2,phiFastLoc,SATdbInterp_i,stableIMF,mag_utc,phiClock,$
                                 bx_over_bybz=Bx_over_ByBz_Lim,LUN=lun)  

  fastLocInterped_i=fastLocInterp_i(phiImf_ii)

  RETURN, fastLocInterped_i

END