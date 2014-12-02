;Tuesday, Dec 2, 2014: Added line at end so that saving the file is optional
pro rdf_dflux_fout,filename,dat,outname

;this pro reads file output from Alfven_stats_3.pro and stores it as a structure

fieldtypes=[3,7,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4]
fieldnames=['orbit','time','alt','mlt','ilat','mag_current','esa_current','elec_energy_flux','integ_elec_energy_flux','char_elec_energy','ion_energy_flux','ion_flux','ion_flux_up',$
                      'integ_ion_flux','integ_ion_flux_up','char_ion_energy','width_time','width_x','delta_B','delta_E','mode','sample_t','proton_flux_up','proton_energy_flux_up',$
                        'oxy_flux_up','oxy_energy_flux_up','helium_flux_up','helium_energy_flux_up','sc_pot']
fieldlocations=[5,10,39,52,65,78,89,103,117,130,139,151,165,178,190,208,221,234,247,260,271,286,298,312,325,342,350,364,376]
fieldgroups=[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28]
data_template={version:1.0,$
            datastart:36,$
            delimiter:' ',$
            missingvalue:!values.f_nan,$
            commentsymbol:';',$
            fieldcount:29,$
            fieldtypes:fieldtypes,$
            fieldnames:fieldnames,$
         fieldlocations:fieldlocations,$
            fieldgroups:fieldgroups}
dat=read_ascii(filename,template=data_template)
;now read the integrated results

openr,f_unit,filename,/get_lun
readf,f_unit,totrows,totcolumns
test=string(4444)
for j=0,28 do begin
    readf,f_unit,test
endfor
readf,f_unit,format='(A36,G16.6)',test,total_electron_energy_dflux
readf,f_unit,format='(A43,G16.6)',test,total_alfven_electron_energy_dflux
readf,f_unit,format='(A33,G16.6)',test,total_ion_outflow
readf,f_unit,format='(A40,G16.6)',test,total_alfven_ion_outflow
readf,f_unit,format='(A45,G16.6)',test,total_upward_ion_outflow
readf,f_unit,format='(A52,G16.6)',test,total_alfven_upward_ion_outflow
free_lun,f_unit
number=n_elements(dat.orbit)
total_electron_energy_dflux=make_array(number,value=total_electron_energy_dflux)
total_alfven_electron_energy_dflux=make_array(number,value=total_alfven_electron_energy_dflux)
total_ion_outflow=make_array(number,value=total_ion_outflow)
total_alfven_ion_outflow=make_array(number,value=total_alfven_ion_outflow)
total_upward_ion_outflow=make_array(number,value=total_upward_ion_outflow)
total_alfven_upward_ion_outflow=make_array(number,value=total_alfven_upward_ion_outflow)

dat_orbit_integrated={$
                 total_electron_energy_dflux:total_electron_energy_dflux,$
                 total_alfven_electron_energy_dflux:total_alfven_electron_energy_dflux,$
                 total_ion_outflow:total_ion_outflow,$
                 total_alfven_ion_outflow:total_alfven_ion_outflow,$
                 total_upward_ion_outflow:total_upward_ion_outflow,$
                 total_alfven_upward_ion_outflow:total_alfven_upward_ion_outflow}

dat=create_struct(dat,dat_orbit_integrated)

IF KEYWORD_SET(outname) THEN save, dat, filename=outname

return
end
  
