;2015/05/26
;The idea is to see how much time typically elapses between the last event on a given orbit and the
;first event on the following orbit to get a sense of time scales

PRO JOURNAL__20150526__delta_t_between_orbit_obs_for_a_given_hemisphere,HEMI=hemi

	;restore db
  dbDir='/SPENCEdata/Research/Cusp/ACE_FAST/scripts_for_processing_Dartmouth_data/'
  dbFile='Dartdb_02282015--500-14999--maximus--cleaned.sav'
  dbTimeFile='Dartdb_02282015--500-14999--cdbTime--cleaned.sav'
  
  defHemi='North'
  IF NOT KEYWORD_SET(hemi) then hemi=defHemi

  restore,dbDir+dbFile
  restore,dbDir+dbTimeFile
  
;**************************************************
;Restrictions on DB
  
;hemisphere restrictions
  IF hemi EQ 'North' THEN BEGIN
;northern hemi
     maximus=resize_maximus(maximus,maximus_ind=5,max_for_ind=90,min_for_ind=55,CDBTIME=cdbTime)
  ENDIF ELSE BEGIN
;southern hemi
     maximus=resize_maximus(maximus,maximus_ind=5,max_for_ind=-55,min_for_ind=-90,CDBTIME=cdbTime)
  ENDELSE  
;current restrictions
  maximus=resize_maximus(maximus,maximus_ind=6,max_for_ind=1000,min_for_ind=10,/ONLY_ABSVALS,CDBTIME=cdbTime)
  
;**************************************************
;Set up arrays to be used
  avg_diff_t_arr=make_array(10000,/DOUBLE)
  orb_diff_t_arr=make_array(10000,/DOUBLE)
  
  i_orb_diff=0
  i_avg_diff=0
  
;**************************************************
;Set up output file
;lun=-1   ;stdout
  OPENW,lun,'outfile.txt',/GET_LUN
  PRINTF,lun,FORMAT='(A0,T45,A0,"ern hemisphere")',TIMESTAMP(),hemi
  PRINTF,lun,''
  PRINTF,lun,"T_ORB gives the time between the first event on the current orbit and the last event on the last orbit with events observed"
  PRINTF,lun,''
  PRINTF,lun,FORMAT='("ORBIT",T15,"N EVENTS",T25,"AVG. T BETWEEN EVENTS (s)",T55,"T_ORB (s)")'
  
;**************************************************
;Now some calculations
  
;first orbit
  uniqueOrbs_i=UNIQ(maximus.orbit,SORT(maximus.orbit))
  curOrb=maximus.orbit(uniqueOrbs_i(0))
  curOrb_i=WHERE(maximus.orbit EQ curOrb)
  nEvents=N_ELEMENTS(curOrb_i)
  IF nEvents GT 1 THEN BEGIN
;Get average time between events
     curTimes = cdbTime(curOrb_i)
     diff_t=curtimes-shift(curtimes,1)
     avg_diff_t=mean(diff_t(1:-1))
     avg_diff_t_arr(i_avg_diff)=avg_diff_t
     i_avg_diff++

     PRINTF,lun,FORMAT='(I0,T15,I0,T25,F0.3)',curOrb,nEvents,avg_diff_t
        
  ENDIF ELSE BEGIN
     curTimes = cdbTime(curOrb_i)
     PRINTF,lun,FORMAT='(I0,T15,I0)',curOrb,nEvents
  ENDELSE
  
  FOR orb_i=1,n_elements(uniqueOrbs_i)-1 DO BEGIN
     prevOrb=curOrb
     latest_t=curTimes(-1)      ;update latest_t for next loop
     
     curOrb=maximus.orbit(uniqueOrbs_i(orb_i))
     curOrb_i=WHERE(maximus.orbit EQ curOrb)
     
                                ;Find out diff between latest obs in last orb and earliest obs in this orb
     earliest_t=cdbTime(curOrb_i(0))
     orb_diff_t=earliest_t-latest_t
     orb_diff_t_arr(i_orb_diff)=orb_diff_t
     nEvents=N_ELEMENTS(curOrb_i)

                                ;if multiple events, get avg time between obs
     IF nEvents GT 1 THEN BEGIN
        
                                ;Get average time between events
        curTimes = cdbTime(curOrb_i)
        diff_t=curtimes-shift(curtimes,1)
        avg_diff_t=mean(diff_t(1:-1))
        
        avg_diff_t_arr(i_avg_diff)=avg_diff_t ;Add this avg_diff_t to the array
        i_avg_diff++
        
        PRINTF,lun,FORMAT='(I0,T15,I0,T25,F0.3,T55,F0.3)',curOrb,nEvents,avg_diff_t,orb_diff_t
        
     ENDIF ELSE BEGIN
        curTimes = cdbTime(curOrb_i)
        PRINTF,lun,FORMAT='(I0,T15,I0,T55,F0.3)',curOrb,nEvents,orb_diff_t
     ENDELSE
     
  ENDFOR
  
END