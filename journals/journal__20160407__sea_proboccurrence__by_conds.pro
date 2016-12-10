;;2016/04/07 At this thing's current state, you can use it to get the indices for the start times of the IMF conditions that
;;interest you
;; Could be good, Spence. ... Come on—think about it, bro ...
PRO JOURNAL__20160407__SEA_PROBOCCURRENCE__BY_CONDS

  histoRange                     = [0.0,0.2]
  histobinsize                   = 1.0
  do_despun                      = 1


  hemi                           = 'NORTH'
  minILAT                        = [ 63, 63, 63, 63, 63, 63]
  ;; maxILAT                        = [ 79, 79, 79, 79, 79, 79]
  maxILAT                        = [ 77, 77, 77, 77, 77, 77]
  centerMLT__dawn                = 12.0
  centerMLT__dusk                = 12.0

  ;; Looks like Southern Hemi cells split around 11.25, and the important stuff is below -71 
  ;; hemi                           = 'SOUTH'
  ;; minILAT                        = -[ 79, 79, 79, 79, 79, 79]
  ;; maxILAT                        = -[ 66, 66, 66, 66, 66, 66]
  ;; centerMLT__dawn                = 12.0
  ;; centerMLT__dusk                = 12.0

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;MLT stuff
  binMLT                         = 0.75
  nBinsMLT                       = 4.0

  do_these_cells                 = [0,1,2]

  cell                           = ['Dawn cell','Dusk cell','Center cell']
  minMLT                         = [ centerMLT__dawn-binMLT*0.5-nBinsMLT*binMLT, centerMLT__dawn+binMLT*0.5                , $ ;;dawnward IMF
                                     centerMLT__dawn-nBinsMLT*binMLT*0.5       ,                                             $ ;;;(center cell)
                                     centerMLT__dusk-binMLT*0.5-nBinsMLT*binMLT, centerMLT__dusk+binMLT*0.5                , $ ;;duskward IMF
                                     centerMLT__dusk-nBinsMLT*binMLT*0.5                                                   ]   ;;;(center cell)

  maxMLT                         = [ centerMLT__dawn-binMLT*0.5                , centerMLT__dawn+binMLT*0.5+nBinsMLT*binMLT, $ ;;dawnward IMF
                                     centerMLT__dawn+nBinsMLT*binMLT*0.5       ,                                             $ ;;;(center cell)
                                     centerMLT__dusk-binMLT*0.5                , centerMLT__dusk+binMLT*0.5+nBinsMLT*binMLT, $ ;;duskward IMF
                                     centerMLT__dusk+nBinsMLT*binMLT*0.5                                                   ]   ;;;(center cell)


  ;;SEA options
  tBeforeEpoch                     = 9
  tAfterEpoch                      = 9
  remove_dupes                     = 0
  only_OMNI_plots                  = 0


  ;;IMF options
  clockStr                         = 'duskward'
  dont_consider_clockAngles        = 1

  byMin                            = 5
  abs_bymin                        = 1
  bzMax                            = -5

  angleLim1                        = 60.
  angleLim2                        = 120.
  
  smoothWindow                     = 10
  stableIMF                        = 10
  maxNStreaks                      = 500

  ;; OMNI_quantities_to_plot          = 'by_gse,bz_gse,bx_gse'
  ;; omni_quantity_ranges             = [[-30,30],[-30,30],[-30,30]]

  OMNI_quantities_to_plot          = 'by_gse'
  omni_quantity_ranges             = [[-30,30]]

  ;;No need for this right now
  ;; LOAD_MAXIMUS_AND_CDBTIME,maximus,cdbtime,/GET_GOOD_I,good_i=good_i

  SET_IMF_PARAMS_AND_IND_DEFAULTS,CLOCKSTR=clockStr, ANGLELIM1=angleLim1, ANGLELIM2=angleLim2, $
                                  DONT_CONSIDER_CLOCKANGLES=dont_consider_clockAngles, $
                                  ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, $
                                  BYMIN=byMin, $
                                  BZMIN=bzMin, $
                                  BYMAX=byMax, $
                                  BZMAX=bzMax, $
                                  DO_ABS_BYMIN=abs_byMin, $
                                  DO_ABS_BYMAX=abs_byMax, $
                                  DO_ABS_BZMIN=abs_bzMin, $
                                  DO_ABS_BZMAX=abs_bzMax, $
                                  BX_OVER_BYBZ_LIM=Bx_over_ByBz_Lim, $
                                  DO_NOT_CONSIDER_IMF=do_not_consider_IMF, $
                                  PARAMSTRING=paramString, $
                                  SATELLITE=satellite, OMNI_COORDS=omni_Coords, $
                                  STABLEIMF=stableIMF, $
                                  SMOOTHWINDOW=smoothWindow, $
                                  INCLUDENOCONSECDATA=includeNoConsecData, $
                                  LUN=lun
  
  stable_OMNI_i      = GET_STABLE_IMF_INDS(MAG_UTC=mag_utc, $
                                           CLOCKSTR=clockStr, $
                                           DONT_CONSIDER_CLOCKANGLES=dont_consider_clockAngles, $
                                           ANGLELIM1=angleLim1, $
                                           ANGLELIM2=angleLim2, $
                                           STABLEIMF=stableIMF, $
                                           SMOOTH_IMF=smoothWindow, $
                                           /RESTRICT_TO_ALFVENDB_TIMES, $
                                           BYMIN=byMin, $
                                           BZMIN=bzMin, $
                                           BXMIN=bxMin, $
                                           BYMAX=byMax, $
                                           BZMAX=bzMax, $
                                           BXMAX=bxMax, $
                                           /GET_BY, $
                                           BY_OUT=By, $
                                           /GET_BZ, $
                                           BZ_OUT=Bz, $
                                           DO_ABS_BYMIN=abs_byMin, $
                                           DO_ABS_BYMAX=abs_byMax, $
                                           DO_ABS_BZMIN=abs_bzMin, $
                                           DO_ABS_BZMAX=abs_bzMax, $
                                           DO_ABS_BXMIN=abs_bxMin, $
                                           DO_ABS_BXMAX=abs_bxMax, $
                                           OMNI_COORDS=OMNI_coords, $
                                           OMNI_PARAMSTR=omni_paramStr, $
                                           LUN=lun)
  

  GET_STREAKS,stable_OMNI_i,START_I=start_ii,STOP_I=stop_ii,SINGLE_I=single_ii,MIN_STREAK_TO_KEEP=minStreak

  nStreaks              = maxNStreaks < N_ELEMENTS(stop_ii)-1

  bigStreaks            = GET_N_MAXIMA_IN_ARRAY(stop_ii-start_ii,N=nStreaks,OUT_I=bigStreaks_i)

  ;;print longest streaks
  PRINT,FORMAT='("N",T5,"Length (min)",T20,"Start time",T45,"Stop time")'
  FOR i=0,N_ELEMENTS(bigStreaks_i)-1 DO BEGIN
     PRINT,FORMAT='(I0,T5,F0.2,T20,A0,T45,A0)',i,bigStreaks[i], $
           TIME_TO_STR(mag_UTC[stable_OMNI_i[start_ii[bigStreaks_i[i]]]]), $
           TIME_TO_STR(mag_UTC[stable_OMNI_i[stop_ii[bigStreaks_i[i]]]])
  ENDFOR

  streakstart_UTC = mag_UTC[stable_OMNI_i[start_ii[bigStreaks_i]]] - 60*stableIMF

  streakstart_UTC = streakstart_UTC[SORT(streakStart_UTC)]

  



  ;;manual mod this
  IF do_despun THEN BEGIN
     plotSuff       = '--' + STRLOWCASE(hemi) + '_hemi--despun_db.png'
  ENDIF ELSE BEGIN
     plotSuff       = '--' + STRLOWCASE(hemi) + '_hemi.png'
  ENDELSE

  probOccPref       = 'PROBOCCURRENCE--justhisto'

  ptRegion          = ['Dawn Cell','Dusk Cell','Center cell']
  symColor          = ['blue','red','black']

  FOR j=0,N_ELEMENTS(do_these_cells)-1 DO BEGIN
     i                 = do_these_cells[j]

     savePlotPref      = STRING(FORMAT='(A0,"--",I0,"-hr_bins")', $
                                probOccPref, $
                                histoBinsize)
                                ;; window_sum)
     spn               = savePlotPref+plotSuff

  SUPERPOSE_SEA_TIMES_ALFVENDBQUANTITIES, $
                                         TBEFOREEPOCH=tBeforeEpoch,TAFTEREPOCH=tAfterEpoch, $
                                         SEA_CENTERTIMES_UTC=streakStart_UTC, $
                                         OMNI_QUANTITIES_TO_PLOT=OMNI_quantities_to_plot, $
                                         OMNI_QUANTITY_RANGES=OMNI_quantity_ranges, $
                                         LOG_OMNI_QUANTITIES=log_omni_quantities, $
                                         SMOOTHWINDOW=smoothWindow, $
                                         /USE_DARTDB_START_ENDDATE, $
                                         DESPUNDB=despun, $
                                         REMOVE_DUPES=remove_dupes, $
                                         MINMLT=minMLT[i], $
                                         MAXMLT=maxMLT[i], $
                                         MINILAT=minILAT[i], $
                                         MAXILAT=maxILAT[i], $
                                         HEMI=hemi, $
                                         /NOMAXPLOTS, $
                                         PLOTTITLE=pT, $
                                         NOGEOMAGPLOTS=(i GT 0), $
                                         WINDOW_GEOMAG=geomagWindow, $
                                         /XLABEL_MAXIND__SUPPRESS, $
                                         HISTORANGE=histoRange, $
                                         HISTOBINSIZE=histoBinsize, $
                                         /OVERPLOT_HIST, $
                                         /PROBOCCURRENCE_SEA, $
                                         SAVEPLOT=(i EQ (N_ELEMENTS(DO_these_i) - 1)), $
                                         OUT_HISTO_PLOT=out_histo_plot, $
                                         /ACCUMULATE__HISTO_PLOTS, $
                                         N__HISTO_PLOTS=N_ELEMENTS(do_these_i), $
                                         SYMCOLOR__HISTO_PLOT=symColor[i], $
                                         /MAKE_LEGEND__HISTO_PLOT, $
                                         NAME__HISTO_PLOT=ptRegion[i], $
                                         SAVEPNAME=spn
  
  ENDFOR


  PRINT,'MOKE DAT'
END