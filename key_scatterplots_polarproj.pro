;+
; NAME: KEY_SCATTERPLOTS_FROM_DB
;
;
;
; PURPOSE: Get a sense for what's happening in a given database. Specifically, the key data products I'm picking here are
;          -> alt                  (altitude)
;          -> mag_current          (Yep, current derived from magnetometer)
;          -> elec_energy_flux     (electron energy flux)
;          -> delta_b              (peak-to-peak of the max magnetic field fluctuation)
;          -> delta_e              (peak-to-peak of the max electric field fluctuation)
;          -> max_chare_losscone   (Max characteristic energy in the losscone)
;          -> pfluxEst             (Poynting flux estimate)
;            
;          Could also mess around with
;          -> width_x              (width of filament along spacecraft trajectory)
;          -> width_time           (temporal width)
;
; CATEGORY: Are you serious? Everyone knows the answer to this.
;
;
;
; INPUTS:
;
; OPTIONAL INPUTS:
;
; KEYWORD PARAMETERS:
;
; OUTPUTS:
;
; OPTIONAL OUTPUTS:
;
; PROCEDURE:
;
; EXAMPLE:
;
; MODIFICATION HISTORY: 2015/03/27
;                       Birth
;-

PRO KEY_SCATTERPLOTS_FROM_DB,dbFile, $
                             DAYSIDE=dayside,NIGHTSIDE=nightside, $
                             NORTH=north,SOUTH=south, $
                             CHARESCR=chareScr,ABSMAGCSCR=absMagcScr

  default_DBFile = "scripts_for_processing_Dartmouth_data/Dartdb_02282015--500-14999--maximus--cleaned.sav"

  IF NOT KEYWORD_SET(dbFile) THEN restore,default_DBFile ELSE restore,dbFile
  
  ;;names of the POSSIBILITIES
  maxTags=tag_names(maximus)

  maxI=84
  minI=60

  minM = 0
  maxM = 24

  ;;****************************************
  ;;screen on maximus? YES

  ;;northern_hemi
  IF KEYWORD_SET(north) THEN BEGIN
     maximus = resize_maximus(maximus,5,minI,maxI)
  END

  IF KEYWORD_SET(south) THEN BEGIN
     maximus = resize_maximus(maximus,5,-maxI,minI)
  END

  ;;dayside
  ;; IF KEYWORD_SET(dayside) THEN BEGIN
  ;;    maximus = resize_maximus(maximus,4,6,18)  ;; Dayside MLTs
  ;;    maximus = resize_maximus(maximus,5,60,84) ;; ILAT range
  ;; ENDIF

  ;;nightside
  ;;Not currently functional, because resize_maximus can't handle selecting MLTS 18-6, you see
  ;; IF KEYWORD_SET(nightside) THEN BEGIN
  ;;    maximus = resize_maximus(maximus,4,6,18)    ;; Nightside MLTs
  ;;    maximus = resize_maximus(maximus,5,60,84)   ;; ILAT range
  ;; ENDIF

  ;; screen by characteristic energy
  ;; IF KEYWORD_SET(charEScr) THEN maximus = resize_maximus(maximus,12,4,300)  

  ;; screen by magnetometer current
  ;; IF KEYWORD_SET(absMagcScr) THEN maximus = resize_maximus(maximus,6,-ABS(absMagcScr),ABS(absMagcScr))  

  ;;****************************************


  plotSuff = ""
  ;; plotSuff = "--Dayside--6-18MLT--60-84ILAT--4-250CHARE"



  IF KEYWORD_SET(mirror) THEN BEGIN
     IF mirror NE 0 THEN mirror = 1 ELSE mirror = 0
  ENDIF ELSE mirror = 0

  IF KEYWORD_SET(wholeCap) THEN BEGIN
     IF wholeCap EQ 0 THEN wholeCap=!NULL
  ENDIF
  IF KEYWORD_SET(midnight) THEN BEGIN
     IF midnight EQ 0 THEN midnight=!NULL
  ENDIF
  
  IF wholeCap NE !NULL THEN BEGIN
     lim=[ minI, 0, maxI, 360] ; lim = [minimum lat, minimum long, maximum lat, maximum long]
  ENDIF ELSE BEGIN
     lim=[minI, minM*15, maxI, maxM*15]
  ENDELSE

;Polar Stereographic
;SEMIMAJOR_AXIS, SEMIMINOR_AXIS, CENTER_LONGITUDE, TRUE_SCALE_LATITUDE, FALSE_EASTING, FALSE_NORTHING

  centerLon=180

  map = MAP('Polar Stereographic', $
              CENTER_LONGITUDE=centerLon, $
              TRUE_SCALE_LATITUDE=75, $
              FILL_COLOR="white",DIMENSIONS=[800,800])

; Change some grid properties.
  grid = map.MAPGRID
;;  grid.LATITUDE_MAX = maxI
  grid.LATITUDE_MIN = minI
  grid.TRANSPARENCY=30
  grid.color="blue"
  grid.linestyle=1

  lats=maximus.ilat
  lons=maximus.mlt*15

  ;; lats=[65,65,65,65]
  ;; lons=[0,90,180,270]

  curPlot = plot(lons,lats,sym_size=0.8, $
                 'o',/overplot,SYM_TRANSPARENCY=98);,$;SYM_SIZE=0.5, $ ;There is such a high density of points that we need transparency
;                ,linestyle=6, $
;                 MAPPROJECTION=map,MAPGRID=grid,/overplot)

END