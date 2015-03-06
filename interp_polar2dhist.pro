PRO INTERP_POLAR2DHIST,temp,tempName,ancillaryData,NOPLOTINTEGRAL=noPlotIntegral,WHOLECAP=wholeCap,MIDNIGHT=midnight, $
                       LABELFORMAT=labelFormat, _EXTRA=e

  restore,ancillaryData

  ;want me to output integral of plot?
  ;;noPlotIntegral=1

  ;Subtract one since last array is the mask
  nPlots=N_ELEMENTS(h2dStr)-1

  ; Open a graphics window.
  cgDisplay,color="black"

  IF KEYWORD_SET(wholeCap) THEN BEGIN
     IF wholeCap EQ 0 THEN wholeCap=!NULL
  ENDIF
  IF KEYWORD_SET(midnight) THEN BEGIN
     IF midnight EQ 0 THEN midnight=!NULL
  ENDIF
  
  IF wholeCap NE !NULL THEN BEGIN
     position = [0.05, 0.05, 0.85, 0.85] 
     lim=[minI,0,84,360]
  ENDIF ELSE BEGIN
     position = [0.1, 0.075, 0.9, 0.75] 
     lim=[minI,minM*15,maxI,maxM*15]
  ENDELSE

  
  cgMap_Set, (minI GT 0) ? 90 : -90, (midnight NE !NULL) ? 0 : 180,/STEREOGRAPHIC, /HORIZON, $
             /ISOTROPIC, /NOERASE, /NOBORDER, POSITION=position,LIMIT=lim
                ;;Limit=[minI-5,maxM*15-360,maxI+5,minM*15],
                
  ; Load the colors for the plot.
  nLevels=12

  ;;Is this a log plot? If so, do integral of exponentiated value
  logPlotzz=STRMATCH(temp.title, '*log*',/FOLD_CASE)
  ;; FOR charEplot, uncomment me: logPlotzz = 1

  ;;Select color table
  orbPlotzz=STRMATCH(temp.title, '*Orbit*',/FOLD_CASE)
  nEvPerOrbPlotzz=STRMATCH(temp.title, '*Events per*',/FOLD_CASE)
  orbFreqPlotzz=STRMATCH(temp.title, '*Orbit Frequency*',/FOLD_CASE)
  charEPlotzz=STRMATCH(temp.title, '*characteristic energy*',/FOLD_CASE)
  ;; ePlotzz=STRMATCH(temp.title, '*electron*',/FOLD_CASE)
  ;; iPlotzz=STRMATCH(temp.title, '*ion*',/FOLD_CASE)
  pPlotzz=STRMATCH(temp.title, '*poynting*',/FOLD_CASE)
  ;; IF ePlotzz GT 0 OR pPlotzz GT 0 OR iPlotzz GT 0 OR orbPlotzz GT 0 THEN BEGIN
  ;;    ;;This is the one for doing sweet electron flux plots
  ;;    cgLoadCT, 16,/BREWER, NCOLORS=nLevels
  ;; ENDIF ELSE BEGIN
  ;;    ;;This one is the one we use for some orbit plots
  ;;    cgLoadCT, 22,/BREWER, /REVERSE, NCOLORS=nLevels
  ;; ENDELSE

  negs=WHERE(temp.data LT 0.0)
  IF negs[0] EQ -1 OR (logPlotzz) THEN BEGIN
     ;;This is the one for doing "all positive" plots
     cgLoadCT, 16,/BREWER, NCOLORS=nLevels
  ENDIF ELSE BEGIN
     ;;This one is for data that includes negs
     cgLoadCT, 22,/BREWER, /REVERSE, NCOLORS=nLevels
  ENDELSE


  ; Set up the contour levels.
  ;   levels = cgScaleVector(Indgen(nlevels), 0,255)      
  
  minM=FLOOR(minM*4.0)/4.0 ;to 1/4 precision
  maxM=FLOOR(maxM*4.0)/4.0 
  minI=FLOOR(minI*4.0)/4.0 
  maxI=FLOOR(maxI*4.0)/4.0 
  

  nXlines=(maxM-minM)/binM + 1
  nYlines=(maxI-minI)/binI + 1

  mlts=indgen(nXlines)*binM+minM
  ilats=indgen(nYlines)*binI+minI

  mlts=mlts*15

  ;;binary matrix to tell us where masked values are
  masked=(h2dStr[nPlots].data GT 250.0)
  notMasked=WHERE(~masked)

  h2descl=MAKE_ARRAY(SIZE(temp.data,/DIMENSIONS),VALUE=0)

  ;;Scale this stuff
  ;;The reason for all the trickery is that we want to know what values are out of bounds,
  ;; and bytscl doesn't do things quite the way we need them done.
  is_OOBHigh = 0
  is_OOBLow = 0
  OOB_HIGH_i = where(temp.data GT temp.lim[1] AND ~masked)
  OOB_LOW_i = where(temp.data LT temp.lim[0] AND ~masked)
  IF OOB_HIGH_i[0] NE -1 THEN is_OOBHigh = 1
  IF OOB_LOW_i[0] NE -1 THEN is_OOBLow = 1
  
  h2descl(notMasked)=bytscl(temp.data(notMasked),top=nLevels-1-is_OOBHigh-is_OOBLow,MAX=temp.lim[1],MIN=temp.lim[0])+is_OOBLow
