;;2017/01/28
PRO JOURNAL__20170128__ZHANG_2014__SCRATCHPAD__DOODAD__NEWELLED_CUSP_STATS

  COMPILE_OPT IDL2

  magc10files   = 0

  ;; dir           = '/home/spencerh/Desktop/Spence_paper_drafts/2017/Alfvens_IMF/dataFiles/'
  dir           = '/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/saves_output_etc/20170129/'
  statsFile     = 'OMNI_stats--Alfvens_dodat_20170127.sav'
  reg10File    = 'Alfvens_IMF-inds--10magc--north_hemi-20170129.sav'
  NC10File     = 'Alfvens_IMF-inds--10magc--NC-north_hemi-20170129.sav'
  invNC10File  = 'Alfvens_IMF-inds--10magc--invNC-north_hemi-20170129.sav'
  regFile    = 'Alfvens_IMF-inds--north_hemi-20170129.sav'
  NCFile     = 'Alfvens_IMF-inds-NC-north_hemi-20170129.sav'
  invNCFile  = 'Alfvens_IMF-inds-invNC-north_hemi-20170129.sav'

  RESTORE,dir+statsFile

  @common__maximus_vars.pro
  IF N_ELEMENTS(MAXIMUS__maximus) EQ 0 THEN BEGIN
     LOAD_MAXIMUS_AND_CDBTIME
  ENDIF

  RESTORE,dir+regFile
  regIndList          = TEMPORARY(OUT_PLOT_I_LIST)

  nRegArr             = !NULL
  FOR k=0,N_ELEMENTS(regIndList)-1 DO BEGIN
     regIndList[k]     = (regIndList[k])[WHERE(MAXIMUS__maximus.MLT[regIndList[k]] GE 9.5 AND $
                                             MAXIMUS__maximus.MLT[regIndList[k]] LE 14.5,nReg)]
     nRegArr          = [nRegArr,nReg]
  ENDFOR

  RESTORE,dir+NCFile
  NCIndList           = TEMPORARY(OUT_PLOT_I_LIST)

  nNCArr              = !NULL
  FOR k=0,N_ELEMENTS(NCIndList)-1 DO BEGIN
     NCIndList[k]     = (NCIndList[k])[WHERE(MAXIMUS__maximus.MLT[NCIndList[k]] GE 9.5 AND $
                                             MAXIMUS__maximus.MLT[NCIndList[k]] LE 14.5,nNC)]
     nNCArr           = [nNCArr,nNC]
  ENDFOR

  RESTORE,dir+invNCFile
  invNCIndList        = TEMPORARY(OUT_PLOT_I_LIST)

  ninvNCArr           = !NULL
  FOR k=0,N_ELEMENTS(invNCIndList)-1 DO BEGIN
     invNCIndList[k]  = (invNCIndList[k])[WHERE(MAXIMUS__maximus.MLT[invNCIndList[k]] GE 9.5 AND $
                                                MAXIMUS__maximus.MLT[invNCIndList[k]] LE 14.5,ninvNC)]
     ninvNCArr        = [ninvNCArr,ninvNC]
  ENDFOR

  RESTORE,dir+reg10File
  reg10IndList          = TEMPORARY(OUT_PLOT_I_LIST)

  nReg10Arr             = !NULL
  FOR k=0,N_ELEMENTS(reg10IndList)-1 DO BEGIN
     reg10IndList[k]     = (reg10IndList[k])[WHERE(MAXIMUS__maximus.MLT[reg10IndList[k]] GE 9.5 AND $
                                             MAXIMUS__maximus.MLT[reg10IndList[k]] LE 14.5,nReg10)]
     nReg10Arr          = [nReg10Arr,nReg10]
  ENDFOR

  RESTORE,dir+NC10File
  NC10IndList           = TEMPORARY(OUT_PLOT_I_LIST)

  nNC10Arr              = !NULL
  FOR k=0,N_ELEMENTS(NC10IndList)-1 DO BEGIN
     NC10IndList[k]     = (NC10IndList[k])[WHERE(MAXIMUS__maximus.MLT[NC10IndList[k]] GE 9.5 AND $
                                             MAXIMUS__maximus.MLT[NC10IndList[k]] LE 14.5,nNC10)]
     nNC10Arr           = [nNC10Arr,nNC10]
  ENDFOR

  RESTORE,dir+invNC10File
  invNC10IndList        = TEMPORARY(OUT_PLOT_I_LIST)

  ninvNC10Arr           = !NULL
  FOR k=0,N_ELEMENTS(invNC10IndList)-1 DO BEGIN
     invNC10IndList[k]  = (invNC10IndList[k])[WHERE(MAXIMUS__maximus.MLT[invNC10IndList[k]] GE 9.5 AND $
                                                MAXIMUS__maximus.MLT[invNC10IndList[k]] LE 14.5,ninvNC10)]
     ninvNC10Arr        = [ninvNC10Arr,ninvNC10]
  ENDFOR

  pctKept   = (nRegArr  -nInvNCarr  )/FLOAT(nRegArr  )*100.
  pctKept10 = (nReg10Arr-nInvNC10Arr)/FLOAT(nReg10Arr)*100.

  pctLost   = (nRegArr  -nNCArr  )/FLOAT(nRegArr  )*100.
  pctLost10 = (nReg10Arr-nNC10Arr)/FLOAT(nReg10Arr)*100.

  PRINT,FORMAT='(A10,T15,A6,T22,A6,T36,A6,T45,A6,T59,A6,T67,A6,T81,A7,T89,A6,T103,A7,T111,A6)', $
        "Clock","nRegulier","(m10)","nNC","(m10)","nInvNC","(m10)","PctKept","(m10)","PctLost","(m10)"
  ;; FOR k=0,7 DO PRINT,FORMAT='(A10,T15,I10,T30,I10,T45,I10,T60,F0.2)',stats.clockStr[k],nRegArr[k],nNCArr[k],nInvNCArr[k],pctKept[k]
  FOR k=0,7 DO PRINT,FORMAT='(A10,T15,I6,T22,I6,T36,I6,T45,I6,T59,I6,T67,I6,T81,F0.2,T89,F0.2,T103,F0.2,T111,F0.2)', $
                     stats.clockStr[k],nRegArr[k],nReg10Arr[k],nNCArr[k],nNC10Arr[k],nInvNCArr[k],nInvNC10Arr[k],pctKept[k],pctKept10[k],pctLost[k],pctLost10[k]

  STOP

END
