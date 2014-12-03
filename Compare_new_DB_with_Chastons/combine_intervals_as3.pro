pro combine_intervals_as3,basename,dat,datadir=datadir,suffix=suffix,outname=outname
  
  IF NOT KEYWORD_SET(datadir) THEN BEGIN
     drive='SPENCEdata2'
     ;datadir='/'+drive+'/Research/Cusp/ACE_FAST/Compare_new_DB_with_Chastons/'
     datadir='/'+drive+'/software/sdt/batch_jobs/Alfven_study/as5_14F/batch_output'
  ENDIF
  
  IF NOT KEYWORD_SET(suffix) THEN BEGIN
     suffix="_burst"
     ;  suffix=""
  ENDIF

  filename=basename+'_0' + suffix
  print,"Filename: " + filename
  result=file_which(datadir,filename)
  print,"Combining all intervals starting with file '" + datadir + filename + "'..."
  if result then begin
     for jj=0,20 do begin
        result=file_which(datadir,filename)
        if result then begin
           print,"Interval " + strcompress(jj)
           maxj = j
           rdf_dflux_fout,result,dat
           if j GT 0 then begin
              dat={orbit:[dat.orbit,curr_dat.orbit],$
                       TIME:[dat.time,curr_dat.time],$
                       ALT:[dat.alt,curr_dat.alt],$
                       MLT:[dat.mlt,curr_dat.mlt],$
                       ILAT:[dat.ilat,curr_dat.ilat],$
                       MAG_CURRENT:[dat.MAG_CURRENT,curr_dat.MAG_CURRENT],$
                       ESA_CURRENT:[dat.ESA_CURRENT,curr_dat.ESA_CURRENT],$
                       ELEC_ENERGY_FLUX:[dat.ELEC_ENERGY_FLUX,curr_dat.ELEC_ENERGY_FLUX],$
                       INTEG_ELEC_ENERGY_FLUX:[dat.INTEG_ELEC_ENERGY_FLUX,curr_dat.INTEG_ELEC_ENERGY_FLUX],$
                       CHAR_ELEC_ENERGY:[dat.CHAR_ELEC_ENERGY,curr_dat.CHAR_ELEC_ENERGY],$
                       ION_ENERGY_FLUX:[dat.ION_ENERGY_FLUX,curr_dat.ION_ENERGY_FLUX],$
                       ION_FLUX:[dat.ION_FLUX,curr_dat.ION_FLUX],$
                       ION_FLUX_UP:[dat.ION_FLUX_UP,curr_dat.ION_FLUX_UP],$
                       INTEG_ION_FLUX:[dat.INTEG_ION_FLUX,curr_dat.INTEG_ION_FLUX],$
                       INTEG_ION_FLUX_UP:[dat.INTEG_ION_FLUX_UP,curr_dat.INTEG_ION_FLUX_UP],$
                       CHAR_ION_ENERGY:[dat.CHAR_ION_ENERGY,curr_dat.CHAR_ION_ENERGY],$
                       WIDTH_TIME:[dat.WIDTH_TIME,curr_dat.WIDTH_TIME],$
                       WIDTH_X:[dat.WIDTH_X,curr_dat.WIDTH_X],$
                       DELTA_B:[dat.DELTA_B,curr_dat.DELTA_B],$
                       DELTA_E:[dat.DELTA_E,curr_dat.DELTA_E],$
                       MODE:[dat.MODE,curr_dat.MODE],$
                       SAMPLE_T:[dat.SAMPLE_T,curr_dat.SAMPLE_T],$
                       PROTON_FLUX_UP:[dat.PROTON_FLUX_UP,curr_dat.PROTON_FLUX_UP],$
                       PROTON_ENERGY_FLUX_UP:[dat.PROTON_ENERGY_FLUX_UP,curr_dat.PROTON_ENERGY_FLUX_UP],$
                       OXY_FLUX_UP:[dat.OXY_FLUX_UP,curr_dat.OXY_FLUX_UP],$
                       OXY_ENERGY_FLUX_UP:[dat.OXY_ENERGY_FLUX_UP,curr_dat.OXY_ENERGY_FLUX_UP],$
                       HELIUM_FLUX_UP:[dat.HELIUM_FLUX_UP,curr_dat.HELIUM_FLUX_UP],$
                       HELIUM_ENERGY_FLUX_UP:[dat.HELIUM_ENERGY_FLUX_UP,curr_dat.HELIUM_ENERGY_FLUX_UP],$
                       SC_POT:[dat.SC_POT,curr_dat.SC_POT],$
                       TOTAL_ELECTRON_ENERGY_DFLUX:[dat.TOTAL_ELECTRON_ENERGY_DFLUX,curr_dat.TOTAL_ELECTRON_ENERGY_DFLUX],$
                       TOTAL_ALFVEN_ELECTRON_ENERGY_DFLUX:[dat.TOTAL_ALFVEN_ELECTRON_ENERGY_DFLUX,curr_dat.TOTAL_ALFVEN_ELECTRON_ENERGY_DFLUX],$
                       TOTAL_ION_OUTFLOW:[dat.TOTAL_ION_OUTFLOW,curr_dat.TOTAL_ION_OUTFLOW],$
                       TOTAL_ALFVEN_ION_OUTFLOW:[dat.TOTAL_ALFVEN_ION_OUTFLOW,curr_dat.TOTAL_ALFVEN_ION_OUTFLOW],$
                       TOTAL_UPWARD_ION_OUTFLOW:[dat.TOTAL_UPWARD_ION_OUTFLOW,curr_dat.TOTAL_UPWARD_ION_OUTFLOW],$
                       TOTAL_ALFVEN_UPWARD_ION_OUTFLOW:[dat.TOTAL_ALFVEN_UPWARD_ION_OUTFLOW,curr_dat.TOTAL_ALFVEN_UPWARD_ION_OUTFLOW]}
           endif else begin
              dat=curr_dat
           endelse
        endif
        filename=basename+'_'+strcompress(string(j)+suffix,/remove_all)
     endfor
  endif else begin
     print,"Couldn't find interval 0: '" + datadir + basename + '_0' + suffix + "'!"
  endelse

  print,"Combined up to interval " + strcompress(maxj,/remove_all)
  
  if keyword_set(outname) then begin
     save, dat,filename=outname
  endif

  return
end
