;;I want to figure out what we've got with this huge storm...

;+
;2015/07/15
;Make those nice plots for the GRL
 
;; DBFile='dartdb/saves/Dartdb_02282015--500-14999--maximus.sav'
;; DB_tFile='dartdb/saves/Dartdb_02282015--500-14999--cdbTime.sav'
;-

;;notes to self
;;first storm: cut back 12 hours
;;second: OK
;;third: Forward 12 hours
;;fourth: OK

;;Now align sudden commencement
;; first: 5 hours and some change back
;; second: 2 hours back
;; third:  1 hour forward
;; fourth: 5 hours back

;;make each plot three days long

PRO JOURNAL__20150715__four_storms_from_Yao_w_Alfvens_overlaid_in_COLOR__Alfven_storm_GRL,OUTFILENAME=outFileName

  dataDir='/SPENCEdata/Research/Cusp/database/'

  DBFile='dartdb/saves/Dartdb_20150611--500-16361_inc_lower_lats--maximus.sav'  
  DB_tFile='dartdb/saves/Dartdb_20150611--500-16361_inc_lower_lats--cdbtime.sav'
  
  maxInd=6
  log_DBquantity=0
  
  restore,dataDir+'sw_omnidata/sw_data.dat'
  restore,dataDir+DBFile
  restore,dataDir+DB_tFile
  
  storm_i=MAKE_ARRAY(4,2,/L64)
  stormStr=MAKE_ARRAY(4,/STRING)
  
  factor=1440                   ;leave this as 1440 (n minutes in a day), since storm_i has a separation of 1 min be tween data points

  ;;plot stuff
  xRange=[0,72]
  yRange_geomag=[-350,50]
  yRange_maximus=[-200,200]
  xtickfont_size=14
  xtickfont_style=1
  ytickfont_size=14
  ytickfont_style=1

  ;;First storm, 11–15 Feb
  ;; storm_i(0,0)=1856160
  ;; storm_i(0,1)=1863359
  ;; storm_i(0,0)=1856880
  ;; storm_i(0,1)=1861199
  ;third change
  storm_i(0,0)=1857180
  storm_i(0,1)=1861499
  stormStr[0]='11-15 Feb, 2000'

  ;;Second storm, 6–9 Apr
  ;; storm_i(1,0)=1935360
  ;; storm_i(1,1)=1941119
  ;; storm_i(1,0)=1935360
  ;; storm_i(1,1)=1939679
  storm_i(1,0)=1935480
  storm_i(1,1)=1939799
  stormStr[1]='06-09 Apr, 2000'

  ;;Third storm, 24–26 May
  ;; storm_i(2,0)=2004480
  ;; storm_i(2,1)=2008799
  ;; storm_i(2,0)=2003760
  ;; storm_i(2,1)=2008079
  storm_i(2,0)=2003700
  storm_i(2,1)=2008019
  stormStr[2]='24-26 May, 2000'

  ;;Fourth storm, 17–20 Sep
  ;; storm_i(3,0)=2171520
  ;; storm_i(3,1)=2177279
  ;; storm_i(3,0)=2171520
  ;; storm_i(3,1)=2175839
  storm_i(3,0)=2171820
  storm_i(3,1)=2176139
  stormStr[3]='17-20 Sep, 2000' 

  ;;Get nearest events in Chaston DB
  storm_utc=MAKE_ARRAY(4,2,/DOUBLE)
  cdb_storm_t=MAKE_ARRAY(4,2,/DOUBLE)
  cdb_storm_i=MAKE_ARRAY(4,2,/L64)
  
  FOR i=0,3 DO BEGIN
     FOR j=0,1 DO BEGIN
        storm_utc(i,j)=(sw_data.epoch.dat(storm_i(i,j))-62167219200000.0000D)/1000.0D
        tempMin=MIN(ABS(storm_utc(i,j)-cdbTime),temp_min_i)
        cdb_storm_i(i,j)=temp_min_i
        cdb_storm_t(i,j)=cdbTime(temp_min_i)
     ENDFOR
  ENDFOR
  
  good_i=get_chaston_ind(maximus,"OMNI",-1,/BOTH_HEMIS)
  mTags=TAG_NAMES(maximus)

