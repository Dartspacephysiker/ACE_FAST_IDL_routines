PRO JOURNAL__20160302__TILE_EFLUX_IFLUX_PROBOCCURRENCE_PFLUX__DELAY_PLOTS

  combined_to_buffer  = 1
  save_combined_window= 1

  hemi                = 'SOUTH'
  ;; hemi                = 'NORTH'
  
  date                = '20160306'
  date_alt            = 'Mar_5_16'

  ;; bonusSuff           = 'high-energy_e'
  bonusSuff           = ''
  plotDir             = '/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/plots/'+date+'/'+hemi+'/'
  ;; plot_subDirs        = ['EFLUX_LOSSCONE_INTEG','iflux_INTEG_UP','probOccurrence','LogpFlux']
  plot_subDirs        = ['EFLUX_LOSSCONE_INTEG','iflux_INTEG_UP','probOccurrence','pFlux']

  delayArr            = [-1500, -1440, -1380, -1320, -1260, $
                         -1200, -1140, -1080, -1020,  -960, $
                         -900,  -840,  -780,  -720,  -660, $
                         -600,  -540,  -480,  -420,  -360, $
                         -300,  -240,  -180,  -120,  -60,  $
                         0,    60,   120,   180,   240, $
                         300,   360,   420,   480,   540, $
                         600,   660,   720,   780,   840, $
                         900,   960,  1020,  1080,  1140, $

                         1200,  1260,  1320,  1380,  1440, $
                         1500]
  delayStr            = STRING(FORMAT='("__",F0.2,"mindelay")',delayArr/60.) 

  ;; paramStr            = 'Feb_26_16--'+hemi+'--despun--logAvg--maskMin10--OMNI--GSM--duskward__0stable' + delayStr + '__byMin3.0--'
  ;; paramStr            = 'Feb_26_16--'+hemi+'--despun--logAvg--maskMin10--OMNI--GSM--duskward__0stable' + delayStr + '__byMin3.0__bzMin-4.0__bzMax4.0--'
  ;; paramStr            = 'Mar_4_16--'+hemi+'--despun--logAvg--maskMin10'+bonusSuff+'--OMNI--GSM--duskward__0stable'+delayStr + '__byMin3.0--'
  ;; paramStr            = 'Mar_4_16--'+hemi+'--despun--logAvg--maskMin10'+bonusSuff+'--OMNI--GSM--duskward__0stable'+delayStr + '__byMin3.0__bzMax-1.0--'
  ;; paramStr            = 'Mar_4_16--'+hemi+'--despun--logAvg--maskMin5'+bonusSuff+'--OMNI--GSM--duskward__0stable'+delayStr + '__byMin3.0__bzMax-3.0--'
  ;; paramStr            = 'Mar_4_16--'+hemi+'--despun--logAvg--maskMin5'+bonusSuff+'--OMNI--GSM--duskward__0stable'+delayStr + '__byMin6.0--'
  paramStr            = date_alt+'--'+hemi+'--despun--logAvg--maskMin5'+bonusSuff+'--OMNI--GSM--duskward__0stable'+delayStr + '__byMin5.0__bzMin-9.0--'
  ;; dataNames           = ['timeAvgd_spatialAvg_NoNegs--LogeNumFl_EFLUX_LOSSCONE_INTEG','timeAvgd_spatialAvg_NoNegs--Logiflux_INTEG_UP','probOccurrence','timeAvgd_NoNegs--LogpFlux']
  dataNames           = ['timeAvgd_spatialAvg_NoNegs--eNumFl_EFLUX_LOSSCONE_INTEG','timeAvgd_spatialAvg_NoNegs--Logiflux_INTEG_UP','probOccurrence','timeAvgd_pFlux']
  fileSuff            = bonusSuff+'--combined.png'

  allFiles_list       = LIST()
  FOR i=0,3 DO BEGIN
     allFiles_list.add,plot_subDirs[i]+'/'+paramStr+dataNames[i]+fileSuff
  ENDFOR

  ;;Now combine 'em!

  FOR i=0,N_ELEMENTS(allFiles_list[0])-1 DO BEGIN
  ;; FOR i=0,0 DO BEGIN

     save_combined_name = paramStr[i]+'four_plots.png'

     plotFiles        = plotDir + [allFiles_list[2,i],allFiles_list[0,i],allFiles_list[1,i],allFiles_list[3,i]]

     TILE_FOUR_PLOTS,plotFiles,titles, $
                     COMBINED_TO_BUFFER=combined_to_buffer, $
                     SAVE_COMBINED_WINDOW=save_combined_window, $
                     SAVE_COMBINED_NAME=save_combined_name, $
                     PLOTDIR=plotDir, $
                     ;; DELETE_PLOTS_WHEN_FINISHED=delete_plots, $
                     LUN=lun
  ENDFOR

END