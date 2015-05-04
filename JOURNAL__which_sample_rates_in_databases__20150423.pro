; IDL Version 8.3 (linux x86_64 m64)
; Journal File for spencerh@tadrith
; Working directory: /SPENCEdata/software/sdt/batch_jobs/Alfven_study/as5_14F
; Date: Thu Apr 23 12:03 2015
 
dbFile='/SPENCEdata/Research/Cusp/ACE_FAST/scripts_for_processing_Dartmouth_data/Dartdb_02282015--500-14999--maximus--cleaned.sav'
restore,dbFile

;only for given current sizes
maximus=resize_maximus(maximus,maximus_ind=6,min_for_ind=10,max_for_ind=2000,/ONLY_ABSVALS)

print,maximus.sample_t[0-99]
print,maximus.sample_t[0:99]

uniq_sample_ts_i=uniq(maximus.sample_t,sort(maximus.sample_t))
print,n_elements(uniq_sample_ts_i)

uniq_sample_ts=maximus.sample_t(uniq_sample_ts_i)
print,uniq_sample_ts

;; cghistoplot,maximus.sample_t,title='Histogram of FAST fields sample_ts used in the Alfvenic FAC database, v.20150228',histdata=sample_tsHist,omin=sample_tsMin,omax=sample_tsMax,binsize=1

;; cghistoplot,maximus.sample_t,title='Histogram of FAST fields sample_ts used in the Alfvenic FAC database, v.20150228',binsize=1,output='Histogram_of_FAST_fields_sample_ts_for_Dartmouth_DB_20150228.png'
;Output file located here: /SPENCEdata/software/sdt/batch_jobs/Alfven_study/as5_14F/Histogram_of_FAST_fields_sample_ts_for_Dartmouth_DB_20150228.png
;Output File: /SPENCEdata/software/sdt/batch_jobs/Alfven_study/as5_14F/Histogram_of_FAST_fields_sample_ts_for_Dartmouth_DB_20150228.png

outHistTxtFile='Histogram_of_FAST_fields_sample_ts_for_Dartmouth_DB_20150228--cleaned--absmagc_GE_10.txt'
OPENW,outHistLun,outHistTxtFile,/GET_LUN


;my own histo maker
PRINTF,outHistLun,'FIELDS SAMPLE_T       SAMPLE_FREQ              HIST COUNTS'
totCount=0
FOR i=0,n_elements(uniq_sample_ts_i) -1 DO BEGIN
   tempCount=N_ELEMENTS(where(ABS(maximus.sample_t - uniq_sample_ts[i]) LT 0.00001))
   PRINTF,outHistLun,format='(F0.6,T23,F0.4,T48,I0)',uniq_sample_ts[i],1.0/uniq_sample_ts[i],tempCount
   totCount +=tempCount
ENDFOR
printf,outHistLun,totCount

;; for i=0,n_elements(sample_tsHist)-1 DO BEGIN

;; ENDFOR

CLOSE,outHistLun
 