;; plotWind=WINDOW(WINDOW_TITLE="Maximus plots", $
;;     DIMENSIONS=[1200,900])
  
  ;;Get ranges for plots
  maxMinutes=MAX((cdbTime(cdb_storm_i(*,1))-cdbTime(cdb_storm_i(*,0)))/3600.,longestStorm_i,MIN=minMinutes)
  minMaxDat=MAKE_ARRAY(4,2,/DOUBLE)
  FOR i=0,3 DO BEGIN
     minMaxDat(i,1)=MAX(maximus.(maxInd)(cdb_storm_i(i,0):cdb_storm_i(i,1)),MIN=tempMin)
     minMaxDat(i,0)=tempMin
  ENDFOR
  
  IF log_DBquantity THEN BEGIN
     maxDat=ALOG10(MAX(minMaxDat(*,1)))
     minDat=ALOG10(MIN(minMaxDat(*,0)))
  ENDIF ELSE BEGIN
     maxDat=MAX(minMaxDat(*,1))
     minDat=MIN(minMaxDat(*,0))
  ENDELSE
  
  
  
  ;;Now plot SYM-H and Chaston stuff together
  plotWind=WINDOW(WINDOW_TITLE="SYM-H plus Chaston plots", $
                  DIMENSIONS=[1200,800])
  
  plotMargin=[0.1, 0.25, 0.1, 0.15]

  color_list=['b','r','g','olive']

  FOR i=0,3 DO BEGIN
                                ;make a string array for plot
     nLabTimes=(storm_i(i,1) - storm_i(i,0)) / factor + 1
     tLabArr=INDGEN(nLabTimes,/L64)*factor/60.
     tLab=MAKE_ARRAY(nLabTimes,/STRING)
     FOR t=0L,nLabTimes-1 DO tLab[t] = cdf_encode_epoch(sw_data.epoch.dat(storm_i(i,0)+factor*t)) ;strings for each day

     ;; nTimes=((storm_i(i,1) - storm_i(i,0)) / factor + 1 )* 2 
     ;; tArr=INDGEN(nTimes,/L64)*12
     nTimes=8
     tArr=INDGEN(nTimes,/L64)*10
     tStr=STRCOMPRESS(tArr,/REMOVE_ALL)

     ;;plot data
     t=(sw_data.epoch.dat(storm_i(i,0):storm_i(i,1))-sw_data.epoch.dat(storm_i(i,0)))/3600000D0
     y=sw_data.sym_h.dat(storm_i(i,0):storm_i(i,1))
     
     plot_symh=plot(t,y, $
                    XTITLE='Hours since '+tLab[0], $
                    YTITLE='SYM-H ' + $
                    ((i GT 0 ) ? '' : '(nT)'), $
                    NAME='SYM-H', $
                    AXIS_STYLE=1, $
                    ;; XRANGE=[0,7000./60.], $
                    ;; XRANGE=[0,130], $
                    XRANGE=xRange, $
                    YRANGE=yRange_geomag, $
                    XTICKFONT_SIZE=xTickFont_size, $
                    XTICKFONT_STYLE=xTickFont_style, $
                    YTICKFONT_SIZE=yTickFont_size, $
                    YTICKFONT_STYLE=yTickFont_style, $
                    ;; XTICKNAME=STRMID(tLab,0,12), $
                    ;; XTICKVALUES=tLabArr, $
                    XTICKNAME=tStr, $
                    XTICKVALUES=tArr, $
                    LAYOUT=[1,4,i+1], $
                    MARGIN = plotMargin, $
                    /CURRENT)

     axes=plot_symh.axes

     axes[0].MINOR=1

     axes[1].MAJOR=5
     axes[1].MINOR=3

     ;;get appropriate indices for DB plot
     plot_i=cgsetintersection(good_i,indgen(cdb_storm_i(i,1)-cdb_storm_i(i,0)+1)+cdb_storm_i(i,0))
     
     ;;get relevant time range
     cdb_t=cdbTime(plot_i)-storm_utc(i,0)
     minTime=MIN(cdb_t)
     minTime=(minTime LT 0) ? minTime : 0.
     ;;get corresponding data
     ;; cdb_y=maximus.(maxInd)(cdb_storm_i(i,0):cdb_storm_i(i,1))
     cdb_y=maximus.(maxInd)(plot_i)
     
     
     
     IF plot_i(0) GT -1 THEN BEGIN
        plot_cdb=plot(cdb_t/3600., $
                      (log_DBquantity) ? ALOG10(cdb_y) : cdb_y, $
                      ;; XTITLE='Hours since '+maximus.time(cdb_storm_i(i,0)), $a
                      ;; XTITLE='Hours since '+time_to_str(storm_utc(i,0),/msec),
                      ;; YTITLE=mTags(maxInd), $
                      XRANGE=xRange, $
                      ;; ;; XRANGE=[minTime,maxMinutes], $
                      ;; YRANGE=[minDat,maxDat], $
                      YRANGE=yRange_maximus, $
                      NAME='Alfven event', $
                      AXIS_STYLE=0, $
                      LINESTYLE=' ', $
                      THICK=6.0, $
                      SYMBOL='x', $
                      SYM_TRANSPARENCY=70, $
                      SYM_COLOR=color_list(i), $
                      SYM_SIZE=1.5, $
                      ;; XTICKFONT_SIZE=10, $
                      ;; XTICKFONT_STYLE=1, $
                      XTICKFONT_SIZE=xTickFont_size, $
                      XTICKFONT_STYLE=xTickFont_style, $
                      ;; XTICKNAME=STRMID(tStr,0,12), $
                      ;; XTICKVALUES=tArr, $
                      ;; XTICKNAME=STRMID(tLab,0,12), $
                      ;; XTICKVALUES=tLabArr, $
                      XTICKNAME=tStr, $
                      XTICKVALUES=tArr, $
                      LAYOUT=[1,4,i+1], $
                      MARGIN = plotMargin, $
                      /CURRENT)
        
        yaxis = AXIS('Y', LOCATION='right', TARGET=plot_cdb, $
                     TITLE='$J_{\parallel}$ ' + $
                     ((i GT 0) ? '' : '($\mu A / m^2$)'), $
                     ;; TICKFONT_SIZE=18, $
                     ;; TICKFONT_STYLE=1, $
                     TICKFONT_SIZE=yTickFont_size, $
                     TICKFONT_STYLE=yTickFont_style, $
                     MAJOR=5, $
                     MINOR=3, $
                     AXIS_RANGE=[minDat,maxDat], $
                     TEXTPOS=1, $
                     COLOR=color_list(i))

     ENDIF

  ENDFOR
  
  IF KEYWORD_SET(outFileName) THEN BEGIN
     plot_cdb.save,outFileName,HEIGHT=1200
  ENDIF

END