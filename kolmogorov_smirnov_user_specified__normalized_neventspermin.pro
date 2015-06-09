;Here we do K-S statistics by normalizing the nevents plot according to the method suggested by
;Prof. LaBelle, where we find the min

PRO kolmogorov_smirnov_user_specified__normalized_neventspermin
  
  date='20150420'
  ksNEvPerMinOutFile = 'ks_stats_neventpermin__'+date+'.sav'
;  normalized_timeFile = 

  ;various
  nDataz=2
  maxhistobins=1000
  fastLocStructind=[0,1]

  ;h2dStr index to use for data
  ;0 = nEventsPerMin
  ;1 = nEvents_
  h2dStr_ind = 1 ;do nEvents
  
  nFiles=3
  datFiles=MAKE_ARRAY(nFiles,/STRING)
  timeHistoFiles=MAKE_ARRAY(nFiles,/STRING)

  datFiles[0]='temp/polarplots_North_avg_dawnward--1stable--5min_IMFsmooth--OMNI_GSM_byMin_5.0_Apr_10_15.dat'
  datFiles[1]='temp/polarplots_North_avg_duskward--1stable--5min_IMFsmooth--OMNI_GSM_byMin_5.0_Apr_10_15.dat'
  datFiles[2]='temp/polarplots_North_avg_all_IMF--0stable--5min_IMFsmooth--OMNI_GSM_Apr_10_15.dat'

  timeHistoFiles[0]='../database/dartdb/saves/fastLoc_timeHistos/fastLoc_intervals2--dawnward_45.00-135.00deg--OMNI_GSM--byMin_5.0--stableIMF_1min--delay_660--smoothWindow_5min--6-18-0.75_MLT--60-84-2_ILAT--orbs520-10983--timehisto--20150420.sav'
  timeHistoFiles[1]='../database/dartdb/saves/fastLoc_timeHistos/fastLoc_intervals2--duskward_45.00-135.00deg--OMNI_GSM--byMin_5.0--stableIMF_1min--delay_660--smoothWindow_5min--6-18-0.75_MLT--60-84-2_ILAT--orbs500-14976--timehisto--20150420.sav'
  timeHistoFiles[2]='../database/dartdb/saves/fastLoc_timeHistos/fastLoc_intervals2--all_IMF_180.00-180.00deg--OMNI_GSM--byMin_0.0--stableIMF_0min--delay_660--smoothWindow_5min--6-18-0.75_MLT--60-84-2_ILAT--orbs500-14999--timehisto--20150420.sav'

  ;restore the three file groups
  restore,datFiles[0]
  dawnward_dat=h2dStr(h2dStr_ind).data
  restore,datFiles[1]
  duskward_dat=h2dStr(h2dStr_ind).data
  restore,datFiles[2]
  all_IMF_dat=h2dStr(h2dStr_ind).data
