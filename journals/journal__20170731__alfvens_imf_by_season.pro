;2017/07/31
PRO JOURNAL__20170731__ALFVENS_IMF_BY_SEASON

  COMPILE_OPT IDL2,STRICTARRSUBS

  LOAD_MAXIMUS_AND_CDBTIME,!NULL,CDBTime,/NO_MEMORY_LOAD,/JUST_CDBTIME

  hemi    = 'NORTH'

  prettyPrint = 1
  
  dirDir  = '/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/temp/'
  myFile  = 'alfDB_uniqInds_CHECK_BECAUSEYOUHAVENTYET.sav'

  clockStrings = ['bzNorth','dusk-north','duskward','dusk-south','bzSouth','dawn-south','dawnward','dawn-north']

  IF FILE_TEST(dirDir+myFile) THEN BEGIN

     RESTORE,dirDir+myFile
     
  ENDIF ELSE BEGIN
     PRINT,"Better pay a visit to JOURNAL__20170722__AVG_OVER_DELAYS__CUSTOM_NIGHTTIME_DELAY__OVERPLOTTER.PRO, since that's where you're going to make this file that you so badly need"
     STOP
     ;;The line looks like this:
     ;; SAVE,totindslist,accelindslist,cuspaccelindslist, $
     ;;      cuspnotaccelindslist,notcuspaccelindslist,notcuspnotaccelindslist, $
     ;;      dayIndsList,nitIndsList, $
     ;;      totallguys, $
     ;;      FILENAME=dirdir+myfile
  ENDELSE

  ;; FOR 
     
  IF KEYWORD_SET(prettyPrint) THEN BEGIN
     prettyClock = ['Northward','Dawn-North','Dawnward','Dawn-South','Southward','Dusk-South','Duskward','Dusk-North']
     ampSpace = ' & '
     retStr   = ' \\'
  ENDIF
  
  indStructList = LIST()
  FOREACH IMF,clockStrings,iIMF DO BEGIN
     
     ;; test = (N_ELEMENTS(GET_SEASON_INDS(CDBTime[totIndsList[iIMF]],/SPRING)) + N_ELEMENTS(GET_SEASON_INDS(CDBTime[totIndsList[iIMF]],/SUMMER)) +
     ;; N_ELEMENTS(GET_SEASON_INDS(CDBTime[totIndsList[iIMF]],/FALL )) + N_ELEMENTS(GET_SEASON_INDS(CDBTime[totIndsList[iIMF]],/WINTER))) EQ N_ELEMENTS(CDBTime[totIndsList[iIMF]])

     times = CDBTime[totIndsList[iIMF]]
     indsList = GET_SEASON_INDS(times, $
                                SPRING=spring, $
                                SUMMER=summer, $
                                FALL=fall, $
                                WINTER=winter, $
                                /ALL_SEASONS, $
                                HEMI=hemi, $
                                ;; USE_JULDAY=use_julDay, $
                                OUT_IND_STRUCT=indStruct, $
                                /QUIET)

     tot = TOTAL(indStruct.N[0:3])
     pctg = indStruct.N/FLOAT(tot)*100.

     IF KEYWORD_SET(prettyPrint) THEN BEGIN

        IF iIMF EQ 0 THEN BEGIN
           PRINT,FORMAT='(A0,T35,A0,A0,A0,T50,A0,A0,T65,A0,A0,T80,A0,A0,T95,A0,A0,T110,A0,A0)', $
                 '$phi_{\textrm{\textsc{IMF}}}$',ampSpace, $
                 ' N ',ampSpace, $
                 indStruct.season[0],ampSpace, $
                 indStruct.season[1],ampSpace, $
                 indStruct.season[2],ampSpace, $
                 indStruct.season[3],ampSpace, $
                 indStruct.season[4],retStr
           ;; PRINT,FORMAT='(A0,A0,T15,A0,A0,T30,A0,A0,T45,A0,A0,T60,A0,A0,T75,A0)','', $
           ;;       indStruct.season[0],ampSpace, $
           ;;       indStruct.season[1],ampSpace, $
           ;;       indStruct.season[2],ampSpace, $
           ;;       indStruct.season[3],ampSpace, $
           ;;       indStruct.season[4],retStr
        ENDIF
           
           PRINT,FORMAT='(A0,T35,A0,I0,A0,T50,F0.2,A0,T65,F0.2,A0,T80,F0.2,A0,T95,F0.2,A0,T110,F0.2,A0)', $
                 prettyClock[iIMF],ampSpace, $
                 N_ELEMENTS(times),ampSpace, $
                 pctg[0],ampSpace, $
                 pctg[1],ampSpace, $
                 pctg[2],ampSpace, $
                 pctg[3],ampSpace, $
                 pctg[4],retStr

        ENDIF ELSE BEGIN

           IF iIMF EQ 0 THEN PRINT,FORMAT='(A0,T15,A0,T30,A0,T45,A0,T60,A0,T75,A0)','',indStruct.season
           PRINT,FORMAT='(A0,T15,I5," (",F0.2,")",T30,I5," (",F0.2,")",T45,I5," (",F0.2,")",T60,I5," (",F0.2,")",T75,I5," (",F0.2,")")', $
                 clockStrings[iIMF], $
                 indStruct.N[0], $
                 pctg[0], $
                 indStruct.N[1], $
                 pctg[1], $
                 indStruct.N[2], $
                 pctg[2], $
                 indStruct.N[3], $
                 pctg[3], $
                 indStruct.N[4], $
                 pctg[4]

        ENDELSE

     ;; PRINT,FORMAT='(A0,T15,F0.2,T25,F0.2,T35,F0.2,T45,F0.2,T55,F0.2)','', $
     ;;       indStruct.N/FLOAT(tot)*100.

     indStructList.Add,TEMPORARY(indStruct)

   ;; test = (N_ELEMENTS(GET_SEASON_INDS(CDBTime[totIndsList[iIMF]],/SPRING)) + N_ELEMENTS(GET_SEASON_INDS(CDBTime[totIndsList[iIMF]],/SUMMER)) +
   ;;   N_ELEMENTS(GET_SEASON_INDS(CDBTime[totIndsList[iIMF]],/FALL )) + N_ELEMENTS(GET_SEASON_INDS(CDBTime[totIndsList[iIMF]],/WINTER))) EQ N_ELEMENTS(CDBTime[totIndsList[iIMF]])

  ENDFOREACH

  STOP

END
