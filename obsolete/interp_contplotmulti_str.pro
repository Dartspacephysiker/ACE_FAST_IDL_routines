; docformat = 'rst'
;
; NAME:
;   interp_contplotmulti_str.pro
;
; PURPOSE:
; The purpose of interp_contplotmulti_str is to display three FAST database
; parameters that have been binned by MLT and ILAT as 2D histograms in
; one window. NOTE: THE SECOND-TO-LAST AND LAST ARRAY MUST BE THE NUMBER
; OF FLUX EVENTS AND THE EVENT MASK, RESPECTIVELY  
;+
; Program default colors can be set within the program; see below. 
;If no windows are currently open when the program is called,
;cgDisplay is used to create a window.
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

PRO interp_contplotmulti_str,h2dStr,CONTOUR=contour,SAVERAW=saveraw

;variables from interp_plots.pro
COMMON ContVars, minMLT, maxMLT, minILAT, maxILAT, binMLT, binILAT 

;Subtract one since last array is the mask
nPlots=N_ELEMENTS(h2dStr)-1

;IF nPlots NE N_ELEMENTS(h2dStr)- THEN print, "Titles not provided for each data set!"

; Load the color table for contours
IF KEYWORD_SET(CONTOUR) THEN BEGIN
   cgLoadCT,65
   TVLCT, r, g, b, /Get
   cPalette = [ [r], [g], [b] ]
ENDIF

; Load the color table for the display.
nLevels=12
cgLoadCT, 22,/BREWER, /REVERSE, NCOLORS=nLevels
;TVLCT, rold, gold, bold, /Get

;start=127
;last=start+127
;r=rold[start:last]
;g=gold[start:last]
;b=bold[start:last]
;r=REBIN(r,256)
;g=REBIN(g,256)
;b=REBIN(b,256)
;r[0]=190
;g[0]=190
;b[0]=190
;TVLCT,r,g,b
;palette = [ [r], [g], [b] ]
;palette = [ [rold], [gold], [bold] ]

;************************************************
;Make mask table and prepare images
cgLoadCT, 0, RGB_TABLE=mask_palette
mask_palette[*,0]=131
mask_palette[*,1]=139
mask_palette[*,2]=131
;Make mask
;h2dMask=h2dStr.h2dData[*,*,nPlots]
h2dM=cgImage_Make_Transparent_Image(BYTSCL(h2dStr[nPlots].data),0,$
                                       MISSING_VALUE=0,PALETTE=mask_palette)

;Prepare images for output (like it says!)
imArr=PTRARR(nPlots,/ALLOCATE_HEAP)
FOR i = 0, nPlots-1 DO BEGIN
   ;Make background images
   *imArr[i]=cgImage_Prepare_Output(h2dStr[i].data,/SCALE,$
                                    stretch=1,bottom=1,top=BYTE(nLevels-2),negative=0,$
                                    MINVALUE=h2dStr[i].lim[0],$
                                    MAXVALUE=h2dStr[i].lim[1])
  IF KEYWORD_SET(SAVERAW) THEN BEGIN & $
    temp=*imArr[i] & $
    SAVE,temp,filename=saveRaw+"rawimage_"+strtrim(i,2)+".dat" & $
  ENDIF                                    
ENDFOR


;************************************************
;Now let's actually PLOT these people
;Open a display window.
cgDisplay

IF nPlots LT 2 THEN pPlots = [1,1] $
  ELSE IF nPlots LT 3 THEN pPlots=[2,1] $ 
  ELSE IF nPlots LT 5 THEN pPlots=[2,2] $
  ELSE IF nPlots LT 7 THEN pPlots=[3,2] $
  ELSE IF nPlots LT 10 THEN pPlots=[3,3] $
  ELSE BEGIN & print,"Too many plots..." & pPlots=[4,4] & ENDELSE
     
positions = cgLayout(pPlots, OXMargin=[5,5],OYMargin=[6,8], YGap=11)

print,"nplots is",nplots
FOR i = 0, nPlots-1 DO BEGIN
;Plot 'em
   p = positions[*,i]
   temp=cgImage_Prepare_Alpha(h2dM,*imArr[i],AlphaFGPosition=[0,0,1,1])
 
;Other attempt
cgImage, temp,$
            XRange=[minMLT,maxMLT], YRange=[minILAT,maxILAT],$
            XTitle='MLT', YTitle='ILAT', $
            /Axes,Position=p, NoErase=i NE 0;,$
            ;palette=palette,MAXVALUE=254,MINVALUE=1

;;Now color bar
;   cgColorBar, position=[p[0], p[3]+0.04, p[2], p[3]+0.055], $
;               Range=[h2dStr[i].lim[0],h2dStr[i].lim[1]],$
;               Title=(h2dStr[i].title EQ "") ? "Flux" : h2dStr[i].title, $
;               Palette=palette,OOB_Low='black',OOB_HIGH='white', $
;               TEXTTHICK=1.5, TLocation="TOP", TCharSize=cgDefCharsize()*1.2
;               
   cgColorBar, divisions=nLevels-2,OOB_Low=0B, OOB_High=BYTE(nLevels-1),$
               NColors=nLevels-2, BOTTOM=1B, /DISCRETE,$
               position=[p[0], p[3]+0.04, p[2], p[3]+0.055], $
               Range=[h2dStr[i].lim[0],h2dStr[i].lim[1]],$
               Title=(h2dStr[i].title EQ "") ? "Flux" : h2dStr[i].title, $
               TEXTTHICK=1.5, TLocation="TOP", TCharSize=cgDefCharsize()*1.2               
               
ENDFOR

;cgText, 0.5, 0.925, /Normal, 'Flux Plots', $
;       Charsize=cgDefCharsize()*1.5, Alignment=0.5

; Display the density plot.

;If CONTOUR keyword set, do them contours
IF KEYWORD_SET(CONTOUR) THEN BEGIN & $
   nContours=4 & $
   cLevels=((h2dStr[i].lim[1]-h2dStr[i].lim[0])*(findgen(nContours)+0.5)/nContours+h2dStr[i].lim[0]) & $
   thick = (!D.Name EQ 'PS') ? 6 : 2 & $
   
   print,"Num elements for plot", i, " is",n_elements(h2dStr[i].data) & $
   print,"cLevels (plot)", i, " is",cLevels & $
   
   cgContour, h2dStr[i].data, $
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
