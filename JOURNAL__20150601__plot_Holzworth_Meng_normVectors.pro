;2015/06/01
;Now I want to make sure that these vectors are actually the right ones...

PRO JOURNAL__20150601__plot_Holzworth_Meng_normVectors

  dataDir='/SPENCEdata/Research/Cusp/ACE_FAST/'

  hwMengFile='hwMeng_normVectorStruct.sav'
  aOaFile='angle_of_attack__fastLocDB_20150409--20150601.sav'
  fastLocFile='time_histo_stuff/fastLoc_intervals2--20150409.sav'
  restore,dataDir+hwMengFile
  restore,dataDir+aOaFile
  restore,dataDir+fastLocFile

  ;; Defaults
  defMinI = 60
  defMaxI = 88
  
  defMinM = 0
  defMaxM = 24

  defTSLat = 75  ;true-scale latitude

  defSTrans = 90

  defDBFile = "scripts_for_processing_Dartmouth_data/Dartdb_02282015--500-14999--maximus--cleaned.sav"
  defOutDir = 'histos_scatters/polar/'
  defOutPref = 'JOURNAL__plot_Holzworth-Meng_normVectors'
  defExt = '.png'

  IF NOT KEYWORD_SET(sTrans) THEN sTrans = defSTrans

  IF NOT KEYWORD_SET(outDir) then outDir = defOutDir
  IF NOT KEYWORD_SET(plotSuff) THEN plotSuff = "" ELSE plotSuff
  IF NOT KEYWORD_SET (outFile) AND NOT KEYWORD_SET(plot_i_file) THEN outFile=defOutPref + plotSuff + defExt ;otherwise handled by plot_i_file
  ;; plotSuff = "--Dayside--6-18MLT--60-84ILAT--4-250CHARE"

  IF minM EQ !NULL THEN minM = defMinM
  IF maxM EQ !NULL THEN maxM = defMaxM
  ;; minM = 0
  ;; maxM = 24

  IF NOT KEYWORD_SET(north) AND NOT KEYWORD_SET(south) THEN north = 1 ;default to northern hemi

  centerLon=KEYWORD_SET(south) ? 0 : 180

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
  grid.font_size = 15

  mlats=grid.latitudes
  FOR i=0,n_elements(mlats)-1 DO BEGIN
     mlats(i).label_position=0.55
     mlats(i).label_valign=1.0
  ENDFOR

  mlons=grid.longitudes
  FOR i=0,n_elements(mlons)-1 DO BEGIN
     mlons(i).label_position=KEYWORD_SET(south) ? 1.0 : 0.02
  ENDFOR

  ;;****************************************
  ; Add auroral zone to plot?

     ;;get boundaries
     nMLTs=96
     activity_level=7
     MLTs=indgen(nMLTs,/FLOAT)*(maxM-minM)/nMLTs+minM
     bndry_eqWard = get_auroral_zone(nMLTs,minM,maxM,BNDRY_POLEWARD=bndry_poleWard,ACTIVITY_LEVEL=activity_level,SOUTH=south)
     ;; aurPlot = plot([MLTS,MLTs,MLTS[0]]*15,[bndry_eqWard,bndry_poleWard,bndry_poleWard[0]],LINESTYLE='-', THICK=4,/overplot)
     aurEqWardPlot = plot([MLTS,MLTs[0]]*15,[bndry_eqWard,bndry_eqWard[0]],LINESTYLE='-', THICK=2.5,/overplot)
     aurPoleWardPlot = plot([MLTS,MLTs[0]]*15,[bndry_poleWard,bndry_poleWard[0]],LINESTYLE='-', THICK=2.5,/overplot)


     ;; hwPlot=PLOT(hwM_normVecs.MLTs,hwM_normVecs.bndry_eqward,'k-', XTITLE="MLT", YTITLE='$ILAT (deg)$')
     ;; hwPlot=PLOT(hwM_normVecs.MLTs,hwM_normVecs.bndry_poleward,'k-', XTITLE="MLT", YTITLE='$ILAT (deg)$',/OVERPLOT)

     ;every thirtieth vector
     inds=indgen(FIX(hwM_normVecs.nMLTS/30))*30

     ;vector plot
     hwMNormVecPlot=VECTOR(TRANSPOSE(hwM_normVecs.normVectors(0,inds)),ABS(TRANSPOSE(hwM_normVecs.normVectors(1,inds))), $
                           hwM_normVecs.MLTs(inds)*15,hwM_normVecs.bndry_eqWard(inds),/OVERPLOT)


     ;Every thirtieth vector for first 300 fastLoc vectors
     nFastLocVecs=15
     ;; fastLoc_plotInds=indgen(nfastLocVecs)*10+200000
     
     fLorb=10000
     fastLoc_plotInds=cgsetintersection(WHERE(fastLoc.ILAT GT 0),WHERE(fastLoc.orbit EQ fLorb))
     ;; fLMax=max(fastLoc_plotInds,fLindMax,SUBSCRIPT_MIN=fLindMin)
     fLnEl=N_ELEMENTS(fastLoc_plotInds)
     fLsubset=FIX(indgen(nFastLocVecs,/FLOAT)/(nFastLocVecs-1)*(fLnEl-1))
     fastLoc_plotInds=fastLoc_plotInds(fLsubset)
              
     ;;find the corresponding lookup vectors
     hwM_inds = MAKE_ARRAY(1000,/INTEGER,VALUE=0) ;I'm assuming no orbit will have more than 100000 events
     FOR j=0,N_ELEMENTS(nFastLocVecs)-1 DO BEGIN
        near = Min(Abs(hwM_normVecs.MLTs-(fastLoc.MLT(fastLoc_plotInds))(j)), temp)
        hwM_inds(j) = temp
     ENDFOR
     
     hwMVecPlot1=VECTOR(TRANSPOSE(hwM_normVecs.normVectors(0,hwM_inds(0:nFastLocVecs-1))), $
                        ABS(TRANSPOSE(hwM_normVecs.normVectors(1,hwM_inds(0:nFastLocVecs-1)))), $
                        fastLoc.MLT(fastLoc_plotInds)*15,fastLoc.ILAT(fastLoc_plotInds), $
                        COLOR='k',SYM_SIZE=0.3, $;HEAD_ANGLE=60,HEAD_INDENT=0.6, ARROW_STYLE=0, $
                        NAME='Orbit '+STRCOMPRESS(fLorb),TITLE='Orbit '+STRCOMPRESS(fLorb),/OVERPLOT)
     fastLocVecPlot1=VECTOR(TRANSPOSE(orbVectors(0,fastLoc_plotInds)),ABS(TRANSPOSE(orbVectors(1,fastLoc_plotInds))), $
                            fastLoc.MLT(fastLoc_plotInds)*15,fastLoc.ILAT(fastLoc_plotInds), $
                            COLOR='r',SYM_SIZE=0.3,NAME='Orbit '+STRCOMPRESS(fLorb),TITLE='Orbit '+STRCOMPRESS(fLorb),/OVERPLOT)
     
     fLorb=9000
     fastLoc_plotInds=cgsetintersection(WHERE(fastLoc.ILAT GT 0),WHERE(fastLoc.orbit EQ fLorb))
     ;; fLMax=max(fastLoc_plotInds,fLindMax,SUBSCRIPT_MIN=fLindMin)
     fLnEl=N_ELEMENTS(fastLoc_plotInds)
     fLsubset=FIX(indgen(nFastLocVecs,/FLOAT)/(nFastLocVecs-1)*(fLnEl-1))
     fastLoc_plotInds=fastLoc_plotInds(fLsubset)
              
     ;;find the corresponding lookup vectors
     ;; hwM_inds = MAKE_ARRAY(1000,/INTEGER,VALUE=0) ;I'm assuming no orbit will have more than 100000 events
     FOR j=0,N_ELEMENTS(nFastLocVecs)-1 DO BEGIN
        near = Min(Abs(hwM_normVecs.MLTs-(fastLoc.MLT(fastLoc_plotInds))(j)), temp)
        hwM_inds(j) = temp
     ENDFOR

     hwMVecPlot2=VECTOR(TRANSPOSE(hwM_normVecs.normVectors(0,hwM_inds(0:nFastLocVecs-1))), $
                        ABS(TRANSPOSE(hwM_normVecs.normVectors(1,hwM_inds(0:nFastLocVecs-1)))), $
                        fastLoc.MLT(fastLoc_plotInds)*15,fastLoc.ILAT(fastLoc_plotInds), $
                        COLOR='k',SYM_SIZE=0.3, $ ;HEAD_ANGLE=60,HEAD_INDENT=0.6, ARROW_STYLE=0, $
                        NAME='Orbit '+STRCOMPRESS(fLorb),TITLE='Orbit '+STRCOMPRESS(fLorb),/OVERPLOT)
     fastLocVecPlot2=VECTOR(TRANSPOSE(orbVectors(0,fastLoc_plotInds)),ABS(TRANSPOSE(orbVectors(1,fastLoc_plotInds))), $
                            fastLoc.MLT(fastLoc_plotInds)*15,fastLoc.ILAT(fastLoc_plotInds), $
                            COLOR='g',SYM_SIZE=0.3,NAME='Orbit '+STRCOMPRESS(fLorb),TITLE='Orbit '+STRCOMPRESS(fLorb),/OVERPLOT)


     ; Add the legend.
     leg = LEGEND(TARGET=[fastLocVecPlot1,fastLocVecPlot2], POSITION=[0.1,0.1], $
                  /NORMAL, /AUTO_TEXT_COLOR)

     ; check normalization
     ;; dotProds(cur_i:cur_i+curOrb_nEvents-1)=orbVectors(0,cur_i:cur_i+curOrb_nEvents-1)*hwM_normVecs.normVectors(0,hwM_inds(0:curOrb_nEvents-1)) + $
     ;;                hemi*orbVectors(1,cur_i:cur_i+curOrb_nEvents-1)*hwM_normVecs.normVectors(1,hwM_inds(0:curOrb_nEvents-1))

     PRINT,FORMAT='("MLT",T12,"ILAT",T24,"Magnitude")'
     FOR j=0,nFastLocVecs-1 DO PRINT,FORMAT='(F0.3,T12,F0.3,T24,F0.3)', $
                                     orbVectors(0,fastLoc_plotInds(j)),ABS(orbVectors(1,fastLoc_plotInds(j))), $
                                     orbVectors(0,fastLoc_plotInds(j))^2+ABS(orbVectors(1,fastLoc_plotInds(j)))^2
     
                                     
;;fastLoc_plotInds(-1)-fastLoc_plotInds(0))

;; Blue b
;; Green g
;; Red r
;; Cyan c
;; Magenta m
;; Yellow y
;; Black k
;; White w

END