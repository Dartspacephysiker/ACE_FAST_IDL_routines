PRO gonnadoit2
restore,"fluxplots_North_dawnward_med_0stable__Jan_22_14.dat"
restore,"elecdata.dat"
restore,"pData.dat"
restore,"mlts_ilats.dat"

; Do this in decomposed color.
cgSetColorState, 1, Current=currentColorState


minMLT = 9
maxMLT = 15 
maxILAT=85
minILAT=65
binMLT=0.5
binILAT=1

nLon=(maxMLT-minMLT)/binMLT + 1
nLat=(maxILAT-minILAT)/binILAT + 1

lon=mlts*15
lat=ilats

lon = lon - (LONG(lon )/180)*360.0

; Wrap the data.
;lon = [lon, lon[0]]

; Properties for all four plots.
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
grid_lon = grid_lon - (LONG(grid_lon )/180)*360.0
   
;drop high e values
;elecdata(where(elecdata GT 1e5))=!VALUES.F_NAN


;stuff
grid_input, lon, lat, elecdata, xyz, newelec, /degree, /sphere, epsilon = 0.1,$
            EXCLUDE=WHERE(elecdata GT 1e5),DUPLICATES="avg"
            
lon = !radeg * atan(xyz[1,*],xyz[0,*])
lat = !radeg * asin(xyz[2,*])
qhull, lon, lat, tri, /delaunay, SPHERE=sph


;get it on a nice grid   
Result = GRIDDATA( Lon,  Lat,  newelec,  /SPHERE, /DEGREE, $
                  /NEAREST_NEIGHBOR, /GRID, xout=grid_lon, yout=grid_lat,$
                  triangles=tri, missing=!VALUES.F_NAN)

;##################################################

; North contour plot.
mapNorth = Obj_New('cgMap', 'Polar Stereographic', Limit=[minILAT, min(lon), maxILAT, max(lon)], $
Position=[0.1, 0.1, 0.8, 0.8], Aspect=1.0, /NoBorder)
mapNorth -> Draw
cgContour, alog10(Result), grid_lon, grid_lat, /Fill, nLevels=nLevels, $
           Label=0, /Overplot, C_Colors=Indgen(nLevels), Map=mapNorth

; Plot annotations.
cgMap_Grid, LatDel=10, LonDel=45, LineStyle=0, Color='charcoal', Map=mapNorth
    
; Grid labels
mapNorth -> SetProperty, Position=[0.05, 0.05, 0.85, 0.85], Limit=[minILAT-5, min(lon), maxILAT, max(lon)]
cgMap_Grid, LatDel=10, Color='charcoal', Map=mapNorth, LatLab=50, LonLab=minILAT-3, $
            /Label, /No_Grid, LONS=[0,90,180,270],LONNAMES=['0','6','12','18']

;rangeLow=(result(sort(result)))[3]
;rangeHigh=(result(sort(result)))[-3]
 
rangeLow=0
rangeHigh=5000
            
cgColorBar, Divisions=nLevels-2, Range=[rangeLow,rangeHigh], OOB_Low=0B, OOB_High=BYTE(nLevels-1), $
NColors=nLevels-2, BOTTOM=1B, /Vertical, Position=[0.90, 0.2, 0.92, 0.8], $
Tlocation='Right', /Discrete, Title='Electron flux (ergs/cm$\up2$)', OOB_Factor=2

END