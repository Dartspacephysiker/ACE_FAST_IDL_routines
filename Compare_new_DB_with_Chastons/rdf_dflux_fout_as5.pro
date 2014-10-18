;Saturday, Oct 17: This thing is not ready at all. I haven't changed anything as of yet to
;reflect the format of files outputted by Alfven_Stats_5
pro rdf_dflux_fout_as5,filename,dat,outname
;  printf,unit1,'total electron dflux at ionosphere from single integ.',Jee_tot(jjj)
;  printf,unit1,'total electron dflux at ionosphere from total of intervals',total(current_intervals(*,7))
;  printf,unit1,'total Alfven electron dflux at ionosphere',total(current_intervals(keep,7))
;  printf,unit1,'total ion outflow at ionosphere from single integ',Ji_tot(jjj)
;  printf,unit1,'total ion outflow at ionosphere from total of intervals',total(current_intervals(*,12))
;  printf,unit1,'total Alfven ion outflow at ionosphere',total(current_intervals(keep,12))
;  printf,unit1,'total upward only ion outflow at ionosphere from single integ.',Ji_up_tot(jjj)
;  printf,unit1,'total upward only ion outflow at ionosphere from total of intervals',total(current_intervals(*,13))
;  printf,unit1,'total Alfven upward only ion outflow at ionosphere',total(current_intervals(keep,13))

;this pro reads file output from Alfven_stats_3.pro and stores it as a structure

fieldtypes=[2,4,7,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,7,7,7]
fieldnames=['orbit','alfvenic','time','alt','mlt','ilat','mag_current','esa_current','eflux_losscone_max','total_eflux_max','eflux_losscone_integ','total_eflux_integ','max_chare_losscone',$
  'max_chare_total','max_ie max_ion_flux','max_upgoing_ionflux','integ_ionf','integ_upgoing_ionf','max_chare','width_t','width_spatial','db','de','fields_samp_period','fields_mode',$
  'max_hf_up','max_h_chare','max_of_up','max_o_chare','max_hef_up','max_he_chare','sc_pot','lp_num','max_lp_current','min_lp_current','median_lp_current']
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
dat=read_ascii(filename,template=data_template)
;now read the integrated results

openr,f_unit,filename,/get_lun
readf,f_unit,totrows,totcolumns
test=string(4444)
for j=0,36 do begin
    readf,f_unit,test
endfor
readf,f_unit,format='(A55,G16.6)',test,total_electron_energy_dflux_single_interval
readf,f_unit,format='(A60,G16.6)',test,total_electron_energy_dflux_all_intervals
readf,f_unit,format='(A43,G16.6)',test,total_alfven_electron_energy_dflux
readf,f_unit,format='(A51,G16.6)',test,total_ion_outflow_single_interval
readf,f_unit,format='(A57,G16.6)',test,total_ion_outflow_all_intervals
readf,f_unit,format='(A40,G16.6)',test,total_alfven_ion_outflow
readf,f_unit,format='(A64,G16.6)',test,total_upward_ion_outflow_single_interval
readf,f_unit,format='(A69,G16.6)',test,total_upward_ion_outflow_all_intervals
readf,f_unit,format='(A52,G16.6)',test,total_alfven_upward_ion_outflow
free_lun,f_unit
number=n_elements(dat.orbit)
total_electron_energy_dflux_single_interval=make_array(number,value=total_electron_energy_dflux_single_interval)
total_electron_energy_dflux_all_intervals=make_array(number,value=total_electron_energy_dflux_all_intervals)
total_alfven_electron_energy_dflux=make_array(number,value=total_alfven_electron_energy_dflux)
total_ion_outflow_single_interval=make_array(number,value=total_ion_outflow_single_interval)
total_ion_outflow_all_intervals=make_array(number,value=total_ion_outflow_all_intervals)
total_alfven_ion_outflow=make_array(number,value=total_alfven_ion_outflow)
total_upward_ion_outflow_single_interval=make_array(number,value=total_upward_ion_outflow_single_interval)
total_upward_ion_outflow_all_intervals=make_array(number,value=total_upward_ion_outflow_all_intervals)
total_alfven_upward_ion_outflow=make_array(number,value=total_alfven_upward_ion_outflow)

dat_orbit_integrated={$
                 total_electron_energy_dflux_single_interval:total_electron_energy_dflux_single_interval,$
                 total_electron_energy_dflux_all_intervals:total_electron_energy_dflux_all_intervals,$
                 total_alfven_electron_energy_dflux:total_alfven_electron_energy_dflux,$
                 total_ion_outflow_single_interval:total_ion_outflow_single_interval,$
                 total_ion_outflow_all_intervals:total_ion_outflow_all_intervals,$
                 total_alfven_ion_outflow:total_alfven_ion_outflow,$
                 total_upward_ion_outflow_single_interval:total_upward_ion_outflow_single_interval,$
                 total_upward_ion_outflow_all_intervals:total_upward_ion_outflow_all_intervals,$
                 total_alfven_upward_ion_outflow:total_alfven_upward_ion_outflow}

dat=create_struct(dat,dat_orbit_integrated)

save, dat, filename=outname

return
end
  
