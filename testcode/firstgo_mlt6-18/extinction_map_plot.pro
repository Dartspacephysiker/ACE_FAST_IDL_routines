; docformat = 'rst'
;+
; This is an example program to demonstrate how to create a curvilinear extinction map plot
; with Coyote Graphics routines. Data obtained from the 
; `AstroPlotLib <http://astroplotlib.stsci.edu/page_curvilinear.htm>` web page. The program
; requires mrdfits from the `NASA Astronomy Library <http://idlastro.gsfc.nasa.gov/homepage.html>`.
; Additional NASA Astronomy Library programs may also be required. It is recommended you download
; and install the entire library.
;
; :Categories:
;    Graphics
;    
; :Examples:
;    Save the program as "extinction_map_plot.pro" and run it like this::
;       IDL> .RUN extinction_map_plot
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
;        Written, 15 February 2013 by David W. Fanning.
;
; :Copyright:
;     Copyright (c) 2013, Fanning Software Consulting, Inc.
;-
PRO Extinction_Map_Plot
 
   ; Read the data file.
   image = mrdfits('lmc_map.fits', 0, hdr) 
   
   ; Open a graphics window.
   cgDisplay
   
   ; Set up the curvilinear map projection coordinates. Note that
   ; we reverse the X axis.
   position = [0.1, 0.25, 0.9, 0.925]
   cgMap_Set, -70,70, /NoErase, /NoBorder, /Reverse, $
      Limit=[-64, 0, -74, 100], $
      Position=position
      
   ; Because we are overplotting a contour plot on a map projecton, 
   ; we must define longitude and latitude vectors that correspond to
   ; the location of the data.
   dims = Size(image, /Dimensions)
   lons = Reverse(cgScaleVector(Findgen(dims[0]), 66.8, 94.2))
   lats = cgScaleVector(Findgen(dims[1]), -66, -74)
   
   ; Load the colors for the plot.
   nlevels = 10
   cgLoadCT, 29, /Brewer, NColors=10, Bottom=1, Clip=[50,225]
   
   ; Set up the contour levels.
   levels = cgScaleVector(Indgen(nlevels), 0.0, 0.5)
   
   ; Remove missing data in the image, indicated by -1000.0 value.
   missingIndices = Where(image EQ -1000.0, missingCount)
   IF missingCount GT 0 THEN image[missingIndices] = !Values.F_NaN
   
   ; Contour the data.
   cgContour, image, lons, lats, Levels=levels, /Overplot, /Cell_Fill, $
      C_Colors=Indgen(nlevels)+1B
      
   ; Add map grid. Set the Clip_Text keyword to enable the NO_CLIP graphics keyword.
   cgMap_Grid, Clip_Text=0, /NoClip

   ; Add annotations to the plot.
   charsize = cgDefCharSize()*0.75
   cgText, 96, -74.5, '7$\uph$00', Alignment=0.5, Orientation=15.00, Charsize=charsize
   cgText, 92, -74.5, '6$\uph$40', Alignment=0.5, Orientation=10.75, Charsize=charsize
   cgText, 88, -74.5, '6$\uph$20', Alignment=0.5, Orientation=6.50, Charsize=charsize
   cgText, 84, -74.5, '6$\uph$00', Alignment=0.5, Orientation=2.25, Charsize=charsize
   cgText, 80, -74.5, '5$\uph$40', Alignment=0.5, Orientation=0.00, Charsize=charsize
   cgText, 76, -74.5, '5$\uph$20', Alignment=0.5, Orientation=-2.25, Charsize=charsize
   cgText, 72, -74.5, '5$\uph$00', Alignment=0.5, Orientation=-6.50, Charsize=charsize
   cgText, 68, -74.5, '4$\uph$40', Alignment=0.5, Orientation=-10.25, Charsize=charsize
   cgText, 64, -74.5, '4$\uph$20', Alignment=0.5, Orientation=-15.00, Charsize=charsize
    
    
   cgText, 97.750, -74, '-74', Alignment=0.5, Orientation=15.00, Charsize=charsize
   cgText, 97.688, -73, '-73', Alignment=0.5, Orientation=15.00, Charsize=charsize
   cgText, 97.625, -72, '-72', Alignment=0.5, Orientation=15.00, Charsize=charsize
   cgText, 97.563, -71, '-71', Alignment=0.5, Orientation=15.00, Charsize=charsize
   cgText, 97.500, -70, '-70', Alignment=0.5, Orientation=15.00, Charsize=charsize
   cgText, 97.478, -69, '-69', Alignment=0.5, Orientation=15.00, Charsize=charsize
   cgText, 97.375, -68, '-68', Alignment=0.5, Orientation=15.00, Charsize=charsize
   cgText, 97.313, -67, '-67', Alignment=0.5, Orientation=15.00, Charsize=charsize
   cgText, 97.250, -66, '-66', Alignment=0.5, Orientation=15.00, Charsize=charsize
  
   cgText, 0.50, 0.22, /Normal, Alignment=0.5, '$\alpha$ (hours)'
   cgText, 0.10, 0.54, /Normal, Alignment=0.5, '$\delta$ (degree)', Orientation= 105.

   ; Add a colorbar.
   cgColorbar, NColors=nlevels, Bottom=1, Range=[0.0, 5.0], Divisions=nlevels, $
        /Discrete, Format='(F0.1)', Position=[0.25, 0.065, 0.75, 0.115], $
        Title='E(V-I)', TLocation='top'
        
END ;*****************************************************************

; This main program shows how to call the program and produce
; various types of output.

  ; Display the plot in a graphics window.
  ;Extinction_Map_Plot
  
  ; Display the plot in a resizeable graphics window.
  cgWindow, 'Extinction_Map_Plot', WBackground='white', $
    WTitle='Curvilinear Extinction Map Plot in a Resizeable Graphics Window'
  
  ; Create a PostScript file.
  ;cgPS_Open, 'extinction_map_plot.ps'
  ;Extinction_Map_Plot
  ;cgPS_Close
  
  ; Create a PNG file with a width of 600 pixels.
  ;cgPS2Raster, 'extinction_map_plot.ps', /PNG, Width=600

END