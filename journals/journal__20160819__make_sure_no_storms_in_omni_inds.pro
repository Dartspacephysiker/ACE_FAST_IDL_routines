;;08/19/16
PRO JOURNAL__20160819__MAKE_SURE_NO_STORMS_IN_OMNI_INDS

  COMPILE_OPT IDL2,STRICTARRSUBS

  DstCutoff     = -20

  indFile       = '/home/spencerh/Desktop/Spence_paper_drafts/2016/Alfvens_IMF/avg_IMF_conds/20160819--btMin_2.0--OMNI_stats--nonstorm/master_OMNI_ind_list--Alfvens_IMF_v4.sav'
  stormFile     = '/SPENCEdata/Research/database/temps/todays_nonstorm_mainphase_and_recoveryphase_OMNIdb_inds--dstCutoff_-20nT20160819.sav'

  ;; stormFile  = TODAYS_NONSTORM_MAINPHASE_AND_RECOVERYPHASE_OMNIDB_INDICES(DSTCUTOFF=DstCutoff)

  RESTORE,indFile
  RESTORE,stormFile

  FOR i=0,7 DO BEGIN
     testMe = CGSETDIFFERENCE(stable_omni_ind_list[i],ns_i,COUNT=testCount,NORESULT=-1)
     IF testMe EQ -1 THEN BEGIN
        PRINT,FORMAT='(A0,T20,": All non-storm")',clockStr_list[i]
     ENDIF ELSE BEGIN
        PRINT,FORMAT='(A0,T20,": ",I8,TR5,"storm events!!")',clockStr_list[i],testCount
     ENDELSE
  ENDFOR

  STOP

END
