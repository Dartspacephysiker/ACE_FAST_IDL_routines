;2015/05/29
;The purpose of this pro is to generate a lookup table so that, for a specified MLT, one can look up
;the direction in (MLT,ILAT) space that is normal to the statistical Holzworth-Meng auroral oval.

PRO JOURNAL__20150529__Holzworth_Meng__make_lookup_table

  ;; Defaults
  defMinI = 60
  defMaxI = 88
  
  defMinM = 0
  defMaxM = 24

  IF minM EQ !NULL THEN minM = defMinM
  IF maxM EQ !NULL THEN maxM = defMaxM

  ;;get boundaries
  nMLTs=2400
  activity_level=7
  ;; MLTs=indgen(nMLTs,/FLOAT)*(maxM-minM)/nMLTs+minM
  MLTs=indgen(nMLTs,/DOUBLE)/100.
  bndry_eqWard = get_auroral_zone(nMLTs,minM,maxM,BNDRY_POLEWARD=bndry_poleWard,ACTIVITY_LEVEL=activity_level)

  ;; aurPlot = plot([MLTS,MLTs,MLTS[0]]*15,[bndry_eqWard,bndry_poleWard,bndry_poleWard[0]],LINESTYLE='-', THICK=4,/overplot)
  ;; aurEqWardPlot = plot([MLTS,MLTs[0]]*15,[bndry_eqWard,bndry_eqWard[0]],LINESTYLE='-', THICK=2.5,/overplot)
  ;; aurPoleWardPlot = plot([MLTS,MLTs[0]]*15,[bndry_poleWard,bndry_poleWard[0]],LINESTYLE='-', THICK=2.5,/overplot)

  ;; ; slopes (rise/run) assuming MLT and ILAT are locally Cartesian
  m_k = make_array(nMLTS,/DOUBLE)

  ;; delt_MLT = shift(mlts,-1)-shift(mlts,1)
  ;; delt_MLT(0) = delt_MLT(1)
  ;; delt_MLT(-1) = delt_MLT(-2)
  oneOver_delt_MLT = 50.    ;corresponds to delt_MLT = 0.02, of course
  
  delt_ILAT = shift(bndry_eqWard,-1)-shift(bndry_eqWard,1)

  m_k = delt_ILAT*oneOver_delt_MLT/15.
  ;; m_k(1:nMLTS-2) = ( (shift(bndry_eqWard,-1))(1:nMLTS-2)-(shift(bndry_eqWard,1))(1:nMLTS-2))/( (shift(mlts,-1))(1:nMLTS-2)-(shift(mlts,1))(1:nMLTS-2))

  negOneOver_m_k = - 1 / m_k
     
  ;; normVectors = [ [ make_array(nMLTs,VALUE=1) ], [ negOneOver_m_k ] ]
  normFactor = 1/SQRT(1+negOneOver_m_k^2.)
  normVectors = make_array(2,nMLTs,/DOUBLE,VALUE=1)
  ;; normVectors(1,*) = negOneOver_m_k
  normVectors(1,*) = ABS(negOneOver_m_k)   ;Use ABS so that all vectors point to more extreme latitude value
  normVectors = transpose([[normFactor],[normFactor]])*normVectors

  normF = 1/SQRT(1+m_k^2.)
  vectors = make_array(2,nMLTs,/DOUBLE,VALUE=1)
  vectors(1,*) = m_k
  vectors = transpose([[normF],[normF]])*vectors

  ;; Check that the vectors pointing around the auroral oval and their normal vectors are, in fact, normal.
  ;; Note, by making normVectors(1,*) = ABS(negOneOver_m_k), we lose a touch of orthogonality, but it's OK
  dotProds=normVectors(0,*)*vectors(0,*)+normVectors(1,*)*vectors(1,*)
  dotProds(where(dotProds LT 1e-17)) = 0.
  normMag=normVectors(0,*)*normvectors(0,*)+normVectors(1,*)*normvectors(1,*) ;these are all one, as they should be

  tStamp=TIMESTAMP()
  hwM_normVecS={hwM_normVecS, $
                      NMLTS:nMLTs,MLTS:mlts, $
                      minMLT:minM,maxMLT:maxM, $
                      SLOPE_SCHEME:"Centered difference", $
                      CREATION_DATE:TIMESTAMP(), $ 
                      NORMVECTORS:normVectors, $
                      NORMVECSTRUCT:"normVectors[0:*] --> normed delta_MLTs;normVectors[1:*] --> normed delta_ILATs", $
                      BNDRY_EQWARD:bndry_eqWard,BNDRY_POLEWARD:bndry_poleWard, $
                      ACTIVITY_LEVEL:activity_level }

  save,hwM_normVecS,filename='hwMeng_normVectorStruct.sav'

END