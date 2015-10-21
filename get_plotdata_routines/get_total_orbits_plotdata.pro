PRO GET_TOTAL_ORBITS_PLOTDATA,maximus,plot_i,MINM=minM,MAXM=maxM,BINM=binM,MINI=minI,MAXI=maxI,BINI=binI, $
                              DO_LSHELL=do_lshell, MINL=minL,MAXL=maxL,BINL=binL, $
                              ORBTOTRANGE=orbTotRange, $
                              H2DSTR=h2dStr,TMPLT_H2DSTR=tmplt_h2dStr,H2DFLUXN=h2dFluxN, $
                              DATANAME=dataName,DATARAWPTR=dataRawPtr,KEEPME=keepme, $
                              NPLOTS=nPlots,UNIQUEORBS_II=uniqueOrbs_ii

  IF N_ELEMENTS(uniqueOrbs_ii) EQ 0 THEN uniqueOrbs_ii=UNIQ(maximus.orbit,SORT(maximus.orbit))

  IF N_ELEMENTS(tmplt_h2dStr) EQ 0 THEN $
     tmplt_h2dStr = MAKE_H2DSTR_TMPLT(BIN1=binM,BIN2=(KEYWORD_SET(DO_lshell) ? binL : binI),$
                                      MIN1=MINM,MIN2=(KEYWORD_SET(DO_LSHELL) ? MINL : MINI),$
                                      MAX1=MAXM,MAX2=(KEYWORD_SET(DO_LSHELL) ? MAXL : MAXI))
  h2dStr={tmplt_h2dStr}
  h2dStr.title="Total Orbits"
  dataName = "orbTot_"

  orbArr=INTARR(N_ELEMENTS(uniqueorbs_ii),N_ELEMENTS(h2dFluxN[*,0]),N_ELEMENTS(h2dFluxN[0,*]))
  h2dOrbN=INTARR(N_ELEMENTS(tmplt_h2dStr.data[*,0]),N_ELEMENTS(tmplt_h2dStr.data[0,*]))
    
  ;;FOR j=0, N_ELEMENTS(uniqueorbs_ii)-1 DO BEGIN 
  ;;   tempOrb=maximus.orbit(ind_region_magc_geabs10_acestart(uniqueOrbs_ii(j))) 
  ;;   temp_ii=WHERE(maximus.orbit(ind_region_magc_geabs10_acestart) EQ tempOrb) 
  ;;   h2dOrbTemp=hist_2d(maximus.mlt(ind_region_magc_geabs10_acestart(temp_ii)),$
  ;;                      maximus.ilat(ind_region_magc_geabs10_acestart(temp_ii)),$
  ;;                      BIN1=binM,BIN2=(KEYWORD_SET(do_lShell) ? binL : binI),$
  ;;                      MIN1=MINM,MIN2=MINI,$
  ;;                      MAX1=MAXM,MAX2=MAXI) 
  ;;   orbARR[j,*,*]=h2dOrbTemp 
  ;;   h2dOrbTemp(WHERE(h2dOrbTemp GT 0)) = 1 
  ;;   h2dStr.data += h2dOrbTemp 
  ;;ENDFOR
  
  FOR j=0, N_ELEMENTS(uniqueorbs_ii)-1 DO BEGIN 
     tempOrb=maximus.orbit[uniqueOrbs_ii[j]]
     temp_ii=WHERE(maximus.orbit EQ tempOrb,/NULL) 
     h2dOrbTemp=hist_2d(maximus.mlt[temp_ii],$
                        maximus.ilat[temp_ii],$
                        BIN1=binM,BIN2=(KEYWORD_SET(do_lShell) ? binL : binI),$
                        MIN1=MINM,MIN2=(KEYWORD_SET(do_lShell) ? minL : minI),$
                        MAX1=MAXM,MAX2=(KEYWORD_SET(do_lShell) ? maxL : maxI)) 

     orbARR[j,*,*]=h2dOrbTemp 
     h2dOrbTemp[WHERE(h2dOrbTemp GT 0,/NULL)] = 1 
     h2dStr.data += h2dOrbTemp 
  ENDFOR

  IF N_ELEMENTS(orbTotRange) EQ 0 OR N_ELEMENTS(orbTotRange) NE 2 THEN $
     h2dStr.lim=[MIN(h2dStr.data),MAX(h2dStr.data)] $ 
  ELSE $
     h2dStr.lim=orbTotRange
  
END