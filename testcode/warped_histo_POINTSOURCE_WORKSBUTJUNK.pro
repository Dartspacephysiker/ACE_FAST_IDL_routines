PRO warped_histo
restore,'fluxplots_North_duskward_avg_0stable_Jan_24_14rawimage_0.dat'

cgSetColorState, 1, Current=currentColorState

binMLT=0.25
binILAT=0.5

minMLT = 9
maxMLT = 15

minILAT = 65
maxILAT = 85

nLevels=12
cgLoadCT, 22,/BREWER, /REVERSE,nColors=nLevels

nLon=(maxMLT-minMLT)/binMLT + 1
nLat=(maxILAT-minILAT)/binILAT + 1

grid_lat=findgen(nLat)*binILAT+minILAT   ;30 to 90 deg @2 deg
grid_lon=(findgen(nLon)*binMLT+minMLT)*15   ;0 to 360 deg @2 deg

grid_lat+=binILAT/2
grid_lon+=binMLT/2*15

that=Replicate_Array(grid_lat,n_elements(grid_lon))
this=Replicate_Array(grid_lon,n_elements(grid_lat))
that=transpose(that)

;grid_lat=REVERSE(findgen(nLat)*binILAT+minILAT)   ;30 to 90 deg @2 deg
;grid_lon=REVERSE((findgen(nLon)*binMLT+minMLT)*15)   ;0 to 360 deg @2 deg

;mapNorth = Obj_New('cgMap', 'Polar Stereographic', /ONIMAGE, $
;                    Limit=[minILAT, minMLT*15, maxILAT, maxMLT*15], $
;                    Position=[0.1, 0.1, 0.8, 0.8], Aspect=1.0, /NOBORDER)

mapPosition = [0.05, 0.05, 0.95, 0.95]

mapNorth = Obj_New('cgMap', 'Polar Stereographic',POSITION=mapPosition,/ONIMAGE,$
                    Limit=[minILAT, minMLT*15, maxILAT, maxMLT*15])

;********
symbol = cgSymCat(15)
cgPlotS,this,that,PSym=symbol,Color=temp,symsize=1,MAP_OBJECT=mapNorth

mapNorth-> GetProperty, XRange=xrange, YRange=yrange

;warped = cgWarpToMap(temp, REVERSE(grid_lon), grid_lat, MAP=mapNorth, $
;                      Resolution=[400,300],/SETRANGE)

;warped = cgWarpToMap(temp, REVERSE(grid_lon), grid_lat, MAP=mapNorth, $
;                      Resolution=[400,300],xrange=xrange,yrange=yrange/2)

cgDisplay, /Free, Title='Warped Image with cgWarpToMap'
;cgImage, warped, Position=[0.1,0.1,0.8,0.8],stretch=0,bottom=1,top=BYTE(nLevels-2),negative=0
mapNorth -> Draw



cgMap_Grid, LineStyle=0, Color='charcoal', Map=mapNorth,$
            LONS=[0,45,90,135,180,225,270],LATS=[65,70,75,80,85]
cgMap_Grid, Color='charcoal', Map=mapNorth, LatLab=minMLT*15-3, LonLab=minILAT+1, $
           /Label, /No_Grid,CLIP_TEXT=0, $
           LONS=[0,45,90,135,180,225,270],LONNAMES=['0','3','6','9','12','15','18'],$
           LATS=[65,70,75,80,85],LATNAMES=['65','70','75','80','85']
        
            

;cgColorBar, Divisions=nLevels-2, Range=[rangeLow,rangeHigh], OOB_Low=0B, OOB_High=BYTE(nLevels-1), $
;NColors=nLevels-2, BOTTOM=1B, /Vertical, Position=[0.90, 0.2, 0.92, 0.8], $
;Tlocation='Right', /Discrete, Title='Electron flux (ergs/cm$\up2$)', OOB_Factor=2

END