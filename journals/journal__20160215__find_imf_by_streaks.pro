PRO JOURNAL__20160215__FIND_IMF_BY_STREAKS

  clockStr                         = 'duskward'
  byMin                            = 5
  abs_bymin                        = 1
  do_angles                        = 1
  bzMax                            = -5

  minStreak                        = 10

  SET_IMF_PARAMS_AND_IND_DEFAULTS,CLOCKSTR=clockStr, ANGLELIM1=angleLim1, ANGLELIM2=angleLim2, $
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
  
  angleLim1          = 60.
  angleLim2          = 120.

  good_i             = GET_OMNI_IMF_INDS_AND_QUANTITIES(satellite, $
                                                        MAG_UTC=mag_utc, $
                                                        /RESTRICT_TO_ALFVENDB_TIMES, $
                                                        PHICLOCK=phiClock, $
                                                        BYMIN=byMin, $
                                                        BZMAX=bzMax, $
                                                        DO_ABS_BYMIN=abs_byMin, $
                                                        DO_ANGLES=do_angles, $
                                                        ANGLELIM1=anglelim1, $
                                                        ANGLELIM2=anglelim2, $
                                                        CLOCKSTR=clockStr)


  GET_STREAKS,good_i,START_I=start_ii,STOP_I=stop_ii,SINGLE_I=single_ii,MIN_STREAK_TO_KEEP=minStreak

  bigStreaks            = GET_N_MAXIMA_IN_ARRAY(stop_ii-start_ii,N=100 < N_ELEMENTS(stop_ii)-1,OUT_I=bigStreaks_i)

  ;;print longest streaks
  PRINT,FORMAT='("N",T5,"Length (min)",T20,"Start time",T45,"Stop time")'
  FOR i=0,N_ELEMENTS(bigStreaks_i)-1 DO BEGIN
     PRINT,FORMAT='(I0,T5,F0.2,T20,A0,T45,A0)',i,bigStreaks[i], $
           TIME_TO_STR(mag_UTC[good_i[start_ii[bigStreaks_i[i]]]]), $
           TIME_TO_STR(mag_UTC[good_i[stop_ii[bigStreaks_i[i]]]])
  ENDFOR

  PRINT,'YO'
END