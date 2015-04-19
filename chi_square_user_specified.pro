;The default for this file is to get chi-square statistics for the N Events per Min plots

PRO chi_square_user_specified
  
  XsqNEvPerMinOutFile = 'Xsq_stats_neventpermin__20150413.sav'

  ;various
  nDataz=2
  maxhistobins=1000
  fastLocStructind=[0,1]

;restore the three files, all_IMF, duskward, dawnward
  restore,'temp/polarplots_North_avg_all_IMF--0stable--5min_IMFsmooth--OMNI_GSM_Apr_10_15.dat'
  all_IMF_dat=h2dStr(0).data
  restore,'temp/polarplots_North_avg_duskward--1stable--5min_IMFsmooth--OMNI_GSM_byMin_5.0_Apr_10_15.dat'
  dusk_dat=h2dStr(0).data
  restore,'temp/polarplots_North_avg_dawnward--1stable--5min_IMFsmooth--OMNI_GSM_byMin_5.0_Apr_10_15.dat'
  dawn_dat=h2dStr(0).data

  ;get reduced histograms
  ;; all_IMF_mlt=total(all_IMF_dat,2)
  ;; all_IMF_ilat=total(all_IMF_dat,1)
  ;; dawn_ilat=total(dawn_dat,1)
  ;; dawn_mlt=total(dawn_dat,2)
  ;; dusk_ilat=total(dusk_dat,1)
  ;; dusk_mlt=total(dusk_dat,2)

  ;multiply by 60.0 to make it n ev per hour
  all_IMF_mlt=total(all_IMF_dat,2)*60.0
  all_IMF_ilat=total(all_IMF_dat,1)*60.0
  dawn_ilat=total(dawn_dat,1)*60.0
  dawn_mlt=total(dawn_dat,2)*60.0
  dusk_ilat=total(dusk_dat,1)*60.0
  dusk_mlt=total(dusk_dat,2)*60.0

  ;because why not?
  mltHistos = TRANSPOSE([[all_imf_mlt],[dawn_mlt],[dusk_mlt]])
  ilatHistos = TRANSPOSE([[all_imf_ilat],[dawn_ilat],[dusk_ilat]])

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
  ;; mltDist = MAKE_ARRAY(3,maxHistoBins,VALUE=0.0,/DOUBLE)
  ;; i_allIMF = 0
  ;; i_dawn = 0
  ;; i_dusk = 0
  ;; FOR i=0,nMLTBins-1 DO BEGIN
  ;;    ;all IMF
  ;;    IF rounded_MLTHistos[0,i] GE 1 THEN BEGIN
  ;;       mltDist[0,i_allIMF:i_allIMF+rounded_MLTHistos[0,i]-1] = mlts[i]
  ;;       i_allIMF += rounded_MLTHistos[0,i]
  ;;    ENDIF
  ;;    ;dawn
  ;;    IF rounded_MLTHistos[1,i] GE 1 THEN BEGIN
  ;;       mltDist[1,i_dawn:i_dawn+rounded_MLTHistos[1,i]-1] = mlts[i]
  ;;       i_dawn += rounded_MLTHistos[1,i]
  ;;    ENDIF
  ;;    ;dusk
  ;;    IF rounded_MLTHistos[2,i] GE 1 THEN BEGIN
  ;;       mltDist[2,i_dusk:i_dusk+rounded_MLTHistos[2,i]-1] = mlts[i]
  ;;       i_dusk += rounded_MLTHistos[2,i]
  ;;    ENDIF

  ;; ENDFOR

  ;as a check, note that i_allIMF should equal total(rounded_MLTHistos[0,*])
  ; or i_dawn should equal total(rounded_MLTHistos[1,*])
  ;They do, so I'm convinced
  ;Here's how to get these distributions:
  ;; allIMF_mlt_dist = TRANSPOSE(mltDist[0,0:i_allIMF-1])
  ;; dawn_mlt_dist = TRANSPOSE(mltDist[1,0:i_dawn-1])
  ;; dusk_mlt_dist = TRANSPOSE(mltDist[2,0:i_dusk-1])

  ;******************************
  ;do ILATs
  ;; ilatDist = MAKE_ARRAY(3,maxHistoBins,VALUE=0.0,/DOUBLE)
  ;; i_allIMF = 0
  ;; i_dawn = 0
  ;; i_dusk = 0
  ;; FOR i=0,nILATBins-1 DO BEGIN
  ;;    ;all IMF
  ;;    IF rounded_ILATHistos[0,i] GE 1 THEN BEGIN
  ;;       ilatDist[0,i_allIMF:i_allIMF+rounded_ILATHistos[0,i]-1] = ilats[i]
  ;;       i_allIMF += rounded_ILATHistos[0,i]
  ;;    ENDIF
  ;;    ;dawn
  ;;    IF rounded_ILATHistos[1,i] GE 1 THEN BEGIN
  ;;       ilatDist[1,i_dawn:i_dawn+rounded_ILATHistos[1,i]-1] = ilats[i]
  ;;       i_dawn += rounded_ILATHistos[1,i]
  ;;    ENDIF
  ;;    ;dusk
  ;;    IF rounded_ILATHistos[2,i] GE 1 THEN BEGIN
  ;;       ilatDist[2,i_dusk:i_dusk+rounded_ILATHistos[2,i]-1] = ilats[i]
  ;;       i_dusk += rounded_ILATHistos[2,i]
  ;;    ENDIF

  ;; ENDFOR

  ;as a check, note that i_allIMF should equal total(rounded_ILATHistos[0,*])
  ; or i_dawn should equal total(rounded_ILATHistos[1,*])
  ;They do, so I'm convinced
  ;Here's how to get these distributions:
  ;; allIMF_ilat_dist = TRANSPOSE(ilatDist[0,0:i_allIMF-1])
  ;; dawn_ilat_dist = TRANSPOSE(ilatDist[1,0:i_dawn-1])
  ;; dusk_ilat_dist = TRANSPOSE(ilatDist[2,0:i_dusk-1])


  ;limits
  fastLocStructLims=make_array(2,2)
  fastLocStructLims[0,*] = [minM,maxM] ; MLT
  fastLocStructLims[1,*] = [minI,maxI] ; ILAT

  ;bin sizes
  fastLocStructBinSizes = make_array(2)
  fastLocStructBinSizes[0] = binM
  fastLocStructBinSizes[1] = binI

  Xsq_stats ={Xsq_statistic:make_array(nDataz,/DOUBLE), $
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

  ;do the Xsq stuff
;;   print,fastLocStructbinsizes
;; ;     0.750000      2.00000
;;   print,fastLocStructlims
;      6.00000      60.0000
;      18.0000      84.0000

  ;do we need cdfs?
  dawn_mlt_cdf=TOTAL(dawn_mlt,/CUMULATIVE)
  dawn_ilat_cdf=TOTAL(dawn_ilat,/CUMULATIVE)
  dusk_ilat_cdf=TOTAL(dusk_ilat,/CUMULATIVE)
  dusk_mlt_cdf=TOTAL(dusk_mlt,/CUMULATIVE)


  ;now chi-square stuff
  xsq_mlt_dawnall = xsq_test(dawn_mlt,all_IMF_mlt)
  xsq_ilat_dawnall = xsq_test(dawn_ilat,all_IMF_ilat)
  xsq_ilat_duskall = xsq_test(dusk_ilat,all_IMF_ilat)
  xsq_mlt_duskall = xsq_test(dusk_mlt,all_IMF_mlt)
  xsq_mlt_duskdawn = xsq_test(dusk_mlt,dawn_mlt)
  xsq_ilat_duskdawn = xsq_test(dusk_ilat,dawn_ilat)

  ;histograms
  ;; allIMF_title='allIMF_N_Events_per_Minute'
  ;; dawn_title='dawn_N_Events_per_Minute'
  ;; dusk_title='dusk_N_Events_per_Minute'

;;   cghistoplot,allimf_mlt_dist, $
;;               BINSIZE=fastLocStructBinSizes[0], LOCATIONS = allIMF_MLT_binLocs, $
;;               HISTDATA=allIMF_MLT_HIST,PROBABILITY_FUNCTION=allIMF_MLT_CDF,/OPROBABILITY, $
;;               MININPUT=fastLocStructLims[0,0],MAXINPUT=fastLocStructLims[0,1], $
;;               OMAX=oMax1,OMIN=oMin1, $
;;               TITLE="MLT_"+allIMF_title, $
;;               OUTPUT="histo_cdf--MLT--"+allIMF_title+".png"

;;   cghistoplot,dawn_mlt_dist, $
;;               BINSIZE=fastLocStructBinSizes[0], LOCATIONS = dawn_MLT_binLocs, $
;;               HISTDATA=dawn_MLT_HIST,PROBABILITY_FUNCTION=dawn_MLT_CDF,/OPROBABILITY, $
;;               MININPUT=fastLocStructLims[0,0],MAXINPUT=fastLocStructLims[0,1], $
;;               OMAX=oMax1,OMIN=oMin1, $
;;               TITLE="MLT_"+dawn_title, $
;;               OUTPUT="histo_cdf--MLT--"+dawn_title+".png"

;;   cghistoplot,dusk_mlt_dist, $
;;               BINSIZE=fastLocStructBinSizes[0], LOCATIONS = dusk_MLT_binLocs, $
;;               HISTDATA=dusk_MLT_HIST,PROBABILITY_FUNCTION=dusk_MLT_CDF,/OPROBABILITY, $
;;               MININPUT=fastLocStructLims[0,0],MAXINPUT=fastLocStructLims[0,1], $
;;               OMAX=oMax1,OMIN=oMin1, $
;;               TITLE="MLT_"+dusk_title, $
;;               OUTPUT="histo_cdf--MLT--"+dusk_title+".png"


;;   cghistoplot,allimf_ilat_dist, $
;;               BINSIZE=fastLocStructBinSizes[1], LOCATIONS = allIMF_ILAT_binLocs, $
;;               HISTDATA=allIMF_ILAT_HIST,PROBABILITY_FUNCTION=allIMF_ILAT_CDF,/OPROBABILITY, $
;;               MININPUT=fastLocStructLims[1,0],MAXINPUT=fastLocStructLims[1,1], $
;;               OMAX=oMax1,OMIN=oMin1, $
;;               TITLE="ILAT_"+allIMF_title, $
;;               OUTPUT="histo_cdf--ILAT--"+allIMF_title+".png"

;;   cghistoplot,dawn_ilat_dist, $
;;               BINSIZE=fastLocStructBinSizes[1], LOCATIONS = dawn_ILAT_binLocs, $
;;               HISTDATA=dawn_ILAT_HIST,PROBABILITY_FUNCTION=dawn_ILAT_CDF,/OPROBABILITY, $
;;               MININPUT=fastLocStructLims[1,0],MAXINPUT=fastLocStructLims[1,1], $
;;               OMAX=oMax1,OMIN=oMin1, $
;;               TITLE="ILAT_"+dawn_title, $
;;               OUTPUT="histo_cdf--ILAT--"+dawn_title+".png"

;;   cghistoplot,dusk_ilat_dist, $
;;               BINSIZE=fastLocStructBinSizes[1], LOCATIONS = dusk_ILAT_binLocs, $
;;               HISTDATA=dusk_ILAT_HIST,PROBABILITY_FUNCTION=dusk_ILAT_CDF,/OPROBABILITY, $
;;               MININPUT=fastLocStructLims[1,0],MAXINPUT=fastLocStructLims[1,1], $
;;               OMAX=oMax1,OMIN=oMin1, $
;;               TITLE="ILAT_"+dusk_title, $
;;               OUTPUT="histo_cdf--ILAT--"+dusk_title+".png"

  nHistBins = [n_elements(dusk_MLT),N_ELEMENTS(dusk_ILAT)]
;; ;just a check
;; ;print,n_elements(dawn_mlt_hist),n_elements(dawn_ilat_hist)
;; ;          17          13

  save,Xsq_mlt_dawnall, $
       Xsq_ilat_dawnall, $
       Xsq_ilat_duskall, $
       Xsq_mlt_duskall, $
       Xsq_mlt_duskdawn, $
       Xsq_ilat_duskdawn, $
       ;; allIMF_ILAT_cdf,dawn_ILAT_CDF,dusk_ILAT_cdf, $
       ;; allIMF_MLT_cdf,dawn_MLT_CDF,dusk_MLT_cdf, $
       fastLocStructLims,fastLocStructBinSizes, $
       nHistBins, $
       ;; allIMF_MLT_binLocs,dawn_MLT_binLocs,dusk_MLT_binLocs, $
       ;; allIMF_ILAT_binLocs,dawn_ILAT_binLocs,dusk_ILAT_binLocs, $
       FILENAME=XsqNEvPerMinOutFile

END