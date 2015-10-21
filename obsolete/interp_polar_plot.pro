PRO interp_polar_plot,rawData,limits
COMMON ContVars, minMLT, maxMLT, minILAT, maxILAT,binMLT,binILAT

;I believe the whole premise of this program is a mistake; it doesn't do any histogramming,
;and in fact grid_input throws out all of our extra data points!

;rawData=[[*dataRawPtr[0]],[maximus.mlt(plot_i)],[maximus.ilat(plot_i)]]
; Do this in decomposed color.
cgSetColorState, 1, Current=currentColorState

nLon=(maxMLT-minMLT)/binMLT + 1
nLat=(maxILAT-minILAT)/binILAT + 1

lon=REFORM(rawData[*,1])*15
lat=REFORM(rawData[*,2])
data=(rawData[*,0])

;lon = lon - (LONG(lon )/180)*360.0

; Wrap the data.
;lon = [lon, lon[0]]

; Properties for plot.
nLevels = 12 ;must be even number
cgLoadct, 22, /REVERSE, /BREWER, NCOLORS=nLevels
;speeds = Indgen(nLevels)*2 ; m/s
;lons = Rebin(lon, nLon+1, nLat)
;lats = Rebin(Reform(lat,1,nLat), nLon+1, nLat)
hsize = (!D.Name NE 'PS') ? 5 : 8

;******************************************GRIDIT
;set up grid
grid_lat=findgen(nLat)*binILAT+minILAT   ;30 to 90 deg @2 deg
grid_lon=(findgen(nLon)*binMLT+minMLT)*15   ;0 to 360 deg @2 deg
;grid_lon = grid_lon - (LONG(grid_lon )/180)*360.0
   
;drop high e values
data(where(data GT 1e5))=!VALUES.F_NAN


;stuff
grid_input, lon, lat, data, xyz, newData, /degree, /sphere, epsilon = 0.5,$
            DUPLICATES="avg";,EXCLUDE=WHERE(data GT 1e5)
            
lon = !radeg * atan(REFORM(xyz[1,*]),REFORM(xyz[0,*]))
lat = !radeg * asin(REFORM(xyz[2,*]))
qhull, lon, lat, tri, /delaunay, SPHERE=sph


;get it on a nice grid   
griddedData = GRIDDATA( Lon,  Lat, newData, /SPHERE, /DEGREES, $
                  METHOD="InverseDistance", EMPTY_SECTORS=3,$
                  /GRID, xout=grid_lon, yout=grid_lat,$
                  triangles=tri, missing=!VALUES.F_NAN)

;##################################################
;print,griddedData,grid_lon,grid_lat
; North contour plot.
mapNorth = Obj_New('cgMap', 'Polar Stereographic',$
                    Limit=[minILAT, minMLT*15, maxILAT, maxMLT*15], $
                    Position=[0.1, 0.1, 0.8, 0.8], Aspect=1.0, /NOBORDER)
mapNorth -> Draw

cgContour, griddedData, grid_lon, grid_lat, nLevels=nLevels,/CELL_FILL, $
           Label=0, /Overplot, C_Colors=Indgen(nLevels), Map=mapNorth,$
           MISSINGVALUE=!VALUES.F_NAN


; Plot annotations.
cgMap_Grid, LineStyle=0, Color='charcoal', Map=mapNorth,$
            LONS=[0,45,90,135,180,225,270],LATS=[65,70,75,80,85]
    
; Grid labels
;mapNorth -> SetProperty, Position=[0.1, 0.1, 0.8, 0.8], $
;            Limit=[minILAT-2, minMLT*15-4, maxILAT+2, maxMLT*15+4], /DRAW
cgMap_Grid, Color='charcoal', Map=mapNorth, LatLab=minMLT*15-3, LonLab=minILAT-1, $
           /Label, /No_Grid,CLIP_TEXT=0, $
           LONS=[0,45,90,135,180,225,270],LONNAMES=['0','3','6','9','12','15','18'],$
           LATS=[65,70,75,80,85],LATNAMES=['65','70','75','80','85']

IF KEYWORD_SET(limits) THEN BEGIN
  rangeLow=limits[0]
  rangeHigh=limits[1]
ENDIF ELSE BEGIN
  rangeLow=(result(sort(result)))[3]
  rangeHigh=(result(sort(result)))[-3]
ENDELSE
             
cgColorBar, Divisions=nLevels-2, Range=[rangeLow,rangeHigh], OOB_Low=0B, OOB_High=BYTE(nLevels-1), $
NColors=nLevels-2, BOTTOM=1B, /Vertical, Position=[0.90, 0.2, 0.92, 0.8], $
Tlocation='Right', /Discrete, Title='Electron flux (ergs/cm$\up2$)', OOB_Factor=2

END