pro saveme1,temp,tempName,ancillaryData
restore,ancillaryData

;Subtract one since last array is the mask
nPlots=N_ELEMENTS(h2dStr)-1

  ; Open a graphics window.
   cgDisplay,color="black"

      position = [0.1, 0.25, 0.9, 0.925]
     cgMap_Set, 90, 0,/STEREOGRAPHIC, /NoErase, /NoBorder, $
     Position=position,$
     ;Limit=[minILAT-5,maxMLT*15-360,maxILAT+5,minMLT*15],
     Limit=[minILAT,minMLT*15,maxILAT,maxMLT*15]  
      
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
h2descl=bytscl(temp.data,top=nLevels-2,MAX=temp.lim[1],MIN=temp.lim[0])



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
  tempILATS=[ilats[j],tempILATS,ilats[j+1],REVERSE(tempILATS)] & $
  tempMLTS=[mlts[i]+binMLT*15/2.0,tempMLTS,mlts[i]+binMLT*15/2.0,tempMLTS+binMLT*15]  
  
;  cgColorFill,[mlts[i],mlts[i+1],mlts[i+1],mlts[i]],[ilats[j:j+1],ilats[j:j+1]],color=h2descl(i,j) & $
  cgColorFill,tempMLTS,tempILATS,color=((h2dStr[nPlots]).data[i,j] EQ 255.0) ? "gray" : h2descl[i,j]
 ENDFOR & $
ENDFOR




   ; Add map grid. Set the Clip_Text keyword to enable the NO_CLIP graphics keyword. 
cgMap_Grid, Clip_Text=1, /NoClip, linestyle=0, thick=3,color='black',londelta=binMLT*15,latdelta=binILAT

   ; Now text. Set the Clip_Text keyword to enable the NO_CLIP graphics keyword. 
cgMap_Grid, Clip_Text=1, /NoClip, /LABEL,linestyle=0, thick=3,color='black',latdelta=binILAT*2,$
            /NO_GRID,latlabel=((maxMLT-minMLT)/2.0+minMLT)*15-binMLT*7.5,lonlabel=minILAT-1,$
            LONS=(2*INDGEN((maxMLT-minMLT)/2.0+2)+minMLT)*15,$
            LONNAMES=[strtrim(minMLT,2)+" MLT",STRTRIM(2*INDGEN((maxMLT-minMLT)/2.0)+(minMLT+2),2)]
  
;charsize = cgDefCharSize()*0.75
;cgText, 0, minILAT-1, '0', Alignment=0.5, Orientation=0, Charsize=charsize      
;cgText, 180, minILAT, '12', Alignment=0.5, Orientation=0.00, Charsize=charsize   
;cgText, 90, minILAT-1, '6 MLT',Alignment=0.5,Charsize=charsize
;cgText, -90, minILAT-1, '18',Alignment=0.5,Charsize=charsize
      
;charsize = cgDefCharSize()*0.75
;cgText, 0, minILAT-5, 'midnight', Alignment=0.5, Orientation=0, Charsize=charsize      
;cgText, 180, minILAT-5, 'noon', Alignment=0.5, Orientation=0.00, Charsize=charsize   
;cgText, 90, minILAT-5, 'dawnward',Alignment=0.5,Charsize=charsize
;cgText, -90, minILAT-5, 'duskward',Alignment=0.5,Charsize=charsize  
         ; Add a colorbar.
   cgColorbar, NColors=nlevels-2, Bottom=1B, Divisions=nlevels-2,OOB_Low=0B, OOB_High=BYTE(nLevels-1),$ 
               Range=temp.lim, Title=temp.title, /Discrete, $
               Position=[0.25, 0.065, 0.75, 0.115], TEXTTHICK=1.5, TLocation="TOP", TCharSize=cgDefCharsize()*1.2,$
        ticknames=[String(temp.lim[0], Format='(D0.1)'),REPLICATE(" ",nLevels-3),String(temp.lim[1], Format='(D0.1)')]
END