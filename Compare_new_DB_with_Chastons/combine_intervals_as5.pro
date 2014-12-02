pro combine_intervals_as5,basename,maximus,datadir=datadir,suffix=suffix

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
     for j=0,20 do begin
        result=file_which(datadir,filename)
        if result then begin
           print,"Interval " + strcompress(j)
           rdf_dflux_fout_as5,result,dat
           if j GT 0 then begin
              maximus={orbit:[maximus.orbit,dat.orbit],$
                       ALFVENIC:[maximus.alfvenic,dat.alfvenic],$
                       TIME:[maximus.time,dat.time],$
                       ALT:[maximus.alt,dat.alt],$
                       MLT:[maximus.mlt,dat.mlt],$
                       ILAT:[maximus.ilat,dat.ilat],$
                       MAG_CURRENT:[maximus.MAG_CURRENT,dat.MAG_CURRENT],$
                       ESA_CURRENT:[maximus.ESA_CURRENT,dat.ESA_CURRENT],$
                       EFLUX_LOSSCONE_MAX:[maximus.EFLUX_LOSSCONE_MAX,dat.EFLUX_LOSSCONE_MAX],$
                       TOTAL_EFLUX_MAX:[maximus.TOTAL_EFLUX_MAX,dat.TOTAL_EFLUX_MAX],$
                       EFLUX_LOSSCONE_INTEG:[maximus.EFLUX_LOSSCONE_INTEG,dat.EFLUX_LOSSCONE_INTEG],$
                       TOTAL_EFLUX_INTEG:[maximus.TOTAL_EFLUX_INTEG,dat.TOTAL_EFLUX_INTEG],$
                       MAX_CHARE_LOSSCONE:[maximus.MAX_CHARE_LOSSCONE,dat.MAX_CHARE_LOSSCONE],$
                       MAX_CHARE_TOTAL:[maximus.MAX_CHARE_TOTAL,dat.MAX_CHARE_TOTAL],$
                       MAX_IE:[maximus.MAX_IE,dat.MAX_IE],$
                       MAX_ION_FLUX:[maximus.MAX_ION_FLUX,dat.MAX_ION_FLUX],$
                       MAX_UPGOING_IONFLUX:[maximus.MAX_UPGOING_IONFLUX,dat.MAX_UPGOING_IONFLUX],$
                       INTEG_IONF:[maximus.INTEG_IONF,dat.INTEG_IONF],$
                       INTEG_UPGOING_IONF:[maximus.INTEG_UPGOING_IONF,dat.INTEG_UPGOING_IONF],$
                       MAX_CHAR_IE:[maximus.MAX_CHAR_IE,dat.MAX_CHAR_IE],$
                       WIDTH_T:[maximus.WIDTH_T,dat.WIDTH_T],$
                       WIDTH_spatial:[maximus.WIDTH_spatial,dat.WIDTH_spatial],$
                       DB:[maximus.DB,dat.DB],$
                       DE:[maximus.DE,dat.DE],$
                       FIELDS_SAMP_PERIOD:[maximus.FIELDS_SAMP_PERIOD,dat.FIELDS_SAMP_PERIOD],$
                       FIELDS_MODE:[maximus.FIELDS_MODE,dat.FIELDS_MODE],$
                       MAX_HF_UP:[maximus.MAX_HF_UP,dat.MAX_HF_UP],$
                       MAX_H_CHARE:[maximus.MAX_H_CHARE,dat.MAX_H_CHARE],$
                       MAX_OF_UP:[maximus.MAX_OF_UP,dat.MAX_OF_UP],$
                       MAX_O_CHARE:[maximus.MAX_O_CHARE,dat.MAX_O_CHARE],$
                       MAX_HEF_UP:[maximus.MAX_HEF_UP,dat.MAX_HEF_UP],$
                       MAX_HE_CHARE:[maximus.MAX_HE_CHARE,dat.MAX_HE_CHARE],$
                       SC_POT:[maximus.SC_POT,dat.SC_POT],$
                       LP_NUM:[maximus.LP_NUM,dat.LP_NUM],$
                       MAX_LP_CURRENT:[maximus.MAX_LP_CURRENT,dat.MAX_LP_CURRENT],$
                       MIN_LP_CURRENT:[maximus.MIN_LP_CURRENT,dat.MIN_LP_CURRENT],$
                       MEDIAN_LP_CURRENT:[maximus.MEDIAN_LP_CURRENT,dat.MEDIAN_LP_CURRENT],$
                       TOTAL_ELECTRON_ENERGY_DFLUX_SINGLE_INTERVAL:[maximus.TOTAL_ELECTRON_ENERGY_DFLUX_SINGLE_INTERVAL,dat.TOTAL_ELECTRON_ENERGY_DFLUX_SINGLE_INTERVAL],$
                       TOTAL_ELECTRON_ENERGY_DFLUX_ALL_INTERVALS:[maximus.TOTAL_ELECTRON_ENERGY_DFLUX_ALL_INTERVALS,dat.TOTAL_ELECTRON_ENERGY_DFLUX_ALL_INTERVALS],$
                       TOTAL_ALFVEN_ELECTRON_ENERGY_DFLUX:[maximus.TOTAL_ALFVEN_ELECTRON_ENERGY_DFLUX,dat.TOTAL_ALFVEN_ELECTRON_ENERGY_DFLUX],$
                       TOTAL_ION_OUTFLOW_SINGLE_INTERVAL:[maximus.TOTAL_ION_OUTFLOW_SINGLE_INTERVAL,dat.TOTAL_ION_OUTFLOW_SINGLE_INTERVAL],$
                       TOTAL_ION_OUTFLOW_ALL_INTERVALS:[maximus.TOTAL_ION_OUTFLOW_ALL_INTERVALS,dat.TOTAL_ION_OUTFLOW_ALL_INTERVALS],$
                       TOTAL_ALFVEN_ION_OUTFLOW:[maximus.TOTAL_ALFVEN_ION_OUTFLOW,dat.TOTAL_ALFVEN_ION_OUTFLOW],$
                       TOTAL_UPWARD_ION_OUTFLOW_SINGLE_INTERVAL:[maximus.TOTAL_UPWARD_ION_OUTFLOW_SINGLE_INTERVAL,dat.TOTAL_UPWARD_ION_OUTFLOW_SINGLE_INTERVAL]}
                      endif else begin
                 maximus=dat 
              endelse
           endif
        filename=basename+'_'+strcompress(string(j)+suffix,/remove_all)
     endfor
  endif else begin
     print,"Couldn't find interval 0: '" + datadir + basename + '_0' + suffix + "'!"
  endelse
  return
end
