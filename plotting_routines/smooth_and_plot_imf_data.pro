PRO smooth_and_plot_IMF_data,XRANGE=xrange,YRANGE=yrange,TIMES=times,PLOTSYM=plotSym,LINESTY=lineSty,SMOOTHWINDOW=smoothWindow

  ;;which db file?
  dbdir="/SPENCEdata/Research/Cusp/database/processed/"
  dbfile=dbdir+"culled_wind_ACE_magdata.dat"
  restore,dbfile

  ;;which indices to look at?
  IF NOT KEYWORD_SET(xrange) THEN BEGIN
     xrange=[0,99]
  ENDIF

  IF NOT KEYWORD_SET(yrange) THEN BEGIN
     yrange=[-10,10]
  ENDIF

  ;;size of smoothing window?
  IF NOT KEYWORD_SET(smoothWindow) THEN smoothWindow = 5 ;default smoothing of 5 minutes
  print,"Smooth window is set to " + strcompress(smoothWindow,/remove_all) + " minutes"

  ;;smoothed data
  bxSmooth=smooth(bx[xrange[0]:xrange[1]],smoothWindow)
  bySmooth=smooth(by[xrange[0]:xrange[1]],smoothWindow)
  bzSmooth=smooth(bz[xrange[0]:xrange[1]],smoothWindow)

  ;;times
  beginTime=time_to_str(mag_utc[xrange[0]])
  endTime=time_to_str(mag_utc[xrange[1]])
  print, "IMF data start: " + strcompress(beginTime,/remove_all)
  print, "IMF data stop:  " + strcompress(endTime,/remove_all)
  print, "Displaying " + strcompress((mag_utc[xrange[1]]-mag_utc[xrange[0]]+60)/60,/remove_all) + " minutes of data"
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

  ;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;first, unsmoothed data;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;
  cgPlot, xrange[0] + indgen(xrange[1]-xrange[0]), bx[xrange[0]:xrange[1]], XRange=xrange, YRange=yrange, $
          xtitle='Index value', ytitle='Field strength (nT)', title="IMF data", $
          PSym=plotSym, Color=col_bx, $
          LineStyle=lineSty, YStyle=1, /window, layout=[2,1,1]
  cgPlot, xrange[0] + indgen(xrange[1]-xrange[0]), by[xrange[0]:xrange[1]], XRange=xrange, YRange=yrange, $
          PSym=plotSym, Color=col_by, $
          LineStyle=lineSty, YStyle=1, /overplot, /addcmd, layout=[2,1,1]
  cgPlot, xrange[0] + indgen(xrange[1]-xrange[0]), bz[xrange[0]:xrange[1]], XRange=xrange, YRange=yrange, $
          PSym=plotSym, Color=col_bz, $
          LineStyle=lineSty, YStyle=1, /overplot, /addcmd, layout=[2,1,1]

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

  ;;;;;;;;;;;;;;;;;;;;;
  ;;Now smoothed data;;
  ;;;;;;;;;;;;;;;;;;;;;
  cgPlot, xrange[0] + indgen(xrange[1]-xrange[0]), bxSmooth, XRange=xrange, YRange=yrange, $
          xtitle='Index value', title="Smoothed IMF data", $
          PSym=plotSym, Color=col_bx, $
          LineStyle=lineSty, YStyle=1, layout=[2,1,2], /addcmd
  cgPlot, xrange[0] + indgen(xrange[1]-xrange[0]), bySmooth, XRange=xrange, YRange=yrange, $
          PSym=plotSym, Color=col_by, $
          LineStyle=lineSty, YStyle=1, /overplot, /addcmd, layout=[2,1,2]
  cgPlot, xrange[0] + indgen(xrange[1]-xrange[0]), bzSmooth, XRange=xrange, YRange=yrange, $
          PSym=plotSym, Color=col_bz, $
          LineStyle=lineSty, YStyle=1, /overplot, /addcmd, layout=[2,1,2]

  ;;Now some legend
  IF N_ELEMENTS(plotSYM) NE 0 THEN $
     CGLEGEND, Title=['Bx', 'By', 'Bz'], PSym=[plotSym,plotSym, plotSym], $
               LineStyle=[lineSty,lineSty,lineSty], Color=[col_bx,col_by,col_bz], Location=[0.5,0.85], $
               Length=0.0, VSpace=2.0, /Box, /Background, BG_Color='rose', /addcmd $
  ELSE CGLEGEND, Title=['Bx', 'By', 'Bz'], $
               LineStyle=[lineSty,lineSty,lineSty], Color=[col_bx,col_by,col_bz], Location=[0.5,0.85], $
               Length=0.0, VSpace=2.0, /Box, /Background, BG_Color='rose', /addcmd 
  
   cgText, 0.5, 0.97,  beginTime + '  -- ' + endTime, ALIGNMENT=0.5, /NORMAL, /ADDCMD

END