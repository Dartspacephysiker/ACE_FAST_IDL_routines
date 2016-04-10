PRO JOURNAL__20160404__TILE_PROBOCCURRENCE_ORBSTUFF_EFLUX_IFLUX_PFLUX__AVERAGED_OVER_DELAYS__VARIABLE_RES

  combined_to_buffer   = 1
  save_combined_window = 1

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;About these plots, about you
  ;; date                = '20160331'
  ;; date_alt            = 'Mar_31_16'

  maskMin              = 5
  despun               = 1

  just_north           = 0
  just_south           = 0

  ;; date                 = '20160403'
  ;; date_alt             = 'Apr_3_16'

  ;; date                 = '20160406'
  ;; date_alt             = 'Apr_6_16'

  date                 = '20160410'
  date_alt             = 'Apr_9_16'

  ;; dataNamesTimeSpace  = ['spatialAvg_NoNegs--LogeNumFl_EFLUX_LOSSCONE_INTEG', $
  ;;                        'spatialAvg_NoNegs--Logiflux_INTEG_UP', $
  ;;                        'probOccurrence', $
  ;;                        'NoNegs--LogpFlux']

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

  ;; delay_res                      = 600
  ;; binOffset_delay                = 0
  ;; nDelArr              = [1,3,5,7,9,11,13]
  ;; delayDeltaSec        = [600,600,600,600,600,600,600]

  ;; delay_res            = 1200
  ;; binOffset_delay      = 0
  ;; nDelArr              = [1,3,5]
  ;; delayDeltaSec        = [1200,1200,1200]

  ;; delayDeltaSec                  = [3600,3600]
  ;; delay_res                      = 3600
  ;; binOffset_delay                = 0
  ;; nDelArr              = [1,3]

  delay_res            = 1800
  binOffset_delay      = 0
  nDelArr              = [1,3,5]
  delayDeltaSec        = [1800,1800,1800]

  ;; delay_res            = 3600
  ;; binOffset_delay      = 0
  ;; nDelArr              = [1,3]
  ;; delayDeltaSec        = [3600,3600]

  ;; delay_start          = -5
  ;; delay_stop           = 20

  CASE 1 OF
     just_north: hemiArr = 'NORTH'
     just_south: hemiArr = 'SOUTH'
     ELSE: hemiArr = ['NORTH','SOUTH']
  ENDCASE

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
  ;; IMFCondStrArr        = '__ABS_byMin10.0__bzMax2.0'
  ;; IMFCondStrArr        = '__ABS_byMin10.0__bzMax0.0'
  ;; IMFCondStrArr       = '__ABS_byMin10.0'
  ;; IMFCondStrArr        = '__ABS_byMin9.0__bzMax-3.0'
  ;; IMFCondStrArr        = '__ABS_byMin8.0__bzMax-4.0'
  ;; IMFCondStrArr        = '__ABS_byMin8.0__bzMax-4.0'
  ;; IMFCondStrArr       = '__ABS_byMin7.0'
  ;; IMFCondStrArr       = '__ABS_byMin7.0__bzMax0.0'
  IMFCondStrArr        = '__ABS_byMin5.0__bzMax-5.0'
  ;; IMFCondStrArr       = '__ABS_byMin5.0__bzMax-3.0'
  ;; IMFCondStrArr       = '__ABS_byMin5.0__bzMax-1.0'
  ;; IMFCondStrArr       = '__ABS_byMin4.0__bzMax-2.0'
  ;; IMFCondStrArr       = '__ABS_byMin3.0__bzMax-1.0'
  ;; IMFCondStrArr       = ''
  ;; IMFCondStrArr       = ['__ABS_byMin5.0__bzMax0.0','__ABS_byMin5.0__bzMin0.0']

  ;; bonusSuff           = 'high-energy_e'
  bonusSuff           = ''

  plotDir             = '/SPENCEdata/Research/Cusp/ACE_FAST/plots/'+date+'/'+IMFCondStrArr+'/'
  fileSuff            = bonusSuff+'--combined.png'

  IF KEYWORD_SET(despun)              THEN despunStr          = '--despun' ELSE despunStr = ''

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;don't mess with Texas below here

  maskStr                                                     = ''
  defMaskMin                                                  = 5
  IF N_ELEMENTS(maskMin) EQ 0 THEN maskMin = defMaskMin $
  ELSE BEGIN
     IF maskMin GT 1 THEN BEGIN
        maskStr='--maskMin' + STRCOMPRESS(maskMin,/REMOVE_ALL)
     ENDIF
  ENDELSE

  ;;Make sure we can put em whar we like
  IF ~FILE_TEST(plotDir+'four_plots/') THEN SPAWN,'mkdir ' + plotDir + 'four_plots/'
  CD,plotDir

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
                 delayArr = (INDGEN(nDelArr[iDel],/LONG)-nDelArr[iDel]/2)*delayDeltaSec[iDel]
              ENDELSE
              out_avgString = GET_DELAY_AVG_STRING(out_avgTypes[iAvgType],delayArr,delayDeltaSec[iDel],delay_res)

              paramPref     = 'polarplots_' + date_alt+'--' + hemiArr[iHemi] + despunStr + '--' + in_avgTypes[iAvgType] + maskStr
              paramStr      = paramPref + bonusSuff + omniPref + out_avgString + IMFCondStrArr[iCond]

              allFiles_list = LIST()
              FOR i=0,N_ELEMENTS(dataNames)-1 DO BEGIN
                 allFiles_list.add,paramStr+'--'+dataNames[i]+fileSuff
              ENDFOR

              ;;Now combine 'em!
              FOR i=0,N_ELEMENTS(allFiles_list[0])-1 DO BEGIN
                 ;; FOR i=0,0 DO BEGIN

                 save_combined_name = paramStr+'--four_plots.png'

                 plotFiles        = [allFiles_list[2,i],allFiles_list[0,i],allFiles_list[1,i],allFiles_list[3,i]]

                 TILE_FOUR_PLOTS,plotFiles,titles, $
                                 COMBINED_TO_BUFFER=combined_to_buffer, $
                                 SAVE_COMBINED_WINDOW=save_combined_window, $
                                 SAVE_COMBINED_NAME=save_combined_name, $
                                 PLOTDIR=plotDir, $
                                 ;; DELETE_PLOTS_WHEN_FINISHED=delete_plots, $
                                 LUN=lun

                 SPAWN,'mv ' + save_combined_name + ' ' + 'four_plots/' + save_combined_name

              ENDFOR

           ENDFOR
        ENDFOR
     ENDFOR
  ENDFOR


END

