PRO INTERP_POLAR2DCONTOUR,temp,tempname, $
                          ancillaryData, $
                          WHOLECAP=wholeCap, $
                          MIDNIGHT=midnight, $
                          FNAME=fname, $
                          _EXTRA=e

  COMPILE_OPT idl2

  RESTORE,ancillaryData
  
  ;;round off ranges of plot to 0.25 precision
  ;; minM                     = FLOOR(minM*4.0)/4.0    ;to 1/4 precision
  ;; maxM                     = FLOOR(maxM*4.0)/4.0 
  ;; minI                     = FLOOR(minI*4.0)/4.0 
  ;; maxI                     = FLOOR(maxI*4.0)/4.0 
  
                                ;Subtract one since last array is the mask
  nPlots                      = N_ELEMENTS(h2dStr)-1

  IF KEYWORD_SET(wholeCap) THEN BEGIN
     position                 = [0.05, 0.05, 0.85, 0.85] 
     lim                      = [minI,0,84,360]
  ENDIF ELSE BEGIN
     position                 = [0.1, 0.075, 0.9, 0.75] 
     lim                      = [minI,minM*15,maxI,maxM*15]
  ENDELSE

  
  ;; cgMap_Set, (minI GT 0) ? 90 : -90, (midnight NE !NULL) ? 0 : 180,/STEREOGRAPHIC, /HORIZON, $
  ;;            /ISOTROPIC, /NOERASE, /NOBORDER, POSITION=position,LIMIT=lim
  ;;Limit=[minI-5,maxM*15-360,maxI+5,minM*15],

  map                         = MAP('Polar Stereographic', $
                                    CENTER_LONGITUDE=KEYWORD_SET(midnight) ? 0 : 180, $
                                    CENTER_LATITUDE=(minI GT 0) ? 90 : -90, $
                                    LIMIT=lim, $
                                    TITLE=temp.title, $
                                    LABEL_FORMAT='polar_maplabels' )

  mg                          = map.mapgrid

  mlons                       = mg.longitudes
  FOR i=0,N_ELEMENTS(mlons)-1 DO BEGIN
     mlons[i].label_angle     = 0
     mlons[i].label_position  = 0.05
  ENDFOR

  mlats                       = mg.latitudes
  FOR i=0,N_ELEMENTS(mlats)-1 DO BEGIN
     mlats[i].label_angle     = 0
;;     mlons[i].label_position=0.2
  ENDFOR

  nXlines                     = (maxM-minM)/binM + 1
  nYlines                     = (maxI-minI)/binI + 1

  mlts                        = INDGEN(nXlines)*binM+minM
  ilats                       = INDGEN(nYlines)*binI+minI

  mlts                        = mlts*15

                                ; Load the colors for the plot.
  nLevels                     = 13

  ;;Is this a log plot? If so, do integral of exponentiated value
  logPlotzz                   = STRMATCH(temp.title, '*log*',/FOLD_CASE)
  ;; FOR charEplot, uncomment me: logPlotzz=1

  ;;Select color table
  orbPlotzz                   = STRMATCH(temp.title, '*Orbit*',/FOLD_CASE)
  nEvPerOrbPlotzz             = STRMATCH(temp.title, '*Events per*',/FOLD_CASE)
  orbFreqPlotzz               = STRMATCH(temp.title, '*Orbit Frequency*',/FOLD_CASE)
  charEPlotzz                 = STRMATCH(temp.title, '*characteristic energy*',/FOLD_CASE)
  ;; ePlotzz=STRMATCH(temp.title, '*electron*',/FOLD_CASE)
  ;; iPlotzz=STRMATCH(temp.title, '*ion*',/FOLD_CASE)
  pPlotzz                     = STRMATCH(temp.title, '*poynting*',/FOLD_CASE)
  ;; IF ePlotzz GT 0 OR pPlotzz GT 0 OR iPlotzz GT 0 OR orbPlotzz GT 0 THEN BEGIN
  ;;    ;;This is the one for doing sweet electron flux plots
  ;;    cgLoadCT, 16,/BREWER, NCOLORS=nLevels
  ;; ENDIF ELSE BEGIN
  ;;    ;;This one is the one we use for some orbit plots
  ;;    cgLoadCT, 22,/BREWER, /REVERSE, NCOLORS=nLevels
  ;; ENDELSE

  negs                        = WHERE(temp.data LT 0.0)
  IF negs[0] EQ -1 OR (logPlotzz) THEN BEGIN
     ;;This is the one for doing "all positive" plots
     cgLoadCT, 16, $
               /BREWER, $
               NCOLORS=nLevels, $
               RGB_TABLE=ct
  ENDIF ELSE BEGIN
     ;;This one is for data that includes negs
     ;; cgLoadCT, 22, $
     ;;           /BREWER, $
     ;;           /REVERSE, $
     ;;           NCOLORS=nLevels, $
     ;;           RGB_TABLE=ct
  ENDELSE
  RAINBOW_COLORS,N_COLORS=nLevels
  TVLCT,ct,/GET

  c                           = CONTOUR(temp.data,mlts,ilats, $
                                        /FILL, $
                                        OVERPLOT=map, $
                                        GRID_UNITS='degrees', $
                                        RGB_TABLE=ct, $
                                        TITLE=temp.title)

  cb                          = COLORBAR(TITLE=temp.title, $
                                         RGB_TABLE=ct, $
                                         RANGE=temp.lim)


  ;;Save and close
  map.Save, (KEYWORD_SET(fname) ? fname : 'polarcont.png'), $
     RESOLUTION=300, $
     /TRANSPARENT, $
     BORDER=10

  map.close

END