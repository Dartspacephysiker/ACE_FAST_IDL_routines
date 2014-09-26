pro interp_contplot_polar,h2dStr
;restore,"fluxplots_North_duskward_avg_0stable_Jan_24_14rawimage_0.dat"
;restore,"fluxplots_North_duskward_avg_0stable_Jan_28_14rawimage_0.dat"
;not quite
      position = [0.1, 0.25, 0.9, 0.925]
     cgMap_Set, 90, 0,/STEREOGRAPHIC, /NoErase, /NoBorder, $
     Position=position,$
     ;Limit=[minILAT-5,maxMLT*15-360,maxILAT+5,minMLT*15],
     Limit=[minILAT-5,minMLT*15,maxILAT,maxMLT*15]  
      
   ; Load the colors for the plot.

map=OBJ_NEW("cgMap",")

nLevels=12
cgLoadCT, 22,/BREWER, /REVERSE, NCOLORS=nLevels
   
   ; Set up the contour levels.
   levels = cgScaleVector(Indgen(nlevels), 0,255)   

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
ENDFOR   
   
nXlines=(maxMLT-minMLT)/binMLT + 1
nYlines=(maxILAT-minILAT)/binILAT + 1

mlts=indgen(nXlines)*binMLT+minMLT
ilats=indgen(nYlines)*binILAT+minILAT

mlts=mlts*15
h2descl=bytscl(temp,top=nLevels-3)+1


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
            MAPCOORD=map,$
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



;11 is "blue-red" color table
;cgLoadCT, 11, NColors=100,CLIP=[140,240]
   
            ; Contour the data.
;   cgContour, h2descl, mlts*15, ilats, Levels=levels, /Overplot, /Cell_Fill, $
;      C_Colors=Indgen(nlevels)+1B

;i = 1 & j = 1 &  tempMLTS=[mlts[i],mlts[i+1]] & tempILATS=ilats[j:j+1] & $
;sempMLTS=REBIN(tempMLTS,4) & sempILATS=REBIN(tempILATS,4)
 
FOR j=0, N_ELEMENTS(ilats)-2 DO BEGIN & $
 FOR i=0, N_ELEMENTS(mlts)-2 DO BEGIN & $
  ;tempMLTS=[mlts[i],mlts[i+1]] & $
  ;tempILATS=ilats[j:j+1] & $

  tempILATS=[ilats[j],ilats[j]+binILAT/2.0,ilats[j+1]] & $
  tempMLTS=[mlts[i],mlts[i],mlts[i]] & $

;print,tempILATS & print,tempMLTS
  ;tempMLTS=REBIN(tempMLTS,4)  & $
  ;tempILATS=REBIN(tempILATS,4) & $

;  tempMLTS=[tempMLTS,REVERSE(tempMLTS)] & $
;  tempILATS=[tempILATS,tempILATS]
  tempILATS=[tempILATS,REVERSE(tempILATS)] & $
  tempMLTS=[tempMLTS,tempMLTS+binMLT*15]  
  
;  cgColorFill,[mlts[i],mlts[i+1],mlts[i+1],mlts[i]],[ilats[j:j+1],ilats[j:j+1]],color=h2descl(i,j) & $
  cgColorFill,tempMLTS,tempILATS,color=h2descl[i,j]
 ENDFOR & $
ENDFOR

   ; Add map grid. Set the Clip_Text keyword to enable the NO_CLIP graphics keyword. 
cgMap_Grid, Clip_Text=1, /NoClip, linestyle=0, thick=3,color='white',londelta=binMLT*15,latdelta=binILAT,$
  /LABEL,latlabel=minMLT*15,lonlabel=minILAT

      
;charsize = cgDefCharSize()*0.75
;cgText, 0, minILAT-5, 'midnight', Alignment=0.5, Orientation=0, Charsize=charsize      
;cgText, 180, minILAT-5, 'noon', Alignment=0.5, Orientation=0.00, Charsize=charsize   
;cgText, 90, minILAT-5, 'dawnward',Alignment=0.5,Charsize=charsize
;cgText, -90, minILAT-5, 'duskward',Alignment=0.5,Charsize=charsize  
 
         ; Add a colorbar.
   cgColorbar, NColors=nlevels, Bottom=1, Range=[0.0, 255], Divisions=nlevels, $
        /Discrete, Format='(F0.1)', Position=[0.25, 0.065, 0.75, 0.115], $
        Title='E(V-I)', TLocation='top'
END