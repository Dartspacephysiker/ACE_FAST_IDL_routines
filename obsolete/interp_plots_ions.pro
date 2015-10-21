;########Ion flux########

;h2dIonFluxStr={h2dStr}
;
;IF medPlot GT 0 THEN BEGIN & $
;   h2dIonFluxstr.data=median_hist(maximus.mlt(plot_i),maximus.ILAT(plot_i),$
;                            maximus.ion_flux_up(plot_i),$
;                            MIN1=MINMLT,MIN2=MINILAT,$
;                            MAX1=MAXMLT,MAX2=MAXILAT,$
;                            BINSIZE1=binMLT,BINSIZE2=binILAT,$
;                            ABSMED=absIonFlux) & $
;ENDIF ELSE BEGIN & $
;   h2dIonFluxStr.data=hist2d(maximus.mlt(plot_i),$
;                             maximus.ilat(plot_i),$
;                             maximus.ion_flux_up(plot_i),$
;                             MIN1=MINMLT,MIN2=MINILAT,$
;                             MAX1=MAXMLT,MAX2=MAXILAT,$
;                             BINSIZE1=binMLT,BINSIZE2=binILAT,$
;                             OBIN1=h2d_ef_bins1,OBIN2=h2d_ef_bins2) & $
;   h2dIonFluxStr.data(where(h2dFluxN NE 0))=h2dIonFluxStr.data(where(h2dFluxN NE 0))/h2dFluxN(where(h2dFluxN NE 0)) & $
;ENDELSE 
;
;;Log plots desired?
;logIonFluxstr=""
;absIonFluxstr=""
;IF absIonFlux EQ 1 THEN BEGIN & $
;   h2dIonFluxStr.data = ABS(h2dIonFluxStr.data) & $
;   absIonFluxstr= "ABS" & $
;ENDIF
;
;IF logIonFluxPlot EQ 1 THEN BEGIN & $
;   logIonFluxstr="Log " & $
;   h2dIonFluxStr.data(where(h2dIonFluxStr.data GT 0))=ALOG10(h2dIonFluxStr.data(where(h2dIonFluxStr.data GT 0))) & $
;ENDIF
;abslogIonFluxStr=absIonFluxStr + logIonFluxStr
;
;h2dIonFluxStr.title= abslogIonFluxstr + "Ion Flux(up)"
;
;;Do custom range for ion flux plots, if requested
;IF customIonRange NE !NULL THEN h2dIonFluxStr.lim=TEMPORARY(customIonRange)$
;   ELSE h2dIonFluxStr.lim = [MIN(h2dIonFluxStr.data),MAX(h2dIonFluxStr.data)]
;
;h2dStr=[h2dStr,TEMPORARY(h2dIonFluxStr)]
;delvar,h2dIonFluxStr

;########Oxygen flux########

;h2dOFluxStr={h2dStr}
;
;IF medPlot GT 0 THEN BEGIN & $
;   h2dIonFluxstr.data=median_hist(maximus.mlt(plot_i),maximus.ILAT(plot_i),$
;                            maximus.oxy_flux_up(plot_i),$
;                            MIN1=MINMLT,MIN2=MINILAT,$
;                            MAX1=MAXMLT,MAX2=MAXILAT,$
;                            BINSIZE1=binMLT,BINSIZE2=binILAT,$
;                            ABSMED=absOFlux) & $
;ENDIF ELSE BEGIN & $
;   h2dOFluxStr.data=hist2d(maximus.mlt(plot_i),$
;                           maximus.ilat(plot_i),$
;                           maximus.oxy_flux_up(plot_i),$
;                           MIN1=MINMLT,MIN2=MINILAT,$
;                           MAX1=MAXMLT,MAX2=MAXILAT,$
;                           BINSIZE1=binMLT,BINSIZE2=binILAT,$
;                           OBIN1=h2d_ef_bins1,OBIN2=h2d_ef_bins2) & $
;
;   h2dOFluxStr.data(where(h2dNStr[1].data NE 0))=h2dOFluxStr.data(where(h2dNStr[1].data NE 0))/h2dNStr[1].data(where(h2dNStr[1].data NE 0)) & $
;ENDELSE 
;
;;Log plots desired?
;logOFluxstr=""
;absOFluxstr=""
;IF absOFlux EQ 1 THEN BEGIN & $
;   h2dOFluxStr.data = ABS(h2dOFluxStr.data) & $
;   absOFluxstr= "ABS" & $
;ENDIF
;
;IF logOFluxPlot EQ 1 THEN BEGIN & $
;   logOFluxstr="Log " & $
;   h2dOFluxStr.data(where(h2dOFluxStr.data GT 0))=ALOG10(h2dOFluxStr.data(where(h2dOFluxStr.data GT 0))) & $
;ENDIF
;
;abslogOFluxStr=absOFluxStr + logOFluxStr
;h2dOFluxStr.title= abslogOFluxstr + "Oxygen Flux(up)"
;
;;Do custom range for Oflux plots, if requested
;IF customORange NE !NULL THEN h2dOFluxStr.lim=TEMPORARY(customORange)$
;   ELSE h2dOFluxStr.lim = [MIN(h2dOFluxStr.data),MAX(h2dOFluxStr.data)]
;
;h2dStr=[h2dStr,TEMPORARY(h2dOFluxStr)]
;delvar,h2dOFluxStr

print,"IONS N STUFFFF"
