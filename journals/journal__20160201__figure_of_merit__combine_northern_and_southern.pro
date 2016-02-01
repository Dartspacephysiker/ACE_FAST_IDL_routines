;;2016/02/01
;;Now let's see wha' happen if we combine stuff from both hemispheres
PRO JOURNAL__20160201__FIGURE_OF_MERIT__COMBINE_NORTHERN_AND_SOUTHERN

  h2dFileDir                               = '/SPENCEdata/Research/Cusp/ACE_FAST/20160130--Alfven_cusp_figure_of_merit/data/'

  hoyDia                                   = GET_TODAY_STRING(/DO_YYYYMMDD_FMT)

  ;;input files
  fileDia                                  = '20160201'
  inFile_north                             = h2dFileDir+'processed/'+fileDia+'--Cusp_splitting--NORTH_figures_of_merit--delays_0-30min.sav'
  inFile_south                             = h2dFileDir+'processed/'+fileDia+'--Cusp_splitting--SOUTH_figures_of_merit--delays_0-30min.sav'

  restore,inFile_north
  combFOMList_North                        = combFOMList
  dawnFOMList_North                        = dawnFOMList
  duskFOMList_North                        = duskFOMList
  
  restore,inFile_south
  combFOMList_South                        = combFOMList
  dawnFOMList_South                        = dawnFOMList
  duskFOMList_South                        = duskFOMList

  ;; save,IMFPredomList,combFOMList,dawnFOMList,duskFOMList,delayList,FILENAME=outFile

END