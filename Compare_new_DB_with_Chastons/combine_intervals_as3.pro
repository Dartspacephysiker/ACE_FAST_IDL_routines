pro combine_intervals_as3,basename,maximus
  
  
  
  for j=0,20 do begin
     
     filename=basename+'_'+strcompress(j,/remove_all)
     ;filename='orb'+strcompress(j,/remove_all)+'_dflux'
     result=file_which('c:/FAST/stats',filename)
     if result then begin
        for jj=0,20 do begin
           result=file_which('c:/FAST/stats',filename)
           if result then begin
              print,"Interval " + strcompress(jj)
              rdf_stats_1,result,dat
              if j GT 1000 then begin
                 maximus={orbit:[maximus.orbit,dat.orbit],$
                          TIME:[maximus.time,dat.time],$
                          ALT:[maximus.alt,dat.alt],$
                          MLT:[maximus.mlt,dat.mlt],$
                          ILAT:[maximus.ilat,dat.ilat],$
                          MAG_CURRENT:[maximus.MAG_CURRENT,dat.MAG_CURRENT],$
                          ESA_CURRENT:[maximus.ESA_CURRENT,dat.ESA_CURRENT],$
                          ELEC_ENERGY_FLUX:[maximus.ELEC_ENERGY_FLUX,dat.ELEC_ENERGY_FLUX],$
                          INTEG_ELEC_ENERGY_FLUX:[maximus.INTEG_ELEC_ENERGY_FLUX,dat.INTEG_ELEC_ENERGY_FLUX],$
                          CHAR_ELEC_ENERGY:[maximus.CHAR_ELEC_ENERGY,dat.CHAR_ELEC_ENERGY],$
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
                          MODE:[maximus.MODE,dat.MODE],$
                          SAMPLE_T:[maximus.SAMPLE_T,dat.SAMPLE_T],$
                          PROTON_FLUX_UP:[maximus.PROTON_FLUX_UP,dat.PROTON_FLUX_UP],$
                          PROTON_ENERGY_FLUX_UP:[maximus.PROTON_ENERGY_FLUX_UP,dat.PROTON_ENERGY_FLUX_UP],$
                          OXY_FLUX_UP:[maximus.OXY_FLUX_UP,dat.OXY_FLUX_UP],$
                          OXY_ENERGY_FLUX_UP:[maximus.OXY_ENERGY_FLUX_UP,dat.OXY_ENERGY_FLUX_UP],$
                          HELIUM_FLUX_UP:[maximus.HELIUM_FLUX_UP,dat.HELIUM_FLUX_UP],$
                          HELIUM_ENERGY_FLUX_UP:[maximus.HELIUM_ENERGY_FLUX_UP,dat.HELIUM_ENERGY_FLUX_UP],$
                          SC_POT:[maximus.SC_POT,dat.SC_POT],$
                          TOTAL_ELECTRON_ENERGY_DFLUX:[maximus.TOTAL_ELECTRON_ENERGY_DFLUX,dat.TOTAL_ELECTRON_ENERGY_DFLUX],$
                          TOTAL_ALFVEN_ELECTRON_ENERGY_DFLUX:[maximus.TOTAL_ALFVEN_ELECTRON_ENERGY_DFLUX,dat.TOTAL_ALFVEN_ELECTRON_ENERGY_DFLUX],$
                          TOTAL_ION_OUTFLOW:[maximus.TOTAL_ION_OUTFLOW,dat.TOTAL_ION_OUTFLOW],$
                          TOTAL_ALFVEN_ION_OUTFLOW:[maximus.TOTAL_ALFVEN_ION_OUTFLOW,dat.TOTAL_ALFVEN_ION_OUTFLOW],$
                          TOTAL_UPWARD_ION_OUTFLOW:[maximus.TOTAL_UPWARD_ION_OUTFLOW,dat.TOTAL_UPWARD_ION_OUTFLOW],$
                          TOTAL_ALFVEN_UPWARD_ION_OUTFLOW:[maximus.TOTAL_ALFVEN_UPWARD_ION_OUTFLOW,dat.TOTAL_ALFVEN_UPWARD_ION_OUTFLOW]}
              endif else begin
                 maximus=dat
              endelse
           endif
           filename=basename+'_'+strcompress(j,/remove_all)
           filename='dflux'+'_'+strcompress(orbit,/remove_all)+'_'+strcompress(jj+1,/remove_all)
        endfor
     endif
  endfor
  return
end
