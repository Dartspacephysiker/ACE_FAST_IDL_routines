; docformat = 'rst'
;
; NAME:
;   interp_contplot_multi.pro
;
; PURPOSE:
; The purpose of interp_contplot_multi is to display three FAST database
; parameters that have been binned by MLT and ILAT as 2D histograms in
; one window. NOTE: THE SECOND-TO-LAST AND LAST ARRAY MUST BE THE NUMBER
; OF FLUX EVENTS AND THE EVENT MASK, RESPECTIVELY  
;+
; The purpose of interp_contplot_multi is to display three FAST database
; parameters that have been binned by MLT and ILAT as 2D histograms in
;one window.
; 
; Program default colors can be set within the program; see below. 
;If no windows are currently open when the program is called,
;cgDisplay is used to create a window.
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

PRO interp_contplot_multi,h2dData,h2dTitle,CONTOUR=contour

;variables from interp_plots.pro
COMMON ContVars, minMLT, maxMLT, minILAT, maxILAT 

;Subtract one since last array is the mask
nPlots=N_ELEMENTS(h2dData(0,0,*))-1

IF nPlots NE N_ELEMENTS(h2dTitle) THEN print, "Titles not provided for each data set!"

; Load the color table for contours
IF KEYWORD_SET(CONTOUR) THEN BEGIN
   cgLoadCT,65
   TVLCT, r, g, b, /Get
   cPalette = [ [r], [g], [b] ]
ENDIF

; Load the color table for the display. All bottomed-out (saturation) values will be gray.
cgLoadCT, 4
TVLCT, cgColor('gray', /Triple), 0
TVLCT, r, g, b, /Get
palette = [ [r], [g], [b] ]

;************************************************
;Make mask table
cgLoadCT, 0, RGB_TABLE=mask_palette

;Make mask
h2dMask=h2dData[*,*,nPlots]
h2dM=cgImage_Make_Transparent_Image(BYTSCL(h2dMask),0,$
                                       MISSING_VALUE=0,PALETTE=mask_palette)

;************************************************
;Use nPlots+1 to account for mask--it simplifies cgImage command later
maxH2d=FLTARR(nPlots+1)
minH2d=FLTARR(nPlots+1)
rangeMin=FLTARR(nPlots+1)
rangeMax=FLTARR(nPlots+1)

;imgMax=0
;imgMin=-30
imArr=PTRARR(nPlots,/ALLOCATE_HEAP)

;Do custom range for Eflux plots, if necessary
customEfRange=0
IF customEfRange NE 0 THEN BEGIN
  maxH2d[0]=1e4
  minH2d[0]=0
  rangeMin[0]=(imgMin EQ !NULL) ? minH2d[0] : imgMin
  rangeMax[0]=(imgMax EQ !NULL) ? maxH2d[0] : imgMax

  *imArr[0]=cgImage_Prepare_Output(h2dData(*,*,0),/SCALE,$
                                   stretch=1,bottom=0,top=255,negative=0,$
                                   MINVALUE=minH2d[0],MAXVALUE=maxH2d[0])
ENDIF

FOR i = (customEfRange EQ 0) ? 0 : 1, nPlots-1 DO BEGIN
   maxH2d[i]=MAX(h2dData(*,*,i))
   minH2d[i]=MIN(h2dData(*,*,i))
   rangeMin[i]=(imgMin EQ !NULL) ? minH2d[i] : imgMin
   rangeMax[i]=(imgMax EQ !NULL) ? maxH2d[i] : imgMax

   ;Make background images
   *imArr[i]=cgImage_Prepare_Output(h2dData(*,*,i),/SCALE,$
                                    stretch=1,bottom=0,top=255,negative=0)
ENDFOR

; Open a display window.
cgDisplay
   
positions = cgLayout([FLOOR(nPlots/2),ROUND(nPlots/2)], OXMargin=[5,5],OYMargin=[5,5], YGap=11)

FOR i = 0, (nPlots-1) DO BEGIN
;Plot 'em
   p = positions[*,i]
   temp=cgImage_Prepare_Alpha(h2dM,*imArr[i],AlphaFGPosition=[0,0,1,1])
 
;Other attempt
cgImage, temp,$
            XRange=[minMLT,maxMLT], YRange=[minILAT,maxILAT],$
            XTitle='MLT', YTitle='ILAT', $
            /Axes,Position=p, NoErase=i NE 0

;Now color bar
   cgColorBar, position=[p[0], p[3]+0.04, p[2], p[3]+0.055], $
               Range=[rangeMin[i], rangeMax[i]], NColors=254,$
               Title=(h2dTitle[i] EQ "") ? "Flux" : h2dTitle[i], $
               Palette=palette,$
               TEXTTHICK=1.5, TLocation="TOP", TCharSize=cgDefCharsize()*1.2
      

ENDFOR

;cgText, 0.5, 0.925, /Normal, 'Flux Plots', $
;       Charsize=cgDefCharsize()*1.5, Alignment=0.5

; Display the density plot.

;If CONTOUR keyword set, do them contours
IF KEYWORD_SET(CONTOUR) THEN BEGIN & $
   nContours=4 & $
   cLevels=((maxH2d-minH2d)*(findgen(nContours)+0.5)/nContours+minH2d) & $
   thick = (!D.Name EQ 'PS') ? 6 : 2 & $
   
   print,"Num elements for plot", i, " is",n_elements(h2dData) & $
   print,"cLevels (plot)", i, " is",cLevels & $
   
   cgContour, h2dData(*,*,i), $
    LEVELS=cLevels[i], /OnImage,$
    C_Colors=bytscl(indgen(nContours)), $
    C_Annotation=['Low', 'Avg', 'High'],$
    Palette=cPalette & $
    ;C_Thick=thick, C_CharThick=thick
   ENDIF
;
;
;; Display a color bar.
;
;rangeMin=(imgMin EQ !NULL) ? minH2d : imgMin
;rangeMax=(imgMax EQ !NULL) ? maxH2d : imgMax
;
;print,"min and maxval:"
;print,rangeMin,rangeMax
;
;   cgColorbar, Position=[0.15, 0.9, 0.9, 0.925], Title='Flux', $
;            Range=[rangeMin, rangeMax], NColors=254;, TLocation='Top';, $
;;           Bottom=1, OOB_Low='gray'

END 
;*****************************************************************
