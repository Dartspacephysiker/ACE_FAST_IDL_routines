;;2016/02/01
;;Now let's see wha' happen if we combine stuff from both hemispheres
PRO JOURNAL__20160201__FIGURE_OF_MERIT_II__COMBINE_NORTHERN_AND_SOUTHERN

  IF N_ELEMENTS(lun) EQ 0 THEN lun         = -1 ;stdout

  h2dFileDir                               = '/SPENCEdata/Research/Cusp/ACE_FAST/20160130--Alfven_cusp_figure_of_merit/data/'

  include_allIMF                           = 0
  hoyDia                                   = GET_TODAY_STRING(/DO_YYYYMMDD_FMT)

  ;;input files
  fileDia                                  = '20160201'
  inFile_north                             = h2dFileDir+'processed/'+fileDia+'--Cusp_splitting--NORTH_figures_of_merit_II--delays_0-30min.sav'
  inFile_south                             = h2dFileDir+'processed/'+fileDia+'--Cusp_splitting--SOUTH_figures_of_merit_II--delays_0-30min.sav'

  nFOM_to_print                            = 25

  restore,inFile_north
  combFOMList_North                        = combFOMList
  dawnFOMList_North                        = dawnFOMList
  duskFOMList_North                        = duskFOMList
  delayList_North                          = delayList
  
  restore,inFile_south
  combFOMList_South                        = combFOMList
  dawnFOMList_South                        = dawnFOMList
  duskFOMList_South                        = duskFOMList
  delayList_South                          = delayList

  IF KEYWORD_SET(include_allIMF) THEN BEGIN
     combNorthSouth                        = (combFOMList_North[0]+combFOMList_North[1]+combFOMList_North[2]+ $
                                              combFOMList_South[0]+combFOMList_South[1]+combFOMList_South[2])/2.
     combNorth                             = combFOMList_North[0]+combFOMList_North[1]+combFOMList_North[2]
     combSouth                             = combFOMList_South[0]+combFOMList_South[1]+combFOMList_South[2]
  ENDIF ELSE BEGIN
     combNorthSouth                        = (combFOMList_North[0]+combFOMList_North[2]+ $
                                              combFOMList_South[0]+combFOMList_South[2])/2.
     combNorth                             = combFOMList_North[0]+combFOMList_North[2]
     combSouth                             = combFOMList_South[0]+combFOMList_South[2]

  ENDELSE

  combNorthSouth_awesome                   = GET_N_MAXIMA_IN_ARRAY(combNorthSouth,N=nFOM_to_print,OUT_I=combNorthSouth_i)
  delayNorthSouth_awesome                  = delayList_North[0,combNorthSouth_i]

  PRINTF,lun,"****FIGURE OF MERIT FROM COMBINING HEMISPHERES****"
  PRINTF,lun,FORMAT='("Rank",T10,"Delay (m)",T25,"N/S FOM",T35,"N FOM",T45,"S FOM")'
  statFmt                                  = '(I0,T10,F0.1,T25,F0.3,T35,F0.3,T45,F0.3)'
  
  FOR i=0,nFOM_to_print-1 DO BEGIN
     list_i                                = combNorthSouth_i[i]
     ;; PRINTF,lun,FORMAT=fomUltimateFmtString,i+1,delayNorthSouth_awesome[i],combNorthSouth_awesome[i],dawnFOMList[0,i],duskFOMList[0,i],dawnFOMList[2,i],duskFOMList[2,i]
     ;; print,i
     ;; print,i+1
     PRINTF,lun,FORMAT=statFmt,i+1,delayNorthSouth_awesome[i],combNorthSouth_awesome[i], $
            combNorth[list_i],combSouth[list_i]
  ENDFOR
  

  ;; nPlots                                   = 3
  ;; datArr                                   = [[combNorthSouth],[combNorth],[combSouth]]
  ;; plotNames                                = ['N+S','North','South']
  ;; plotColor                                = ['BLACK','RED','BLUE']
  nPlots                                   = 2
  datArr                                   = [[combNorth],[combSouth]]
  plotNames                                = ['North','South']
  plotColor                                = ['RED','BLUE']
  plotArr                                  = MAKE_ARRAY(nPlots,/OBJ)

  plotWin                                  = WINDOW(WINDOW_TITLE='Figures of merit for each hemisphere', $
                                                    DIMENSIONS=[1200,800])
  FOR i=0,nPlots-1 DO BEGIN
     plotArr[i]                            = PLOT(delayList[0],datArr[*,i], $
                                                  TITLE=(i GT 0) ? !NULL : 'Figure of Merit II', $
                                                  NAME=plotNames[i], $
                                                  OVERPLOT=(i GT 0), $
                                                  COLOR=plotColor[i], $
                                                  THICK=3.0, $
                                                  TRANSPARENCY=50, $
                                                  /CURRENT)
                                                  
  ENDFOR
  legend                                   = LEGEND(TARGET=plotArr[0:nPlots-1], $
                                                    /NORMAL, $
                                                    POSITION=[0.85,0.82], $
                                                    FONT_SIZE=18, $
                                                    HORIZONTAL_ALIGNMENT=0.5, $
                                                    VERTICAL_SPACING=0.01, $
                                                    /AUTO_TEXT_COLOR)

END