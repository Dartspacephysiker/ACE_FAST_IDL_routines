PRO JOURNAL__20160329__TILE_PROBOCCURRENCE_ORBSTUFF_EFLUX_IFLUX_PFLUX__AVERAGED_OVER_DELAYS__ALL_CONDITIONS

  combined_to_buffer  = 1
  save_combined_window= 1

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;About these plots, about you
  date                = '20160330'
  date_alt            = 'Mar_29_16'

  dataNamesTimeSpace  = ['spatialAvg_NoNegs--LogeNumFl_EFLUX_LOSSCONE_INTEG', $
                         'spatialAvg_NoNegs--Logiflux_INTEG_UP', $
                         'probOccurrence', $
                         'NoNegs--LogpFlux']

  dataNamesTimeSpace  = ['timeAvgd_spatialAvg_NoNegs--LogeNumFl_EFLUX_LOSSCONE_INTEG', $
                         'timeAvgd_spatialAvg_NoNegs--Logiflux_INTEG_UP', $
                         'probOccurrence', $
                         'timeAvgd_NoNegs--LogpFlux']

  ;; dataNamesLogAvg     = ['spatialAvg_NoNegs--eNumFl_EFLUX_LOSSCONE_INTEG', $
  ;;                        'spatialAvg_iflux_INTEG_UP', $
  ;;                        'probOccurrence', $
  ;;                        'pFlux'];, $
;                         'nEvents']

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Delay stuff

  ;; nDelArr              = [121,241]
  ;; delayDeltaSec        = [15,15]

  ;; nDelArr              = [61,121]
  ;; delayDeltaSec        = [30,30]

  nDelArr              = [31,61]
  delayDeltaSec        = [60,60]
  delay_start          = -5
  delay_stop           = 20

  ;; nDelArr              = [31,61,61,121]
  ;; delayDeltaSec        = [60,60,30,30]

  hemiArr        = ['NORTH','SOUTH']
  hemiArr        = ['NORTH']

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Avg types?
  ;; in_avgTypes    = ['avg','avg']
  ;; out_avgTypes   = ['avg','logAvg']

  ;; in_avgTypes    = ['avg']
  ;; out_avgTypes   = ['avg']

  ;; in_avgTypes    = ['logAvg']
  in_avgTypes    = ['avg']
  out_avgTypes   = ['timeAvg']

  ;;Set up the names
  omniPref            = '--OMNI--GSM--duskward__0stable'

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;IMF Conds
  ;; IMFCondStrArr       = '__ABS_byMin5.0__bzMax-3.0'
  IMFCondStrArr       = '__ABS_byMin4.0__bzMax-2.0'
  ;; IMFCondStrArr       = ['__ABS_byMin5.0__bzMax0.0','__ABS_byMin5.0__bzMin0.0']

  ;; bonusSuff           = 'high-energy_e'
  bonusSuff           = ''

  plotDir             = '/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/plots/'+date+'/'
  fileSuff            = bonusSuff+'--combined.png'

  FOR iAvgType=0,N_ELEMENTS(in_avgTypes)-1 DO BEGIN

     ;; CASE STRUPCASE(avgTypes[iAvgType]) OF
     ;;    'AVG': BEGIN
           dataNames = dataNamesTimeSpace 
     ;;    END
     ;;    'LOGAVG': BEGIN
     ;;       dataNames = dataNamesLogAvg
     ;;    END
     ;; ENDCASE

     FOR iCond=0,N_ELEMENTS(IMFCondStrArr)-1 DO BEGIN
        FOR iHemi=0,N_ELEMENTS(hemiArr)-1 DO BEGIN
           FOR iDel=0,N_ELEMENTS(nDelArr)-1 DO BEGIN

              IF N_ELEMENTS(delay_start) GT 0 THEN BEGIN
                 delayArr = (INDGEN(FIX((delay_stop-delay_start)*60./delayDeltaSec[0])+1,/LONG)+delay_start)*delayDeltaSec[0]
              ENDIF ELSE BEGIN
                 delayArr = (INDGEN(nDelays,/LONG)-nDelays/2)*delayDeltaSec
              ENDELSE
              out_avgString = GET_DELAY_AVG_STRING(out_avgTypes[iAvgType],delayArr,delayDeltaSec[iDel])

              paramPref     = 'polarplots_' + date_alt+'--' + hemiArr[iHemi] + '--despun--'+in_avgTypes[iAvgType]+'--maskMin5'
              paramStr      = paramPref + bonusSuff + omniPref + out_avgString + IMFCondStrArr[iCond]

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