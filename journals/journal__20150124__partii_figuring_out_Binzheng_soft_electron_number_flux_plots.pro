;;01242015
;;The important part is below, where I discover for electron number flux the same thing I discovered
;;for electron energy flux--that the vast, vast majority of events are not the outliers.
;;At the bottom I think you'll discover that the proper way to go about this is to restrict the data
;;to something like -1e7 through 1e7, or maybe less
restore,'/SPENCEdata/Research/Cusp/database/dartdb/saves/Dartdb_01242015_maximus.sav'
help,maximus,/str
;;** Structure <de47c8>, 46 tags, length=52204440, data length=52204430, refs=1:
;;  ORBIT           INT       Array[269095]
;;  ALFVENIC        FLOAT     Array[269095]
;;  TIME            STRING    Array[269095]
;;  ALT             FLOAT     Array[269095]
;;  MLT             FLOAT     Array[269095]
;;  ILAT            FLOAT     Array[269095]
;;  MAG_CURRENT     FLOAT     Array[269095]
;;  ESA_CURRENT     FLOAT     Array[269095]
;;  ELEC_ENERGY_FLUX
;;                  FLOAT     Array[269095]
;;  INTEG_ELEC_ENERGY_FLUX
;;                  FLOAT     Array[269095]
;;  EFLUX_LOSSCONE_INTEG
;;                  FLOAT     Array[269095]
;;  TOTAL_EFLUX_INTEG
;;                  FLOAT     Array[269095]
;;  MAX_CHARE_LOSSCONE
;;                  FLOAT     Array[269095]
;;  MAX_CHARE_TOTAL FLOAT     Array[269095]
;;  ION_ENERGY_FLUX FLOAT     Array[269095]
;;  ION_FLUX        FLOAT     Array[269095]
;;  ION_FLUX_UP     FLOAT     Array[269095]
;;  INTEG_ION_FLUX  FLOAT     Array[269095]
;;  INTEG_ION_FLUX_UP
;;                  FLOAT     Array[269095]
;;  CHAR_ION_ENERGY FLOAT     Array[269095]
;;  WIDTH_TIME      FLOAT     Array[269095]
;;  WIDTH_X         FLOAT     Array[269095]
;;  DELTA_B         FLOAT     Array[269095]
;;  DELTA_E         FLOAT     Array[269095]
;;  SAMPLE_T        FLOAT     Array[269095]
;;  MODE            FLOAT     Array[269095]
;;  PROTON_FLUX_UP  FLOAT     Array[269095]
;;  PROTON_CHAR_ENERGY
;;                  FLOAT     Array[269095]
;;  OXY_FLUX_UP     FLOAT     Array[269095]
;;  OXY_CHAR_ENERGY FLOAT     Array[269095]
;;  HELIUM_FLUX_UP  FLOAT     Array[269095]
;;  HELIUM_CHAR_ENERGY
;;                  FLOAT     Array[269095]
;;  SC_POT          FLOAT     Array[269095]
;;  L_PROBE         FLOAT     Array[269095]
;;  MAX_L_PROBE     FLOAT     Array[269095]
;;  MIN_L_PROBE     FLOAT     Array[269095]
;;  MEDIAN_L_PROBE  FLOAT     Array[269095]
;;  TOTAL_ELECTRON_ENERGY_DFLUX_SINGLE
;;                  FLOAT     Array[269095]
;;  TOTAL_ELECTRON_ENERGY_DFLUX_MULTIPLE_TOT
;;                  FLOAT     Array[269095]
;;  TOTAL_ALFVEN_ELECTRON_ENERGY_DFLUX
;;                  FLOAT     Array[269095]
;;  TOTAL_ION_OUTFLOW_SINGLE
;;                  FLOAT     Array[269095]
;;  TOTAL_ION_OUTFLOW_MULTIPLE_TOT
;;                  FLOAT     Array[269095]
;;  TOTAL_ALFVEN_ION_OUTFLOW
;;                  FLOAT     Array[269095]
;;  TOTAL_UPWARD_ION_OUTFLOW_SINGLE
;;                  FLOAT     Array[269095]
;;  TOTAL_UPWARD_ION_OUTFLOW_MULTIPLE_TOT
;;                  FLOAT     Array[269095]
;;  TOTAL_ALFVEN_UPWARD_ION_OUTFLOW
;;                  FLOAT     Array[269095]

