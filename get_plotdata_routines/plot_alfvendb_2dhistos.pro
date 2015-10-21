PRO PLOT_ALFVENDB_2DHISTOS,H2DSTRARR=h2dStrArr,DATANAMEARR=dataName,TEMPFILE=tempFile, $
                           SQUAREPLOT=squarePlot, POLARCONTOUR=polarContour, $ 
                           JUSTDATA=justData, SHOWPLOTSNOSAVE=showPlotsNoSave, $
                           PLOTDIR=plotDir, PLOTMEDORAVG=plotMedOrAvg, $
                           PARAMSTR=paramStr, DEL_PS=del_PS, $
                           HEMI=hemi, $
                           CLOCKSTR=clockStr, _EXTRA = e


  ;;if not saving plots and plots not turned off, do some stuff  ;; otherwise, make output
  IF KEYWORD_SET(showPlotsNoSave) THEN BEGIN 
     IF N_ELEMENTS(justData) EQ 0 AND KEYWORD_SET(squarePlot) THEN $
        cgWindow, 'interp_contplotmulti_str', h2dStrArr,$
                  Background='White', $
                  WTitle='Flux plots for '+hemi+'ern Hemisphere, ' + $
                  (KEYWORD_SET(clockStr) ? clockStr+' IMF, ' : '') + strmid(plotMedOrAvg,1) $
     ELSE IF N_ELEMENTS(justData) EQ 0 THEN $
        FOR i = 0, N_ELEMENTS(h2dStrArr) - 2 DO $ 
           cgWindow,'interp_polar2dhist',h2dStrArr[i],tempFile, $
                _extra=e,$
                Background="White",wxsize=800,wysize=600, $
                WTitle='Polar plot_'+dataNameArr[i]+','+hemi+'ern Hemisphere, ' + $
                    (KEYWORD_SET(clockStr) ? clockStr+' IMF, ' : '') + strmid(plotMedOrAvg,1) $
                
     ELSE PRINTF,LUN,"**Plots turned off with justData**" 
  ENDIF ELSE BEGIN 
     IF KEYWORD_SET(squarePlot) AND NOT KEYWORD_SET(justData) THEN BEGIN 
        CD, CURRENT=c ;; & PRINTF,LUN, "Current directory is " + c + "/" + plotDir 
        PRINTF,LUN, "Creating output files..." 

        ;;Create a PostScript file.
        cgPS_Open, plotDir + 'fluxplots_'+paramStr+'.ps', /nomatch, xsize=1000, ysize=1000
        interp_contplotmulti_str,h2dStrArr 
        cgPS_Close 

        ;;Create a PNG file with a width of 800 pixels.
        cgPS2Raster, plotDir + 'fluxplots_'+paramStr+'.ps', $
                     /PNG, Width=800, DELETE_PS = del_PS
     
     ENDIF ELSE BEGIN
        IF N_ELEMENTS(justData) EQ 0 THEN BEGIN 
           CD, CURRENT=c & PRINTF,LUN, "Current directory is " + c + "/" + plotDir 
           PRINTF,LUN, "Creating output files..." 
           
           FOR i = 0, N_ELEMENTS(h2dStrArr) - 2 DO BEGIN  
              
              IF KEYWORD_SET(polarContour) THEN BEGIN
                 ;; The NAME field of the !D system variable contains the name of the
                 ;; current plotting device.
                 mydevice = !D.NAME
                 ;; Set plotting to PostScript:
                 SET_PLOT, 'PS'
                 ;; Use DEVICE to set some PostScript device options:
                 DEVICE, FILENAME='myfile.ps', /LANDSCAPE
                 ;; Make a simple plot to the PostScript file:
                 interp_polar2dcontour,h2dStrArr[i],dataNameArr[i],tempFile, $
                                       fname=plotDir + dataNameArr[i]+paramStr+'.png', _extra=e
                 ;; Close the PostScript file:
                 DEVICE, /CLOSE
                 ;; Return plotting to the original device:
                 SET_PLOT, mydevice
              ENDIF ELSE BEGIN
                 ;;Create a PostScript file.
                 cgPS_Open, plotDir + dataNameArr[i]+paramStr+'.ps' 
                 interp_polar2dhist,h2dStrArr[i],tempFile,_extra=e 
                 cgPS_Close 
                 ;;Create a PNG file with a width of 800 pixels.
                 cgPS2Raster, plotDir + dataNameArr[i]+paramStr+'.ps', $
                              /PNG, Width=800, DELETE_PS = del_PS
              ENDELSE
              
           ENDFOR    
        
        ENDIF
     ENDELSE
  ENDELSE

END