; IDL Version 8.4.1 (linux x86_64 m64)
; Journal File for spencerh@thelonious.dartmouth.edu
; Working directory: /SPENCEdata/Research/Cusp/ACE_FAST
; Date: Fri Apr 10 10:59:36 2015
 
restore,'temp/polarplots_North_avg_all_IMF--0stable--5min_IMFsmooth--OMNI_GSM_Apr_10_15.dat'
help
print,dataname[0]
;nEventPerMin
all_IMF_dat=h2dStr(0).data
cd,current=___cur & print,___cur
;/SPENCEdata/Research/Cusp/ACE_FAST
cd,current=___cur & print,___cur
;/SPENCEdata/Research/Cusp/ACE_FAST
cd,current=___cur & print,___cur
;/SPENCEdata/Research/Cusp/ACE_FAST
cd,current=___cur & print,___cur
;/SPENCEdata/Research/Cusp/ACE_FAST
cd,current=___cur & print,___cur
;/SPENCEdata/Research/Cusp/ACE_FAST
cd,current=___cur & print,___cur
;/SPENCEdata/Research/Cusp/ACE_FAST
cd,current=___cur & print,___cur
;/SPENCEdata/Research/Cusp/ACE_FAST
cd,current=___cur & print,___cur
;/SPENCEdata/Research/Cusp/ACE_FAST
cd,current=___cur & print,___cur
;/SPENCEdata/Research/Cusp/ACE_FAST
cd,current=___cur & print,___cur
;/SPENCEdata/Research/Cusp/ACE_FAST
cd,current=___cur & print,___cur
;/SPENCEdata/Research/Cusp/ACE_FAST
restore,'temp/polarplots_North_avg_duskward--1stable--5min_IMFsmooth--OMNI_GSM_byMin_5.0_Apr_10_15.dat'
help
duskward_dat=h2dStr(0).data
restore,'temp/polarplots_North_avg_dawnward--1stable--5min_IMFsmooth--OMNI_GSM_byMin_5.0_Apr_10_15.dat'
dawnward_dat=h2dStr(0).data
help,duskward_dat
help
print,12.0/0.75
;      16.0000
dawnward_ilat=total(dawnward_dat,1)
help,dawnward_ilat
dawnward_mlt=total(dawnward_dat,2)
duskward_ilat=total(duskward_dat,1)
duskward_mlt=total(duskward_dat,2)
all_IMF_mlt=total(duskward_dat,2)
all_IMF_ilat=total(duskward_dat,1)
  maxStructLims[0,*] = [minM,maxM] ; MLT
; % Variable is undefined: MAXSTRUCTLIMS.
  maxStructLims[1,*] = [minI,maxI]  ; ILAT
; % Variable is undefined: MAXSTRUCTLIMS.
 maxStructLims=make_array(2,2)
  maxStructLims[0,*] = [minM,maxM] ; MLT
  maxStructLims[1,*] = [minI,maxI]  ; ILAT
  maxStructBinSizes = make_array(2)
  maxStructBinSizes[0] = binM
  maxStructBinSizes[1] = binI
nDataz=2
maxhistobins=1000
maxstructind=[0,1]

  ks_stats ={ks_statistic:make_array(nDataz,/DOUBLE), $
             pVal:make_array(nDataz,/DOUBLE), $
             dataProd:make_array(nDataz,/STRING), $
             histoBinSize:make_array(nDataz,/DOUBLE), $
             binLocs1:make_array(nDataz,maxHistoBins), $
             binLocs2:make_array(nDataz,maxHistoBins), $
             histoLims:make_array(nDataz,2,/DOUBLE), $
             histo1:make_array(nDataz,maxHistoBins), $
             histo2:make_array(nDataz,maxHistoBins), $
             cHisto1:make_array(nDataz,maxHistoBins), $
             cHisto2:make_array(nDataz,maxHistoBins), $
             nHistBins:make_array(nDataz)}


;do the ks stuff
print,maxstructbinsizes
;     0.750000      2.00000
print,maxstructlims
;      6.00000      60.0000
;      18.0000      84.0000
print,histo1title
; % PRINT: Variable is undefined: HISTO1TITLE.
dawnward_mlt_cdf=TOTAL(dawnward_mlt,/CUMULATIVE)
dawnward_ilat_cdf=TOTAL(dawnward_ilat,/CUMULATIVE)
duskward_ilat_cdf=TOTAL(duskward_ilat,/CUMULATIVE)
duskward_mlt_cdf=TOTAL(duskward_mlt,/CUMULATIVE)



kstwo,dawnward_mlt,all_IMF_mlt,ks_mlt_dawnall,pval_mlt_dawnall
kstwo,dawnward_ilat,all_IMF_ilat,ks_ilat_dawnall,pval_ilat_dawnall
kstwo,duskward_ilat,all_IMF_ilat,ks_ilat_duskall,pval_ilat_duskall
kstwo,duskward_mlt,all_IMF_mlt,ks_mlt_duskall,pval_mlt_duskall
kstwo,duskward_mlt,dawnward_mlt,ks_mlt_duskdawn,pval_mlt_duskdawn
kstwo,duskward_ilat,dawnward_ilat,ks_ilat_duskdawn,pval_ilat_duskdawn

mlts=indgen(17)*0.75 + 6
ilats=indgen(13)*2.0+60
