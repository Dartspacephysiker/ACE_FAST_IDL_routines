;+
; NAME: KEY_SCATTERPLOTS_POLARPROJ
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

PRO KEY_SCATTERPLOTS_POLARPROJ,dbFile, $
                               DAYSIDE=dayside,NIGHTSIDE=nightside, $
                               NORTH=north,SOUTH=south, $
                               CHARESCR=chareScr,ABSMAGCSCR=absMagcScr, $
                               PLOTSUFF=plotSuff, $
                               OUTFILE=outFile, $
                               PLOT_I_FILE=plot_i_file, PLOT_I_DIR=plot_i_dir, $
                               STRANS=sTrans, $
                               _EXTRA = e

  ;; Defaults
  defMinI = 60
  defMaxI = 88
  
  defMinM = 0
  defMaxM = 24

  defTSLat = 75

  defDBFile = "scripts_for_processing_Dartmouth_data/Dartdb_02282015--500-14999--maximus--cleaned.sav"
  defOutDir = 'histos_scatters/polar/'
  defOutPref = 'key_scatterplots_polarproj'
  defExt = '.png'

  defPlot_i_dir = 'plot_indices_saves/'

  ;; defSTrans = 99 ;use for plotting entire db
  defSTrans = 90 ;use for very narrowed plot_i

  IF NOT KEYWORD_SET(sTrans) THEN sTrans = defSTrans

  IF NOT KEYWORD_SET(outDir) then outDir = defOutDir
  IF NOT KEYWORD_SET(plotSuff) THEN plotSuff = "" ELSE plotSuff
  IF NOT KEYWORD_SET (outFile) AND NOT KEYWORD_SET(plot_i_file) THEN outFile=defOutPref + plotSuff + defExt
  ;; plotSuff = "--Dayside--6-18MLT--60-84ILAT--4-250CHARE"

  IF NOT KEYWORD_SET(plot_i_dir) THEN plot_i_dir = defPlot_i_dir

  minM = 0
  maxM = 24

  IF NOT KEYWORD_SET(north) AND NOT KEYWORD_SET(south) THEN north = 1 ;default to northern hemi

  centerLon=180

  lun=-1

  ;; Deal with map stuff
  IF KEYWORD_SET(north) THEN BEGIN
     maxI=defMaxI
     minI=defMinI
     tsLat=defTSLat
  ENDIF ELSE BEGIN
     IF KEYWORD_SET(south) THEN BEGIN
        maxI=-defMinI
        minI=-defMaxI
        tsLat=-defTSLat
     ENDIF ELSE BEGIN
        PRINT,"Gotta select a hemisphere, bro"
        WAIT,0.5
        RETURN
     ENDELSE
  ENDELSE

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
  map = MAP('Polar Stereographic', $
            CENTER_LONGITUDE=centerLon, $
            TRUE_SCALE_LATITUDE=tsLat, $
            LABEL_FORMAT='polar_maplabels', $
            FILL_COLOR="white",DIMENSIONS=[800,800])

  ; Change some grid properties.
  grid = map.MAPGRID
  IF KEYWORD_SET(north) THEN grid.LATITUDE_MIN = minI ELSE IF KEYWORD_SET(south) THEN grid.LATITUDE_MAX = maxI
  grid.TRANSPARENCY=30
  grid.color="blue"
  grid.linestyle=1
  grid.label_angle = 0
  grid.font_size = 12

  mlats=grid.latitudes
  FOR i=0,n_elements(mlats)-1 DO BEGIN
     mlats(i).label_position=0.55
     mlats(i).label_valign=1.0
  ENDFOR

  mlons=grid.longitudes
  FOR i=0,n_elements(mlons)-1 DO BEGIN
     mlons(i).label_position=0.02
  ENDFOR

  ;;****************************************
  IF NOT KEYWORD_SET(dbFile) THEN restore,defDBFile ELSE restore,dbFile
  
  ;;names of the POSSIBILITIES
  maxTags=tag_names(maximus)

  IF KEYWORD_SET(plot_i_file) THEN BEGIN
     restore,plot_i_dir+plot_i_file
     printf,lun,""
     printf,lun,"**********DATA SUMMARY**********"
     print,lun,"DBFile: " + dbFile
     printf,lun,satellite+" satellite data delay: " + strtrim(delay,2) + " seconds"
     printf,lun,"IMF stability requirement: " + strtrim(stableIMF,2) + " minutes"
     ;; printf,lun,"Events per bin requirement: >= " +strtrim(maskMin,2)+" events"
     printf,lun,"Screening parameters: [Min] [Max]"
     printf,lun,"Mag current: " + strtrim(maxNEGMC,2) + " " + strtrim(minMC,2)
     printf,lun,"MLT: " + strtrim(minM,2) + " " + strtrim(maxM,2)
     printf,lun,"ILAT: " + strtrim(minI,2) + " " + strtrim(maxI,2)
     printf,lun,"Hemisphere: " + hemStr
     printf,lun,"IMF Predominance: " + clockStr
     printf,lun,"Angle lim 1: " + strtrim(angleLim1,2)
     printf,lun,"Angle lim 2: " + strtrim(angleLim2,2)
     printf,lun,"Number of orbits used: " + strtrim(N_ELEMENTS(uniqueOrbs_ii),2)
     printf,lun,"Total number of events used: " + strtrim(N_ELEMENTS(plot_i),2)
     printf,lun,"Percentage of current DB used: " + $
            strtrim((N_ELEMENTS(plot_i))/FLOAT(n_elements(maximus.orbit))*100.0,2) + "%"
                                ;NOTE, sometimes percentage of current DB will be discrepant between
                                ;key_scatterplots_polarproj and get_inds_from_db because
                                ;key_scatterplots_polarproj actually resizes maximus
     maximus = resize_maximus(maximus,INDS=plot_i)

     IF NOT KEYWORD_SET(outFile) THEN outFile=defOutPref+paramStr+plotSuff+defExt

  ENDIF
  
  ;;northern_hemi
  IF KEYWORD_SET(north) OR KEYWORD_SET(south) THEN BEGIN
     maximus = resize_maximus(maximus,MAXIMUS_IND=5,MIN_FOR_IND=minI,MAX_FOR_IND=maxI)
  END

  ;;screen on maximus? YES

  ;;dayside
  ;; IF KEYWORD_SET(dayside) THEN BEGIN
  ;;    maximus = resize_maximus(maximus,MAXIMUS_IND=4,MIN_FOR_IND=6,MAX_FOR_IND=18)  ;; Dayside MLTs
  ;;    maximus = resize_maximus(maximus,MAXIMUS_IND=5,MIN_FOR_IND=60,MAX_FOR_IND=84) ;; ILAT range
  ;; ENDIF

  ;;nightside
  ;;Not currently functional, because resize_maximus can't handle selecting MLTS 18-6, you see
  ;; IF KEYWORD_SET(nightside) THEN BEGIN
  ;;    maximus = resize_maximus(maximus,MAXIMUS_IND=4,MIN_FOR_IND=6,MAX_FOR_IND=18)    ;; Nightside MLTs
  ;;    maximus = resize_maximus(maximus,MAXIMUS_IND=5,MIN_FOR_IND=60,MAX_FOR_IND=84)   ;; ILAT range
  ;; ENDIF

  ;; screen by characteristic energy
  ;; IF KEYWORD_SET(charEScr) THEN maximus = resize_maximus(maximus,MAXIMUS_IND=12,MIN_FOR_IND=4,MAX_FOR_IND=300)  

  ;; screen by magnetometer current
  min_absMagcScr=10
  max_absMagcScr=500
  ;; IF KEYWORD_SET(absMagcScr) THEN maximus = resize_maximus(maximus,MAXIMUS_IND=6,MIN_FOR_IND=min_absMagcScr,MAX_FOR_IND=max_absMagcScr)  


  ;;****************************************

  lats=maximus.ilat
  lons=maximus.mlt*15
  ;; lats=[65,65,65,65]
  ;; lons=[0,90,180,270]


  ;; Plotting
  curPlot = scatterplot(lons,lats,sym_size=0.8, $
                 SYMBOL='o',/overplot,SYM_TRANSPARENCY=sTrans);,$;SYM_SIZE=0.5, $ ;There is such a high density of points that we need transparency
  ;; curPlot = plot(lons,lats,sym_size=0.8, $
  ;;                'o',/overplot,SYM_TRANSPARENCY=95);,$;SYM_SIZE=0.5, $ ;There is such a high density of points that we need transparency
;                ,linestyle=6, $
;                 MAPPROJECTION=map,MAPGRID=grid,/overplot)
  curPlot.save,outDir+outFile,resolution=600

END