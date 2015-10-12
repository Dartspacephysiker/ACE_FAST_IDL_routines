PRO GET_TOTAL_ORBITS_PLOTDATA,maximus,plot_i,MINM=minM,MAXM=maxM,BINM=binM,MINI=minI,MAXI=maxI,BINI=binI, $
                              ORBTOTRANGE=orbTotRange, $
                              H2DSTR=h2dStr,TMPLT_H2DSTR=tmplt_h2dStr,H2DFLUXN=h2dFluxN,H2DTOTORBSTR=h2dTotOrbStr, $
                              DATANAMEARR=dataNameArr,DATARAWPTRARR=dataRawPtrArr,KEEPME=keepme, $
                              NPLOTS=nPlots,ORBTOTPLOT=orbTotPlot,UNIQUEORBS_II=uniqueOrbs_ii

  IF N_ELEMENTS(uniqueOrbs_ii) EQ 0 THEN uniqueOrbs_ii=UNIQ(maximus.orbit,SORT(maximus.orbit))

  h2dTotOrbStr={tmplt_h2dStr}
  orbArr=INTARR(N_ELEMENTS(uniqueorbs_ii),N_ELEMENTS(h2dFluxN[*,0]),N_ELEMENTS(h2dFluxN[0,*]))
  h2dOrbN=INTARR(N_ELEMENTS(h2dStr[0].data[*,0]),N_ELEMENTS(h2dStr[0].data[0,*]))
  
  
  ;;FOR j=0, N_ELEMENTS(uniqueorbs_ii)-1 DO BEGIN 
  ;;   tempOrb=maximus.orbit(ind_region_magc_geabs10_acestart(uniqueOrbs_ii(j))) 
  ;;   temp_ii=WHERE(maximus.orbit(ind_region_magc_geabs10_acestart) EQ tempOrb) 
  ;;   h2dOrbTemp=hist_2d(maximus.mlt(ind_region_magc_geabs10_acestart(temp_ii)),$
  ;;                      maximus.ilat(ind_region_magc_geabs10_acestart(temp_ii)),$
  ;;                      BIN1=binM,BIN2=binI,$
  ;;                      MIN1=MINM,MIN2=MINI,$
  ;;                      MAX1=MAXM,MAX2=MAXI) 
  ;;   orbARR[j,*,*]=h2dOrbTemp 
  ;;   h2dOrbTemp(WHERE(h2dOrbTemp GT 0)) = 1 
  ;;   h2dTotOrbStr.data += h2dOrbTemp 
  ;;ENDFOR
  
  FOR j=0, N_ELEMENTS(uniqueorbs_ii)-1 DO BEGIN 
     tempOrb=maximus.orbit[uniqueOrbs_ii[j]]
     temp_ii=WHERE(maximus.orbit EQ tempOrb,/NULL) 
     h2dOrbTemp=hist_2d(maximus.mlt[temp_ii],$
                        maximus.ilat[temp_ii],$
                        BIN1=binM,BIN2=binI,$
                        MIN1=MINM,MIN2=MINI,$
                        MAX1=MAXM,MAX2=MAXI) 
     orbARR[j,*,*]=h2dOrbTemp 
     h2dOrbTemp[WHERE(h2dOrbTemp GT 0,/NULL)] = 1 
     h2dTotOrbStr.data += h2dOrbTemp 
  ENDFOR
  
  h2dTotOrbStr.title="Total Orbits"
  IF N_ELEMENTS(orbTotRange) EQ 0 OR N_ELEMENTS(orbTotRange) NE 2 THEN $
     h2dTotOrbStr.lim=[MIN(h2dTotOrbStr.data),MAX(h2dTotOrbStr.data)] $ 
  ELSE $
     h2dTotOrbStr.lim=orbTotRange
  
  IF KEYWORD_SET(orbTotPlot) THEN BEGIN & h2dStr=[h2dStr,h2dTotOrbStr] 
     IF keepMe THEN dataNameArr=[dataNameArr,"orbTot_"] 
  ENDIF

END