PRO PointSourceOverlay

   ; Obtain the data: lat, lon, soilc.
   Restore, File='ptsource_carbon.sav'
restore,'fluxplots_North_duskward_avg_0stable_Jan_24_14rawimage_0.dat'

   ; Set up color model, open window.
   cgSetColorState, 0, Current=currentState
;   cgDisplay, 600, 400, /Free, Title='Point Source Overlay on Map'

binMLT=0.25
binILAT=0.5

minMLT = 9
maxMLT = 15

minILAT = 65
maxILAT = 85



   ; Set up the soil carbon colors.
nLevels=12
cgLoadCT, 22,/BREWER, /REVERSE,nColors=nLevels

   ; Set up the map projecton data space.
   cgErase
;   cgMap_Set, /Cylindrical, /NoBorder, /NoErase, $
;     Limit=[-60, -180, 90, 180], Position=[0.1, 0.1, 0.8, 0.9]

mapNorth = Obj_New('cgMap', 'Polar Stereographic',POSITION=mapPosition,/ONIMAGE,$
                    Limit=[minILAT, minMLT*15, maxILAT, maxMLT*15])
   ; Create a land mask.
   cgMap_Continents, Color='black', /Fill
   mask = TVRD()

   ; Plot only those points that are over "land".
   dc = Convert_Coord(lon, lat, /Data, /To_Device)
   indices = Where(mask[dc[0,*],dc[1,*]] EQ 0)
   symbol = cgSymCat(15)
   PlotS, lon[indices ], lat[indices ], PSym=symbol, $
      Color=soilc_colors[indices ], SymSize=0.5

   ; Pretty everything up.
   cgMap_Continents, Color='charcoal'
   cgMap_Grid, /Box, Color='charcoal'
   cgColorbar, /Vertical, Position=[0.87, 0.1, 0.9, 0.9], Bottom=1, NColors=8, $
      Divisions=8, Minor=0, YTicklen=1, Range=[0,Max(soilc)], AnnotateColor='charcoal', $
      /Right, Title='Ton/ha', Format='(F5.3)'

   ; Switch back to color model in effect before we changed it.
   cgSetColorState, currentState

END
