PRO GET_CONTRIBUTING_ORBITS_PLOTDATA,maximus,plot_i,MINM=minM,MAXM=maxM,BINM=binM,MINI=minI,MAXI=maxI,BINI=binI, $
                                     DO_LSHELL=do_lShell, MINL=minL,MAXL=maxL,BINL=binL, $
                                     ORBCONTRIBRANGE=orbContribRange, $
                                     UNIQUEORBS_I=uniqueOrbs_i,H2D_NONZERO_CONTRIBORBS_I=h2d_nonzero_contribOrbs_i, $
                                     H2DSTR=h2dStr,TMPLT_H2DSTR=tmplt_h2dStr, $ ;H2DFLUXN=h2dFluxN, $
                                     DATANAME=dataName


  ;;  @orbplot_defaults.PRO

  IF N_ELEMENTS(uniqueOrbs_i) EQ 0 THEN BEGIN
     uniqueOrbs_ii = UNIQ(maximus.orbit[plot_i],SORT(maximus.orbit[plot_i]))
     uniqueOrbs_i = plot_i[uniqueOrbs_ii]
  ENDIF
  nOrbs = N_ELEMENTS(uniqueOrbs_i)

  IF N_ELEMENTS(tmplt_h2dStr) EQ 0 THEN $
     tmplt_h2dStr = MAKE_H2DSTR_TMPLT(BIN1=binM,BIN2=(KEYWORD_SET(do_lShell) ? binL : binI),$
                                      MIN1=MINM,MIN2=(KEYWORD_SET(do_lShell) ? MINL : MINI),$
                                      MAX1=MAXM,MAX2=(KEYWORD_SET(do_lShell) ? MAXL : MAXI))
  h2dStr={tmplt_h2dStr}
  h2dStr.data[*,*] = 0
  h2dStr.title="Num Contributing Orbits"
  dataName = "orbsContributing_"

  h2dOrbN=INTARR(N_ELEMENTS(tmplt_h2dStr.data[*,0]),N_ELEMENTS(tmplt_h2dStr.data[0,*]))
  orbArr=INTARR(N_ELEMENTS(uniqueOrbs_i),N_ELEMENTS(tmplt_h2dStr.data[*,0]),N_ELEMENTS(tmplt_h2dStr.data[0,*]))
  ;; orbArr=INTARR(N_ELEMENTS(uniqueOrbs_i),N_ELEMENTS(h2dFluxN[*,0]),N_ELEMENTS(h2dFluxN[0,*]))
  
  FOR j=0, N_ELEMENTS(uniqueOrbs_i)-1 DO BEGIN 
     tempOrb=maximus.orbit[uniqueOrbs_i[j]] 
     temp_ii=WHERE(maximus.orbit[plot_i] EQ tempOrb,/NULL) 
     h2dOrbTemp=hist_2d(maximus.mlt[plot_i[temp_ii]],$
                        (KEYWORD_SET(do_lShell) ? maximus.lshell : maximus.ilat)[plot_i[temp_ii]],$
                        BIN1=binM,BIN2=(KEYWORD_SET(do_lShell) ? binL : binI),$
                        MIN1=MINM,MIN2=(KEYWORD_SET(do_lShell) ? MINL : MINI),$
                        MAX1=MAXM,MAX2=(KEYWORD_SET(do_lShell) ? MAXL : MAXI)) 
     orbARR[j,*,*]=h2dOrbTemp 
     h2dOrbTemp[WHERE(h2dOrbTemp GT 0,/NULL)] = 1 
     h2dStr.data += h2dOrbTemp 
  ENDFOR
  
  IF N_ELEMENTS(orbContribRange) EQ 0 OR N_ELEMENTS(orbContribRange) NE 2 THEN $
     h2dStr.lim=[MIN(h2dStr.data),MAX(h2dStr.data)] $
  ELSE $
     h2dStr.lim=orbContribRange

  h2d_nonzero_contribOrbs_i = WHERE(h2dStr.data GT 0,/NULL)
END