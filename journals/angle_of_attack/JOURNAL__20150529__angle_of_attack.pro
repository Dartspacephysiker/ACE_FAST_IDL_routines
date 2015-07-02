;2015/05/29
;20150513
;Post-thesis proposal
;   The big idea is to figure out if there is a bias in the identification of Alfvén events that corresponds to a certain
;"angle of attack" (as described by Kristina Lynch). The concept is that auroral arcs are very usually elongated in the
;east-west direction, and the change in the B-field as a function of distance that a satellite would measure, cutting
;directly across an arc, vs. that it would measure if it cut obliquely across an arc, would result in (possibly very)
;different calculations in the associated current. 
;   This journal is going to explore how one might calculate such an angle of attack. One naïve estimate is the rate of
;change in MLT relative to {time? ilat? altitude? speed? some combo?}.

;The idea here is to define an "angle of attack" of the FAST satellite relative to the statistical
;Holzworth-Meng auroral oval. It draws upon the lookup table generated in
;JOURNAL__20150529__Holzworth_Meng[...] to get the normal direction for a given MLT.

PRO JOURNAL__20150529__ANGLE_OF_ATTACK

  dataDir='/home/spencerh/Research/Cusp/ACE_FAST/'
  
  ;;Get DB file
  dbFile='/SPENCEdata/Research/Cusp/database/dartdb/saves/Dartdb_02282015--500-14999--maximus--cleaned.sav'
  ;; dbFile='/SPENCEdata/Research/Cusp/database/dartdb/saves/Dartdb_02282015--500-14999--maximus.sav'
  restore,dataDir+dbFile

  dbTimeFile='/SPENCEdata/Research/Cusp/database/dartdb/saves/Dartdb_02282015--500-14999--cdbTime--cleaned.sav'
  ;; dbTimeFile='/SPENCEdata/Research/Cusp/database/dartdb/saves/Dartdb_02282015--500-14999--cdbTime.sav'
  restore,dataDir+dbTimeFile

  ;; ephemeris file  
  ;; ephemFile = 'time_histo_stuff/fastLoc_intervals2--20150409.sav'
  ephemTimeFile='time_histo_stuff/fastLoc_intervals2--20150409--times.sav'
  restore,dataDir+ephemTimeFile

  ;; angle-of-attack file for fastLocDB
  aOaFile='angle_of_attack__fastLocDB_20150409--20150601.sav'
  restore,dataDir+aOaFile

  ;; aOa_fastLoc=angle_of_attack
  ;; dotProds_fastLoc=dotProds
  ;; orbV_fastLoc=orbVectors
  ;; save,aOa_fastLoc,dotProds_fastLoc,orbV_fastLoc,filename='angle_of_attack__fastLocDB_20150409--20150601.sav'

  ;;Get Hw/M structure
  hwMFile='hwMeng_normVectorStruct.sav'
  restore,dataDir+hwMFile

  aOa_maxClean =make_array(n_elements(maximus.orbit),/DOUBLE)
  orbV_maxClean = make_array(2,n_elements(maximus.orbit),/DOUBLE,VALUE=1)
  dotProds_maxClean=make_array(n_elements(maximus.orbit),/DOUBLE)

  hwM_inds = MAKE_ARRAY(n_elements(maximus.orbit),/LONG,VALUE=0) ;I'm assuming no orbit will have more than 100000 events
           
  ;; FOR k=0,N_ELEMENTS(cdbTime)-1 DO BEGIN
  ;;    near = Min(Abs(cdbTime-fastLoc_times), temp)
  ;;    hwM_inds(k) = temp
  ;; ENDFOR

  hwM_inds=VALUE_LOCATE(fastLoc_times,cdbTime)

  dotProds_maxClean=dotProds_fastLoc(hwM_inds)
  aOa_maxClean=aOa_fastLoc(hwM_inds)
  orbV_maxClean = orbV_maxClean(*,hwM_inds)

  ;; dotProds_maxClean(where(ABS(dotProds_maxClean) LT 1e-15)) = 0.
  aOa_maxClean=180/!PI*ACOS(dotProds_maxClean)

  print,"Whoa."
  cghistoplot,dotProds_maxClean,mininput=-1,maxinput=1,output='histogram_dotProds__for_DartDB_cleaned_20150602.png',title="Dot product values for Dartmouth FAC database (N=772291)"
  cghistoplot,aOa_maxClean,mininput=0,maxinput=180
  cghistoplot,aOa_maxClean,mininput=0,maxinput=180,output='histogram_angle_of_attack__for_DartDB_cleaned_20150602.png',title="Angles of attack for Dartmouth FAC database (N=772291)"

  save,aOa_maxClean,dotProds_maxClean,orbV_maxClean,filename='angle_of_attack__DartDB_20150228_cleaned--20150601.sav'

END