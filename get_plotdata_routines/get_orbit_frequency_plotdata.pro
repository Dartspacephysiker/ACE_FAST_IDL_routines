PRO GET_ORBIT_FREQUENCY_PLOTDATA,maximus,plot_i,MINM=minM,MAXM=maxM,BINM=binM,MINI=minI,MAXI=maxI,BINI=binI, $
                                 ORBFREQRANGE=orbFreqRange, $
                                 H2DSTR=h2dStr,TMPLT_H2DSTR=tmplt_h2dStr,H2DFLUXN=h2dFluxN,H2DORBSTR=h2dOrbStr,H2DTOTORBSTR=h2dTotOrbStr, $
                                 DATANAMEARR=dataNameArr,DATARAWPTRARR=dataRawPtrArr,KEEPME=keepme, $
                                 NPLOTS=nPlots,ORBTOTPLOT=orbTotPlot,UNIQUEORBS_II=uniqueOrbs_ii

     h2dFreqOrbStr={tmplt_h2dStr}
     h2dFreqOrbStr.data=h2dOrbStr.data
     h2dFreqOrbStr.data[WHERE(h2dTotOrbStr.data NE 0,/NULL)]=h2dOrbStr.data[WHERE(h2dTotOrbStr.data NE 0,/NULL)]/h2dTotOrbStr.data[WHERE(h2dTotOrbStr.data NE 0,/NULL)]
     h2dFreqOrbStr.title="Orbit Frequency"
     
     IF N_ELEMENTS(orbFreqRange) EQ 0 OR N_ELEMENTS(orbFreqRange) NE 2 THEN $
        h2dFreqOrbStr.lim=[MIN(h2dFreqOrbStr.data),MAX(h2dFreqOrbStr.data)] $
     ELSE $
        h2dFreqOrbStr.lim=orbFreqRange

     h2dStr=[h2dStr,h2dFreqOrbStr] 
     IF keepMe THEN dataNameArr=[dataNameArr,"orbFreq_"] 

     ;;What if I use indices where neither tot orbits nor contributing orbits is zero?
     orbs_w_events_histo_i=where(h2dorbstr.data NE 0)
     orbs_histo_i=where(h2dtotorbstr.data NE 0)
     orbfreq_histo_i=cgsetintersection(orbs_w_events_histo_i,orbs_histo_i)
     h2dnewdata=h2dOrbStr.data
     h2dnewdata[orbfreq_histo_i]=h2dOrbStr.data[orbfreq_histo_i]/h2dTotOrbStr.data[orbfreq_histo_i]
     diff=where(h2dfreqorbstr.data NE h2dnewdata)

     wait, 2
END