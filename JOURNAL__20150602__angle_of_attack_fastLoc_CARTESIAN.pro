;2015/06/02
;There are some issues with NaNs when the longitude doesn't change at all, so we've got to go
;Cartesian, baby.

;2015/05/29
;The idea here is to define an "angle of attack" of the FAST satellite relative to the statistical
;Holzworth-Meng auroral oval. It draws upon the lookup table generated in
;JOURNAL__20150529__Holzworth_Meng[...] to get the normal direction for a given MLT.

PRO JOURNAL__20150602__ANGLE_OF_ATTACK_FASTLOC_CARTESIAN

  dataDir='/home/spencerh/Research/Cusp/ACE_FAST/'
  
  ;;Get DB file
  ;; dbFile='/SPENCEdata/Research/Cusp/database/dartdb/saves/Dartdb_02282015--500-14999--maximus--cleaned.sav'
  ;; dbFile='/SPENCEdata/Research/Cusp/database/dartdb/saves/Dartdb_02282015--500-14999--maximus.sav'
  ;; restore,dataDir+dbFile

  ;; ephemeris file
  
  ephemFile = 'time_histo_stuff/fastLoc_intervals2--20150409.sav'
  restore,dataDir+ephemFile

  ;; help,fastLoc

  ;; ** Structure <125dd48>, 9 tags, length=307544336, data length=307544328, refs=1:
  ;;    ORBIT           LONG      Array[4271449]
  ;;    TIME            STRING    Array[4271449]
  ;;    ALT             FLOAT     Array[4271449]
  ;;    MLT             FLOAT     Array[4271449]
  ;;    ILAT            FLOAT     Array[4271449]
  ;;    FIELDS_MODE     FLOAT     Array[4271449]
  ;;    INTERVAL        LONG      Array[4271449]
  ;;    INTERVAL_START  STRING    Array[4271449]
  ;;    INTERVAL_STOP   STRING    Array[4271449]
  
  ;;Get Hw/M structure
  hwMFile='hwMeng_normVectorStruct.sav'
  restore,dataDir+hwMFile

  ;; help,hwM_normVecS
  
  ;; ** Structure HWM_NORMVECS, 11 tags, length=96072, data length=96056:
  ;;    NMLTS           INT           2400
  ;;    MLTS            DOUBLE    Array[2400]
  ;;    MINMLT          INT              0
  ;;    MAXMLT          INT             24
  ;;    SLOPE_SCHEME    STRING    'Centered difference'
  ;;    CREATION_DATE   STRING    '2015-05-29T14:54:22.0000630617111Z'
  ;;    NORMVECTORS     DOUBLE    Array[2, 2400]
  ;;    NORMVECSTRUCT   STRING    'normVectors[0:*] --> normed delta_MLTs'...
  ;;    BNDRY_EQWARD    DOUBLE    Array[2400]
  ;;    BNDRY_POLEWARD  DOUBLE    Array[2400]
  ;;    ACTIVITY_LEVEL  INT              7

  ;; Go on an orbit-by-orbit basis
  
  ;; angle_of_attack =make_array(n_elements(maximus.orbit),/float)
  angle_of_attack =make_array(n_elements(fastLoc.orbit),/DOUBLE)
  orbVectors = make_array(2,n_elements(fastLoc.orbit),/DOUBLE,VALUE=1)
  dotProds=make_array(n_elements(fastLoc.orbit),/DOUBLE)

  orbMin = 500
  orbMax = 15000
  cur_i  = 0
  hwM_inds = MAKE_ARRAY(100000,/INTEGER,VALUE=0) ;I'm assuming no orbit will have more than 100000 events

  FOR curOrb=orbMin,orbMax DO BEGIN

     curOrb_i = WHERE(fastLoc.orbit EQ curOrb,/NULL)
     curOrb_nEvents = N_ELEMENTS(curOrb_i)
     
     ;We use hemi only to flip the sign of ILAT in the HwM lookup vectors, since the
     ;statistical auroral oval in the southern hemi is just a mirror reflection of that in the
     ;northern hemi
     IF curOrb_nEvents GT 0 THEN BEGIN
        hemi = FIX(fastLoc.ILAT(curOrb_i) GT 0)
        hemi(WHERE(hemi LT 1)) = -1
     ENDIF

     CASE 1 OF
        (curOrb_nEvents EQ 1): BEGIN
           angle_Of_Attack(cur_i) = -900.
           cur_i++
        END
        (curOrb_nEvents EQ 2): BEGIN

           delt_ILAT = (fastLoc.ILAT(curOrb_i))(1)-(fastLoc.ILAT(curOrb_i))(0)
           delt_MLT = (fastLoc.MLT(curOrb_i))(1)-(fastLoc.MLT(curOrb_i))(0)

           slope = delt_ILAT/(delt_MLT*15)
           ;; sign  = delt_MLT/abs(delt_MLT)
           normFactor = 1/SQRT(1+slope^2)

           ;; orbVectors = make_array(2,curOrb_nEvents,/DOUBLE,VALUE=1)
           orbVectors(1,cur_i:cur_i+curOrb_nEvents-1) = slope
           ;; orbVectors(cur_i:cur_i+curOrb_nEvents-1) = transpose([[normFactor],[normFactor]])*orbVectors(cur_i:cur_i+curOrb_nEvents-1)
           FOR k=0,1 DO orbVectors(k,cur_i:cur_i+curOrb_nEvents-1) = normFactor*orbVectors(k,cur_i:cur_i+curOrb_nEvents-1)

           ;now match the MLTs of FAST data points with the closest value in the hwM_normVecs lookup table
           FOR j=0,curOrb_nEvents-1 DO BEGIN
              near = Min(Abs(hwM_normVecs.MLTs-(fastLoc.MLT(curOrb_i))(j)), temp)
              hwM_inds(j) = temp
           ENDFOR

           ;now dot product
           dotProds(cur_i:cur_i+curOrb_nEvents-1)=orbVectors(0,cur_i:cur_i+curOrb_nEvents-1)*hwM_normVecs.normVectors(0,hwM_inds(0:curOrb_nEvents-1)) + $
                    hemi*orbVectors(1,cur_i:cur_i+curOrb_nEvents-1)*hwM_normVecs.normVectors(1,hwM_inds(0:curOrb_nEvents-1))
                                
           ;new angles of attack
           ;; angle_of_attack(cur_i:cur_i+curOrb_nEvents-1)=180/!PI*ACOS(dotProds(cur_i:cur_i+curOrb_nEvents-1))*sign
           
           ;update counter
           cur_i = cur_i + curOrb_nEvents

        END
        (curOrb_nEvents GE 3): BEGIN

           delt_ILAT = shift(fastLoc.ILAT(curOrb_i),-1)-shift(fastLoc.ILAT(curOrb_i),1)
           delt_MLT = shift(fastLoc.MLT(curOrb_i),-1)-shift(fastLoc.MLT(curOrb_i),1)
           
           ;handle first and last deltas separately
           delt_ILAT(0) = (fastLoc.ILAT(curOrb_i))(1)-(fastLoc.ILAT(curOrb_i))(0)
           delt_MLT(0) = (fastLoc.MLT(curOrb_i))(1)-(fastLoc.MLT(curOrb_i))(0)
           delt_ILAT(-1) = (fastLoc.ILAT(curOrb_i))(-1)-(fastLoc.ILAT(curOrb_i))(-2)
           delt_MLT(-1) = (fastLoc.MLT(curOrb_i))(-1)-(fastLoc.MLT(curOrb_i))(-2)

           slope = delt_ILAT/(delt_MLT*15)
           ;; sign  = delt_MLT/abs(delt_MLT)
           normFactor = 1/SQRT(1+slope^2)

           ;; orbVectors = make_array(2,curOrb_nEvents,/DOUBLE,VALUE=1)
           orbVectors(1,cur_i:cur_i+curOrb_nEvents-1) = slope
           ;; orbVectors(cur_i:cur_i+curOrb_nEvents-1) = transpose([[normFactor],[normFactor]])*orbVectors(cur_i:cur_i+curOrb_nEvents-1)
           FOR k=0,1 DO orbVectors(k,cur_i:cur_i+curOrb_nEvents-1) = normFactor*orbVectors(k,cur_i:cur_i+curOrb_nEvents-1)
           ;; orbVectors(1,*) = slope
           ;; orbVectors = transpose([[normFactor],[normFactor]])*orbVectors

           ;now match the MLTs of FAST data points with the closest value in the hwM_normVecs lookup table
           ;; hwM_inds = VALUE_LOCATE(hwM_normVecs.MLTs,fastLoc.MLT(curOrb_i))
           FOR j=0,curOrb_nEvents-1 DO BEGIN
              near = Min(Abs(hwM_normVecs.MLTs-(fastLoc.MLT(curOrb_i))(j)), temp)
              hwM_inds(j) = temp
           ENDFOR
           
           ;now dot product
           dotProds(cur_i:cur_i+curOrb_nEvents-1)=orbVectors(0,cur_i:cur_i+curOrb_nEvents-1)*hwM_normVecs.normVectors(0,hwM_inds(0:curOrb_nEvents-1)) + $
                                                  hemi*orbVectors(1,cur_i:cur_i+curOrb_nEvents-1)*hwM_normVecs.normVectors(1,hwM_inds(0:curOrb_nEvents-1))
                                
           ;new angles of attack
           ;; angle_of_attack(cur_i:cur_i+curOrb_nEvents-1)=180/!PI*ACOS(dotProds(cur_i:cur_i+curOrb_nEvents-1))*sign
           
           ;update counter
           cur_i = cur_i + curOrb_nEvents

        END
        ELSE: PRINT,FORMAT='("ORBIT:",T8,I0,T20,"N Events:",T31,I0)',curOrb,curOrb_nEvents
     ENDCASE

  ENDFOR

  dotProds(where(ABS(dotProds) LT 1e-15)) = 0.
  ;; sign=dotProds/ABS(dotProds)
  angle_of_attack=180/!PI*ACOS(dotProds)

  print,"Whoa."
  cghistoplot,dotProds,mininput=-1,maxinput=1
  cghistoplot,angle_of_attack,mininput=0,maxinput=180
  cghistoplot,angle_of_attack,mininput=0,maxinput=180,output='histogram_angle_of_attack__for_fastLoc_20150602.png'

  save,angle_of_attack,dotProds,orbVectors,filename='angle_of_attack__fastLocDB_20150409--20150601.sav'

  ;; fastLoc={fastLoc, orbit:fastLoc.orbit, interval:fastLoc.interval, time:fastLoc.time, $
  ;;          alt:fastLoc.alt, mlt:fastLoc.mlt, ilat:fastLoc.ilat, $
  ;;          angle_of_attack:angle_of_attack_time, fields_mode:fastLoc.fields_mode, $
  ;;          interval_start:fastLoc.interval_start, interval_stop:fastLoc.interval_stop}


END