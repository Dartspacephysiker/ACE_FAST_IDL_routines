; docformat = 'rst'
;
; NAME:
;   interp_contplot.pro
;
; PURPOSE:
; The purpose of interp_contplot is to display a FAST database
; parameter that has been binned by MLT and ILAT as a 2D histogram.;   
;   
;+
; The purpose of interp_contplot is to display a FAST database
; parameter that has been binned by MLT and ILAT as a 2D histogram.
; 
; Program default colors can be set within the program; see below. If no windows are currently
; open when the program is called, cgDisplay is used to create a window.
; 
; The program requires the `Coyote Library <http://www.idlcoyote.com/documents/programs.php>`
; to be installed on your machine.
;
; :Categories:
;    Graphics
;    
; :Params:
;    h2dData: in, required, type=any
;    This data should be a 2D array of data, binned by MLT and ILAT.
;       
; :Keywords:
;     CONTOUR: in, optional, default=0. Overlay a contour on the 2D
;     histogram using cg library plus some SLAC procedures.
;
; :Examples:
;     Kick it.
;  
; :Author:
;    Hammertime         
;-

PRO interp_contplot,h2dData,h2dTitle,CONTOUR=contour,MAX=max

;variables from interp_plots.pro
COMMON ContVars, minMLT, maxMLT, minILAT, maxILAT 

;map=cgMap('Polar Stereographic',/LATLON_RANGES, $
;          XRANGE=[minMLT*15.0,maxMLT*15.0], YRANGE=[minILAT,maxILAT], $
;          TITLE="Polar Stereo Display")


maxCmd= 5e3
maxH2d=(KEYWORD_SET(MAX))? maxCmd : MAX(h2dData)

minH2d=MIN(h2dData)

; Open a display window.
cgDisplay

; Load the color table for contours
IF KEYWORD_SET(CONTOUR) THEN BEGIN & $
   cgLoadCT,65 & $
   TVLCT, r, g, b, /Get & $
   cPalette = [ [r], [g], [b] ] & $
   ENDIF

; Load the color table for the display. All bottomed-out (saturation) values will be gray.
cgLoadCT, 4
TVLCT, cgColor('gray', /Triple), 0
TVLCT, r, g, b, /Get
palette = [ [r], [g], [b] ]
   
;imgMax=0
;imgMin=-30

;You might consider replacing h2dScaled with h2dData, here and in cgContour
; Display the density plot.
cgImage, h2dData, XRange=[minMLT,maxMLT], YRange=[minILAT,maxILAT],$
	/Axes, Palette=palette,$
        minvalue=(imgMin EQ !NULL) ? minH2d : imgMin,$
        maxvalue=(imgMax EQ !NULL) ? maxH2d : imgMax,$
	XTitle='MLT', YTitle='ILAT', $;MAPCOORD=map$
        Title=(h2dTitle EQ "") ? "Flux" : h2dTitle ,$
	Position=[0.125, 0.125, 0.9, 0.8]


;If CONTOUR keyword set, do them contours
IF KEYWORD_SET(CONTOUR) THEN BEGIN & $
   nContours=4 & $
   cLevels=((maxH2d-minH2d)*(findgen(nContours)+0.5)/nContours+minH2d) & $
   thick = (!D.Name EQ 'PS') ? 6 : 2 & $
   
   print,"Num elements is",n_elements(h2dData) & $
   print,"cLevels is",cLevels & $
   
   cgContour, h2dData, $
    LEVELS=cLevels, /OnImage,$
    C_Colors=bytscl(indgen(nContours)), $
    C_Annotation=['Low', 'Avg', 'High'],$
    Palette=cPalette & $
    ;C_Thick=thick, C_CharThick=thick
   ENDIF


; Display a color bar.

rangeMin=(imgMin EQ !NULL) ? minH2d : imgMin
rangeMax=(imgMax EQ !NULL) ? maxH2d : imgMax

print,"min and maxval:"
print,rangeMin,rangeMax

   cgColorbar, Position=[0.15, 0.9, 0.9, 0.925], Title='Flux', $
            Range=[rangeMin, rangeMax], NColors=254;, TLocation='Top';, $
;           Bottom=1, OOB_Low='gray'
END 
;*****************************************************************
