;;I want to figure out what we've got with this huge storm...

;+
;2015/07/01
;This time, I'm make a figure for the GRL we're hoping to write!!
 
;; DBFile='dartdb/saves/Dartdb_02282015--500-14999--maximus.sav'
;; DB_tFile='dartdb/saves/Dartdb_02282015--500-14999--cdbTime.sav'
;-

PRO JOURNAL__20150701__huge_storm_20000406_w_Alfvens_overlaid__Alfven_storm_GRL,PS_OUTPUT=ps_output

  dataDir='/SPENCEdata/Research/Cusp/database/'

  DBFile='dartdb/saves/Dartdb_20150611--500-16361_inc_lower_lats--maximus.sav'  
  DB_tFile='dartdb/saves/Dartdb_20150611--500-16361_inc_lower_lats--cdbtime.sav'
  
  maxInd=6
  log_DBquantity=0
  
  restore,dataDir+'sw_omnidata/sw_data.dat'
  restore,dataDir+DBFile
  restore,dataDir+DB_tFile
  
  storm_i=MAKE_ARRAY(1,2,/L64)
  stormStr=MAKE_ARRAY(1,/STRING)
  
  ;;Storm, 17–20
  ;;Second storm, 6–9 Apr
  storm_i(0,0)=1934640
  storm_i(0,1)=1942559
  stormStr[0]='06-09 Apr, 2000'
  ;; storm_i(0,0)=2075840
  ;; storm_i(0,1)=2084000
  ;; stormStr[0]='17 Jul, 2000' 

  ;;Get nearest events in Chaston DB
  storm_utc=MAKE_ARRAY(1,2,/DOUBLE)
  cdb_storm_t=MAKE_ARRAY(1,2,/DOUBLE)
  cdb_storm_i=MAKE_ARRAY(1,2,/L64)
  
  ;; FOR i=0 DO BEGIN
  i=0
     FOR j=0,1 DO BEGIN
        storm_utc(i,j)=(sw_data.epoch.dat(storm_i(i,j))-62167219200000.0000D)/1000.0D
        tempMin=MIN(ABS(storm_utc(i,j)-cdbTime),temp_min_i)
        cdb_storm_i(i,j)=temp_min_i
        cdb_storm_t(i,j)=cdbTime(temp_min_i)
     ENDFOR
  ;; ENDFOR
  
  good_i=get_chaston_ind(maximus,"OMNI",-1,/BOTH_HEMIS)
  mTags=TAG_NAMES(maximus)

;; plotWind=WINDOW(WINDOW_TITLE="Maximus plots", $
;;     DIMENSIONS=[1200,900])
  
  ;;Get ranges for plots
  maxMinutes=MAX((cdbTime(cdb_storm_i(*,1))-cdbTime(cdb_storm_i(*,0)))/3600.,longestStorm_i,MIN=minMinutes)
  minMaxDat=MAKE_ARRAY(4,2,/DOUBLE)
  ;; FOR i=0,3 DO BEGIN
     i=0
     minMaxDat(i,1)=MAX(maximus.(maxInd)(cdb_storm_i(i,0):cdb_storm_i(i,1)),MIN=tempMin)
     minMaxDat(i,0)=tempMin
  ;; ENDFOR
  
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
  
  plotMargin=[0.1, 0.15, 0.1, 0.15]

  color_list=['b','r','g','olive']

  ;; FOR i=0,3 DO BEGIN
  i=0
                                ;make a string array for plot
     factor=1440                ;leave this as 1440 (n minutes in a day), since storm_i has a separation of 1 min be tween data points
     nTimes=(storm_i(i,1) - storm_i(i,0)) / factor + 1
     tArr=INDGEN(nTimes,/L64)*factor/60.
     tStr=MAKE_ARRAY(nTimes,/STRING)
     FOR t=0L,nTimes-1 DO tStr[t] = cdf_encode_epoch(sw_data.epoch.dat(storm_i(i,0)+factor*t)) ;strings for each day
     
     ;;plot data
     t=(sw_data.epoch.dat(storm_i(i,0):storm_i(i,1))-sw_data.epoch.dat(storm_i(i,0)))/3600000D0
     y=sw_data.sym_h.dat(storm_i(i,0):storm_i(i,1))
     
     plot_symh=plot(t,y, $
                    XTITLE='Hours since '+tStr[0], $
                    YTITLE='SYM-H ' + $
                    ((i GT 0 ) ? '' : '(nT)'), $
                    NAME='SYM-H', $
                    AXIS_STYLE=1, $
                    ;; XRANGE=[0,7000./60.], $
                    XRANGE=[0,130], $
                    YRANGE=[-350,50], $
                    XTICKFONT_SIZE=18, $
                    XTICKFONT_STYLE=1, $
                    YTICKFONT_SIZE=18, $
                    YTICKFONT_STYLE=1, $
                    ;; XTICKNAME=STRMID(tStr,0,12), $
                    ;; XTICKVALUES=tArr, $
                    ;; LAYOUT=[1,4,i+1], $
                    MARGIN = plotMargin, $
                    /CURRENT)

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
                      XRANGE=[0,120], $
                      ;; ;; XRANGE=[minTime,maxMinutes], $
                      ;; YRANGE=[minDat,maxDat], $
                      YRANGE=[-200,200], $
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
                      ;; XTICKNAME=STRMID(tStr,0,12), $
                      ;; XTICKVALUES=tArr, $
                      ;; LAYOUT=[1,4,i+1], $
                      MARGIN = plotMargin, $
                      /CURRENT)
        
        yaxis = AXIS('Y', LOCATION='right', TARGET=plot_cdb, $
                     TITLE='$J_{\parallel}$ ' + $
                     ((i GT 0) ? '' : '($\mu A / m^2$)'), $
                     TICKFONT_SIZE=18, $
                     TICKFONT_STYLE=1, $
                     MAJOR=5, $
                     MINOR=3, $
                     ;; AXIS_RANGE=[minDat,maxDat], $
                     TEXTPOS=1, $
                     COLOR=color_list(i))

     ENDIF

  ;; ENDFOR
  
  ;; IF KEYWORD_SET(ps_output) THEN BEGIN

  ;;    device, /close
  ;;    set_plot, 'x'
  ;;    !p.font=-1

  ;; ENDIF

END