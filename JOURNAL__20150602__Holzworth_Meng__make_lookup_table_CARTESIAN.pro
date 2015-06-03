;2015/06/02
;There are some issues for the fastLoc and maximus DBs when delta_MLT=0, so we're going CARTESIAN, mi amigo.

;2015/05/29
;The purpose of this pro is to generate a lookup table so that, for a specified MLT, one can look up
;the direction in (MLT,ILAT) space that is normal to the statistical Holzworth-Meng auroral oval.

PRO JOURNAL__20150602__Holzworth_Meng__make_lookup_table_CARTESIAN

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

  ;; sph_coord = [[45.0, -60.0, 10.0], [0.0, 0.0, 0.0]]
  sph_coord = TRANSPOSE([[MLTs*15],[bndry_eqWard],[MAKE_ARRAY(nMLTS,/DOUBLE,VALUE=1)]])
  rect_coord = CV_COORD(FROM_SPHERE=sph_coord, /TO_RECT, /DEGREES)

  ;; ;Don't normalize slopes yet! It comes later, after calculations...
  slopes=shift(rect_coord,0,-1)-shift(rect_coord,0,1)
  ;; FOR j=0,nMLTs-1 DO BEGIN
  ;;    normFactor = 1./SQRT((slopes(0,j))^2+(slopes(1,j))^2+(slopes(2,j))^2)
  ;;    slopes(*,j)=normFactor*slopes(*,j)
  ;; ENDFOR

  ;; invNegSlopes=-1./slopes

  normRVecs=rect_coord
  FOR j=0,nMLTs-1 DO BEGIN
     normFactor = 1./SQRT((rect_coord(0,j))^2+(rect_coord(1,j))^2+(rect_coord(2,j))^2)
     normRVecs(*,j)=normFactor*normRVecs(*,j)
  ENDFOR
  
  ;;NOW normalize slopes—we didn't do it before because we want to keep the values as numerically unchanged as possible for
  ;;calculating other normal vectors
  FOR j=0,nMLTs-1 DO BEGIN
     normFactor = 1./SQRT((slopes(0,j))^2+(slopes(1,j))^2+(slopes(2,j))^2)
     slopes(*,j)=normFactor*slopes(*,j)
  ENDFOR

  thresh=1e-12
  bad_delta_X=where(ABS(slopes(0,*)) LT thresh,/NULL)
  bad_delta_Y=where(ABS(slopes(1,*)) LT thresh,/NULL)
  bad_delta_Z=where(ABS(slopes(2,*)) LT thresh,/NULL)
  print,"N Bad delta_X: ",n_elements(bad_delta_X)
  print,"N Bad delta_Y: ",n_elements(bad_delta_Y)
  print,"N Bad delta_z: ",n_elements(bad_delta_Z)

  ;; ;Make normal vectors
  IF n_elements(bad_delta_X) EQ 0 THEN BEGIN
     IF N_ELEMENTS(bad_delta_Y) EQ 0 THEN BEGIN
        normVecs=normRvecs
        normVecs(0,*)=1                      ;arbitrarily assign u_x
        normVecs(1,*)=(normRVecs(2,*)+slopes(1,*)*normVecs(0,*))/slopes(0,*)
        normVecs(2,*)=(normRVecs(0,*)+slopes(2,*)*normVecs(1,*))/slopes(1,*)

        FOR j=0,nMLTs-1 DO BEGIN
           normFactor = 1./SQRT((normVecs(0,j))^2+(normVecs(1,j))^2+(normVecs(2,j))^2)
           normVecs(*,j)=normFactor*normVecs(*,j)
        ENDFOR
     ENDIF
  ENDIF

  ;; ;check norm of radius vectors
  ;; print,FORMAT='(G0.4,T15,G0.4,T30,G0.4)',normRVecs(*,0)
  ;; FOR j=0,nMLTs-1 DO BEGIN
  ;;    PRINT,(normRVecs(0,j))^2+(normRVecs(1,j))^2+(normRVecs(2,j))^2
  ;; ENDFOR
  
  ;; ;check norm of these Hw-M vecs
  ;; print,FORMAT='(G0.4,T15,G0.4,T30,G0.4)',normVecs(*,0)
  ;; FOR j=0,nMLTs/10 DO PRINT,(normVecs(0,j))^2+(normVecs(1,j))^2+(normVecs(2,j))^2

  ;; ;check norm of slope vecs
  ;; print,FORMAT='(G0.4,T15,G0.4,T30,G0.4)',slopes(*,0)
  ;; FOR j=0,nMLTs/10 DO PRINT,(slopes(0,j))^2+(slopes(1,j))^2+(slopes(2,j))^2

  ;; ;Check orthogonality of normRVecs and slope vectors
  dP_sR_CART=slopes(0,*)*normRVecs(0,*)+slopes(1,*)*normRVecs(1,*)+slopes(2,*)*normRVecs(2,*)

  ;; Check that the vectors pointing around the auroral oval and their normal vectors are, in fact, normal.
  ;; Note, by making normVectors(1,*) = ABS(negOneOver_m_k), we lose a touch of orthogonality, but it's OK
  dP_CART=slopes(0,*)*normVecs(0,*)+slopes(1,*)*normVecs(1,*)+slopes(2,*)*normVecs(2,*)
  ;; dotProds(where(dotProds LT 1e-17)) = 0.

  ;; ;Subtract off projection
  FOR j=0,2 DO normVecs(j,*)=normVecs(j,*)-dP_CART*slopes(j,*)

  ;; ;Re-normalize
  FOR j=0,nMLTs-1 DO BEGIN
     normFactor = 1./SQRT((normVecs(0,j))^2+(normVecs(1,j))^2+(normVecs(2,j))^2)
     normVecs(*,j)=normFactor*normVecs(*,j)
  ENDFOR

  ;;Check orthogonality of normVecs and rVecs
  dP_nR_CART=normVecs(0,*)*normRVecs(0,*)+normVecs(1,*)*normRVecs(1,*)+normVecs(2,*)*normRVecs(2,*)

  normVectors=CV_COORD(FROM_RECT=normVecs, /TO_SPHERE, /DEGREES)
  normVectors=[normVectors(0,*),normVectors(1,*)]

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

  save,hwM_normVecS,filename='hwMeng_normVectorStruct_CARTESIAN.sav'

END