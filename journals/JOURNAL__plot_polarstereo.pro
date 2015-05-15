;You'd better believe I'm following my man, David Fanning, to do this.
;Check out http://www.idlcoyote.com/code_tips/usegriddata.html, which
;is my idea source.

;Just use any old entry in h2dStr to get the info you need on lat and long


;h2dData=h2deflux_av

;nLat=N_ELEMENTS((h2dStr[0].data)[0,*]) ;Corresponds to ILAT
;nLong=N_ELEMENTS((h2dStr[0].data)[*,0]);Corresponds to MLT

;nLat=N_ELEMENTS(h2dData[0,*]) ;Corresponds to ILAT
;nLong=N_ELEMENTS(h2dData[*,0]);Corresponds to MLT

;lat = cgScaleVector(Findgen(nLat)*binILAT, minILAT, maxILAT)
;lon = cgScaleVector(Findgen(nLong)*binMLT, minMLT*15.0,maxMLT*15.0)-180 ;scaled -180 to 180

;ysize = Size(lat, /DIMENSION)
;xsize = Size(lon, /DIMENSION)
;lats = Rebin(Reform(lat, 1, ysize), xsize, ysize)
;lons = Rebin(lon, xsize, ysize)

;mapStruct = Map_Proj_Init('Polar Stereographic', /GCTP, CENTER_LON=0, $
;   CENTER_LAT=70)
;xy = Map_Proj_Forward(lons, lats, MAP_STRUCTURE=mapStruct)
;x = Reform(xy[0,*], xsize, ysize)
;y = Reform(xy[1,*], xsize, ysize)

;Triangulate, x ,y, triangles,TOLERANCE=1.0

;griddedData = GridData(x, y, h2dData, /NEAREST_NEIGHBOR, /DEGREES,$
;                       TRIANGLES=triangles, DELTA=[25000, 25000], $
;                       DIMENSION=[304,448], START=[-3850000., -5350000.], $
;                       MISSING=!Values.F_NAN)

;scaledImage = BytScl(regriddedImage, TOP=9, MIN=-7.5, MAX=7.5) + 1B

;************************************************************


cgLoadCT, 4
TVLCT, cgColor('gray', /Triple), 0
TVLCT, r, g, b, /Get
palette = [ [r], [g], [b] ]

;h2dData=ABS(h2dEflux_av)
;nLat=N_ELEMENTS(h2dData[0,*]) ;Corresponds to ILAT
;nLong=N_ELEMENTS(h2dData[*,0]);Corresponds to MLT
;lat = cgScaleVector(Findgen(nLat)*binILAT, minILAT, maxILAT)
;lon = cgScaleVector(Findgen(nLong)*binMLT, minMLT*15.0,maxMLT*15.0)

h2dData=ABS(maximus.INTEG_ELEC_ENERGY_FLUX(plot_i))

plot_i=SORT(h2dData)
h2dData=h2dData(plot_i)

;nLat=N_ELEMENTS(plot_i)
;nLong=N_Elements(plot_i)

lat = maximus.ilat(plot_i)
lon = maximus.mlt(plot_i)*15.0

;s = Size(h2dData, /DIMENSIONS)
centerLat = 90
centerLon = 180

mapPosition = [0.05, 0.05, 0.95, 0.95]

map=Obj_New('cgMap','Polar Stereographic',ELLIPSOID='sphere', $
            Position=mapPosition, $
            Center_Latitude=90, Center_Longitude=centerLon) ;$
;            TITLE="Polar Stereo Display")
 
warped = cgWarpToMap(h2dData, lon, lat, Map=map,$; Missing=0, $
                     Resolution=[100, 100], /SetRange)

maxH2d=MAX(warped)

minH2d=MIN(warped)

cgImage, warped, Stretch=1, Position=[0.1, 0.1, 0.9, 0.9], Background='white',$
         XRANGE=xrange,YRANGE=yrange;PALETTE=palette
map -> Draw
annotateColor = 'Yellow'
cgMap_Grid, Map=map, /Label, Color=annotateColor, /cgGrid


;***********************************************


;map=Obj_New('cgMap','Polar Stereographic',/LATLON_RANGES, $
;          XRANGE=[minMLT*15.0,maxMLT*15.0], YRANGE=[minILAT,maxILAT], $
;          TITLE="Polar Stereo Display")


;ysize = Size(lat, /DIMENSION)
;xsize = Size(lon, /DIMENSION)
;lats = Rebin(Reform(lat, 1, ysize), xsize, ysize)
;lons = Rebin(lon, xsize, ysize)


;mapStruct = Map_Proj_Init('Equirectangular', /GCTP, CENTER_LON=180, SPHERE_RADI;US=6378273.00)
;xy = Map_Proj_Forward(lons, lats, MAP_STRUCTURE=mapStruct)
;x = Reform(xy[0,*], xsize, ysize)
;y = Reform(xy[1,*], xsize, ysize)

;Triangulate, x ,y, triangles

;griddedData = GridData(x, y, h2dStr[0].data, /NEAREST_NEIGHBOR, $
;                       TRIANGLES=triangles, DELTA=[25000, 25000], $
;                       DIMENSION=[304,448], START=[-3850000., -5350000.], $
;                       MISSING=!Values.F_NAN)






