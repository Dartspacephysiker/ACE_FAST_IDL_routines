;2016/03/21 Can you show me what it's all about?
PRO JOURNAL__20160321__SCATTERPLOTS_FOR_SEVERAL_DELAYS__DAWNDUSK

  nonstorm                       = 0

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;ILAT stuff
  hemi                           = 'NORTH'
  minILAT                        = 61
  maxILAT                        = 85
  binILAT                        = 3.0

  ;; hemi                           = 'SOUTH'
  ;; minILAT                        = -85
  ;; maxILAT                        = -61
  ;; binILAT                        = 3.0

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;MLT stuff
  ;; binMLT                         = 0.5
  ;; shiftMLT                       = 0.25

  minMLT                         = 6.0
  maxMLT                         = 18.0
  binMLT                         = 1.0
  shiftMLT                       = 0.5

  ;;IMF condition stuff
  ;; stableIMF                      = 20
  byMin                          = 3
  do_abs_bymin                   = 1
  bzMin                          = 0
  ;; bzMax                          = 0

  ;;DB stuff
  do_despun                      = 1

  ;;Delay stuff
  delayArr                       = [-1500, -1440, -1380, -1320, -1260, $
                                    -1200, -1140, -1080, -1020,  -960, $
                                     -900,  -840,  -780,  -720,  -660, $
                                     -600,  -540,  -480,  -420,  -360, $
                                     -300,  -240,  -180,  -120,  -60,  $
                                        0,    60,   120,   180,   240, $
                                      300,   360,   420,   480,   540, $
                                      600,   660,   720,   780,   840, $
                                      900,   960,  1020,  1080,  1140, $
                                     1200,  1260,  1320,  1380,  1440, $
                                     1500]

  ;; charERange                     = [4,300]
  ;; charERange                     = [300,4000]

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Plot stuff

  plot_i_list                    = GET_RESTRICTED_AND_INTERPED_DB_INDICES(maximus,satellite,delayArr,LUN=lun, $
                                                                          DBTIMES=cdbTime,dbfile=dbfile, $
                                                                          DO_DESPUNDB=do_despun, $
                                                                          HEMI=hemi, $
                                                                          ORBRANGE=orbRange, $
                                                                          ALTITUDERANGE=altitudeRange, $
                                                                          CHARERANGE=charERange, $
                                                                          POYNTRANGE=poyntRange, $
                                                                          MINMLT=minMLT,MAXMLT=maxMLT, $
                                                                          BINM=binMLT, $
                                                                          SHIFTM=shiftMLT, $
                                                                          MINILAT=minILAT, $
                                                                          MAXILAT=maxILAT, $
                                                                          BINI=binILAT, $
                                                                          DO_LSHELL=do_lshell, $
                                                                          MINLSHELL=minL,MAXLSHELL=maxL,BINL=binL, $
                                                                          SMOOTHWINDOW=smoothWindow, $
                                                                          BYMIN=byMin,BZMIN=bzMin, $
                                                                          BYMAX=byMax,BZMAX=bzMax, $
                                                                          DO_ABS_BYMIN=do_abs_byMin, $
                                                                          DO_ABS_BYMAX=do_abs_byMax, $
                                                                          DO_ABS_BZMIN=do_abs_bzMin, $
                                                                          DO_ABS_BZMAX=do_abs_bzMax, $
                                                                          CLOCKSTR=clockStr, $
                                                                          RESTRICT_WITH_THESE_I=restrict_with_these_i, $
                                                                          BX_OVER_BYBZ=Bx_over_ByBz_Lim, $
                                                                          /MULTIPLE_DELAYS, $
                                                                          STABLEIMF=stableIMF, $
                                                                          DO_NOT_CONSIDER_IMF=do_not_consider_IMF, $
                                                                          OMNI_COORDS=omni_Coords, $
                                                                          ANGLELIM1=angleLim1, $
                                                                          ANGLELIM2=angleLim2, $
                                                                          HWMAUROVAL=HwMAurOval, $
                                                                          HWMKPIND=HwMKpInd, $
                                                                          NO_BURSTDATA=no_burstData)

  STOP

END
