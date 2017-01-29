;;01/28/17
PRO JOURNAL__20170128__ZHANG_2014__SCRATCHPAD__DOODAD

  COMPILE_OPT IDL2

  second_set = 1

  dir       = '/home/spencerh/Desktop/Spence_paper_drafts/2017/Alfvens_IMF/dataFiles/'
  statsFile = 'OMNI_stats--Alfvens_dodat_20170127.sav'

  IF KEYWORD_SET(second_set) THEN BEGIN
     PRINT,"customInteg__70-80ILAT__6-12MLT"
     PRINT,"BUT YOU HAVEN'T ACTUALLY MADE THOSE JOINALS YET!!"
     
     h2dDir = '~/Research/Satellites/FAST/OMNI_FAST/temp/'
     pFFile     = h2dDir + 'polarplots_Dst_-50750-4300km-orb_500-12670-NORTH-cur_-1-1-avgnStorm_9stable_0.0Del_30.0Res_0.0Ofst_btMin1.0-Ring_tAvgd_pF_pF.dat'

     eFFile     = h2dDir + 'polarplots_Dst_-50750-4300km-orb_500-12670-NORTH-cur_-1-1-avgnStorm_9stable_0.0Del_30.0Res_0.0Ofst_btMin1.0-Ring_tAvgd_sptAvg_NoN-eNumFl_eF_LC_intg.dat' 
     broadNFile = h2dDir + 'polarplots_NWO-Dst_-50750-4300_km--orbs_500-12670-NORTH-0sampT-avgnStorm_9stable_0.0Del_30.0Res_0.0Ofst_btMin1.0-Ring_tAvgd_NoN-eNumFl-all_fluxes_eSpec-2009_broad.dat'

  ENDIF ELSE BEGIN
     PRINT,"customInteg__70-80ILAT__7.5-10.5MLT"

     H2DDir     = '~/Desktop/Spence_paper_drafts/2017/Alfvens_IMF/dataFiles/'
     pFFile     = h2dDir + 'tAvgd_pF__customInteg__70-80ILAT__7.5-10.5MLT.sav'

     eFFile     = h2dDir + 'tAvgd_eF__customInteg__70-80ILAT__7.5-10.5MLT.sav'
     broadNFile = h2dDir + 'tAvgd_eNumF_broadband__customInteg__70-80ILAT__7.5-10.5MLT.sav'
  ENDELSE

  RESTORE,dir+statsFile

  RESTORE,pfFile
  pFH2D = h2dStrArr
  pFDay = pFH2D.grossintegrals.day/pFH2D.grossintegrals.total*100.
  pFDayPMax = pFH2D.grossintegrals.day/MAX(pFH2D.grossintegrals.day)
  pFCust = pFH2D.grossintegrals.custom/pFH2D.grossintegrals.total*100.
  pFCustPNorte = pFH2D.grossintegrals.custom/pFH2D[0].grossintegrals.custom
  
  RESTORE,eFFile
  eFH2D    = h2dStrArr
  eFDay    = eFH2D.grossintegrals.day/eFH2D.grossintegrals.total*100.
  eFDayPMax = eFH2D.grossintegrals.day/MAX(eFH2D.grossintegrals.day)
  eFCust    = eFH2D.grossintegrals.custom/eFH2D.grossintegrals.total*100.
  eFCustPNorte = eFH2D.grossintegrals.custom/eFH2D[0].grossintegrals.custom

  RESTORE,broadNFile
  broadH2D = h2dStrArr
  broadDay = broadH2D.grossintegrals.day/broadH2D.grossintegrals.total*100. 
  broadDayPMax = broadH2D.grossintegrals.day/MAX(broadH2D.grossintegrals.day)

  ;;Fixksidaf;ljk
  ;; broadCust = broadH2D.grossintegrals.day/broadH2D.grossintegrals.total*100. 
  ;; broadCustPNorte = broadH2D.grossintegrals.day/MAX(broadH2D.grossintegrals.day)
  broadCust = broadH2D.grossintegrals.custom/broadH2D.grossintegrals.total*100. 
  broadCustPNorte = broadH2D.grossintegrals.custom/broadH2D[0].grossintegrals.custom

  PRINT,"DAYSIDE PORCENTAJE"
  PRINT,FORMAT='(T20,A0,T30,A0,T40,A0)',"Alfic pF","Alfic eF","broad NF"
  FOR k=0,7 DO BEGIN & PRINT,FORMAT='(I02,T5,A10,T20,F0.2,T30,F0.2,T40,F0.2)', $
                             k,stats.clockStr[k],pFDay[k],eFDay[k],broadDay[k] & ENDFOR
   
  PRINT,"DAYSIDE PORCENTAJE DE MÁXIMO"
  FOR k=0,7 DO BEGIN & PRINT,FORMAT='(I02,T5,A10,T20,F0.2,T30,F0.2,T40,F0.2)', $
                             k,stats.clockStr[k],pFDayPMax[k],eFDayPMax[k],broadDayPMax[k] & ENDFOR

  PRINT,'7.5--10.5 MLT PORCENTAJE'
  PRINT,FORMAT='(T20,A0,T30,A0,T40,A0)',"Alfic pF","Alfic eF","broad NF"
  FOR k=0,7 DO BEGIN & PRINT,FORMAT='(I02,T5,A10,T20,F0.2,T30,F0.2,T40,F0.2)', $
                             k,stats.clockStr[k],pFCust[k],eFCust[k],broadCust[k] & ENDFOR
   
  PRINT,'7.5--10.5 MLT PORCENTAJE DE NORTE'
  FOR k=0,7 DO BEGIN & PRINT,FORMAT='(I02,T5,A10,T20,F0.2,T30,F0.2,T40,F0.2)', $
                             k,stats.clockStr[k],pFCustPNorte[k],eFCustPNorte[k],broadCustPNorte[k] & ENDFOR

  maxStdDev   = MAX(stats.stdDev.swSpeed,maxInd)
  units       = 'km/s'
  thing       = "SW STDDEV"
  PRINT,FORMAT='(A0," (porcentaje de máximo, ",F0.2," ",A0," under ",A0, " IMF)")',thing,maxStdDev/1000.0,units,stats.clockStr[maxInd]
  FOR k=0,7 DO BEGIN & PRINT,FORMAT='(I02,T5,A10,T20,F0.2,T30,F0.2,T40,F0.2)',k,stats.clockStr[k], $
                             stats.stdDev.swSpeed[k]/1000.,stats.stdDev.swSpeed[k]/maxStdDev & ENDFOR

END
