pro combine_intervals_as5,basename,dat,datadir=datadir,suffix=suffix,outname=outname

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
  if result then begin
     print,"Combining all intervals starting with file '" + datadir + filename + "'..."
     rdf_dflux_fout_as5,result,curr_dat
     dat=curr_dat 
     for j=1,20 do begin
        filename=basename+'_'+strcompress(string(j)+suffix,/remove_all)
        result=file_which(datadir,filename)
        if result then begin
           print,"Interval " + strcompress(j)
           maxj = j
           rdf_dflux_fout_as5,result,curr_dat
           dat={orbit:[dat.orbit,curr_dat.orbit],$
                ALFVENIC:[dat.alfvenic,curr_dat.alfvenic],$
                TIME:[dat.time,curr_dat.time],$
                ALT:[dat.alt,curr_dat.alt],$
                MLT:[dat.mlt,curr_dat.mlt],$
                ILAT:[dat.ilat,curr_dat.ilat],$
                MAG_CURRENT:[dat.MAG_CURRENT,curr_dat.MAG_CURRENT],$
                ESA_CURRENT:[dat.ESA_CURRENT,curr_dat.ESA_CURRENT],$
                EFLUX_LOSSCONE_MAX:[dat.EFLUX_LOSSCONE_MAX,curr_dat.EFLUX_LOSSCONE_MAX],$
                TOTAL_EFLUX_MAX:[dat.TOTAL_EFLUX_MAX,curr_dat.TOTAL_EFLUX_MAX],$
                EFLUX_LOSSCONE_INTEG:[dat.EFLUX_LOSSCONE_INTEG,curr_dat.EFLUX_LOSSCONE_INTEG],$
                TOTAL_EFLUX_INTEG:[dat.TOTAL_EFLUX_INTEG,curr_dat.TOTAL_EFLUX_INTEG],$
                MAX_CHARE_LOSSCONE:[dat.MAX_CHARE_LOSSCONE,curr_dat.MAX_CHARE_LOSSCONE],$
                MAX_CHARE_TOTAL:[dat.MAX_CHARE_TOTAL,curr_dat.MAX_CHARE_TOTAL],$
                MAX_IE:[dat.MAX_IE,curr_dat.MAX_IE],$
                MAX_ION_FLUX:[dat.MAX_ION_FLUX,curr_dat.MAX_ION_FLUX],$
                MAX_UPGOING_IONFLUX:[dat.MAX_UPGOING_IONFLUX,curr_dat.MAX_UPGOING_IONFLUX],$
                INTEG_IONF:[dat.INTEG_IONF,curr_dat.INTEG_IONF],$
                INTEG_UPGOING_IONF:[dat.INTEG_UPGOING_IONF,curr_dat.INTEG_UPGOING_IONF],$
                MAX_CHAR_IE:[dat.MAX_CHAR_IE,curr_dat.MAX_CHAR_IE],$
                WIDTH_T:[dat.WIDTH_T,curr_dat.WIDTH_T],$
                WIDTH_spatial:[dat.WIDTH_spatial,curr_dat.WIDTH_spatial],$
                DB:[dat.DB,curr_dat.DB],$
                DE:[dat.DE,curr_dat.DE],$
                FIELDS_SAMP_PERIOD:[dat.FIELDS_SAMP_PERIOD,curr_dat.FIELDS_SAMP_PERIOD],$
                FIELDS_MODE:[dat.FIELDS_MODE,curr_dat.FIELDS_MODE],$
                MAX_HF_UP:[dat.MAX_HF_UP,curr_dat.MAX_HF_UP],$
                MAX_H_CHARE:[dat.MAX_H_CHARE,curr_dat.MAX_H_CHARE],$
                MAX_OF_UP:[dat.MAX_OF_UP,curr_dat.MAX_OF_UP],$
                MAX_O_CHARE:[dat.MAX_O_CHARE,curr_dat.MAX_O_CHARE],$
                MAX_HEF_UP:[dat.MAX_HEF_UP,curr_dat.MAX_HEF_UP],$
                MAX_HE_CHARE:[dat.MAX_HE_CHARE,curr_dat.MAX_HE_CHARE],$
                SC_POT:[dat.SC_POT,curr_dat.SC_POT],$
                LP_NUM:[dat.LP_NUM,curr_dat.LP_NUM],$
                MAX_LP_CURRENT:[dat.MAX_LP_CURRENT,curr_dat.MAX_LP_CURRENT],$
                MIN_LP_CURRENT:[dat.MIN_LP_CURRENT,curr_dat.MIN_LP_CURRENT],$
                MEDIAN_LP_CURRENT:[dat.MEDIAN_LP_CURRENT,curr_dat.MEDIAN_LP_CURRENT],$
                TOTAL_ELECTRON_ENERGY_DFLUX_SINGLE_INTERVAL:[dat.TOTAL_ELECTRON_ENERGY_DFLUX_SINGLE_INTERVAL,curr_dat.TOTAL_ELECTRON_ENERGY_DFLUX_SINGLE_INTERVAL],$
                TOTAL_ELECTRON_ENERGY_DFLUX_ALL_INTERVALS:[dat.TOTAL_ELECTRON_ENERGY_DFLUX_ALL_INTERVALS,curr_dat.TOTAL_ELECTRON_ENERGY_DFLUX_ALL_INTERVALS],$
                TOTAL_ALFVEN_ELECTRON_ENERGY_DFLUX:[dat.TOTAL_ALFVEN_ELECTRON_ENERGY_DFLUX,curr_dat.TOTAL_ALFVEN_ELECTRON_ENERGY_DFLUX],$
                TOTAL_ION_OUTFLOW_SINGLE_INTERVAL:[dat.TOTAL_ION_OUTFLOW_SINGLE_INTERVAL,curr_dat.TOTAL_ION_OUTFLOW_SINGLE_INTERVAL],$
                TOTAL_ION_OUTFLOW_ALL_INTERVALS:[dat.TOTAL_ION_OUTFLOW_ALL_INTERVALS,curr_dat.TOTAL_ION_OUTFLOW_ALL_INTERVALS],$
                TOTAL_ALFVEN_ION_OUTFLOW:[dat.TOTAL_ALFVEN_ION_OUTFLOW,curr_dat.TOTAL_ALFVEN_ION_OUTFLOW],$
                TOTAL_UPWARD_ION_OUTFLOW_SINGLE_INTERVAL:[dat.TOTAL_UPWARD_ION_OUTFLOW_SINGLE_INTERVAL,curr_dat.TOTAL_UPWARD_ION_OUTFLOW_SINGLE_INTERVAL]}
        endif else break 
     endfor
     print,"Combined up to interval " + strcompress(maxj,/remove_all)
  endif else begin
     print,"Couldn't find interval 0: '" + datadir + basename + '_0' + suffix + "'!"
  endelse
  
  if keyword_set(outname) then begin
     save, dat,filename=outname
  endif

  return
end
