;; 03/07/2015 This won't work as of yet because I haven't figured out what to do with the whole
;; OOB_high and OOB_low stuff; will there be an OOB for a contour plot?


PRO interp_polar2dcontour__coyote,temp,tempname,ancillaryData,WHOLECAP=wholeCap,MIDNIGHT=midnight, FNAME=fname, _EXTRA = e

  restore,ancillaryData
  
;;  cgDisplay,color='black',window=1

  ;round off ranges of plot to 0.25 precision
  minM=FLOOR(minM*4.0)/4.0 ;to 1/4 precision
  maxM=FLOOR(maxM*4.0)/4.0 
  minI=FLOOR(minI*4.0)/4.0 
  maxI=FLOOR(maxI*4.0)/4.0 
  
  ;Subtract one since last array is the mask
  nPlots=N_ELEMENTS(h2dStr)-1

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

  
  ;; cgMap_Set, (minI GT 0) ? 90 : -90, (midnight NE !NULL) ? 0 : 180,/STEREOGRAPHIC, /HORIZON, $
  ;;            /ISOTROPIC, /NOERASE, /NOBORDER, POSITION=position,LIMIT=lim
                ;;Limit=[minI-5,maxM*15-360,maxI+5,minM*15],

  map= MAP('Polar Stereographic', $
           CENTER_LONGITUDE=(midnight NE !NULL) ? 0 : 180, CENTER_LATITUDE = (minI GT 0) ? 90 : -90, $
           limit=lim,title=temp.title,label_format='polar_maplabels' )

  mg=map.mapgrid

  mlons=mg.longitudes
  FOR i=0,N_ELEMENTS(mlons)-1 DO BEGIN
     mlons[i].label_angle=0
     mlons[i].label_position=0.05
  ENDFOR

  mlats=mg.latitudes
  FOR i=0,N_ELEMENTS(mlats)-1 DO BEGIN
     mlats[i].label_angle=0
;;     mlons[i].label_position=0.2
  ENDFOR

  nXlines=(maxM-minM)/binM + 1
  nYlines=(maxI-minI)/binI + 1

  mlts=indgen(nXlines)*binM+minM
  ilats=indgen(nYlines)*binI+minI

  mlts=mlts*15

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
     cgLoadCT, 16,/BREWER, NCOLORS=nLevels,rgb_table=ct
  ENDIF ELSE BEGIN
     ;;This one is for data that includes negs
     cgLoadCT, 22,/BREWER, /REVERSE, NCOLORS=nLevels,rgb_table=ct
  ENDELSE

  ;;  ct = COLORTABLE(72, /reverse)

  c = CONTOUR(temp.data, mlts, ilats, /FILL, overplot=map, GRID_UNITS='degrees', RGB_TABLE=ct, TITLE=temp.title)
;;  cb = COLORBAR(TITLE=temp.title,rgb_table=ct, RANGE=temp.lim)

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

  map.Save, (KEYWORD_SET(fname) ? fname : 'polarcont.png'), RESOLUTION=300, /TRANSPARENT, BORDER=10
  map.close
END