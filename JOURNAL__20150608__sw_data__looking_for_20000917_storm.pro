; Date: Mon Jun  8 16:28:35 2015
 
;; DBFile='dartdb/saves/Dartdb_02282015--500-14999--maximus.sav'
;; DB_tFile='dartdb/saves/Dartdb_02282015--500-14999--cdbTime.sav'

plotScaleString='Hours'
plotScaleString='Minutes'

DBFile='dartdb/saves/Dartdb_20150611--500-16361_inc_lower_lats--maximus.sav'  
DB_tFile='dartdb/saves/Dartdb_20150611--500-16361_inc_lower_lats--cdbtime.sav'

maxInd=6
log_DBquantity=0

restore,dataDir+'sw_omnidata/sw_data.dat'
restore,dataDir+DBFile
restore,dataDir+DB_tFile

print,cdf_encode_epoch(sw_data.epoch.dat(4427999))
;31-Dec-2004 23:59:00.000
;OK, we've got data through 2004

print,cdf_encode_epoch(sw_data.epoch.dat(2171520))
;17-Sep-2000 03:00:00.000
;There we go. The FAST stuff reported in Yao et al. 2008 was happening on 18 Sep, ~4:30-5:00 p.m.

storm_i=MAKE_ARRAY(4,2,/L64)
stormStr=MAKE_ARRAY(4)

;First storm, 11–15 Feb
storm_i(0,0)=1856160
storm_i(0,1)=1863359
stormStr[0]='11-15 Feb, 2000'

;Second storm, 6–9 Apr
storm_i(1,0)=1935360
storm_i(1,1)=1941119
stormStr[1]='06-09 Apr, 2000'

;Third storm, 24–26 May
storm_i(2,0)=2004480
storm_i(2,1)=2008799
stormStr[2]='24-26 May, 2000'

;Fourth storm, 17–20 Sep
storm_i(3,0)=2171520
storm_i(3,1)=2177279
stormStr[3]='17-20 Sep, 2000' 

;Get nearest events in Chaston DB
storm_utc=MAKE_ARRAY(4,2,/DOUBLE)
cdb_storm_t=MAKE_ARRAY(4,2,/DOUBLE)
cdb_storm_i=MAKE_ARRAY(4,2,/L64)
;; mag_utc=(sw_data.epoch.dat-62167219200000.0000D)/1000.0D ;For conversion between SW DB and ours
FOR i=0,3 DO BEGIN
   FOR j=0,1 DO BEGIN
      storm_utc(i,j)=(sw_data.epoch.dat(storm_i(i,j))-62167219200000.0000D)/1000.0D
      tempMin=MIN(ABS(storm_utc(i,j)-cdbTime),temp_min_i)
      cdb_storm_i(i,j)=temp_min_i
      cdb_storm_t(i,j)=cdbTime(temp_min_i)
   ENDFOR
ENDFOR

;Now plot SYM-H
plotWind=WINDOW(WINDOW_TITLE="SYM-H plots", $
    DIMENSIONS=[1200,900])

FOR i=0,3 DO BEGIN

   ;make a string array for plot
   factor=1440 ;leave this as 1440 (n minutes in a day), since storm_i has a separation of 1 min between data points
   nTimes=(storm_i(i,1) - storm_i(i,0)) / factor + 1
   tArr=INDGEN(nTimes,/L64)*factor/60.
   tStr=MAKE_ARRAY(nTimes,/STRING)
   FOR t=0L,nTimes-1 DO tStr[t] = cdf_encode_epoch(sw_data.epoch.dat(storm_i(i,0)+factor*t)) ;strings for each day

   ;plot data
   t=(sw_data.epoch.dat(storm_i(i,0):storm_i(i,1))-sw_data.epoch.dat(storm_i(i,0)))/3600000D0
   y=sw_data.sym_h.dat(storm_i(i,0):storm_i(i,1))

   plot=plot(t,y, $
             XTITLE='Hours since '+tStr[0], $
             YTITLE='SYM-H (nT)', $
             ;; XRANGE=[0,7000./60.], $
             XRANGE=[0,120], $
             YRANGE=[-350,50], $
             XTICKFONT_SIZE=10, $
             XTICKFONT_STYLE=1, $
             ;; XTICKNAME=STRMID(tStr,0,12), $
             ;; XTICKVALUES=tArr, $
             LAYOUT=[1,4,i+1], $
             /CURRENT)
ENDFOR

;And NOW let's plot quantity from the Alfven DB to see how it fares during storms

good_i=get_chaston_ind(maximus,"OMNI",-1,/BOTH_HEMIS)
mTags=TAG_NAMES(maximus)

plotWind=WINDOW(WINDOW_TITLE="Maximus plots", $
    DIMENSIONS=[1200,900])

;Get ranges for plots
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

;colors for each storm
color_list=['b','r','g','olive']

;now plot DB quantity
FOR i=0,3 DO BEGIN

   ;get appropriate indices
   plot_i=cgsetintersection(good_i,indgen(cdb_storm_i(i,1)-cdb_storm_i(i,0)+1)+cdb_storm_i(i,0))

   ;get relevant time range
   cdb_t=cdbTime(plot_i)-storm_utc(i,0)
   minTime=MIN(cdb_t)
   minTime=(minTime LT 0) ? minTime : 0.
   ;get corresponding data
   ;; cdb_y=maximus.(maxInd)(cdb_storm_i(i,0):cdb_storm_i(i,1))
   cdb_y=maximus.(maxInd)(plot_i)

   IF plot_i(0) GT -1 THEN plot=plot(cdb_t/3600., $
                                     (log_DBquantity) ? ALOG10(cdb_y) : cdb_y, $
                                     ;; XTITLE='Hours since '+maximus.time(cdb_storm_i(i,0)), $
                                     XTITLE='Hours since '+time_to_str(storm_utc(i,0),/msec), $
                                     YTITLE=mTags(maxInd), $
                                     XRANGE=[minTime,maxMinutes], $
                                     YRANGE=[minDat,maxDat], $
                                     LINESTYLE=' ', $
                                     SYMBOL='+', $
                                     XTICKFONT_SIZE=10, $
                                     XTICKFONT_STYLE=1, $
                                     ;; XTICKNAME=STRMID(tStr,0,12), $
                                     ;; XTICKVALUES=tArr, $
                                     LAYOUT=[1,4,i+1], $
                                     /CURRENT)

   IF i EQ 0 THEN BEGIN
      plot_i_master=plot_i
      plot_i_list=LIST(plot_i)
      plot_i_color=MAKE_ARRAY(N_ELEMENTS(plot_i),/STRING,VALUE=color_list[i])

   ENDIF ELSE BEGIN
      plot_i_master=[plot_i_master,plot_i]
      plot_i_list.add,plot_i
      plot_i_color=[plot_i_color,MAKE_ARRAY(N_ELEMENTS(plot_i),/STRING,VALUE=color_list[i])]
   ENDELSE

ENDFOR

;save,plot_i_master,plot_i_list,plot_i_color,color_list,filename='PLOT_INDICES--four_storms_from_2000--Yao_et_al_2008.sav'