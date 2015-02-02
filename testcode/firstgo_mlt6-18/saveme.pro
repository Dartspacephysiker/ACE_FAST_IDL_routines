pro saveme
restore,"fluxplots_North_dawnward_med_0stable__Jan_22_14.dat"

  ; Open a graphics window.
   cgDisplay,color="black"

maxMLT=18
minMLT=6   
maxILAT=85
minILAT=65
binMLT=0.5
binILAT=1

doDat=1 ;bin data?
      position = [0.1, 0.25, 0.9, 0.925]
     cgMap_Set, 90, 0,/STEREOGRAPHIC, /NoErase, /NoBorder, $
     Position=position,$
     ;Limit=[minILAT-5,maxMLT*15-360,maxILAT+5,minMLT*15],
     Limit=[minILAT-5,minMLT*15,maxILAT,maxMLT*15]  
      
   ; Load the colors for the plot.

nLevels=12
cgLoadCT, 22,/BREWER, /REVERSE, NCOLORS=nLevels
   
   ; Set up the contour levels.
   levels = cgScaleVector(Indgen(nlevels), 0,255)      
   
nXlines=(maxMLT-minMLT)/binMLT + 1
nYlines=(maxILAT-minILAT)/binILAT + 1

mlts=indgen(nXlines)*binMLT+minMLT
ilats=indgen(nYlines)*binILAT+minILAT

mlts=mlts*15
h2descl=bytscl(h2deflux)



;11 is "blue-red" color table
;cgLoadCT, 11, NColors=100,CLIP=[140,240]
   
            ; Contour the data.
;   cgContour, h2descl, mlts*15, ilats, Levels=levels, /Overplot, /Cell_Fill, $
;      C_Colors=Indgen(nlevels)+1B
 
FOR i=0, N_ELEMENTS(mlts)-2 DO BEGIN & $
 FOR j=0, N_ELEMENTS(ilats)-2 DO BEGIN & $
  tempMLTS=[mlts[i],mlts[i+1]] & $
  tempILATS=ilats[j:j+1] & $

;  tempMLTS=REBIN(tempMLTS,4)  & $
;  tempILATS=REBIN(tempILATS,4) & $

  tempMLTS=[tempMLTS,REVERSE(tempMLTS)] & $
  tempILATS=[tempILATS,tempILATS]
;  cgColorFill,[mlts[i],mlts[i+1],mlts[i+1],mlts[i]],[ilats[j:j+1],ilats[j:j+1]],color=h2descl(i,j) & $
  cgColorFill,tempMLTS,tempILATS,color=h2descl[i,j]
 print,"coords are LAT:",tempILATS,"LONGS:",tempMLTS,"COLOR:",h2descl(i,j) & $
 ENDFOR & $
ENDFOR

   ; Add map grid. Set the Clip_Text keyword to enable the NO_CLIP graphics keyword. 
cgMap_Grid, Clip_Text=1, /NoClip, linestyle=0, thick=2,color='white',londelta=binMLT*15,latdelta=binILAT,$
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