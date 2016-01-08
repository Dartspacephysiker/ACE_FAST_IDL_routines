;2015/10/24
PRO PLOT_SW_OR_GEOMAGQUANTITY_TRACE__EPOCH,geomagEpochSeconds,geomagEpochDat,NAME=name,AXIS_STYLE=axis_Style, $
   ;; ALF_T=alf_t,ALF_Y=alf_y, $
   PLOTTITLE=plotTitle, $
   XTITLE=xTitle,XRANGE=xRange, $
   YTITLE=yTitle,YRANGE=yRange,LOGYPLOT=logYPlot, YMINOR=yMinorTicks, $
   LINETHICK=lineThick,LINETRANSP=lineTransp, $
   OVERPLOT=overPlot, $
   CURRENT=current, $
   MARGIN=margin, $
   LAYOUT=layout, $
   CLIP=clip, $
   OUTPLOT=outPlot,ADD_PLOT_TO_PLOT_ARRAY=add_plot_to_plot_array
  
  @utcplot_defaults.pro

  plot=plot(geomagEpochSeconds/3600.,geomagEpochDat, $
            NAME=name, $
            AXIS_STYLE=axis_style, $
            TITLE=plotTitle, $
            XTITLE=xTitle, $
            YTITLE=yTitle, $
            XRANGE=KEYWORD_SET(xRange) ? xRange : [MIN(geomagEpochSeconds),MAX(geomagEpochSeconds)], $
            YRANGE=KEYWORD_SET(yRange) ? yRange : [MIN(geomagEpochDat),MAX(geomagEpochDat)], $
            YLOG=KEYWORD_SET(logYPlot) ? 1 : 0, $
            ;; YMINOR=yMinorTicks, $
            ;; YTICKNAME=['-100','-75','-50','-25','0','25'], $
            ;; YTICKVALUES=[-100,-75,-50,-25,0,25], $
            YMINOR=4, $
            YTICKNAME=['-100','-50','0'], $
            YTICKVALUES=[-100,-50,0], $
            FONT_SIZE=title_font_size, $
            XTICKFONT_SIZE=max_xtickfont_size, $
            XTICKFONT_STYLE=max_xtickfont_style, $
            YTICKFONT_SIZE=max_ytickfont_size, $
            YTICKFONT_STYLE=max_ytickfont_style, $
            OVERPLOT=overplot, $
            CURRENT=current, $
            MARGIN=margin, $
            LAYOUT=layout, $
            CLIP=clip, $
            TRANSPARENCY=N_ELEMENTS(lineTransp) GT 0 ? lineTransp : defLineTransp, $
            THICK=KEYWORD_SET(lineThick) ? lineThick : defLineThick) 

  IF KEYWORD_SET(add_plot_to_plot_array) THEN BEGIN
     IF N_ELEMENTS(outPlot) GT 0 THEN outPlot=[outPlot,plot] ELSE outPlot = plot
  ENDIF ELSE BEGIN
     outPlot = plot
  ENDELSE

END