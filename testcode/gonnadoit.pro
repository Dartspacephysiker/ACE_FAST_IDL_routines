;###################################################
    ; Read the data.
;    lat_file = 'lat.dat'
;    lon_file = 'lon.dat'
;    u_file = 'u.dat'
;    v_file = 'v.dat'
;
;    n_lat = 46 ; given
;    n_lon = 72 ; given
;    lat = fltarr(n_lat)
;    lon = fltarr(n_lon)
;    u = fltarr(n_lon, n_lat)
;    v = fltarr(n_lon, n_lat)
;
;    OpenR, id, lat_file,/Get_Lun
;    ReadF, id, lat
;    Free_Lun, id
;
;    OpenR, id, lon_file, /Get_Lun
;    ReadF, id, lon
;    Free_Lun, id
;
;    OpenR, id, u_file, /Get_Lun
;    ReadF, id, u
;    Free_Lun, id
;
;    OpenR, id, v_file, /Get_Lun
;    ReadF, id, v
;    Free_Lun, id
;    
;        ; Wrap the data.
;    lon = [lon, lon[0]]
;    u = [u,u[0,*]]
;    v = [v,v[0,*]]
;    ;#######################################################

restore,"fluxplots_North_dawnward_med_0stable__Jan_22_14.dat"
restore,"elecdata.dat"
restore,"pData.dat"
restore,"mlts_ilats.dat"

; Do this in decomposed color.
cgSetColorState, 1, Current=currentColorState


maxMLT=18
minMLT=6   
maxILAT=85
minILAT=65
binMLT=0.5
binILAT=1

nLon=(maxMLT-minMLT)/binMLT + 1
nLat=(maxILAT-minILAT)/binILAT + 1

lon=(indgen(nLon)*binMLT+minMLT)*15
lat=indgen(nLat)*binILAT+minILAT

lon = lon - (LONG(lon )/180)*360.0

; Wrap the data.
;lon = [lon, lon[0]]

; Properties for all four plots.
nLevels = 30
cgLoadct, 22, /REVERSE, /BREWER, NCOLORS=nLevels
speeds = Indgen(nLevels)*2 ; m/s
;lons = Rebin(lon, nLon+1, nLat)
;lats = Rebin(Reform(lat,1,nLat), nLon+1, nLat)
hsize = (!D.Name NE 'PS') ? 5 : 8

; North contour plot.
mapNorth = Obj_New('cgMap', 'Polar Stereographic', Limit=[minILAT, min(lon), maxILAT, max(lon)], $
Position=[0.1, 0.1, 0.8, 0.8], Aspect=1.0, /NoBorder)
mapNorth -> Draw
cgContour, h2deflux, lon, lat>0, /Fill, nLevels=nLevels, missingvalue=0, $
Label=0, /Overplot, C_Colors=Indgen(nLevels), Map=mapNorth

; Plot annotations.
cgMap_Grid, LatDel=10, LonDel=90, LineStyle=0, Color='charcoal', Map=mapNorth
    
; Grid labels
mapNorth -> SetProperty, Position=[0.1, 0.1, 0.8, 0.8], Limit=[minILAT-5, min(lon), maxILAT, max(lon)]
cgMap_Grid, LatDel=10, LonDel=90, Color='charcoal', Map=mapNorth, LatLab=45, LonLab=65, $
            /Label, /No_Grid, LONS=[0,90,180,270],LONNAMES=['0','6','12','18']    