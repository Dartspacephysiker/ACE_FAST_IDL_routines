;Tuesday, Dec 2, 2014: Added line at end so that saving the file is optional
;Ha! It should be ready now...
;Saturday, Oct 17: This thing is not ready at all. I haven't changed anything as of yet to
;reflect the format of files outputted by Alfven_Stats_5
pro rdf_stats_dartmouth_as5,filename,dat,outname
;  printf,unit1,'total electron dflux at ionosphere from single integ.',Jee_tot(jjj)
;  printf,unit1,'total electron dflux at ionosphere from total of intervals',total(current_intervals(*,7))
;  printf,unit1,'total Alfven electron dflux at ionosphere',total(current_intervals(keep,7))
;  printf,unit1,'total ion outflow at ionosphere from single integ',Ji_tot(jjj)
;  printf,unit1,'total ion outflow at ionosphere from total of intervals',total(current_intervals(*,12))
;  printf,unit1,'total Alfven ion outflow at ionosphere',total(current_intervals(keep,12))
;  printf,unit1,'total upward only ion outflow at ionosphere from single integ.',Ji_up_tot(jjj)
;  printf,unit1,'total upward only ion outflow at ionosphere from total of intervals',total(current_intervals(*,13))
;  printf,unit1,'total Alfven upward only ion outflow at ionosphere',total(current_intervals(keep,13))

;this pro reads file output from Alfven_stats_5.pro and stores it as a structure

fieldtypes=[2,4,7,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,7,7,7]
fieldnames=['orbit','alfvenic','time','alt','mlt','ilat','MAG_CURRENT','ESA_CURRENT','ELEC_ENERGY_FLUX','INTEG_ELEC_ENERGY_FLUX','eflux_losscone_integ','total_eflux_integ','max_chare_losscone',$
  'max_chare_total','ION_ENERGY_FLUX','ION_FLUX','ION_FLUX_UP','INTEG_ION_FLUX','INTEG_ION_FLUX_UP','CHAR_ION_ENERGY','WIDTH_TIME','WIDTH_X','DELTA_B','DELTA_E','SAMPLE_T','MODE',$
  'PROTON_FLUX_UP','PROTON_CHAR_ENERGY','OXY_FLUX_UP','OXY_CHAR_ENERGY','HELIUM_FLUX_UP','HELIUM_CHAR_ENERGY','SC_POT','L_PROBE','MAX_L_PROBE','MIN_L_PROBE','MEDIAN_L_PROBE']
fieldlocations=[4,15,23,52,65,78,90,103,117,130,143,156,169,182,191,207,217,230,242,260,271,286,298,312,322,338,351,364,377,390,403,416,428,442,0,19,43]
fieldgroups=[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36]
data_template={version:1.0,$
            datastart:48,$
            delimiter:' ',$
            missingvalue:!values.f_nan,$
            commentsymbol:';',$
            fieldcount:[34,3],$
            fieldtypes:fieldtypes,$
            fieldnames:fieldnames,$
         fieldlocations:fieldlocations,$
            fieldgroups:fieldgroups}

;for testing
;restore,'rdf_as5_ascii_template.sav'
;dat=read_ascii(filename,template=tmplt)

dat=read_ascii(filename,template=data_template)

;now read the integrated results

openr,f_unit,filename,/get_lun
readf,f_unit,totrows,totcolumns
test=string(4444)
for j=0,36 do begin
    readf,f_unit,test
endfor
readf,f_unit,format='(A55,G16.6)',test,TOTAL_ELECTRON_ENERGY_DFLUX_SINGLE
readf,f_unit,format='(A60,G16.6)',test,TOTAL_ELECTRON_ENERGY_DFLUX_MULTIPLE_TOT
readf,f_unit,format='(A43,G16.6)',test,TOTAL_ALFVEN_ELECTRON_ENERGY_DFLUX
readf,f_unit,format='(A51,G16.6)',test,TOTAL_ION_OUTFLOW_SINGLE
readf,f_unit,format='(A57,G16.6)',test,TOTAL_ION_OUTFLOW_MULTIPLE_TOT
readf,f_unit,format='(A40,G16.6)',test,TOTAL_ALFVEN_ION_OUTFLOW
readf,f_unit,format='(A64,G16.6)',test,TOTAL_UPWARD_ION_OUTFLOW_SINGLE
;Had to kludge a chunk of code; for some reason Alfven_Stats_5 writes an uninvited newline character here and
;messes up the reading of TOTAL_UPWARD_ION_OUTFLOW_MULTIPLE_TOT from the dflux file
;readf,f_unit,format='(A69,G16.6)',test,TOTAL_UPWARD_ION_OUTFLOW_MULTIPLE_TOT
;print,test,"TOTAL_UPWARD_ION_OUTFLOW_MULTIPLE_TOT",string(TOTAL_UPWARD_ION_OUTFLOW_MULTIPLE_TOT)
readf,f_unit,format='(A69)',test
readf,f_unit,format='(A2,G16.6)',test,TOTAL_UPWARD_ION_OUTFLOW_MULTIPLE_TOT
readf,f_unit,format='(A52,G16.6)',test,TOTAL_ALFVEN_UPWARD_ION_OUTFLOW

