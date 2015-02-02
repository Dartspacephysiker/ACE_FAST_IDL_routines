; docformat = 'rst'
;+
; This is an example program to demontrate how to create a polar wind plot
; with Coyote Graphics routines.
;
; :Categories:
;    Graphics
;    
; :Examples:
;    Save the program as "polar_wind_plot.pro" and run it like this::
;       IDL> .RUN polar_wind_plot
;       
; :Author:
;    FANNING SOFTWARE CONSULTING::
;       David W. Fanning 
;       1645 Sheely Drive
;       Fort Collins, CO 80526 USA
;       Phone: 970-221-0438
;       E-mail: david@idlcoyote.com
;       Coyote's Guide to IDL Programming: http://www.idlcoyote.com
;
; :History:
;     Change History::
;        Written, 23 January 2013 by David W. Fanning.
;        Modified to use updated cgMapVector object, 3 July 2013. DWF.
;
; :Copyright:
;     Copyright (c) 2013, Fanning Software Consulting, Inc.
;-
PRO Polar_Wind_Plot

 
    ; Do this in decomposed color.
    cgSetColorState, 1, Current=currentColorState
    
    ; Read the data.
    lat_file = 'lat.dat'
    lon_file = 'lon.dat'
    u_file = 'u.dat'
    v_file = 'v.dat'

    n_lat = 46 ; given
    n_lon = 72 ; given
    lat = fltarr(n_lat)
    lon = fltarr(n_lon)
    u = fltarr(n_lon, n_lat)
    v = fltarr(n_lon, n_lat)

    OpenR, id, lat_file,/Get_Lun
    ReadF, id, lat
    Free_Lun, id

    OpenR, id, lon_file, /Get_Lun
    ReadF, id, lon
    Free_Lun, id

    OpenR, id, u_file, /Get_Lun
    ReadF, id, u
    Free_Lun, id

    OpenR, id, v_file, /Get_Lun
    ReadF, id, v
    Free_Lun, id
    
    ; Wrap the data.
    lon = [lon, lon[0]]
    u = [u,u[0,*]]
    v = [v,v[0,*]]
    
    ; Calculate wind speeds.
    wspd = sqrt(u^2 + v^2)
   
    ; Properties for all four plots.
    n_levels = 12
    cgLoadct, 22, /REVERSE, /BREWER, NCOLORS=12
    speeds = Indgen(n_levels)*2 ; m/s
    lons = Rebin(lon, n_lon+1, n_lat)
    lats = Rebin(Reform(lat,1,n_lat), n_lon+1, n_lat)
    hsize = (!D.Name NE 'PS') ? 5 : 8
    
    ; Graphics window.
    cgDisplay, 800, 600
    
    ; North contour plot.
    mapNorth = Obj_New('cgMap', 'Polar Stereographic', Limit=[0, -180, 90, 180], $
       Position=[0.08, 0.53, 0.47, 0.92], Aspect=1.0, /NoBorder)
    mapNorth -> Draw
    cgContour, wspd, lon, lat>0, /Fill, Levels=speeds, $
        Label=0, /Overplot, C_Colors=Indgen(12), Map=mapNorth
        
    ; Plot annotations.
    cgMap_Continents, Color='charcoal', Map=mapNorth
    cgMap_Grid, LatDel=30, LonDel=60, LineStyle=0, Color='charcoal', Map=mapNorth
    
    ; Grid labels
    mapNorth -> SetProperty, Position=[0.03, 0.48, 0.52, 0.96], Limit=[-15, -180, 90, 180]
    cgMap_Grid, LatDel=30, LonDel=60, Color='charcoal', Map=mapNorth, LatLab=15, LonLab=-10, /Label, /No_Grid

    ; North wind plot.
    mapNorth -> SetProperty, Position=[0.48, 0.53, 0.87, 0.92], Limit=[0, -180, 90, 180]
    mapNorth -> Draw
    indices = Where(lats GE 0, count)
    cgLoadct, 22, /REVERSE, /BREWER, NColor=12, RGB_TABLE=palette
    windNorth = Obj_New('cgMapVector', mapNorth, LATS=lats[indices], LONS=lons[indices], $
         VMAGNITUDE=v[indices], UMAGNITUDE=u[indices], LENGTH=25, $
         POSITION=[0.48, 0.53, 0.87, 0.92], PALETTE=palette, /SOLID, HSIZE=hsize)
    windNorth -> Draw
    
    ; Plot annotations.
    cgMap_Continents, Color='charcoal', Map=mapNorth
    cgMap_Grid, LatDel=30, LonDel=60, LineStyle=0, Color='charcoal', Map=mapNorth

    ; Grid labels
    mapNorth -> SetProperty, Position=[0.43, 0.48, 0.92, 0.96], Limit=[-15, -180, 90, 180]
    cgMap_Grid, LatDel=30, LonDel=60, Color='charcoal', Map=mapNorth, LatLab=15, LonLab=-10, /Label, /No_Grid

    ; South contour plot.
    mapSouth = Obj_New('cgMap', 'Polar Stereographic', Limit=[-90, -180, 0, 180], $
       Position=[0.08, 0.08, 0.47, 0.47], Aspect=1.0, Center_Lat=-90, /NoBorder)
    mapSouth -> Draw
    cgContour, wspd, lon, lat<0, /Fill, Levels=speeds, $
        Label=0, /Overplot, C_Colors=Indgen(12), Map=mapSouth
        
    ; Plot annotations.
    cgMap_Continents, Color='charcoal', Map=mapSouth
    cgMap_Grid, LatDel=30, LonDel=60, LineStyle=0, Color='charcoal', Map=mapSouth

    ; Grid labels
    mapSouth -> SetProperty, Position=[0.03, 0.03, 0.52, 0.50], Limit=[-90, -180, 15, 180]
    cgMap_Grid, LatDel=30, LonDel=60, Color='charcoal', Map=mapSouth, LatLab=165, LonLab=10, /Label, /No_Grid

    ; South wind plot.
    mapSouth -> SetProperty, Position=[0.48, 0.08, 0.87, 0.47], Limit=[-90, -180, 0, 180]
    mapSouth -> Draw
    indices = Where(lats LT 0, count)
    cgLoadct, 22, /REVERSE, /BREWER, NColor=12, RGB_TABLE=palette
    minmax, lons[indices]
    windSouth = Obj_New('cgMapVector', mapSouth, LATS=lats[indices], LONS=lons[indices], $
         VMAGNITUDE=v[indices], UMAGNITUDE=u[indices], LENGTH=25, $
         POSITION=[0.48, 0.08, 0.87, 0.47], PALETTE=palette, /SOLID, HSIZE=hsize)
    windSouth -> Draw
    
    ; Plot annotations
    cgMap_Continents, Color='charcoal', Map=mapSouth
    cgMap_Grid, LatDel=30, LonDel=60, LineStyle=0, Color='charcoal', Map=mapSouth
       
    ; Grid labels
    mapSouth -> SetProperty, Position=[0.43, 0.03, 0.92, 0.50], Limit=[-90, -180, 15, 180]
    cgMap_Grid, LatDel=30, LonDel=60, Color='charcoal', Map=mapSouth, LatLab=165, LonLab=10, /Label, /No_Grid

    ; Other plot annotation.
    cgText, 0.045, 0.90, /Normal, Charsize=2.0, 'North'
    cgText, 0.045, 0.45, /Normal, Charsize=2.0, 'South'
    cgColorBar, Divisions=10, Range=[2,22], OOB_Low=0B, OOB_High=11B, $
       NColors=10, BOTTOM=1, /Vertical, Position=[0.90, 0.2, 0.92, 0.8], $
       Tlocation='Right', /Discrete, Title='Wind Speed (ms$\up-1$)', OOB_Factor=2
       
    ; Restore the color state.
    cgSetColorState, currentColorState
    
    ; Clean up
    Obj_Destroy, mapNorth
    Obj_Destroy, windNorth
    Obj_Destroy, mapSouth
    Obj_Destroy, windSouth

END ;*****************************************************************

; This main program shows how to call the program and produce
; various types of output.

  ; Display the contour plot in a graphics window.
  Polar_Wind_Plot
  
  ; Display the contour plot in a resizeable graphics window.
  cgWindow, 'Polar_Wind_Plot', WBackground='White', $
     WTitle='Polar Wind Plot in a Resizeable Graphics Window'
  
  ; Create a PostScript file.
  cgPS_Open, 'polar_wind_plot.ps'
  Polar_Wind_Plot
  cgPS_Close
  
  ; Create a PNG file with a width of 600 pixels.
  cgPS2Raster, 'polar_wind_plot.ps', /PNG, Width=600

END