cghistoplot,maximus.EFLUX_LOSSCONE_INTEG,locations=locs,omax=omax,omin=omin,histdata=hdata
print,omax
;; 7.51706e+14
print,omin
;;-5.05107e+15
print,n_elements(locs)
;;      10803

for i=0,200 do print,locs(i),hdata[i]
;;-5.05107e+15           1
;;-5.05053e+15           0
;;-5.05000e+15           0
;;-5.04946e+15           0
;;-5.04892e+15           0
;;-5.04838e+15           0
;;........................
;;-4.94418e+15           0
;;-4.94364e+15           0

print,n_elements(locs)/2
;;       5401
print,locs(9800)
;; 2.13088e+14
print,locs(9500)
;; 5.19401e+13
print,locs(9300)
;;-5.54921e+13


;;THIS IS THE IMPORTANT PART--NOTE THAT THE ONE BIN CLOSEST TO ZERO IS LOADED WITH A FEW HUNDRED
;;THOUSAND EVENTS!!!
for i=9300,9500 do print,locs(i),hdata(i)
;;-5.54921e+13           0
;;-5.49546e+13           0
;;-5.44172e+13           0
;;-5.38804e+13           0
;;-5.33430e+13           0
;;-5.28061e+13           0
;;-5.22687e+13           0
;;-5.17318e+13           0
;;-5.11944e+13           0
;;-5.06575e+13           0
;;-5.01201e+13           0
;;........................
;;-1.03702e+13           0
;;-1.77597e+12           0
;;-1.23856e+12           0
;;-7.01690e+11           5
;;-1.64282e+11      268770
;; 3.72588e+11           1
;; 9.09996e+11           0
;; 1.44687e+12           0
;; 1.98427e+12           2
;; 2.52115e+12           0
;; 3.05855e+12           1
;; 3.59542e+12           0
;; 4.13283e+12           0
;; 4.67024e+12           0
;; 5.20711e+12           0
;; 5.74452e+12           0
;; 6.28139e+12           0
;; 6.81880e+12           0
;; .......................
;; 5.14027e+13           0
;; 5.19401e+13           0

;;for i=1000,1200 do print,locs(i),hdata(i)
;; -1.60614e+07           1
;; -1.50775e+07           0
;; -1.40936e+07           2
;; -1.31096e+07           1
;; -1.21257e+07           0
;; -1.11418e+07           1
;; -1.01578e+07           1
;; -9.17389e+06           0
;; -8.18995e+06           0
;; -7.20602e+06           2
;; -6.22208e+06           5
;; -5.23814e+06           4
;; -4.25414e+06           3
;; -3.27021e+06           8
;; -2.28627e+06          20
;; -1.30234e+06         234
;;     -318400.      267691
;;      665536.         510
;;  1.64947e+06          84
;;  2.63341e+06          15
;;  3.61734e+06           8
;;  4.60128e+06           6
;;  5.58522e+06           5
;;  6.56915e+06           5
;;  7.55309e+06           2
;;  8.53702e+06           2
;;  9.52096e+06           1
;;  1.05049e+07           0
;;  1.14888e+07           3
;;  1.24728e+07           2
;;  1.34567e+07           3
;;  1.44406e+07           1
;;  1.54246e+07           1
;;  1.64085e+07           1
;;  1.73924e+07           1
;;  1.83764e+07           0
;;  1.93603e+07           0
;;  2.03443e+07           0
;;  2.13283e+07           0
;;  2.23122e+07           0
;;  2.32961e+07           1
;;  2.42801e+07           0
;;  2.52640e+07           0
;;  2.62479e+07           0
;;  2.72319e+07           0
;;  2.82158e+07           0
;;  2.91997e+07           0
;;  3.01837e+07           0
;;  3.11676e+07           2
;;  3.21516e+07           0
;;  3.31355e+07           0
;;  3.41194e+07           0
;;  3.51034e+07           1
;;...........................
;;  1.77774e+08           0
;;  1.78758e+08           0
;;  1.79742e+08           0
;;  1.80726e+08           0
cghistoplot,maximus.EFLUX_LOSSCONE_INTEG,locations=locs,omax=omax,omin=omin,histdata=hdata,mininput=-1e7,maxinput=1e7
print,n_elements(maximus.EFLUX_LOSSCONE_INTEG)
;; 269095
print,267691.0/269095.0
;; 0.994783
