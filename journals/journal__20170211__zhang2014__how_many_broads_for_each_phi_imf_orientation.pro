;;2017/02/11
PRO JOURNAL__20170211__ZHANG2014__HOW_MANY_BROADS_FOR_EACH_PHI_IMF_ORIENTATION

  COMPILE_OPT IDL2

  indsDir     = '/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/temp/'
  indsFil     = 'multi_PASIS_vars-eSpec-w_t-NWO--upto90-Dst_-50750-4300_km--orbs_500-12670-NORTH-0sampT-avgnStorm_9stable_0.0Del_30.0Res_0.0Ofst_btMin1.0-Ring.sav'

  alfIndsFil  = 'multi_PASIS_vars-alfDB-w_t-Dst_-50--upto90ILAT750-4300km-orb_500-12670-NORTH-cur_-1-1-avgnStorm_9stable_0.0Del_30.0Res_0.0Ofst_btMin1.0-Ring.sav'

  statsDir    = '/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/saves_output_etc/20170210/'
  statsFil    = 'OMNI_stats--Alfvens_dodat_20170210.sav'

  
  RESTORE,indsDir+indsFil
  RESTORE,statsDir+statsFil
  RESTORE,indsDir+alfIndsFil

  ;;Sort the clock inds
  sC_i        = SORT(stats.clockStr) 
  oi          = [sC_i[0],sC_i[2],sC_i[4],sC_i[3],sC_i[1],sC_i[6],sC_i[7],sC_i[5]]

  nClockStr   = N_ELEMENTS(stats.clockStr)
  nBArr       = MAKE_ARRAY(nClockStr,/LONG)
  nDArr       = MAKE_ARRAY(nClockStr,/LONG)
  nMArr       = MAKE_ARRAY(nClockStr,/LONG)

  pBArr       = MAKE_ARRAY(nClockStr,/FLOAT)
  pDArr       = MAKE_ARRAY(nClockStr,/FLOAT)
  pMArr       = MAKE_ARRAY(nClockStr,/FLOAT)

  nAlfArr     = MAKE_ARRAY(nClockStr,/FLOAT)
  alfBRatArr  = MAKE_ARRAY(nClockStr,/FLOAT)

  PRINT,FORMAT='(A0,T15,A0,T25,A0,T35,A0,T45,A0,T55,A0,T65,A0,T75,A0,T85,A0)',"clockStr","nTot","%","nBroad","%","nDiff","%","nMono","%"
  FOREACH k,oi DO BEGIN
     ;; actK = oi[k]
     SPLIT_ESPECDB_I_BY_ESPEC_TYPE,pasis__indices__espec_list[k], $
                                   PURE_B_I=pure_b_i, $
                                   PURE_D_I=pure_d_i, $
                                   PURE_M_I=pure_m_i, $
                                   /QUIET

     nTot = N_ELEMENTS(pasis__indices__espec_list[k])
     nB   = N_ELEMENTS(pure_b_i)
     nD   = N_ELEMENTS(pure_d_i)
     nM   = N_ELEMENTS(pure_m_i)

     pTot = 100
     pB   = nB/FLOAT(nTot)*100
     pD   = nD/FLOAT(nTot)*100
     pM   = nM/FLOAT(nTot)*100
     PRINT,FORMAT='(A0,T15,I0,T25,F0.2,"%",T35,I0,T45,F0.2,"%",T55,I0,T65,F0.2,"%",T75,I0,T85,F0.2,"%")', $
           stats.clockStr[k],nTot,pTot,nB,pB,nD,pD,nM,pM

     ;; nBArr = [nBArr,nB]
     ;; nDArr = [nDArr,nD]
     ;; nMArr = [nMArr,nM]

     ;; pBArr = [pBArr,pB]
     ;; pDArr = [pDArr,pD]
     ;; pMArr = [pMArr,pM]
     nBArr[k] = nB
     nDArr[k] = nD
     nMArr[k] = nM

     pBArr[k] = pB
     pDArr[k] = pD
     pMArr[k] = pM
  ENDFOREACH
  PRINT,""

  PRINT,FORMAT='(A0,T15,A0,T25,A0)',"clockStr","nAlf","AlfBRat"
  FOREACH k,oi DO BEGIN

     nAlfArr[k]    = N_ELEMENTS(PASIS__plot_i_list[k])
     alfBRatArr[k] = nAlfArr[k]/nBArr[k]

     PRINT,FORMAT='(A0,T15,I0,T25,F0.2)',stats.clockStr[k],nAlfArr[k],alfBRatArr[k]

  ENDFOREACH

END
