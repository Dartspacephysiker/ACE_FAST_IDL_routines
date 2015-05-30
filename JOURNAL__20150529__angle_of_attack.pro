;2015/05/29
;The idea here is to define an "angle of attack" of the FAST satellite relative to the statistical
;Holzworth-Meng auroral oval. It draws upon the lookup table generated in
;JOURNAL__20150529__Holzworth_Meng[...] to get the normal direction for a given MLT.

PRO JOURNAL__20150529__ANGLE_OF_ATTACK

  dataDir='/home/spencerh/Research/Cusp/ACE_FAST/'
  
  ;;Get DB file
  dbFile='scripts_for_processing_Dartmouth_data/Dartdb_02282015--500-14999--maximus--cleaned.sav'
  ;; dbFile='scripts_for_processing_Dartmouth_data/Dartdb_02282015--500-14999--maximus.sav'
  restore,dataDir+dbFile

  ;; resize maximus by current size?
  maximus = resize_maximus(maximus,maximus_ind=6,min_for_ind=10,max_for_ind=1000,/ONLY_ABSVALS)
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
  
  angle_of_attack =make_array(n_elements(maximus.orbit),/float)

  orbMin = 500
  orbMax = 15000
  cur_i  = 0
  hwM_inds = MAKE_ARRAY(100000,/INTEGER,VALUE=0) ;I'm assuming no orbit will have more than 100000 events

  FOR curOrb=orbMin,orbMax DO BEGIN

     curOrb_i = WHERE(maximus.orbit EQ curOrb,/NULL)
     curOrb_nEvents = N_ELEMENTS(curOrb_i)
     
     ;We use hemi only to flip the sign of ILAT in the HwM lookup vectors, since the
     ;statistical auroral oval in the southern hemi is just a mirror reflection of that in the
     ;northern hemi
     IF curOrb_nEvents GT 0 THEN BEGIN
        hemi = FIX(maximus.ILAT(curOrb_i) GT 0)
        hemi(WHERE(hemi LT 1)) = -1
     ENDIF

     CASE 1 OF
        (curOrb_nEvents EQ 1): BEGIN
           angle_Of_Attack(cur_i) = -900.
           cur_i++
        END
        (curOrb_nEvents EQ 2): BEGIN

           delt_ILAT = (maximus.ILAT(curOrb_i))(1)-(maximus.ILAT(curOrb_i))(0)
           delt_MLT = (maximus.MLT(curOrb_i))(1)-(maximus.MLT(curOrb_i))(0)

           slope = delt_ILAT/(delt_MLT*15)
           sign  = delt_MLT/abs(delt_MLT)
           normFactor = 1/SQRT(1+slope^2)

           orbVectors = make_array(2,curOrb_nEvents,/DOUBLE,VALUE=1)
           orbVectors(1,*) = slope
           orbVectors = transpose([[normFactor],[normFactor]])*orbVectors

           ;now match the MLTs of FAST data points with the closest value in the hwM_normVecs lookup table
           FOR j=0,curOrb_nEvents-1 DO BEGIN
              near = Min(Abs(hwM_normVecs.MLTs-(maximus.MLT(curOrb_i))(j)), temp)
              hwM_inds(j) = temp
           ENDFOR

           ;now dot product
           dotProds=orbVectors(0,*)*hwM_normVecs.normVectors(0,hwM_inds(0:curOrb_nEvents-1)) + $
                    hemi*orbVectors(1,*)*hwM_normVecs.normVectors(1,hwM_inds(0:curOrb_nEvents-1))
           dotProds(where(dotProds LT 1e-15)) = 0.
                                
           ;new angles of attack
           angle_of_attack(cur_i:cur_i+curOrb_nEvents-1)=180/!PI*ACOS(dotProds)*sign
           
           ;update counter
           cur_i = cur_i + curOrb_nEvents

        END
        (curOrb_nEvents GE 3): BEGIN

           delt_ILAT = shift(maximus.ILAT(curOrb_i),-1)-shift(maximus.ILAT(curOrb_i),1)
           delt_MLT = shift(maximus.MLT(curOrb_i),-1)-shift(maximus.MLT(curOrb_i),1)
           
           ;handle first and last deltas separately
           delt_ILAT(0) = (maximus.ILAT(curOrb_i))(1)-(maximus.ILAT(curOrb_i))(0)
           delt_MLT(0) = (maximus.MLT(curOrb_i))(1)-(maximus.MLT(curOrb_i))(0)
           delt_ILAT(-1) = (maximus.ILAT(curOrb_i))(-1)-(maximus.ILAT(curOrb_i))(-2)
           delt_MLT(-1) = (maximus.MLT(curOrb_i))(-1)-(maximus.MLT(curOrb_i))(-2)

           slope = delt_ILAT/(delt_MLT*15)
           sign  = delt_MLT/abs(delt_MLT)
           normFactor = 1/SQRT(1+slope^2)

           orbVectors = make_array(2,curOrb_nEvents,/DOUBLE,VALUE=1)
           orbVectors(1,*) = slope
           orbVectors = transpose([[normFactor],[normFactor]])*orbVectors

           ;now match the MLTs of FAST data points with the closest value in the hwM_normVecs lookup table
           ;; hwM_inds = VALUE_LOCATE(hwM_normVecs.MLTs,maximus.MLT(curOrb_i))
           FOR j=0,curOrb_nEvents-1 DO BEGIN
              near = Min(Abs(hwM_normVecs.MLTs-(maximus.MLT(curOrb_i))(j)), temp)
              hwM_inds(j) = temp
           ENDFOR
           
           ;now dot product
           dotProds=orbVectors(0,*)*hwM_normVecs.normVectors(0,hwM_inds(0:curOrb_nEvents-1)) + $
                    hemi*orbVectors(1,*)*hwM_normVecs.normVectors(1,hwM_inds(0:curOrb_nEvents-1))
           dotProds(where(dotProds LT 1e-15)) = 0.
                                
           ;new angles of attack
           angle_of_attack(cur_i:cur_i+curOrb_nEvents-1)=180/!PI*ACOS(dotProds)*sign
           
           ;update counter
           cur_i = cur_i + curOrb_nEvents

        END
        ELSE: PRINT,FORMAT='("ORBIT:",T8,I0,T20,"N Events:",T31,I0)',curOrb,curOrb_nEvents
     ENDCASE

  ENDFOR

  print,"Whoa."
  cghistoplot,angle_of_attack,mininput=-90,maxinput=90,binsize=5
  cghistoplot,angle_of_attack,mininput=-90,maxinput=90,binsize=5,output='histogram_angle_of_attack__for_DartmouthDB_02282015_trytwo.png'

  ;; fastLoc={fastLoc, orbit:fastLoc.orbit, interval:fastLoc.interval, time:fastLoc.time, $
  ;;          alt:fastLoc.alt, mlt:fastLoc.mlt, ilat:fastLoc.ilat, $
  ;;          angle_of_attack:angle_of_attack_time, fields_mode:fastLoc.fields_mode, $
  ;;          interval_start:fastLoc.interval_start, interval_stop:fastLoc.interval_stop}


END