; IDL Version 8.4.1 (linux x86_64 m64)
; Journal File for spencerh@thelonious.dartmouth.edu
; Working directory: /SPENCEdata/Research/Cusp/ACE_FAST
; Date: Fri Apr 10 10:59:36 2015
PRO JOURNAL_make_ks_for_neventpermin__20150410
  
  ksNEvPerMinOutFile = 'ks_stats_neventpermin__20150410.sav'

  ;various
  nDataz=2
  maxhistobins=1000
  maxstructind=[0,1]

;restore the three files, all_IMF, duskward, dawnward
  restore,'temp/polarplots_North_avg_all_IMF--0stable--5min_IMFsmooth--OMNI_GSM_Apr_10_15.dat'
  all_IMF_dat=h2dStr(0).data
  restore,'temp/polarplots_North_avg_duskward--1stable--5min_IMFsmooth--OMNI_GSM_byMin_5.0_Apr_10_15.dat'
  duskward_dat=h2dStr(0).data
  restore,'temp/polarplots_North_avg_dawnward--1stable--5min_IMFsmooth--OMNI_GSM_byMin_5.0_Apr_10_15.dat'
  dawnward_dat=h2dStr(0).data
  print,12.0/0.75
;      16.0000

  ;get reduced histograms
  all_IMF_mlt=total(all_IMF_dat,2)
  all_IMF_ilat=total(all_IMF_dat,1)
  dawnward_ilat=total(dawnward_dat,1)
  dawnward_mlt=total(dawnward_dat,2)
  duskward_ilat=total(duskward_dat,1)
  duskward_mlt=total(duskward_dat,2)

  ;because why not?
  mltHistos = TRANSPOSE([[all_imf_mlt],[dawnward_mlt],[duskward_mlt]])
  ilatHistos = TRANSPOSE([[all_imf_ilat],[dawnward_ilat],[duskward_ilat]])

  rounded_MLTHistos=round(mltHistos)
  rounded_ILATHistos=round(mltHistos)

  ;what are the mlts and ilats involved here?
  ;get them from restored file
  nMLTBins = n_elements(h2dStr(0).data(*,0))
  nILATBins = n_elements(h2dStr(0).data(0,*))
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
  maxStructLims=make_array(2,2)
  maxStructLims[0,*] = [minM,maxM] ; MLT
  maxStructLims[1,*] = [minI,maxI] ; ILAT

  ;bin sizes
  maxStructBinSizes = make_array(2)
  maxStructBinSizes[0] = binM
  maxStructBinSizes[1] = binI

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
  print,maxstructbinsizes
;     0.750000      2.00000
  print,maxstructlims
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
              BINSIZE=maxStructBinSizes[0], LOCATIONS = locations1, $
              HISTDATA=allIMF_MLT_HIST,PROBABILITY_FUNCTION=allIMF_MLT_CDF,/OPROBABILITY, $
              MININPUT=maxStructLims[0,0],MAXINPUT=maxStructLims[0,1], $
              OMAX=oMax1,OMIN=oMin1, $
              TITLE="MLT_"+allIMF_title, $
              OUTPUT="histo_cdf--MLT--"+allIMF_title+".png"

  cghistoplot,dawn_mlt_dist, $
              BINSIZE=maxStructBinSizes[0], LOCATIONS = locations1, $
              HISTDATA=dawn_MLT_HIST,PROBABILITY_FUNCTION=dawn_MLT_CDF,/OPROBABILITY, $
              MININPUT=maxStructLims[0,0],MAXINPUT=maxStructLims[0,1], $
              OMAX=oMax1,OMIN=oMin1, $
              TITLE="MLT_"+dawn_title, $
              OUTPUT="histo_cdf--MLT--"+dawn_title+".png"

  cghistoplot,dusk_mlt_dist, $
              BINSIZE=maxStructBinSizes[0], LOCATIONS = locations1, $
              HISTDATA=dusk_MLT_HIST,PROBABILITY_FUNCTION=dusk_MLT_CDF,/OPROBABILITY, $
              MININPUT=maxStructLims[0,0],MAXINPUT=maxStructLims[0,1], $
              OMAX=oMax1,OMIN=oMin1, $
              TITLE="MLT_"+dusk_title, $
              OUTPUT="histo_cdf--MLT--"+dusk_title+".png"


  cghistoplot,allimf_ilat_dist, $
              BINSIZE=maxStructBinSizes[1], LOCATIONS = locations1, $
              HISTDATA=allIMF_ILAT_HIST,PROBABILITY_FUNCTION=allIMF_ILAT_CDF,/OPROBABILITY, $
              MININPUT=maxStructLims[1,0],MAXINPUT=maxStructLims[1,1], $
              OMAX=oMax1,OMIN=oMin1, $
              TITLE="ILAT_"+allIMF_title, $
              OUTPUT="histo_cdf--ILAT--"+allIMF_title+".png"

  cghistoplot,dawn_ilat_dist, $
              BINSIZE=maxStructBinSizes[1], LOCATIONS = locations1, $
              HISTDATA=dawn_ILAT_HIST,PROBABILITY_FUNCTION=dawn_ILAT_CDF,/OPROBABILITY, $
              MININPUT=maxStructLims[1,0],MAXINPUT=maxStructLims[1,1], $
              OMAX=oMax1,OMIN=oMin1, $
              TITLE="ILAT_"+dawn_title, $
              OUTPUT="histo_cdf--ILAT--"+dawn_title+".png"

  cghistoplot,dusk_ilat_dist, $
              BINSIZE=maxStructBinSizes[1], LOCATIONS = locations1, $
              HISTDATA=dusk_ILAT_HIST,PROBABILITY_FUNCTION=dusk_ILAT_CDF,/OPROBABILITY, $
              MININPUT=maxStructLims[1,0],MAXINPUT=maxStructLims[1,1], $
              OMAX=oMax1,OMIN=oMin1, $
              TITLE="ILAT_"+dusk_title, $
              OUTPUT="histo_cdf--ILAT--"+dusk_title+".png"


  save,ks_mlt_dawnall,pval_mlt_dawnall, $
       ks_ilat_dawnall,pval_ilat_dawnall, $
       ks_ilat_duskall,pval_ilat_duskall, $
       ks_mlt_duskall,pval_mlt_duskall, $
       ks_mlt_duskdawn,pval_mlt_duskdawn, $
       ks_ilat_duskdawn,pval_ilat_duskdawn, $
       FILENAME=ksNEvPerMinOutFile

END