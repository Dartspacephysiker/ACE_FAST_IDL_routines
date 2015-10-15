PRO GET_CONTRIBUTING_ORBITS_PLOTDATA,maximus,plot_i,MINM=minM,MAXM=maxM,BINM=binM,MINI=minI,MAXI=maxI,BINI=binI, $
                                     DO_LSHELL=do_lshell, MINL=minL,MAXL=maxL,BINL=binL, $
                                     ORBCONTRIBRANGE=orbContribRange, $
                                     H2DSTR=h2dStr,TMPLT_H2DSTR=tmplt_h2dStr,H2DFLUXN=h2dFluxN,H2DORBSTR=h2dOrbStr, $
                                     DATANAMEARR=dataNameArr,DATARAWPTRARR=dataRawPtrArr,KEEPME=keepme, $
                                     OUTH2DBINSMLT=outH2DBinsMLT,OUTH2DBINSILAT=outH2DBinsILAT,OUTH2DBINSLSHELL=outH2DBinsLShell, $
                                     NPLOTS=nPlots,ORBCONTRIBPLOT=orbContribPlot,UNIQUEORBS_II=uniqueOrbs_ii,NORBS=nOrbs

  IF N_ELEMENTS(uniqueOrbs_ii) EQ 0 THEN uniqueOrbs_ii = UNIQ(maximus.orbit[plot_i],SORT(maximus.orbit[plot_i]))
  IF N_ELEMENTS(nOrbs) EQ 0 THEN nOrbs = N_ELEMENTS(uniqueOrbs_ii)

     h2dOrbStr={tmplt_h2dStr}

     h2dOrbN=INTARR(N_ELEMENTS(h2dStr[0].data[*,0]),N_ELEMENTS(h2dStr[0].data[0,*]))
     orbArr=INTARR(N_ELEMENTS(uniqueorbs_ii),N_ELEMENTS(h2dFluxN[*,0]),N_ELEMENTS(h2dFluxN[0,*]))

     FOR j=0, N_ELEMENTS(uniqueorbs_ii)-1 DO BEGIN 
        tempOrb=maximus.orbit[plot_i[uniqueOrbs_ii[j]]] 
        temp_ii=WHERE(maximus.orbit[plot_i] EQ tempOrb,/NULL) 
        h2dOrbTemp=hist_2d(maximus.mlt[plot_i[temp_ii]],$
                           (KEYWORD_SET(DO_LSHELL) ? maximus.lshell : maximus.ilat)[plot_i[temp_ii]],$
                           BIN1=binM,BIN2=(KEYWORD_SET(do_lshell) ? binL : binI),$
                           MIN1=MINM,MIN2=(KEYWORD_SET(DO_LSHELL) ? MINL : MINI),$
                           MAX1=MAXM,MAX2=(KEYWORD_SET(DO_LSHELL) ? MAXL : MAXI)) 
        orbARR[j,*,*]=h2dOrbTemp 
        h2dOrbTemp[WHERE(h2dOrbTemp GT 0,/NULL)] = 1 
        h2dOrbStr.data += h2dOrbTemp 
     ENDFOR

     h2dOrbStr.title="Num Contributing Orbits"

     IF N_ELEMENTS(orbContribRange) EQ 0 OR N_ELEMENTS(orbContribRange) NE 2 THEN $
        h2dOrbStr.lim=[MIN(h2dOrbStr.data),MAX(h2dOrbStr.data)] $
     ELSE $
        h2dOrbStr.lim=orbContribRange

     ;;Mask all bins that don't have requisite number of orbits passing through
     IF KEYWORD_SET(numOrbLim) THEN BEGIN 
        h2dStr[KEYWORD_SET(nPlots)].data[WHERE(h2dOrbStr.data LT numOrbLim)] = 255 ;mask 'em!

        ;;little check to see how many more elements are getting masked
        ;;exc_orb_i = where(h2dOrbStr.data LT numOrbLim)
        ;;masked_i = where(h2dStr(1).data EQ 255)
        ;;print,n_elements(exc_orb_i) - n_elements(cgsetintersection(exc_orb_i,masked_i))
        ;;8

     ENDIF
        
     IF KEYWORD_SET(orbContribPlot) THEN BEGIN 
        h2dStr=[h2dStr,h2dOrbStr] 
        IF keepMe THEN dataNameArr=[dataNameArr,"orbsContributing_"] 
     ENDIF

END