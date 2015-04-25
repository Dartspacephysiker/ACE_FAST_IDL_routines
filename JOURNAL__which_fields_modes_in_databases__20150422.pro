; IDL Version 8.3 (linux x86_64 m64)
; Journal File for spencerh@tadrith
; Working directory: /SPENCEdata/software/sdt/batch_jobs/Alfven_study/as5_14F
; Date: Wed Apr 22 17:43:46 2015
 
dbFile='/SPENCEdata/Research/Cusp/ACE_FAST/scripts_for_processing_Dartmouth_data/Dartdb_02282015--500-14999--maximus.sav'
restore,dbFile
help,maximus,/str
print,maximus.mode[0-99]
;      44.0000
print,maximus.mode[0:99]
;      2.00000      2.00000      2.00000      2.00000      2.00000      2.00000
;      2.00000      2.00000      2.00000      2.00000      2.00000      2.00000
;      2.00000      2.00000      2.00000      2.00000      2.00000      2.00000
;      2.00000      2.00000      2.00000      2.00000      2.00000      2.00000
;      2.00000      2.00000      2.00000      2.00000      2.00000      2.00000
;      2.00000      2.00000      2.00000      2.00000      2.00000      2.00000
;      2.00000      2.00000      2.00000      2.00000      2.00000      2.00000
;      2.00000      2.00000      2.00000      2.00000      2.00000      2.00000
;      2.00000      2.00000      2.00000      2.00000      2.00000      2.00000
;      2.00000      2.00000      2.00000      2.00000      2.00000      2.00000
;      2.00000      2.00000      2.00000      2.00000      2.00000      2.00000
;      2.00000      2.00000      2.00000      2.00000      2.00000      2.00000
;      2.00000      2.00000      2.00000      2.00000      2.00000      2.00000
;      2.00000      2.00000      2.00000      2.00000      2.00000      2.00000
;      2.00000      2.00000      2.00000      2.00000      2.00000      2.00000
;      2.00000      2.00000      2.00000      2.00000      2.00000      2.00000
;      2.00000      2.00000      2.00000      2.00000
uniq_modes_i=uniq(maximus.mode,sort(maximus.mode))
print,n_elements(uniq_modes_i)
;          36
print,maximus.mode(uniq_modes_i)
;      2.00000      18.0000      19.0000      21.0000      22.0000      23.0000
;      24.0000      25.0000      26.0000      29.0000      30.0000      31.0000
;      33.0000      34.0000      35.0000      36.0000      37.0000      40.0000
;      41.0000      43.0000      44.0000      45.0000      49.0000      50.0000
;      53.0000      55.0000      64.0000      65.0000      66.0000      67.0000
;      128.000      129.000      130.000      131.000      132.000      255.000
cghistoplot,maximus.mode,title='Histogram of FAST fields modes used in the Alfvenic FAC database, v.20150228',histdata=modesHist,omin=modesMin,omax=modesMax,binsize=1

cghistoplot,maximus.mode,title='Histogram of FAST fields modes used in the Alfvenic FAC database, v.20150228',binsize=1,output='Histogram_of_FAST_fields_modes_for_Dartmouth_DB_20150228.png'
;Output file located here: /SPENCEdata/software/sdt/batch_jobs/Alfven_study/as5_14F/Histogram_of_FAST_fields_modes_for_Dartmouth_DB_20150228.png
;Output File: /SPENCEdata/software/sdt/batch_jobs/Alfven_study/as5_14F/Histogram_of_FAST_fields_modes_for_Dartmouth_DB_20150228.png

outHistTxtFile='Histogram_of_FAST_fields_modes_for_Dartmouth_DB_20150228.txt'
OPENW,outHistLun,outHistTxtFile,/GET_LUN

PRINTF,outHistLun,'FIELDS MODE       HIST COUNTS'


for i=0,n_elements(modesHist)-1 DO BEGIN
   printf,outHistLun,format='(I0,T20,I0)',i+modesMin,modesHist[i]
ENDFOR

CLOSE,outHistLun
