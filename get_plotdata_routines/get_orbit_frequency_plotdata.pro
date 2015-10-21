PRO GET_ORBIT_FREQUENCY_PLOTDATA,maximus,MINM=minM,MAXM=maxM,BINM=binM,MINI=minI,MAXI=maxI,BINI=binI, $
                                 ORBFREQRANGE=orbFreqRange, $
                                 H2DSTR=h2dStr,TMPLT_H2DSTR=tmplt_h2dStr, $
                                 H2DCONTRIBORBSTR=h2dContribOrbStr,H2DTOTORBSTR=h2dTotOrbStr, $
                                 H2D_NONZERO_ALLORB_I=h2d_nonZero_allOrb_i,H2D_NONZERO_CONTRIBORBS_I=h2d_nonzero_contribOrbs_i, $
                                 DATANAME=dataName

  IF N_ELEMENTS(tmplt_h2dStr) EQ 0 THEN $
     tmplt_h2dStr = MAKE_H2DSTR_TMPLT(BIN1=binM,BIN2=(KEYWORD_SET(DO_lshell) ? binL : binI),$
                                      MIN1=MINM,MIN2=(KEYWORD_SET(DO_LSHELL) ? MINL : MINI),$
                                      MAX1=MAXM,MAX2=(KEYWORD_SET(DO_LSHELL) ? MAXL : MAXI))
  h2dStr={tmplt_h2dStr}
  h2dStr.title="Orbit Frequency"
  dataName = "orbFreq_"
  
  h2dStr.data=h2dContribOrbStr.data
  h2dStr.data[h2d_nonZero_allOrb_i]=DOUBLE(h2dContribOrbStr.data[h2d_nonZero_allOrb_i])/h2dTotOrbStr.data[h2d_nonZero_allOrb_i]
  
  IF N_ELEMENTS(orbFreqRange) EQ 0 OR N_ELEMENTS(orbFreqRange) NE 2 THEN $
     h2dStr.lim=[MIN(h2dStr.data),MAX(h2dStr.data)] $
  ELSE $
     h2dStr.lim=orbFreqRange
  
  ;;The following snippet is meant to compare nonzero totorb data with nonzero contriborb data
  ;;What if I use indices where neither tot orbits nor contributing orbits is zero?
  ;; orbfreq_histo_i=cgsetintersection(h2d_nonzero_contribOrbs_i,h2d_nonZero_allOrb_i)
  ;; h2dnewdata=h2dContribOrbStr.data
  ;; h2dnewdata[orbfreq_histo_i]=h2dContribOrbStr.data[orbfreq_histo_i]/h2dTotOrbStr.data[orbfreq_histo_i]
  ;; diff=where(h2dStr.data NE h2dnewdata)
  ;;     wait, 2

END