;;  h2descl(where(temp.data(notMasked) GT temp.lim[1])) = BYTE(nLevels-1)
;;  h2descl(where(temp.data(notMasked) LT temp.lim[0])) = 0B
  IF OOB_HIGH_i[0] NE -1 THEN h2descl(OOB_HIGH_i) = BYTE(nLevels-1)
  IF OOB_LOW_i[0] NE -1 THEN h2descl(OOB_LOW_i) = 0B


  ;11 is "blue-red" color table
  ;cgLoadCT, 11, NColors=100,CLIP=[140,240]
  
  ; Contour the data.
  ;   cgContour, h2descl, mlts*15, ilats, Levels=levels, /Overplot, /Cell_Fill, $
  ;      C_Colors=Indgen(nlevels)+1B

  ;i = 1 & j = 1 &  tempMLTS=[mlts[i],mlts[i+1]] & tempILATS=ilats[j:j+1] 
  ;sempMLTS=REBIN(tempMLTS,4) & sempILATS=REBIN(tempILATS,4)

  ;integrals for each hemi
  dawnIntegral=(orbPlotzz) ? 0L : DOUBLE(0.0)
  duskIntegral=(orbPlotzz) ? 0L : DOUBLE(0.0)
  
  FOR j=0, N_ELEMENTS(ilats)-2 DO BEGIN 
     FOR i=0, N_ELEMENTS(mlts)-2 DO BEGIN 
        ;tempMLTS=[mlts[i],mlts[i+1]] 
        ;tempILATS=ilats[j:j+1] 

        tempILATS=[ilats[j],ilats[j]+binI/2.0,ilats[j+1]] 
        tempMLTS=[mlts[i],mlts[i],mlts[i]] 

        ;print,tempILATS & print,tempMLTS
        ;tempMLTS=REBIN(tempMLTS,4)  
        ;tempILATS=REBIN(tempILATS,4) 

        ;  tempMLTS=[tempMLTS,REVERSE(tempMLTS)] 
        ;  tempILATS=[tempILATS,tempILATS]
        tempILATS=[ilats[j],tempILATS,ilats[j+1],REVERSE(tempILATS)] 
        tempMLTS=[mlts[i]+binM*15/2.0,tempMLTS,mlts[i]+binM*15/2.0,tempMLTS+binM*15]  
        
        ;;Integrals
        IF ~masked[i,j] AND tempMLTS[0] GE 180 AND tempMLTS[5] GE 180 THEN duskIntegral+=(logPlotzz) ? 10^temp.data[i,j] : temp.data[i,j] $
        ELSE IF ~masked[i,j] AND tempMLTS[0] LE 180 AND tempMLTS[5] LE 180 THEN dawnIntegral+=(logPlotzz) ? 10^temp.data[i,j] : temp.data[i,j]
        ;; print,"masked["+strcompress(i,/REMOVE_ALL)+","+strcompress(j,/REMOVE_ALL)+"] is " + strcompress(masked[i,j],/REMOVE_ALL)
        ;; print,"temp.data["+strcompress(i,/REMOVE_ALL)+","+strcompress(j,/REMOVE_ALL)+"] is " + strcompress(temp.data[i,j],/REMOVE_ALL)
        ;; print,"dawnint is " + strcompress(dawnIntegral) + " and duskint is " + strcompress(duskIntegral)
        ;; print,""
        ;  cgColorFill,[mlts[i],mlts[i+1],mlts[i+1],mlts[i]],[ilats[j:j+1],ilats[j:j+1]],color=h2descl(i,j) 
        cgColorFill,tempMLTS,tempILATS,color=(masked[i,j]) ? "gray" : h2descl[i,j]

     ENDFOR 
  ENDFOR

  ; Add map grid. Set the Clip_Text keyword to enable the NO_CLIP graphics keyword. 
  cgMap_Grid, Clip_Text=1, /NoClip, linestyle=0, thick=(!D.Name EQ 'PS') ? 3 : 2,$
              color='black',londelta=binM*15,latdelta=binI

  ; Now text. Set the Clip_Text keyword to enable the NO_CLIP graphics keyword. 
  IF wholeCap NE !NULL THEN BEGIN
     cgMap_Grid, Clip_Text=1, /NoClip, /LABEL,linestyle=0, thick=3,color='black',latdelta=binI*2,$
                 /NO_GRID,$
                 latlabel=minM*15-5,lonlabel=minI,$ ;latlabel=((maxM-minM)/2.0+minM)*15-binM*7.5,
                 LONS=(1*INDGEN(12)*30),$
                 LONNAMES=[STRTRIM(INDGEN(12,2))*2]
  ENDIF ELSE BEGIN
     cgMap_Grid, Clip_Text=1, /NoClip, /LABEL,linestyle=0, thick=3,color='black',latdelta=binI*2,$
                 /NO_GRID,$
                 latlabel=minM*15-5,lonlabel=minI,$ ;latlabel=((maxM-minM)/2.0+minM)*15-binM*7.5,
                 LONS=(1*INDGEN((maxM-minM)/1.0+1)+minM)*15,$
                 LONNAMES=[strtrim(minM,2)+" MLT",STRTRIM(INDGEN((maxM-minM)/1.0)+(minM+1),2)]
  ENDELSE
     
  ;charSize = cgDefCharSize()*0.75
  ;cgText, 0, minI-1, '0', Alignment=0.5, Orientation=0, Charsize=charSize      
  ;cgText, 180, minI, '12', Alignment=0.5, Orientation=0.00, Charsize=charSize   
  ;cgText, 90, minI-1, '6 MLT',Alignment=0.5,Charsize=charSize
  ;cgText, -90, minI-1, '18',Alignment=0.5,Charsize=charSize
  
  charSize = cgDefCharSize()*((wholeCap NE !NULL) ? 0.7 : 0.75)
  ;cgText, 0, minI-5, 'midnight', Alignment=0.5, Orientation=0, Charsize=charSize      
  ;cgText, 180, minI-5, 'noon', Alignment=0.5, Orientation=0.00, Charsize=charSize   
  ;cgText, 90, minI-5, 'dawnward',Alignment=0.5,Charsize=charSize
  ;cgText, -90, minI-5, 'duskward',Alignment=0.5,Charsize=charSize  

  ;;Integral text
  ;;REMEMBER: h2dStr[nPlots].data is the MASK
  IF NOT KEYWORD_SET(noPlotIntegral) THEN BEGIN 
     IF logPlotzz THEN BEGIN
        integ=ALOG10(TOTAL(10.0^(temp.data(WHERE(~masked)))))
        absInteg=integ
        dawnIntegral=ALOG10(dawnIntegral)
        duskIntegral=ALOG10(duskIntegral)
     ENDIF ELSE BEGIN
        integ=TOTAL(temp.data(WHERE(~masked)))
        absInteg=TOTAL(ABS(temp.data(WHERE(~masked))))
     ENDELSE


     IF wholeCap NE !NULL THEN BEGIN
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
     
     IF NOT (logPlotzz) THEN cgText,lTexPos1,bTexPos2,'|Integral|: ' + string(absInteg,Format='(D0.3)'),/NORMAL,CHARSIZE=charSize
     cgText,lTexPos1,bTexPos1,'Integral: ' + string(integ,Format='(D0.3)'),/NORMAL,CHARSIZE=charSize 
     cgText,lTexPos2,bTexPos1,'Dawnward: ' + string(dawnIntegral,Format='(D0.3)'),/NORMAL,CHARSIZE=charSize 
     cgText,lTexPos2,bTexPos2,'Duskward: ' + string(duskIntegral,Format='(D0.3)'),/NORMAL,CHARSIZE=charSize 
  ENDIF 

  ;; colorbar label stuff
  IF NOT KEYWORD_SET(labelFormat) THEN labelFormat='(D0.1)'
  ;;  labelFormat='(I0)'
  lowerLab=(logPlotzz AND (pPlotzz OR nEvPerOrbPlotzz OR orbFreqPlotzz OR charEPlotzz)) ? 10^(temp.lim[0]) : temp.lim[0]
  midLab=(logPlotzz AND (pPlotzz OR nEvPerOrbPlotzz OR orbFreqPlotzz OR charEPlotzz)) ? 10^((temp.lim[0]+temp.lim[1])/2) : ((temp.lim[0]+temp.lim[1])/2)
  UpperLab=(logPlotzz AND (pPlotzz OR nEvPerOrbPlotzz OR orbFreqPlotzz OR charEPlotzz)) ? 10^temp.lim[1] : temp.lim[1]

  IF logPlotzz OR orbFreqPlotzz OR ((temp.lim[0] NE 0) AND (ALOG10(ABS(temp.lim[0])) LT -1)) THEN labelFormat='(D0.2)'
  IF wholeCap NE !NULL THEN BEGIN
     cgColorbar, NColors=nlevels-is_OOBHigh-is_OOBLow, Divisions=nlevels-is_OOBHigh-is_OOBLow, Bottom=BYTE(is_OOBLow), $
