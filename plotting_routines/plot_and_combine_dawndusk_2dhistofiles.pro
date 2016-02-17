;2016/02/16
PRO PLOT_AND_COMBINE_DAWNDUSK_2DHISTOFILES,dawnFiles,$
   DUSKREPLACESTR=duskReplaceStr, $
   PROMPT_FOR_QUANTS_TO_PLOT_FOR_EACH_FILE=reprompt, $
   PLOTDIR=plotDir, $
   LUN=lun
  
  IF ~KEYWORD_SET(lun) THEN lun     = -1

  IF ~KEYWORD_SET(dawnFiles) THEN BEGIN
     dawnFiles                      = DIALOG_PICKFILE(/READ, $
                             /MULTIPLE_FILES, $
                             PATH='./', $
                             TITLE='Select dawnward H2D data file(s) to plot', $
                             FILTER='*.dat')
     IF dawnFiles[0] EQ '' THEN BEGIN
        PRINTF,lun,'No dawnFiles selected! Exiting ...'
        RETURN
     ENDIF
  ENDIF
  nFiles                            = N_ELEMENTS(dawnFiles)

  IF N_ELEMENTS(duskReplaceStr) EQ 0 THEN BEGIN
     response                       = ''
     READ,response,PROMPT='OK to replace "dawnward" with "duskward" in list of dawn files? (y/n)'
     CASE STRUPCASE(STRMID(response,0,1)) OF
        'Y': BEGIN
           dawnStr                  = 'dawnward'
           duskReplaceStr           = 'duskward'
        END
        'N': BEGIN
           proceed                  = 0
           dawnStr                  = ''
           duskReplaceStr           = ''
           dawnduskOK               = ''
           WHILE ~proceed DO BEGIN
              READ,dawnStr,PROMPT='Enter dawn string to find: '
              READ,duskReplaceStr,PROMPT='Enter dusk string that replaces dawn string: '
              READ,dawnduskOK,PROMPT=STRING(FORMAT='("[dawn string, dusk string] = [ ",A0,", ",A0," ]. OK? (y/n)")', $
                                         '"'+dawnStr+'"','"'+duskReplaceStr+'"')
              CASE STRUPCASE(STRMID(dawnduskOK,0,1)) OF
                 'Y': proceed       = 1
                 'N': PRINT,"All right, try again ..."
                 ELSE: PRINT,"Say what?"
              ENDCASE
           ENDWHILE
        END
     ENDCASE
  ENDIF

  duskFiles = dawnFiles.REPLACE(dawnStr,duskReplaceStr,/FOLD_CASE)

  ;;Set plot dir if need be
  IF ~KEYWORD_SET(plotDir) THEN set_plot_dir,plotDir


  ;;Loop over files, plot and combine dawn/dusk pairs
  titles       = ['Dawnward','Duskward']
  FOR i=0,nFiles-1 DO BEGIN
     IF KEYWORD_SET(reprompt) THEN quants_to_plot = !NULL

     plot_2dhisto_file,dawnFiles[i], $
                       PLOTDIR=plotDir, $
                       QUANTS_TO_PLOT=quants_to_plot, $
                       OUT_PLOTNAMES=plotNames, $
                       LUN=lun

     plot_2dhisto_file,duskFiles[i], $
                       PLOTDIR=plotDir, $
                       QUANTS_TO_PLOT=quants_to_plot, $
                       LUN=lun


     COMBINE_ALFVEN_STATS_PLOTS,titles, $
                                TEMPFILES=[dawnFiles[i],duskFiles[i]], $
                                PLOTS_TO_COMBINE=quants_to_plot, $
                                PLOTNAMES=plotNames, $
                                OUT_IMGS_ARR=out_imgs_arr, $
                                OUT_TITLEOBJS_ARR=out_titleObjs_arr, $
                                /COMBINED_TO_BUFFER, $
                                /SAVE_COMBINED_WINDOW, $
                                SAVE_COMBINED_NAME=save_combined_name, $
                                PLOTSUFFIX=plotSuffix, $
                                PLOTDIR=plotDir, $
                                /DELETE_PLOTS_WHEN_FINISHED

  ENDFOR
  
  
  

END