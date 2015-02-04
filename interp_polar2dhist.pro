PRO INTERP_POLAR2DHIST,temp,tempName,ancillaryData,NOPLOTINTEGRAL=noPlotIntegral,WHOLECAP=wholeCap,MIDNIGHT=midnight,_EXTRA=e

  restore,ancillaryData

  ;want me to output integral of plot?
  ;;noPlotIntegral=1

  ;Subtract one since last array is the mask
  nPlots=N_ELEMENTS(h2dStr)-1

  ; Open a graphics window.
  cgDisplay,color="black"


  IF KEYWORD_SET(wholeCap) THEN BEGIN
     position = [0.05, 0.05, 0.85, 0.85] 
     lim=[minILAT,0,88,360]
  ENDIF ELSE BEGIN
     position = [0.1, 0.075, 0.9, 0.75] 
     lim=[minILAT,minMLT*15,maxILAT,maxMLT*15]
  ENDELSE

  cgMap_Set, (minILAT GT 0) ? 90 : -90, (KEYWORD_SET(midnight)) ? 0 : 180,/STEREOGRAPHIC, /HORIZON, $
             /NOERASE, /NOBORDER, POSITION=position,LIMIT=lim
                ;;Limit=[minILAT-5,maxMLT*15-360,maxILAT+5,minMLT*15],
                
  ; Load the colors for the plot.
  nLevels=12

  ;;Select color table
  ePlotzz=STRMATCH(temp.title, '*electron*',/FOLD_CASE)
  pPlotzz=STRMATCH(temp.title, '*poynting*',/FOLD_CASE)
  IF ePlotzz GT 0 OR pPlotzz GT 0 THEN BEGIN
     ;This is the one for doing sweet electron flux plots
     cgLoadCT, 16,/BREWER, NCOLORS=nLevels
  ENDIF ELSE BEGIN
     ;This one is the one we use for orbit plots
     cgLoadCT, 22,/BREWER, /REVERSE, NCOLORS=nLevels
  ENDELSE

  ;;Is this a log plot? If so, do integral of exponentiated value
  logPlotzz=STRMATCH(temp.title, '*log*',/FOLD_CASE)

  ; Set up the contour levels.
  ;   levels = cgScaleVector(Indgen(nlevels), 0,255)      
  
  minMLT=FLOOR(minMLT*4.0)/4.0 ;to 1/4 precision
  maxMLT=FLOOR(maxMLT*4.0)/4.0 
  minILAT=FLOOR(minILAT*4.0)/4.0 
  maxILAT=FLOOR(maxILAT*4.0)/4.0 
  

  nXlines=(maxMLT-minMLT)/binMLT + 1
  nYlines=(maxILAT-minILAT)/binILAT + 1

  mlts=indgen(nXlines)*binMLT+minMLT
  ilats=indgen(nYlines)*binILAT+minILAT

  mlts=mlts*15

  ;;Scale this stuff
  ;;The reason for all the trickery is that we want to know what values are out of bounds,
  ;; and bytscl doesn't do things quite the way we need them done.
  h2descl=bytscl(temp.data,top=nLevels-3,MAX=temp.lim[1],MIN=temp.lim[0])+1B
  h2descl(where(temp.data GT temp.lim[1])) = BYTE(nLevels-1)
  h2descl(where(temp.data LT temp.lim[0])) = 0B


  ;11 is "blue-red" color table
  ;cgLoadCT, 11, NColors=100,CLIP=[140,240]
  
  ; Contour the data.
  ;   cgContour, h2descl, mlts*15, ilats, Levels=levels, /Overplot, /Cell_Fill, $
  ;      C_Colors=Indgen(nlevels)+1B

  ;i = 1 & j = 1 &  tempMLTS=[mlts[i],mlts[i+1]] & tempILATS=ilats[j:j+1] 
  ;sempMLTS=REBIN(tempMLTS,4) & sempILATS=REBIN(tempILATS,4)

  ;integrals for each hemi
  dawnIntegral=0
  duskIntegral=0

  ;;binary matrix to tell us where masked values are
  masked=(h2dStr[nPlots].data GT 250.0)

  FOR j=0, N_ELEMENTS(ilats)-2 DO BEGIN 
     FOR i=0, N_ELEMENTS(mlts)-2 DO BEGIN 
        ;tempMLTS=[mlts[i],mlts[i+1]] 
        ;tempILATS=ilats[j:j+1] 

        tempILATS=[ilats[j],ilats[j]+binILAT/2.0,ilats[j+1]] 
        tempMLTS=[mlts[i],mlts[i],mlts[i]] 

        ;print,tempILATS & print,tempMLTS
        ;tempMLTS=REBIN(tempMLTS,4)  
        ;tempILATS=REBIN(tempILATS,4) 

        ;  tempMLTS=[tempMLTS,REVERSE(tempMLTS)] 
        ;  tempILATS=[tempILATS,tempILATS]
        tempILATS=[ilats[j],tempILATS,ilats[j+1],REVERSE(tempILATS)] 
        tempMLTS=[mlts[i]+binMLT*15/2.0,tempMLTS,mlts[i]+binMLT*15/2.0,tempMLTS+binMLT*15]  
        
        ;;Integrals
        IF ~masked[i,j] AND tempMLTS[0] GE 180 AND tempMLTS[5] GE 180 THEN duskIntegral+=(logPlotzz) ? 10^temp.data[i,j] : temp.data[i,j] $
        ELSE IF ~masked[i,j] AND tempMLTS[0] LE 180 AND tempMLTS[5] LE 180 THEN dawnIntegral+=(logPlotzz) ? 10^temp.data[i,j] : temp.data[i,j]
        
        ;  cgColorFill,[mlts[i],mlts[i+1],mlts[i+1],mlts[i]],[ilats[j:j+1],ilats[j:j+1]],color=h2descl(i,j) 
        cgColorFill,tempMLTS,tempILATS,color=(masked[i,j]) ? "gray" : h2descl[i,j]

     ENDFOR 
  ENDFOR

  ; Add map grid. Set the Clip_Text keyword to enable the NO_CLIP graphics keyword. 
  cgMap_Grid, Clip_Text=1, /NoClip, linestyle=0, thick=(!D.Name EQ 'PS') ? 3 : 2,$
              color='black',londelta=binMLT*15,latdelta=binILAT

  ; Now text. Set the Clip_Text keyword to enable the NO_CLIP graphics keyword. 
  IF KEYWORD_SET(wholeCap) THEN BEGIN
     cgMap_Grid, Clip_Text=1, /NoClip, /LABEL,linestyle=0, thick=3,color='black',latdelta=binILAT*2,$
                 /NO_GRID,$
                 latlabel=minMLT*15-5,lonlabel=minILAT,$ ;latlabel=((maxMLT-minMLT)/2.0+minMLT)*15-binMLT*7.5,
                 LONS=(1*INDGEN(12)*30),$
                 LONNAMES=[STRTRIM(INDGEN(12,2))*2]
  ENDIF ELSE BEGIN
     cgMap_Grid, Clip_Text=1, /NoClip, /LABEL,linestyle=0, thick=3,color='black',latdelta=binILAT*2,$
                 /NO_GRID,$
                 latlabel=minMLT*15-5,lonlabel=minILAT,$ ;latlabel=((maxMLT-minMLT)/2.0+minMLT)*15-binMLT*7.5,
                 LONS=(1*INDGEN((maxMLT-minMLT)/1.0+1)+minMLT)*15,$
                 LONNAMES=[strtrim(minMLT,2)+" MLT",STRTRIM(INDGEN((maxMLT-minMLT)/1.0)+(minMLT+1),2)]
  ENDELSE
     
  ;charSize = cgDefCharSize()*0.75
  ;cgText, 0, minILAT-1, '0', Alignment=0.5, Orientation=0, Charsize=charSize      
  ;cgText, 180, minILAT, '12', Alignment=0.5, Orientation=0.00, Charsize=charSize   
  ;cgText, 90, minILAT-1, '6 MLT',Alignment=0.5,Charsize=charSize
  ;cgText, -90, minILAT-1, '18',Alignment=0.5,Charsize=charSize
  
  charSize = cgDefCharSize()*((KEYWORD_SET(wholeCap) ? 0.7 : 0.75))
  ;cgText, 0, minILAT-5, 'midnight', Alignment=0.5, Orientation=0, Charsize=charSize      
  ;cgText, 180, minILAT-5, 'noon', Alignment=0.5, Orientation=0.00, Charsize=charSize   
  ;cgText, 90, minILAT-5, 'dawnward',Alignment=0.5,Charsize=charSize
  ;cgText, -90, minILAT-5, 'duskward',Alignment=0.5,Charsize=charSize  

  ;;Integral text
  ;;REMEMBER: h2dStr[nPlots].data is the MASK
  IF NOT KEYWORD_SET(noPlotIntegral) THEN BEGIN 
     IF logPlotzz THEN BEGIN
        integ=TOTAL(10.0^(temp.data(WHERE(~masked))))
        absInteg=integ
     ENDIF ELSE BEGIN
        integ=TOTAL(temp.data(WHERE(~masked)))
        absInteg=TOTAL(ABS(temp.data(WHERE(~masked))))
     ENDELSE
     ;; dawnIntegral=
     ;; duskIntegral=
     IF KEYWORD_SET(wholeCap) THEN BEGIN
        lTexPos1=0.09
        lTexPos2=0.63
        bTexPos1=0.88
        bTexPos2=0.84
     ENDIF ELSE BEGIN
        lTexPos1=0.11
        lTexPos2=0.68
        bTexPos1=0.78
        bTexPos2=0.74
     ENDELSE
     cgText,lTexPos1,bTexPos1,'Integral: ' + string(integ,Format='(D0.3)'),/NORMAL,CHARSIZE=charSize 
     IF NOT (logPlotzz) THEN cgText,lTexPos1,bTexPos2,'|Integral|: ' + string(absInteg,Format='(D0.3)'),/NORMAL,CHARSIZE=charSize 
     cgText,lTexPos2,bTexPos1,'Dawnward: ' + string(dawnIntegral,Format='(D0.3)'),/NORMAL,CHARSIZE=charSize 
     cgText,lTexPos2,bTexPos2,'Duskward: ' + string(duskIntegral,Format='(D0.3)'),/NORMAL,CHARSIZE=charSize 
  ENDIF 

  IF KEYWORD_SET(wholeCap) THEN BEGIN
     cgColorbar, NColors=nlevels-2, Divisions=nlevels-2, Bottom=1B, $
                 OOB_Low=(temp.lim[0] EQ 0) ? !NULL : 0B, OOB_High=(temp.lim[1] EQ MAX(temp.data)) ? !NULL : BYTE(nLevels-1), $ 
                 Range=temp.lim, Title=temp.title, /Discrete, $
                 Position=[0.91, 0.10, 0.95, 0.90], TEXTTHICK=1.5, /VERTICAL, TLocation="RIGHT", TCharSize=cgDefCharsize()*1.0,$
                 ;; ticknames=[String(temp.lim[0], Format='(D0.1)'),REPLICATE(" ",nLevels-3),String(temp.lim[1], Format='(D0.1)')]
                 ticknames=[String(temp.lim[0], Format='(D0.1)'),REPLICATE(" ",(nLevels-3)/2),$
                            String(((temp.lim[0]+temp.lim[1])/2), Format='(D0.1)'),REPLICATE(" ",(nLevels-3)/2),$
                            String(temp.lim[1], Format='(D0.1)')]
  ENDIF ELSE BEGIN
     cgText,0.41,0.763,'ILAT',/NORMAL, charsize=charSize         
     ;; Add a colorbar.
     cgColorbar, NColors=nlevels-2, Bottom=1B, Divisions=nlevels-2, $
                 OOB_Low=(temp.lim[0] EQ 0) ? !NULL : 0B, OOB_High=(temp.lim[1] EQ MAX(temp.data)) ? !NULL : BYTE(nLevels-1), $ 
                 Range=temp.lim, Title=temp.title, /Discrete, $
                 Position=[0.25, 0.88, 0.75, 0.92], TEXTTHICK=1.5, TLocation="TOP", TCharSize=cgDefCharsize()*1.0,$
                 ;; ticknames=[String(temp.lim[0], Format='(D0.1)'),REPLICATE(" ",nLevels-3),String(temp.lim[1], Format='(D0.1)')]
                 ticknames=[String(temp.lim[0], Format='(D0.1)'),REPLICATE(" ",(nLevels-3)/2),$
                            String(((temp.lim[0]+temp.lim[1])/2), Format='(D0.1)'),REPLICATE(" ",(nLevels-3)/2),$
                            String(temp.lim[1], Format='(D0.1)')]
  ENDELSE

END