IF diagnostic NE !NULL THEN BEGIN
  print,"TOTAL_ELECTRON_ENERGY_DFLUX_SINGLE",string(TOTAL_ELECTRON_ENERGY_DFLUX_SINGLE)
  print,"TOTAL_ELECTRON_ENERGY_DFLUX_MULTIPLE_TOT: ", string(TOTAL_ELECTRON_ENERGY_DFLUX_MULTIPLE_TOT)
  print,"TOTAL_ION_OUTFLOW_SINGLE",string(TOTAL_ION_OUTFLOW_SINGLE)
  print,"TOTAL_ALFVEN_ELECTRON_ENERGY_DFLUX: ", string(TOTAL_ALFVEN_ELECTRON_ENERGY_DFLUX)
  print,"TOTAL_ION_OUTFLOW_MULTIPLE_TOT",string(TOTAL_ION_OUTFLOW_MULTIPLE_TOT)
  print,"TOTAL_ALFVEN_ION_OUTFLOW",string(TOTAL_ALFVEN_ION_OUTFLOW)
  print,"TOTAL_UPWARD_ION_OUTFLOW_SINGLE",string(TOTAL_UPWARD_ION_OUTFLOW_SINGLE)
  print,"TOTAL_UPWARD_ION_OUTFLOW_MULTIPLE_TOT: ",string(TOTAL_UPWARD_ION_OUTFLOW_MULTIPLE_TOT)
  ;print,test
  print,"TOTAL_ALFVEN_UPWARD_ION_OUTFLOW",string(TOTAL_ALFVEN_UPWARD_ION_OUTFLOW)
ENDIF

free_lun,f_unit
number=n_elements(dat.orbit)
TOTAL_ELECTRON_ENERGY_DFLUX_SINGLE=make_array(number,value=TOTAL_ELECTRON_ENERGY_DFLUX_SINGLE)
TOTAL_ELECTRON_ENERGY_DFLUX_MULTIPLE_TOT=make_array(number,value=TOTAL_ELECTRON_ENERGY_DFLUX_MULTIPLE_TOT)
TOTAL_ALFVEN_ELECTRON_ENERGY_DFLUX=make_array(number,value=TOTAL_ALFVEN_ELECTRON_ENERGY_DFLUX)
TOTAL_ION_OUTFLOW_SINGLE=make_array(number,value=TOTAL_ION_OUTFLOW_SINGLE)
TOTAL_ION_OUTFLOW_MULTIPLE_TOT=make_array(number,value=TOTAL_ION_OUTFLOW_MULTIPLE_TOT)
TOTAL_ALFVEN_ION_OUTFLOW=make_array(number,value=TOTAL_ALFVEN_ION_OUTFLOW)
TOTAL_UPWARD_ION_OUTFLOW_SINGLE=make_array(number,value=TOTAL_UPWARD_ION_OUTFLOW_SINGLE)
TOTAL_UPWARD_ION_OUTFLOW_MULTIPLE_TOT=make_array(number,value=TOTAL_UPWARD_ION_OUTFLOW_MULTIPLE_TOT)
TOTAL_ALFVEN_UPWARD_ION_OUTFLOW=make_array(number,value=TOTAL_ALFVEN_UPWARD_ION_OUTFLOW)

dat_orbit_integrated={$
                 TOTAL_ELECTRON_ENERGY_DFLUX_SINGLE:TOTAL_ELECTRON_ENERGY_DFLUX_SINGLE,$
                 TOTAL_ELECTRON_ENERGY_DFLUX_MULTIPLE_TOT:TOTAL_ELECTRON_ENERGY_DFLUX_MULTIPLE_TOT,$
                 TOTAL_ALFVEN_ELECTRON_ENERGY_DFLUX:TOTAL_ALFVEN_ELECTRON_ENERGY_DFLUX,$
                 TOTAL_ION_OUTFLOW_SINGLE:TOTAL_ION_OUTFLOW_SINGLE,$
                 TOTAL_ION_OUTFLOW_MULTIPLE_TOT:TOTAL_ION_OUTFLOW_MULTIPLE_TOT,$
                 TOTAL_ALFVEN_ION_OUTFLOW:TOTAL_ALFVEN_ION_OUTFLOW,$
                 TOTAL_UPWARD_ION_OUTFLOW_SINGLE:TOTAL_UPWARD_ION_OUTFLOW_SINGLE,$
                 TOTAL_UPWARD_ION_OUTFLOW_MULTIPLE_TOT:TOTAL_UPWARD_ION_OUTFLOW_MULTIPLE_TOT,$
                 TOTAL_ALFVEN_UPWARD_ION_OUTFLOW:TOTAL_ALFVEN_UPWARD_ION_OUTFLOW}

dat=create_struct(dat,dat_orbit_integrated)

IF KEYWORD_SET(outname) THEN save, dat, filename=outname

return
end
  
