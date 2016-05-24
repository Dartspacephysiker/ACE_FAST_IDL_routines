PRO plot_IMF_data,XRANGE=xrange,YRANGE=yrange,TIMES=times,PLOTSYM=plotSym,LINESTY=lineSty

  ;;which db file?
  dbdir="/SPENCEdata/Research/database/processed/"
  dbfile=dbdir+"culled_wind_ACE_magdata.dat"
  restore,dbfile

  ;;which indices to look at?
  IF NOT KEYWORD_SET(xrange) THEN BEGIN
     xrange=[0,100]
  ENDIF

  IF NOT KEYWORD_SET(yrange) THEN BEGIN
     yrange=[-10,10]
  ENDIF

  ;;smoothed data
  bxSmooth=bx[xrange[0]:xrange[1]]
  bySmooth=by[xrange[0]:xrange[1]]
  bzSmooth=bz[xrange[0]:xrange[1]]

  ;;options
  col_dat="black"
  col_smooth="red"

  col_bx='red'
  col_by='green'
  col_bz='blue'

  ;;plot symbol, plot linestyle
  IF N_ELEMENTS(plotSYM) NE 0 THEN BEGIN
     IF plotSym EQ 1 THEN plotSym=-15
  ENDIF
  IF N_ELEMENTS(lineSty) NE 0 THEN BEGIN
     IF lineSty EQ 1 THEN lineSty=0
  ENDIF ELSE lineSty=0

  ;;plot Bx,By,Bz on same plot
  ;; cgPlot, mag_prop.bx_gse[xrange[0]:xrange[1]], PSym=plotSym, Color=col_bx, YRange=yrange, $
  ;;         LineStyle=lineSty, YStyle=1, /Window
  ;; cgPlot, mag_prop.by_gse[xrange[0]:xrange[1]], PSym=plotSym, Color=col_by, YRange=yrange, $
  ;;         LineStyle=lineSty, YStyle=1, /AddCmd
  ;; cgPlot, mag_prop.bz_gse[xrange[0]:xrange[1]], PSym=plotSym, Color=col_bz, YRange=yrange, $
  ;;         LineStyle=lineSty, YStyle=1, /AddCmd

  ;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;first, unsmoothed data;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;
  cgPlot, xrange[0] + indgen(xrange[1]-xrange[0]), bx[xrange[0]:xrange[1]], XRange=xrange, YRange=yrange, $
          xtitle='Index value', ytitle='Field strength (nT)', title="IMF data", $
          PSym=plotSym, Color=col_bx, $
          LineStyle=lineSty, YStyle=1, /window
  cgPlot, xrange[0] + indgen(xrange[1]-xrange[0]), by[xrange[0]:xrange[1]], XRange=xrange, YRange=yrange, $
          PSym=plotSym, Color=col_by, $
          LineStyle=lineSty, YStyle=1, /overplot, /addcmd
  cgPlot, xrange[0] + indgen(xrange[1]-xrange[0]), bz[xrange[0]:xrange[1]], XRange=xrange, YRange=yrange, $
          PSym=plotSym, Color=col_bz, $
          LineStyle=lineSty, YStyle=1, /overplot, /addcmd

  ;;now some sort of running average
;;  cgPlot, cgDemoData(17), PSym=-16, Color=col_smooth, /Overplot, $
;;          LineStyle=2, /AddCmd

  ;;Now some legend
  IF N_ELEMENTS(plotSYM) NE 0 THEN $
     CGLEGEND, Title=['Bx', 'By', 'Bz'], PSym=[plotSym,plotSym, plotSym], $
               LineStyle=[lineSty,lineSty,lineSty], Color=[col_bx,col_by,col_bz], Location=[0.2,0.85], $
               Length=0.0, VSpace=2.0, /Box, /Background, BG_Color='rose', /addcmd $
  ELSE CGLEGEND, Title=['Bx', 'By', 'Bz'], $
               LineStyle=[lineSty,lineSty,lineSty], Color=[col_bx,col_by,col_bz], Location=[0.2,0.85], $
               Length=0.0, VSpace=2.0, /Box, /Background, BG_Color='rose', /addcmd 
  

  ;; CGLEGEND, Title=['IMF data', 'Smooth IMF data'], PSym=[-15,-16], $
  ;;           LineStyle=[0,2], Color=['red','dodger blue'], Location=[0.2,0.85], $
  ;;           Length=0.0, VSpace=2.0, /Box, /Background, BG_Color='rose'
  
  ;;Now add time range to plot
  ;; beginTime=strcompress(str(mag_prop.year[xrange[0]]) + '-' + $
  ;;                       string(format='(I02)',mag_prop.month[xrange[0]])+'-'+ $
  ;;                       string(format='(I02)',mag_prop.day[xrange[0]])+'-'+ $
  ;;                       string(format='(I02)',mag_prop.hour[xrange[0]])+':' + $
  ;;                       string(format='(I02)',mag_prop.minute[xrange[0]]), $
  ;;                       /remove_all)

  ;; endTime=strcompress(str(mag_prop.year[xrange[1]]) + '-' + $
  ;;                       string(format='(I02)',mag_prop.month[xrange[1]])+'-'+ $
  ;;                       string(format='(I02)',mag_prop.day[xrange[1]])+'-'+ $
  ;;                       string(format='(I02)',mag_prop.hour[xrange[1]])+':' + $
  ;;                       string(format='(I02)',mag_prop.minute[xrange[1]]), $
  ;;                       /remove_all)

  beginTime=time_to_str(mag_utc[xrange[0]])
  endTime=time_to_str(mag_utc[xrange[1]])

  cgText, 0.5, 0.96,  beginTime + '  -- ' + endTime, ALIGNMENT=0.5, /NORMAL, /ADDCMD
  ;; cgText, 0.15, 0.1,  beginTime, ALIGNMENT=0.5, /NORMAL, /ADDCMD
  ;; cgText, 0.85, 0.1, endTime, ALIGNMENT=0.5, /NORMAL, /ADDCMD

END