;;                 OOB_Low=(temp.lim[0] EQ 0) ? !NULL : 0B, OOB_High=(temp.lim[1] EQ MAX(temp.data)) ? !NULL : BYTE(nLevels-1), $ 
                 OOB_Low=(temp.lim[0] LE MIN(temp.data(notMasked))) ? !NULL : 0B, $
                 OOB_High=(temp.lim[1] GE MAX(temp.data(notMasked))) ? !NULL : BYTE(nLevels-1), $ 
                 Range=temp.lim, $
                 Title=temp.title, $ ; Title="Characteristic Energy (eV)", $ ;Title="Poynting flux (mW/m!U2!N)", $
                 /Discrete, $
                 Position=[0.86, 0.10, 0.89, 0.90], TEXTTHICK=1.5, /VERTICAL, TLocation="RIGHT", TCharSize=cgDefCharsize()*1.0,$
                 ;; ticknames=[String(temp.lim[0], Format=labelFormat),REPLICATE(" ",nLevels-3),String(temp.lim[1], Format=labelFormat)]
                 ticknames=[String(lowerLab, Format=labelFormat),REPLICATE(" ",(nLevels-1)/2-is_OOBLow),$
                            String(midLab, Format=labelFormat),REPLICATE(" ",(nLevels-1)/2-is_OOBHigh),$
                            String(UpperLab, Format=labelFormat)] ;for charE plot, uncomment me: String(UpperLab, Format='(I0)')]
  ENDIF ELSE BEGIN
     cgText,0.41,0.763,'ILAT',/NORMAL, charsize=charSize         
     ;; Add a colorbar.
     cgColorbar, NColors=nlevels-is_OOBHigh-is_OOBLow, Bottom=BYTE(is_OOBLow), Divisions=nlevels-is_OOBHigh-is_OOBLow, $
                 OOB_Low=(temp.lim[0] LE MIN(temp.data(notMasked))) ? !NULL : 0B, $
                 OOB_High=(temp.lim[1] GE MAX(temp.data(notMasked))) ? !NULL : BYTE(nLevels-1), $ 
                 Range=temp.lim, $
                 Title=temp.title, $
                 /Discrete, $
                 Position=[0.25, 0.89, 0.75, 0.91], TEXTTHICK=1.5, TLocation="TOP", TCharSize=cgDefCharsize()*1.0,$
                 ;; ticknames=[String(temp.lim[0], Format=labelFormat),REPLICATE(" ",nLevels-3),String(temp.lim[1], Format=labelFormat)]
                 ticknames=[String(lowerLab, Format=labelFormat),REPLICATE(" ",(nLevels-1)/2-is_OOBLow),$
                            String(midLab, Format=labelFormat),REPLICATE(" ",(nLevels-1)/2-is_OOBHigh),$
                            String(upperLab, Format=labelFormat)]
  ENDELSE

END