;  print,12.0/0.75
;      16.0000

  restore,timeHistoFiles[0]
  dawnward_timeHist=timehisto
  restore,timeHistoFiles[1]
  duskward_timeHist=timeHisto
  restore,timeHistoFiles[2]
  all_IMF_timeHist=timeHisto

  ;get reduced histograms
  all_IMF_mlt=total(all_IMF_dat,2)
  all_IMF_ilat=total(all_IMF_dat,1)
  dawnward_ilat=total(dawnward_dat,1)
  dawnward_mlt=total(dawnward_dat,2)
  duskward_ilat=total(duskward_dat,1)
  duskward_mlt=total(duskward_dat,2)

  ;now time histos
  all_IMF_mlt_timeHisto=total(all_IMF_timeHisto,2)
  all_IMF_ilat_timeHisto=total(all_IMF_timeHisto,1)
  dawnward_ilat_timeHisto=total(dawnward_timeHisto,1)
  dawnward_mlt_timeHisto=total(dawnward_timeHisto,2)
  duskward_ilat_timeHisto=total(duskward_timeHisto,1)
  duskward_mlt_timeHisto=total(duskward_timeHisto,2)
  
  ;because why not?
  mltHistos = TRANSPOSE([[all_imf_mlt],[dawnward_mlt],[duskward_mlt]])
  ilatHistos = TRANSPOSE([[all_imf_ilat],[dawnward_ilat],[duskward_ilat]])

  mltTimeHistos = TRANSPOSE([[all_imf_mlt_timeHisto],[dawnward_mlt_timeHisto],[duskward_mlt_timeHisto]])
  ilatTimeHistos = TRANSPOSE([[all_imf_ilat_timeHisto],[dawnward_ilat_timeHisto],[duskward_ilat_timeHisto]])

  rounded_MLTHistos=round(mltHistos)
  rounded_ILATHistos=round(mltHistos)

  ;what are the mlts and ilats involved here?
  ;get them from restored file
  nMLTBins = n_elements(h2dStr(h2dStr_ind).data(*,0))
  nILATBins = n_elements(h2dStr(h2dStr_ind).data(0,*))
  mlts=indgen(nMLTBins)*binM + minM
  ilats=indgen(nILATBins)*binI + minI

  ;******************************
  ;do MLTs
  mltDist = MAKE_ARRAY(3,maxHistoBins,VALUE=0.0,/DOUBLE)
  i_allIMF = 0
  i_dawn = 0
  i_dusk = 0
  FOR i=0,nMLTBins-1 DO BEGIN
     ;all IMF
     IF rounded_MLTHistos[0,i] GE 1 THEN BEGIN
        mltDist[0,i_allIMF:i_allIMF+rounded_MLTHistos[0,i]-1] = mlts[i]
        i_allIMF += rounded_MLTHistos[0,i]
     ENDIF
     ;dawn
     IF rounded_MLTHistos[1,i] GE 1 THEN BEGIN
        mltDist[1,i_dawn:i_dawn+rounded_MLTHistos[1,i]-1] = mlts[i]
        i_dawn += rounded_MLTHistos[1,i]
     ENDIF
     ;dusk
     IF rounded_MLTHistos[2,i] GE 1 THEN BEGIN
        mltDist[2,i_dusk:i_dusk+rounded_MLTHistos[2,i]-1] = mlts[i]
        i_dusk += rounded_MLTHistos[2,i]
     ENDIF

  ENDFOR

  ;as a check, note that i_allIMF should equal total(rounded_MLTHistos[0,*])
  ; or i_dawn should equal total(rounded_MLTHistos[1,*])
  ;They do, so I'm convinced
  ;Here's how to get these distributions:
  allIMF_mlt_dist = TRANSPOSE(mltDist[0,0:i_allIMF-1])
  dawn_mlt_dist = TRANSPOSE(mltDist[1,0:i_dawn-1])
  dusk_mlt_dist = TRANSPOSE(mltDist[2,0:i_dusk-1])

  ;******************************
  ;do ILATs
  ilatDist = MAKE_ARRAY(3,maxHistoBins,VALUE=0.0,/DOUBLE)
  i_allIMF = 0
  i_dawn = 0
  i_dusk = 0
  FOR i=0,nILATBins-1 DO BEGIN
     ;all IMF
     IF rounded_ILATHistos[0,i] GE 1 THEN BEGIN
        ilatDist[0,i_allIMF:i_allIMF+rounded_ILATHistos[0,i]-1] = ilats[i]
        i_allIMF += rounded_ILATHistos[0,i]
     ENDIF
     ;dawn
     IF rounded_ILATHistos[1,i] GE 1 THEN BEGIN
        ilatDist[1,i_dawn:i_dawn+rounded_ILATHistos[1,i]-1] = ilats[i]
        i_dawn += rounded_ILATHistos[1,i]
     ENDIF
     ;dusk
     IF rounded_ILATHistos[2,i] GE 1 THEN BEGIN
        ilatDist[2,i_dusk:i_dusk+rounded_ILATHistos[2,i]-1] = ilats[i]
        i_dusk += rounded_ILATHistos[2,i]
     ENDIF

  ENDFOR

  ;as a check, note that i_allIMF should equal total(rounded_ILATHistos[0,*])
  ; or i_dawn should equal total(rounded_ILATHistos[1,*])
  ;They do, so I'm convinced
  ;Here's how to get these distributions:
  allIMF_ilat_dist = TRANSPOSE(ilatDist[0,0:i_allIMF-1])
  dawn_ilat_dist = TRANSPOSE(ilatDist[1,0:i_dawn-1])
  dusk_ilat_dist = TRANSPOSE(ilatDist[2,0:i_dusk-1])


  ;limits
  fastLocStructLims=make_array(2,2)
  fastLocStructLims[0,*] = [minM,maxM] ; MLT
  fastLocStructLims[1,*] = [minI,maxI] ; ILAT

  ;bin sizes
  fastLocStructBinSizes = make_array(2)
  fastLocStructBinSizes[0] = binM
  fastLocStructBinSizes[1] = binI

  ks_stats ={ks_statistic:make_array(nDataz,/DOUBLE), $
             pVal:make_array(nDataz,/DOUBLE), $
             dataProd:make_array(nDataz,/STRING), $
             histoBinSize:make_array(nDataz,/DOUBLE), $
             binLocs1:make_array(nDataz,maxHistoBins), $
             binLocs2:make_array(nDataz,maxHistoBins), $
             histoLims:make_array(nDataz,2,/DOUBLE), $
             histo1:make_array(nDataz,maxHistoBins), $
             histo2:make_array(nDataz,maxHistoBins), $
             cHisto1:make_array(nDataz,maxHistoBins), $
             cHisto2:make_array(nDataz,maxHistoBins), $
             nHistBins:make_array(nDataz)}

  ;do the ks stuff
  print,fastLocStructbinsizes
