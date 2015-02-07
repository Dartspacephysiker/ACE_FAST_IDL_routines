PRO interp_polar2dcontour_with_neventsdata,WHOLECAP=wholeCap,MIDNIGHT=midnight

  fname='../rawsaves/fluxplots_North_duskward_avg--0stable--wind_ACE_byMin_3.00000_Feb_ 7_15.dat'

  restore,fname
  
  ;round off ranges of plot to 0.25 precision
  minM=FLOOR(minM*4.0)/4.0 ;to 1/4 precision
  maxM=FLOOR(maxM*4.0)/4.0 
  minI=FLOOR(minI*4.0)/4.0 
  maxI=FLOOR(maxI*4.0)/4.0 
  
  ;do nEventPerOrb
  i=3
  temp=h2dstr[i]
  tempname=dataname[i]

  ;Subtract one since last array is the mask
  nPlots=N_ELEMENTS(h2dStr)-1

  ; Open a graphics window.
  ;; cgDisplay,color="black"

  IF KEYWORD_SET(wholeCap) THEN BEGIN
     IF wholeCap EQ 0 THEN wholeCap=!NULL
  ENDIF
  IF KEYWORD_SET(midnight) THEN BEGIN
     IF midnight EQ 0 THEN midnight=!NULL
  ENDIF
  
  IF wholeCap NE !NULL THEN BEGIN
     position = [0.05, 0.05, 0.85, 0.85] 
     lim=[minI,0,88,360]
  ENDIF ELSE BEGIN
     position = [0.1, 0.075, 0.9, 0.75] 
     lim=[minI,minM*15,maxI,maxM*15]
  ENDELSE

  
  ;; cgMap_Set, (minI GT 0) ? 90 : -90, (midnight NE !NULL) ? 0 : 180,/STEREOGRAPHIC, /HORIZON, $
  ;;            /ISOTROPIC, /NOERASE, /NOBORDER, POSITION=position,LIMIT=lim
                ;;Limit=[minI-5,maxM*15-360,maxI+5,minM*15],

  map= MAP('Polar Stereographic', $
           CENTER_LONGITUDE=(midnight NE !NULL) ? 0 : 180, CENTER_LATITUDE = (minI GT 0) ? 90 : -90, $
           limit=lim,title=temp.title,label_format='polar_maplabels')

  mg=map.mapgrid

  mlons=mg.longitudes
  FOR i=0,N_ELEMENTS(mlons)-1 DO BEGIN
     mlons[i].label_angle=0
     mlons[i].label_position=0.05
  ENDFOR

  mlats=mg.latitudes
  FOR i=0,N_ELEMENTS(mlats)-1 DO BEGIN
     mlats[i].label_angle=0
;;     mlons[i].label_position=0.2
  ENDFOR

  nXlines=(maxM-minM)/binM + 1
  nYlines=(maxI-minI)/binI + 1

  mlts=indgen(nXlines)*binM+minM
  ilats=indgen(nYlines)*binI+minI

  mlts=mlts*15

  ct = COLORTABLE(72, /reverse)

  c = CONTOUR(temp.data, mlts, ilats, /FILL, overplot=map, GRID_UNITS='degrees', RGB_TABLE=ct, TITLE=temp.title)
  cb = COLORBAR(TITLE=temp.title,rgb_table=ct, target=c)

END