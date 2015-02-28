pro combine_stats_2_Dartmouth_startstop_inc,maximus
;12/14/2014 
;This might not work as written; it still needs to be tested
  
  date='02282015'
  Dartmouth_DB='/SPENCEdata/software/sdt/batch_jobs/Alfven_study/as5_14F/batch_output/'
  contents_file='./orbits_contained_in_DartDBfile_' + date + '--startstops_included.txt'
  ;;  contents_file='./orbits_contained_in_DartDBfile_' + date + '--first5000--startstops_included.txt'
  outfile='Dartdb_' + date + '--500-14999--maximus.sav'

;open file to write list of orbits included
  OPENW,outlun,contents_file,/get_lun

  min_orbit=500
  max_orbit=15000

  for j=min_orbit,max_orbit do begin

;    filename='Dartmouth_as5_startstop_dflux'+'_'+strcompress(j,/remove_all)+'_0'
     filename='Dartmouth_as5_dflux'+'_'+strcompress(j,/remove_all)+'_0'
                                ;filename='orb'+strcompress(j,/remove_all)+'_dflux'
     result=file_which(Dartmouth_DB,filename)
     if result then begin
        for jj=0,9 do begin
           result=file_which(Dartmouth_DB,filename)
           if result then begin
              print,j,jj
              printf,outlun,j,jj
              rdf_stats_dartmouth_as5_startstop_inc,result,dat
              if j GT min_orbit then begin
                 maximus={orbit:[maximus.orbit,dat.orbit],$
                          alfvenic:[maximus.alfvenic,dat.alfvenic],$
                          TIME:[maximus.time,dat.time],$
                          ALT:[maximus.alt,dat.alt],$
                          MLT:[maximus.mlt,dat.mlt],$
                          ILAT:[maximus.ilat,dat.ilat],$
                          MAG_CURRENT:[maximus.MAG_CURRENT,dat.MAG_CURRENT],$
                          ESA_CURRENT:[maximus.ESA_CURRENT,dat.ESA_CURRENT],$
                          ELEC_ENERGY_FLUX:[maximus.ELEC_ENERGY_FLUX,dat.ELEC_ENERGY_FLUX],$
                          INTEG_ELEC_ENERGY_FLUX:[maximus.INTEG_ELEC_ENERGY_FLUX,dat.INTEG_ELEC_ENERGY_FLUX],$
                          EFLUX_LOSSCONE_INTEG:[maximus.EFLUX_LOSSCONE_INTEG,dat.EFLUX_LOSSCONE_INTEG],$
                          total_eflux_integ:[maximus.total_eflux_integ,dat.total_eflux_integ],$
                          max_chare_losscone:[maximus.max_chare_losscone,dat.max_chare_losscone],$
                          max_chare_total:[maximus.max_chare_total,dat.max_chare_total],$
                          ION_ENERGY_FLUX:[maximus.ION_ENERGY_FLUX,dat.ION_ENERGY_FLUX],$
                          ION_FLUX:[maximus.ION_FLUX,dat.ION_FLUX],$
                          ION_FLUX_UP:[maximus.ION_FLUX_UP,dat.ION_FLUX_UP],$
                          INTEG_ION_FLUX:[maximus.INTEG_ION_FLUX,dat.INTEG_ION_FLUX],$
                          INTEG_ION_FLUX_UP:[maximus.INTEG_ION_FLUX_UP,dat.INTEG_ION_FLUX_UP],$
                          CHAR_ION_ENERGY:[maximus.CHAR_ION_ENERGY,dat.CHAR_ION_ENERGY],$
                          WIDTH_TIME:[maximus.WIDTH_TIME,dat.WIDTH_TIME],$
                          WIDTH_X:[maximus.WIDTH_X,dat.WIDTH_X],$
                          DELTA_B:[maximus.DELTA_B,dat.DELTA_B],$
                          DELTA_E:[maximus.DELTA_E,dat.DELTA_E],$
                          SAMPLE_T:[maximus.SAMPLE_T,dat.SAMPLE_T],$
                          MODE:[maximus.MODE,dat.MODE],$
                          PROTON_FLUX_UP:[maximus.PROTON_FLUX_UP,dat.PROTON_FLUX_UP],$
                          PROTON_CHAR_ENERGY:[maximus.PROTON_CHAR_ENERGY,dat.PROTON_CHAR_ENERGY],$
                          OXY_FLUX_UP:[maximus.OXY_FLUX_UP,dat.OXY_FLUX_UP],$
                          OXY_CHAR_ENERGY:[maximus.OXY_CHAR_ENERGY,dat.OXY_CHAR_ENERGY],$
                          HELIUM_FLUX_UP:[maximus.HELIUM_FLUX_UP,dat.HELIUM_FLUX_UP],$
                          HELIUM_CHAR_ENERGY:[maximus.HELIUM_CHAR_ENERGY,dat.HELIUM_CHAR_ENERGY],$
                          SC_POT:[maximus.SC_POT,dat.SC_POT],$
                          L_PROBE:[maximus.L_PROBE,dat.L_PROBE],$
                          MAX_L_PROBE:[maximus.MAX_L_PROBE,dat.MAX_L_PROBE],$
                          MIN_L_PROBE:[maximus.MIN_L_PROBE,dat.MIN_L_PROBE],$
                          MEDIAN_L_PROBE:[maximus.MEDIAN_L_PROBE,dat.MEDIAN_L_PROBE],$
                          START_TIME:[maximus.START_TIME,dat.START_TIME],$
                          STOP_TIME:[maximus.STOP_TIME,dat.STOP_TIME],$
                          TOTAL_ELECTRON_ENERGY_DFLUX_SINGLE:[maximus.TOTAL_ELECTRON_ENERGY_DFLUX_SINGLE,dat.TOTAL_ELECTRON_ENERGY_DFLUX_SINGLE],$
                          TOTAL_ELECTRON_ENERGY_DFLUX_MULTIPLE_TOT:[maximus.TOTAL_ELECTRON_ENERGY_DFLUX_MULTIPLE_TOT,dat.TOTAL_ELECTRON_ENERGY_DFLUX_MULTIPLE_TOT],$
                          TOTAL_ALFVEN_ELECTRON_ENERGY_DFLUX:[maximus.TOTAL_ALFVEN_ELECTRON_ENERGY_DFLUX,dat.TOTAL_ALFVEN_ELECTRON_ENERGY_DFLUX],$
                          TOTAL_ION_OUTFLOW_SINGLE:[maximus.TOTAL_ION_OUTFLOW_SINGLE,dat.TOTAL_ION_OUTFLOW_SINGLE],$
                          TOTAL_ION_OUTFLOW_MULTIPLE_TOT:[maximus.TOTAL_ION_OUTFLOW_MULTIPLE_TOT,dat.TOTAL_ION_OUTFLOW_MULTIPLE_TOT],$
                          TOTAL_ALFVEN_ION_OUTFLOW:[maximus.TOTAL_ALFVEN_ION_OUTFLOW,dat.TOTAL_ALFVEN_ION_OUTFLOW],$
                          TOTAL_UPWARD_ION_OUTFLOW_SINGLE:[maximus.TOTAL_UPWARD_ION_OUTFLOW_SINGLE,dat.TOTAL_UPWARD_ION_OUTFLOW_SINGLE],$
                          TOTAL_UPWARD_ION_OUTFLOW_MULTIPLE_TOT:[maximus.TOTAL_UPWARD_ION_OUTFLOW_MULTIPLE_TOT,dat.TOTAL_UPWARD_ION_OUTFLOW_MULTIPLE_TOT],$
                          TOTAL_ALFVEN_UPWARD_ION_OUTFLOW:[maximus.TOTAL_ALFVEN_UPWARD_ION_OUTFLOW,dat.TOTAL_ALFVEN_UPWARD_ION_OUTFLOW]}
              endif else begin
                 maximus=dat
              endelse
           endif
;           filename='Dartmouth_as5_startstop_dflux'+'_'+strcompress(j,/remove_all)+'_'+strcompress(jj+1,/remove_all)
           filename='Dartmouth_as5_dflux'+'_'+strcompress(j,/remove_all)+'_'+strcompress(jj+1,/remove_all)
;    filename='dflux'+'_startstop_'+strcompress(j,/remove_all)+'_'+strcompress(jj+1,/remove_all)
        endfor
     endif
  endfor

  save,maximus,filename=outfile

  return

end
