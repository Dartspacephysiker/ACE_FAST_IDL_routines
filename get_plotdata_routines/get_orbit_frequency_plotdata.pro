PRO GET_ORBIT_FREQUENCY_PLOTDATA,maximus,plot_i,MINM=minM,MAXM=maxM,BINM=binM,MINI=minI,MAXI=maxI,BINI=binI, $
                                 ORBFREQRANGE=orbFreqRange, $
                                 H2DSTR=h2dStr,TMPLT_H2DSTR=tmplt_h2dStr,H2DFLUXN=h2dFluxN,H2DORBSTR=h2dOrbStr,H2DTOTORBSTR=h2dTotOrbStr, $
                                 DATANAMEARR=dataNameArr,DATARAWPTRARR=dataRawPtrArr,KEEPME=keepme, $
                                 NPLOTS=nPlots,ORBTOTPLOT=orbTotPlot,UNIQUEORBS_II=uniqueOrbs_ii

  IF N_ELEMENTS(tmplt_h2dStr) EQ 0 THEN $
     tmplt_h2dStr = MAKE_H2DSTR_TMPLT(BIN1=binM,BIN2=(KEYWORD_SET(DO_lshell) ? binL : binI),$
                                      MIN1=MINM,MIN2=(KEYWORD_SET(DO_LSHELL) ? MINL : MINI),$
                                      MAX1=MAXM,MAX2=(KEYWORD_SET(DO_LSHELL) ? MAXL : MAXI))
  h2dStr={tmplt_h2dStr}
  h2dStr.title="Orbit Frequency"
  dataName = "orbFreq_"
  
  nonzero_orb_i = WHERE(h2dTotOrbStr.data NE 0,/NULL)
  h2dStr.data=h2dOrbStr.data
  h2dStr.data[nonzero_orb_i]=h2dOrbStr.data[nonzero_orb_i]/h2dTotOrbStr.data[nonzero_orb_i]
  
  IF N_ELEMENTS(orbFreqRange) EQ 0 OR N_ELEMENTS(orbFreqRange) NE 2 THEN $
     h2dStr.lim=[MIN(h2dStr.data),MAX(h2dStr.data)] $
  ELSE $
     h2dStr.lim=orbFreqRange
  
  ;;What if I use indices where neither tot orbits nor contributing orbits is zero?
  orbs_w_events_histo_i=where(h2dOrbStr.data NE 0)
  orbs_histo_i=where(h2dtotorbstr.data NE 0)
  orbfreq_histo_i=cgsetintersection(orbs_w_events_histo_i,orbs_histo_i)
  h2dnewdata=h2dOrbStr.data
  h2dnewdata[orbfreq_histo_i]=h2dOrbStr.data[orbfreq_histo_i]/h2dTotOrbStr.data[orbfreq_histo_i]
  diff=where(h2dStr.data NE h2dnewdata)
  ;;     wait, 2

END