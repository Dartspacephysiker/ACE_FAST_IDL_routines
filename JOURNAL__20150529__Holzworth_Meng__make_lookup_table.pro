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
  normFactor = 1/SQRT(1+negOneOver_m_k^2)
  normVectors = make_array(2,nMLTs,/DOUBLE,VALUE=1)
  normVectors(1,*) = negOneOver_m_k
  normVectors = transpose([[normFactor],[normFactor]])*normVectors

  normF = 1/SQRT(1+m_k^2)
  vectors = make_array(2,nMLTs,/DOUBLE,VALUE=1)
  vectors(1,*) = m_k
  vectors = transpose([[normF],[normF]])*vectors

  dotProds=normVectors(0,*)*vectors(0,*)+normVectors(1,*)*vectors(1,*)
  dotProds(where(dotProds LT 1e-15)) = 0.
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

  ;; defTSLat = 75

  ;; defOutDir = 'histos_scatters/polar/'
  ;; defOutPref = 'key_scatterplots_polarproj'
  ;; defExt = '.png'

  ;; defPlot_i_dir = 'plot_indices_saves/'

  ;; IF NOT KEYWORD_SET(outDir) then outDir = defOutDir
  ;; IF NOT KEYWORD_SET(plotSuff) THEN plotSuff = "" ELSE plotSuff
  ;; IF NOT KEYWORD_SET (outFile) AND NOT KEYWORD_SET(plot_i_file) THEN outFile=defOutPref + plotSuff + defExt ;otherwise handled by plot_i_file
  ;; ;; plotSuff = "--Dayside--6-18MLT--60-84ILAT--4-250CHARE"

  ;; IF NOT KEYWORD_SET(plot_i_dir) THEN plot_i_dir = defPlot_i_dir

  ;; IF NOT KEYWORD_SET(north) AND NOT KEYWORD_SET(south) THEN north = 1 ;default to northern hemi

  ;; centerLon=180

  ;; lun=-1

  ;; ;; Deal with map stuff
  ;; IF KEYWORD_SET(north) THEN BEGIN
  ;;    maxI=defMaxI
  ;;    minI=defMinI
  ;;    tsLat=defTSLat
  ;; ENDIF ELSE BEGIN
  ;;    IF KEYWORD_SET(south) THEN BEGIN
  ;;       maxI=-defMinI
  ;;       minI=-defMaxI
  ;;       tsLat=-defTSLat
  ;;    ENDIF ELSE BEGIN
  ;;       PRINT,"Gotta select a hemisphere, bro"
  ;;       WAIT,0.5
  ;;       RETURN
  ;;    ENDELSE
  ;; ENDELSE

  ;; IF KEYWORD_SET(mirror) THEN BEGIN
  ;;    IF mirror NE 0 THEN mirror = 1 ELSE mirror = 0
  ;; ENDIF ELSE mirror = 0

  ;; IF KEYWORD_SET(wholeCap) THEN BEGIN
  ;;    IF wholeCap EQ 0 THEN wholeCap=!NULL
  ;; ENDIF
  ;; IF KEYWORD_SET(midnight) THEN BEGIN
  ;;    IF midnight EQ 0 THEN midnight=!NULL
  ;; ENDIF
  
  ;; IF wholeCap NE !NULL THEN BEGIN
  ;;    lim=[ minI, 0, maxI, 360] ; lim = [minimum lat, minimum long, maximum lat, maximum long]
  ;; ENDIF ELSE BEGIN
  ;;    lim=[minI, minM*15, maxI, maxM*15]
  ;; ENDELSE

  ;; ;Polar Stereographic
  ;; ;SEMIMAJOR_AXIS, SEMIMINOR_AXIS, CENTER_LONGITUDE, TRUE_SCALE_LATITUDE, FALSE_EASTING, FALSE_NORTHING
  ;; map = MAP('Polar Stereographic', $
  ;;           CENTER_LONGITUDE=centerLon, $
  ;;           TRUE_SCALE_LATITUDE=tsLat, $
  ;;           LABEL_FORMAT='polar_maplabels', $
  ;;           FILL_COLOR="white",DIMENSIONS=[800,800])

  ;; ; Change some grid properties.
  ;; grid = map.MAPGRID
  ;; IF KEYWORD_SET(north) THEN grid.LATITUDE_MIN = minI ELSE IF KEYWORD_SET(south) THEN grid.LATITUDE_MAX = maxI
  ;; grid.TRANSPARENCY=30
  ;; grid.color="blue"
  ;; grid.linestyle=1
  ;; grid.label_angle = 0
  ;; grid.font_size = 15

  ;; mlats=grid.latitudes
  ;; FOR i=0,n_elements(mlats)-1 DO BEGIN
  ;;    mlats(i).label_position=0.55
  ;;    mlats(i).label_valign=1.0
  ;; ENDFOR

  ;; mlons=grid.longitudes
  ;; FOR i=0,n_elements(mlons)-1 DO BEGIN
  ;;    mlons(i).label_position=0.02
  ;; ENDFOR