;     0.750000      2.00000
  print,fastLocStructlims
;      6.00000      60.0000
;      18.0000      84.0000

  ;do we need cdfs?
  dawnward_mlt_cdf=TOTAL(dawnward_mlt,/CUMULATIVE)
  dawnward_ilat_cdf=TOTAL(dawnward_ilat,/CUMULATIVE)
  duskward_ilat_cdf=TOTAL(duskward_ilat,/CUMULATIVE)
  duskward_mlt_cdf=TOTAL(duskward_mlt,/CUMULATIVE)


  ;;it's all wrong as written
  ;now kstwo stuff
  kstwo,dawn_mlt_dist,allIMF_mlt_dist,ks_mlt_dawnall,pval_mlt_dawnall
  kstwo,dawn_ilat_dist,allIMF_ilat_dist,ks_ilat_dawnall,pval_ilat_dawnall
  kstwo,dusk_ilat_dist,allIMF_ilat_dist,ks_ilat_duskall,pval_ilat_duskall
  kstwo,dusk_mlt_dist,allIMF_mlt_dist,ks_mlt_duskall,pval_mlt_duskall
  kstwo,dusk_mlt_dist,dawn_mlt_dist,ks_mlt_duskdawn,pval_mlt_duskdawn
  kstwo,dusk_ilat_dist,dawn_ilat_dist,ks_ilat_duskdawn,pval_ilat_duskdawn

  ;histograms
  allIMF_title='allIMF_N_Events_per_Minute'
  dawn_title='dawn_N_Events_per_Minute'
  dusk_title='dusk_N_Events_per_Minute'

  cghistoplot,allimf_mlt_dist, $
              BINSIZE=fastLocStructBinSizes[0], LOCATIONS = allIMF_MLT_binLocs, $
              HISTDATA=allIMF_MLT_HIST,PROBABILITY_FUNCTION=allIMF_MLT_CDF,/OPROBABILITY, $
              MININPUT=fastLocStructLims[0,0],MAXINPUT=fastLocStructLims[0,1], $
              OMAX=oMax1,OMIN=oMin1, $
              TITLE="MLT_"+allIMF_title, $
              OUTPUT="histo_cdf--MLT--"+allIMF_title+".png"

  cghistoplot,dawn_mlt_dist, $
              BINSIZE=fastLocStructBinSizes[0], LOCATIONS = dawn_MLT_binLocs, $
              HISTDATA=dawn_MLT_HIST,PROBABILITY_FUNCTION=dawn_MLT_CDF,/OPROBABILITY, $
              MININPUT=fastLocStructLims[0,0],MAXINPUT=fastLocStructLims[0,1], $
              OMAX=oMax1,OMIN=oMin1, $
              TITLE="MLT_"+dawn_title, $
              OUTPUT="histo_cdf--MLT--"+dawn_title+".png"

  cghistoplot,dusk_mlt_dist, $
              BINSIZE=fastLocStructBinSizes[0], LOCATIONS = dusk_MLT_binLocs, $
              HISTDATA=dusk_MLT_HIST,PROBABILITY_FUNCTION=dusk_MLT_CDF,/OPROBABILITY, $
              MININPUT=fastLocStructLims[0,0],MAXINPUT=fastLocStructLims[0,1], $
              OMAX=oMax1,OMIN=oMin1, $
              TITLE="MLT_"+dusk_title, $
              OUTPUT="histo_cdf--MLT--"+dusk_title+".png"


  cghistoplot,allimf_ilat_dist, $
              BINSIZE=fastLocStructBinSizes[1], LOCATIONS = allIMF_ILAT_binLocs, $
              HISTDATA=allIMF_ILAT_HIST,PROBABILITY_FUNCTION=allIMF_ILAT_CDF,/OPROBABILITY, $
              MININPUT=fastLocStructLims[1,0],MAXINPUT=fastLocStructLims[1,1], $
              OMAX=oMax1,OMIN=oMin1, $
              TITLE="ILAT_"+allIMF_title, $
              OUTPUT="histo_cdf--ILAT--"+allIMF_title+".png"

  cghistoplot,dawn_ilat_dist, $
              BINSIZE=fastLocStructBinSizes[1], LOCATIONS = dawn_ILAT_binLocs, $
              HISTDATA=dawn_ILAT_HIST,PROBABILITY_FUNCTION=dawn_ILAT_CDF,/OPROBABILITY, $
              MININPUT=fastLocStructLims[1,0],MAXINPUT=fastLocStructLims[1,1], $
              OMAX=oMax1,OMIN=oMin1, $
              TITLE="ILAT_"+dawn_title, $
              OUTPUT="histo_cdf--ILAT--"+dawn_title+".png"

  cghistoplot,dusk_ilat_dist, $
              BINSIZE=fastLocStructBinSizes[1], LOCATIONS = dusk_ILAT_binLocs, $
              HISTDATA=dusk_ILAT_HIST,PROBABILITY_FUNCTION=dusk_ILAT_CDF,/OPROBABILITY, $
              MININPUT=fastLocStructLims[1,0],MAXINPUT=fastLocStructLims[1,1], $
              OMAX=oMax1,OMIN=oMin1, $
              TITLE="ILAT_"+dusk_title, $
              OUTPUT="histo_cdf--ILAT--"+dusk_title+".png"

  nHistBins = [n_elements(dusk_MLT_HIST),N_ELEMENTS(dusk_ILAT_HIST)]
;just a check
;print,n_elements(dawn_mlt_hist),n_elements(dawn_ilat_hist)
;          17          13

  save,ks_mlt_dawnall,pval_mlt_dawnall, $
       ks_ilat_dawnall,pval_ilat_dawnall, $
       ks_ilat_duskall,pval_ilat_duskall, $
       ks_mlt_duskall,pval_mlt_duskall, $
       ks_mlt_duskdawn,pval_mlt_duskdawn, $
       ks_ilat_duskdawn,pval_ilat_duskdawn, $
       allIMF_ILAT_cdf,dawn_ILAT_CDF,dusk_ILAT_cdf, $
       allIMF_MLT_cdf,dawn_MLT_CDF,dusk_MLT_cdf, $
       fastLocStructLims,fastLocStructBinSizes, $
       nHistBins, $
       allIMF_MLT_binLocs,dawn_MLT_binLocs,dusk_MLT_binLocs, $
       allIMF_ILAT_binLocs,dawn_ILAT_binLocs,dusk_ILAT_binLocs, $
       FILENAME=ksNEvPerMinOutFile

END