PRO JOURNAL__20161105__JUNK_TEST_BZ_RELATIONSHIP

  COMPILE_OPT idl2

  runNum = 2

  use_Kan_Lee    = 1

  ;;First run, delta_Bz = 2.5
  CASE runNum OF
     1: BEGIN
        Bz_vals  = [8.624,6.042,3.670,1.593,-1.598,-3.756,-6.024,-8.540]
        BzStd    = 2*[0.711,0.699,0.704,0.596,0.590,0.708,0.694,0.709]
        NHIntegs = [1.01,.564,0.446,0.605,1.16,1.42,2.93,3.99]
        integErr = MAKE_ARRAY(N_ELEMENTS(Bz_vals),VALUE=0,/FLOAT)
     END
     2: BEGIN
        ;;Second run, delta_Bz = 2.0,500 km to 4180 km
        Bz_vals  = [8.909,6.867,4.899,3.006,1.297,-1.314,-3.048,-4.898,-6.822,-8.870]
        BzStd    = 2*[0.578,0.575,0.574,0.573,0.468,0.469,0.575,0.572,0.564,0.570]
        NHIntegs = [1.14,0.669,0.486,0.482,0.582,0.993,1.23,1.83,3.26,6.06]
        integErr = MAKE_ARRAY(N_ELEMENTS(Bz_vals),VALUE=0,/FLOAT)

        KL_vals  = [0.000,0.000,0.000,0.000,0.000,0.543,1.301,2.130,3.015,3.831]
        KLStd    = [0.230,0.339,0.062,0.050,0.034,0.222,0.371,0.508,0.675,0.890]
     END
  ENDCASE

  posBz           = WHERE(Bz_vals GT 0,COMPLEMENT=negBz)
  ;;The linear fit
  negParams       = LINFIT(Bz_vals[negBz],NHIntegs[negBz],YFIT=negFit)
  negCorr         = LINCORR(Bz_vals[negBz],NHIntegs[negBz],T_STAT=neg_t_stat)

  xTitle          = 'Southward B!Dz!N (nT)'
  yTitle          = 'Integrated ' + ANSI_VALUE('Alfvénic') + 'Power (GW)' 

  fontSize        = 18

  IF KEYWORD_SET(use_Kan_Lee) THEN BEGIN
     xTitle       = 'v B!DT!Nsin!U2!N(!4g!X/2)'
     Bz_vals      = KL_vals
     BzStd        = KLStd

     negBz        = WHERE(Bz_vals GT 0,COMPLEMENT=posBz)
     ;;The linear fit
     negParams    = LINFIT(Bz_vals[negBz],NHIntegs[negBz],YFIT=negFit)
     negCorr      = LINCORR(Bz_vals[negBz],NHIntegs[negBz],T_STAT=neg_t_stat)

  ENDIF

  sym             = ['D','tu']
  sym_thick       = 2.0
  thick           = 1.0
  transp          = 40
  ;; lineStyle       = ['--','-:']
  lineStyle       = ['-','-']

  eb_cs           = 0.2
  eb_lineStyle    = ['--','-:']

  window          = WINDOW(DIMENSIONS=[800,600])

  xRange          = KEYWORD_SET(use_Kan_Lee) ? MINMAX(Bz_vals) : [-10,10]
  ;; yRange          = [0,(MINMAX(NHIntegs))[1]]
  yRange          = runNum EQ 2 ? [0,6.7] : [0,4.2]

  plot            = ERRORPLOT(Bz_vals[posBz], $
                              NHIntegs[posBz], $
                              BzStd[posBz], $
                              integErr[posBz], $
                              TITLE=title, $
                              XTITLE=xTitle, $
                              YTITLE=yTitle, $
                              XRANGE=xRange, $
                              YRANGE=yRange, $
                              SYMBOL='Tu', $
                              ERRORBAR_CAPSIZE=eb_cs, $
                              ERRORBAR_LINESTYLE=eb_lineStyle[0], $
                              SYM_THICK=sym_thick, $
                              THICK=thick, $
                              TRANSPARENCY=transp, $
                              LINESTYLE=KEYWORD_SET(use_Kan_Lee) ? 0 : lineStyle[0], $
                              NAME='NH', $
                              COLOR='Red', $
                              FONT_SIZE=fontSize, $
                              CURRENT=window)


  plot            = ERRORPLOT(Bz_vals[negBz], $
                              NHIntegs[negBz], $
                              BzStd[negBz], $
                              integErr[negBz], $
                              TITLE=title, $
                              XTITLE=xTitle, $
                              YTITLE=yTitle, $
                              XRANGE=xRange, $
                              YRANGE=yRange, $
                              SYMBOL='Tu', $
                              ERRORBAR_CAPSIZE=eb_cs, $
                              ERRORBAR_LINESTYLE=eb_lineStyle[0], $
                              SYM_THICK=sym_thick, $
                              THICK=thick, $
                              TRANSPARENCY=transp, $
                              LINESTYLE=KEYWORD_SET(use_Kan_Lee) ? ' ' : lineStyle[0], $
                              ;; LINESTYLE=lineStyle[0], $
                              NAME='NH', $
                              COLOR='Blue', $
                              FONT_SIZE=fontSize, $
                              /OVERPLOT, $
                              CURRENT=window)

  plot2            = PLOT(Bz_vals[negBz], $
                          negFit, $
                          ;; TITLE=title, $
                          ;; XTITLE=xTitle, $
                          ;; YTITLE=yTitle, $
                          ;; XRANGE=[-10,10], $
                          ;; YRANGE=yRange, $
                          ;; SYMBOL='Tu', $
                          ;; SYM_THICK=sym_thick, $
                          ;; THICK=thick, $
                          ;; TRANSPARENCY=transp, $
                          LINESTYLE=KEYWORD_SET(use_Kan_Lee) ? 0 : lineStyle[0], $
                          ;; LINESTYLE=lineStyle[0], $
                          NAME='NH', $
                          COLOR='BLUE', $
                          FONT_SIZE=fontSize, $
                          /OVERPLOT, $
                          CURRENT=window)

  slopeString  = STRING(FORMAT='(A-10,T15,F7.3)',"slope  =",negParams[1])
  corrString   = STRING(FORMAT='(A-10,T15,F7.3)',"r      =",negCorr[0])
  tString      = STRING(FORMAT='(A-10,T15,F7.3)',"t-test =",neg_t_stat)

  slopeText    = TEXT(0.2,0.80, $
                      slopeString, $
                      /NORMAL, $
                      FONT_NAME='Courier', $
                      FONT_SIZE=18, $
                      TARGET=plot)
  corrText     = TEXT(0.2,0.75, $
                      corrString, $
                      /NORMAL, $
                      FONT_NAME='Courier', $
                      FONT_SIZE=18, $
                      TARGET=plot)
  tText        = TEXT(0.2,0.70, $
                      tString, $
                      /NORMAL, $
                      FONT_NAME='Courier', $
                      FONT_SIZE=18, $
                      TARGET=plot)


END