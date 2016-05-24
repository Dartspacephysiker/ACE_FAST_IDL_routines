PRO JOURNAL__20160328__TILE_EFLUX_IFLUX_PROBOCCURRENCE_PFLUX__AVERAGED_OVER_DELAYS__ALL_CONDITIONS

  combined_to_buffer  = 1
  save_combined_window= 1

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;About these plots, about you
  date                = '20160328'
  date_alt            = 'Mar_28_16'

  dataNamesTimeSpace  = ['timeAvgd_spatialAvg_NoNegs--LogeNumFl_EFLUX_LOSSCONE_INTEG', $
                         'timeAvgd_spatialAvg_NoNegs--Logiflux_INTEG_UP', $
                         'probOccurrence', $
                         'timeAvgd_NoNegs--LogpFlux']

  ;; dataNamesLogAvg     = ['spatialAvg_NoNegs--eNumFl_EFLUX_LOSSCONE_INTEG', $
  ;;                        'spatialAvg_iflux_INTEG_UP', $
  ;;                        'probOccurrence', $
  ;;                        'pFlux'];, $
;                         'nEvents']


  ;; nDelArr        = [121,241]
  ;; delayDeltaSec  = 15

  nDelArr              = [61,121]
  delayDeltaSec        = 30

  hemiArr        = ['NORTH','SOUTH']
  ;; avgTypes       = ['avg','logAvg']
  avgTypes       = 'avg'

  ;;Set up the names
  omniPref            = '--OMNI--GSM--duskward__0stable'

  ;; IMFCondStr          = '__byMin5.0__bzMax-1.0'
  IMFCondStrArr       = ['__ABS_byMin5.0__bzMax-1.0','__ABS_byMin5.0__bzMin1.0']

  ;; bonusSuff           = 'high-energy_e'
  bonusSuff           = ''

  plotDir             = '/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/plots/'+date+'/'
  fileSuff            = bonusSuff+'--combined.png'

  FOR iAvgType=0,N_ELEMENTS(avgTypes)-1 DO BEGIN

     CASE STRUPCASE(avgTypes[iAvgType]) OF
        'AVG': BEGIN
           dataNames = dataNamesTimeSpace 
        END
        'LOGAVG': BEGIN
           dataNames = dataNamesLogAvg
        END
     ENDCASE

     FOR iCond=0,N_ELEMENTS(IMFCondStrArr)-1 DO BEGIN
        FOR iHemi=0,N_ELEMENTS(hemiArr)-1 DO BEGIN
           FOR iDel=0,N_ELEMENTS(nDelArr)-1 DO BEGIN

              delayArr      = (INDGEN(nDelArr[iDel],/LONG)-nDelArr[iDel]/2)*delayDeltaSec
              avgString     = STRING(FORMAT='("__averaged_over_",F0.2,"-",F0.2,"minDelays--delay_delta_",I0,"sec")',delayArr[0]/60.,delayArr[-1]/60.,delayDeltaSec)

              paramPref     = 'polarplots_' + date_alt+'--' + hemiArr[iHemi] + '--despun--'+avgTypes[iAvgType]+'--maskMin5'
              paramStr      = paramPref + bonusSuff + omniPref + avgString + IMFCondStrArr[iCond]

              allFiles_list = LIST()
              FOR i=0,N_ELEMENTS(dataNames)-1 DO BEGIN
                 allFiles_list.add,paramStr+'--'+dataNames[i]+fileSuff
              ENDFOR

              ;;Now combine 'em!
              FOR i=0,N_ELEMENTS(allFiles_list[0])-1 DO BEGIN
                 ;; FOR i=0,0 DO BEGIN

                 save_combined_name = paramStr+'--four_plots.png'

                 plotFiles        = plotDir + [allFiles_list[2,i],allFiles_list[0,i],allFiles_list[1,i],allFiles_list[3,i]]

                 TILE_FOUR_PLOTS,plotFiles,titles, $
                                 COMBINED_TO_BUFFER=combined_to_buffer, $
                                 SAVE_COMBINED_WINDOW=save_combined_window, $
                                 SAVE_COMBINED_NAME=save_combined_name, $
                                 PLOTDIR=plotDir, $
                                 ;; DELETE_PLOTS_WHEN_FINISHED=delete_plots, $
                                 LUN=lun
              ENDFOR

           ENDFOR
        ENDFOR
     ENDFOR
  ENDFOR





END