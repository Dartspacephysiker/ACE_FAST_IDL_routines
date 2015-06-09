; Date: Mon Jun  8 16:28:35 2015
 
restore,'../database/sw_omnidata/sw_data.dat'

print,cdf_encode_epoch(sw_data.epoch.dat(4427999))
;31-Dec-2004 23:59:00.000
;OK, we've got data through 2004

print,cdf_encode_epoch(sw_data.epoch.dat(2171520))
;17-Sep-2000 03:00:00.000
;There we go. The FAST stuff reported in Yao et al. 2008 was happening on 18 Sep, ~4:30-5:00 p.m.

storm_t=MAKE_ARRAY(4,2,/L64)
stormStr=MAKE_ARRAY(4)


;First storm, 11–15 Feb
storm_t(0,0)=1856160
storm_t(0,1)=1863359
stormStr[0]='11-15 Feb, 2000'

;Second storm, 6–9 Apr
storm_t(1,0)=1935360
storm_t(1,1)=1941119
stormStr[1]='06-09 Apr, 2000'

;Third storm, 24–26 May
storm_t(2,0)=2004480
storm_t(2,1)=2008799
stormStr[2]='24-26 May, 2000'

;Fourth storm, 17–20 Sep
storm_t(3,0)=2171520
storm_t(3,1)=2177279
stormStr[3]='17-20 Sep, 2000' 

plotWind=WINDOW(WINDOW_TITLE="SYM/H plots", $
    DIMENSIONS=[1000,900])

FOR i=0,3 DO BEGIN

   ;make a string array
   nTimes=(storm_t(i,1) - storm_t(i,0)) / 1440
   tArr=INDGEN(nTimes,/L64)*1440
   tStr=MAKE_ARRAY(nTimes,/STRING)
   FOR t=0L,nTimes-1 DO tStr[t] = cdf_encode_epoch(sw_data.epoch.dat(storm_t(i,0)+1440*t))

   ;; t_start=cdf_encode_epoch(sw_data.epoch.dat(storm_t(i,0)))
   ;; t_mid=cdf_encode_epoch(sw_data.epoch.dat(storm_t(i,0)+1440))
   ;; t_end=cdf_encode_epoch(sw_data.epoch.dat(storm_t(i,0)+2880))

   plot=plot((sw_data.epoch.dat(storm_t(i,0):storm_t(i,1))-sw_data.epoch.dat(storm_t(i,0)))/60000D0, $
             sw_data.sym_h.dat(storm_t(i,0):storm_t(i,1)), $
             XTITLE='Minutes since '+tStr[0], $
             YTITLE='SYM/H (nT)', $
             XTICKFONT_SIZE=10, $
             ;; XTICKFONT_STYLE=1, $
             ;; XTICKNAME=STRMID(tStr,0,12), $
             ;; XTICKVALUES=tArr, $
             LAYOUT=[1,4,i+1], $
             /CURRENT)
ENDFOR
