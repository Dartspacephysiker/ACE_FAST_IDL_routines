;2015/10/24
PRO PLOT_SW_OR_GEOMAGQUANTITY_TRACE__EPOCH,geomagEpochSeconds,geomagEpochDat,NAME=name,AXIS_STYLE=axis_Style, $
   ;; ALF_T=alf_t,ALF_Y=alf_y, $
   PLOTTITLE=plotTitle, $
   XTITLE=xTitle,XRANGE=xRange, $
   YTITLE=yTitle,YRANGE=yRange,LOGYPLOT=logYPlot, YMINOR=yMinorTicks, $
   YTICKNAME=yTickName, $
   YTICKVALUES=yTickValues, $
   LINETHICK=lineThick,LINETRANSP=lineTransp, $
   OVERPLOT=overPlot, $
   CURRENT=current, $
   MARGIN=margin, $
   LAYOUT=layout, $
   POSITION=position, $
   CLIP=clip, $
   OUTPLOT=outPlot, $
   ADD_PLOT_TO_PLOT_ARRAY=add_plot_to_plot_array, $
   YEAR_AND_SEASON_MODE=year_and_season_mode

  
  @utcplot_defaults.pro

  IF KEYWORD_SET(plotTitle) THEN title = plotTitle ELSE title = ''
  IF KEYWORD_SET(xTitle) THEN xTit = xTitle ELSE xTit = ''
  IF KEYWORD_SET(yTitle) THEN yTit = yTitle ELSE yTit = ''
  xR                               = KEYWORD_SET(xRange) ? xRange : [MIN(geomagEpochSeconds),MAX(geomagEpochSeconds)]
  yR                               = KEYWORD_SET(yRange) ? yRange : [MIN(geomagEpochSeconds),MAX(geomagEpochSeconds)]
  yLog                             = KEYWORD_SET(logYPlot) ? 1 : 0

  IF KEYWORD_SET(year_and_season_mode) THEN BEGIN
     SETUP_YEAR_AND_SEASON_SEA_PLOT, $
        PLOTTITLE=title, $
        XMINOR=xMinor, $
        XRANGE=xR, $
        XSTYLE=xStyle, $
        XTICKVALUES=xTickValues,$
        XTICKNAME=xTickName, $
        XTITLE=xTit, $
        YTITLE=yTit
  ENDIF

  plot     = PLOT(geomagEpochSeconds/3600.,geomagEpochDat, $
                  NAME=name, $
                  AXIS_STYLE=axis_style, $
                  TITLE=title, $
                  XTITLE=xTit, $
                  YTITLE=yTit, $
                  XRANGE=xR, $
                  YRANGE=yR, $
                  YLOG=yLog, $
                  YMINOR=yMinorTicks, $
                  XMINOR=xMinor, $
                  XTICKNAME=xTickName, $
                  XTICKVALUES=xTickValues, $
                  XSTYLE=xStyle, $
                  YTICKNAME=yTickName, $
                  YTICKVALUES=yTickValues, $
                  FONT_SIZE=title_font_size, $
                  XTICKFONT_SIZE=max_xtickfont_size, $
                  XTICKFONT_STYLE=max_xtickfont_style, $
                  YTICKFONT_SIZE=max_ytickfont_size, $
                  YTICKFONT_STYLE=max_ytickfont_style, $
                  OVERPLOT=overplot, $
                  CURRENT=current, $
                  MARGIN=margin, $
                  LAYOUT=layout, $
                  POSITION=position, $
                  CLIP=clip, $
                  TRANSPARENCY=N_ELEMENTS(lineTransp) GT 0 ? lineTransp : defLineTransp, $
                  THICK=KEYWORD_SET(lineThick) ? lineThick : defLineThick) 

  IF KEYWORD_SET(add_plot_to_plot_array) THEN BEGIN
     IF N_ELEMENTS(outPlot) GT 0 THEN outPlot=[outPlot,plot] ELSE outPlot = plot
  ENDIF ELSE BEGIN
     outPlot = plot
  ENDELSE

END