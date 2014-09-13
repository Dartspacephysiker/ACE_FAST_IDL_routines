pro interp_polar2dhist,temp,tempName,ancillaryData
restore,ancillaryData

;want me to output integral of plot?
integralText=0

;Subtract one since last array is the mask
nPlots=N_ELEMENTS(h2dStr)-1

  ; Open a graphics window.
   cgDisplay,color="black"

      position = [0.1, 0.075, 0.9, 0.75]
     cgMap_Set, (minILAT GT 0) ? 90 : -90, 180,/STEREOGRAPHIC, /NoErase, /NoBorder, $
     Position=position,$
     ;Limit=[minILAT-5,maxMLT*15-360,maxILAT+5,minMLT*15],
     Limit=[minILAT,minMLT*15,maxILAT,maxMLT*15]  
      
   ; Load the colors for the plot.

nLevels=12
cgLoadCT, 22,/BREWER, /REVERSE, NCOLORS=nLevels
   
   ; Set up the contour levels.
;   levels = cgScaleVector(Indgen(nlevels), 0,255)      
   
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

;integrals for each hemi
dawnIntegral=0
duskIntegral=0

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
  
  IF tempMLTS[0] GE 180 AND tempMLTS[5] GE 180 THEN duskIntegral+=temp.data[i,j] ELSE IF tempMLTS[0] LE 180 AND tempMLTS[5] LE 180 THEN dawnIntegral+=temp.data[i,j]
  
;  cgColorFill,[mlts[i],mlts[i+1],mlts[i+1],mlts[i]],[ilats[j:j+1],ilats[j:j+1]],color=h2descl(i,j) & $
  cgColorFill,tempMLTS,tempILATS,color=((h2dStr[nPlots]).data[i,j] GT 250.0) ? "gray" : h2descl[i,j]
 ENDFOR & $
ENDFOR




   ; Add map grid. Set the Clip_Text keyword to enable the NO_CLIP graphics keyword. 
cgMap_Grid, Clip_Text=1, /NoClip, linestyle=0, thick=(!D.Name EQ 'PS') ? 3 : 2,$
            color='black',londelta=binMLT*15,latdelta=binILAT

   ; Now text. Set the Clip_Text keyword to enable the NO_CLIP graphics keyword. 
cgMap_Grid, Clip_Text=1, /NoClip, /LABEL,linestyle=0, thick=3,color='black',latdelta=binILAT*2,$
            /NO_GRID,$
            latlabel=minMLT*15-5,lonlabel=minILAT,$;latlabel=((maxMLT-minMLT)/2.0+minMLT)*15-binMLT*7.5,
            LONS=(1*INDGEN((maxMLT-minMLT)/1.0+1)+minMLT)*15,$
            LONNAMES=[strtrim(minMLT,2)+" MLT",STRTRIM(INDGEN((maxMLT-minMLT)/1.0)+(minMLT+1),2)]
  
;charsize = cgDefCharSize()*0.75
;cgText, 0, minILAT-1, '0', Alignment=0.5, Orientation=0, Charsize=charsize      
;cgText, 180, minILAT, '12', Alignment=0.5, Orientation=0.00, Charsize=charsize   
;cgText, 90, minILAT-1, '6 MLT',Alignment=0.5,Charsize=charsize
;cgText, -90, minILAT-1, '18',Alignment=0.5,Charsize=charsize
      
charsize = cgDefCharSize()*0.75
;cgText, 0, minILAT-5, 'midnight', Alignment=0.5, Orientation=0, Charsize=charsize      
;cgText, 180, minILAT-5, 'noon', Alignment=0.5, Orientation=0.00, Charsize=charsize   
;cgText, 90, minILAT-5, 'dawnward',Alignment=0.5,Charsize=charsize
;cgText, -90, minILAT-5, 'duskward',Alignment=0.5,Charsize=charsize  
IF (integralText) THEN BEGIN & $
  cgText,0.11,0.78,'Integral: ' + string(TOTAL(temp.data(WHERE(h2dStr[nPlots].data LT 250))),Format='(D0.3)'),/NORMAL & $
  cgText,0.105,0.74,'|Integral|: ' + string(TOTAL(ABS(temp.data(WHERE(h2dStr[nPlots].data LT 250)))),Format='(D0.3)'),/NORMAL & $
    cgText,0.68,0.78,'Dawnward: ' + string(dawnIntegral,Format='(D0.3)'),/NORMAL & $
    cgText,0.68,0.74,'Duskward: ' + string(duskIntegral,Format='(D0.3)'),/NORMAL & $
ENDIF 

cgText,0.41,0.763,'ILAT',/NORMAL, charsize=charsize         
         ; Add a colorbar.
   cgColorbar, NColors=nlevels-2, Bottom=1B, Divisions=nlevels-2,$;OOB_Low=0B, OOB_High=BYTE(nLevels-1),$ 
               Range=temp.lim, Title=temp.title, /Discrete, $
               Position=[0.25, 0.87, 0.75, 0.92], TEXTTHICK=1.5, TLocation="TOP", TCharSize=cgDefCharsize()*1.2,$
        ticknames=[String(temp.lim[0], Format='(D0.1)'),REPLICATE(" ",nLevels-3),String(temp.lim[1], Format='(D0.1)')]
END