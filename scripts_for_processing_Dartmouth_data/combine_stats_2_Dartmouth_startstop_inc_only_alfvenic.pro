pro combine_stats_2_Dartmouth_startstop_inc_only_alfvenic,maximus
;2015/06/09
;This pro only sucks in Alfvenic events

;12/14/2014 
;This might not work as written; it still needs to be tested
  
  date='20150611'
  Dartmouth_DB='/SPENCEdata/software/sdt/batch_jobs/Alfven_study/as5_14F/batch_output/'
  contents_file='./orbits_contained_in_DartDBfile_' + date + '--startstops_included.txt'
  ;;  contents_file='./orbits_contained_in_DartDBfile_' + date + '--first5000--startstops_included.txt'
  ;; outfile='Dartdb_' + date + '--500-14999--maximus.sav'
  ;; outfile='Dartdb_' + date + '--10001-14999--maximus--only_below_aur_oval.sav'
  outfile='Dartdb_' + date + '--15000-16361--maximus--below_aur_oval.sav'

  ;; below_aur_ovalStr=''
  ;; below_aur_ovalStr='--only_below_aur_oval'
  below_aur_ovalStr='below_aur_oval'

  only_alfvenic=1

  ;open file to write list of orbits included
  OPENW,outlun,contents_file,/get_lun

  ;; min_orbit=500
  ;; max_orbit=15000
  ;; min_orbit=10001
  ;; max_orbit=14999
  min_orbit=15000
  max_orbit=16999

  for j=min_orbit,max_orbit do begin

;    filename='Dartmouth_as5_startstop_dflux'+'_'+strcompress(j,/remove_all)+'_0'
     filename='Dartmouth_as5_dflux'+'_'+strcompress(j,/remove_all)+'_0'+below_aur_ovalStr
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

                 IF only_alfvenic THEN alfvenic_i = WHERE(dat.alfvenic GT 0.5,/NULL) ELSE alfvenic_i = indgen(n_elements(dat.orbit))
                 IF n_elements(alfvenic_i) GT 0 THEN BEGIN
                    maximus={orbit:[maximus.orbit,dat.orbit(alfvenic_i)],$
                             alfvenic:[maximus.alfvenic,dat.alfvenic(alfvenic_i)],$
                             TIME:[maximus.time,dat.time(alfvenic_i)],$
                             ALT:[maximus.alt,dat.alt(alfvenic_i)],$
                             MLT:[maximus.mlt,dat.mlt(alfvenic_i)],$
                             ILAT:[maximus.ilat,dat.ilat(alfvenic_i)],$
                             MAG_CURRENT:[maximus.MAG_CURRENT,dat.MAG_CURRENT(alfvenic_i)],$
                             ESA_CURRENT:[maximus.ESA_CURRENT,dat.ESA_CURRENT(alfvenic_i)],$
                             ELEC_ENERGY_FLUX:[maximus.ELEC_ENERGY_FLUX,dat.ELEC_ENERGY_FLUX(alfvenic_i)],$
                             INTEG_ELEC_ENERGY_FLUX:[maximus.INTEG_ELEC_ENERGY_FLUX,dat.INTEG_ELEC_ENERGY_FLUX(alfvenic_i)],$
                             EFLUX_LOSSCONE_INTEG:[maximus.EFLUX_LOSSCONE_INTEG,dat.EFLUX_LOSSCONE_INTEG(alfvenic_i)],$
                             total_eflux_integ:[maximus.total_eflux_integ,dat.total_eflux_integ(alfvenic_i)],$
                             max_chare_losscone:[maximus.max_chare_losscone,dat.max_chare_losscone(alfvenic_i)],$
                             max_chare_total:[maximus.max_chare_total,dat.max_chare_total(alfvenic_i)],$
                             ION_ENERGY_FLUX:[maximus.ION_ENERGY_FLUX,dat.ION_ENERGY_FLUX(alfvenic_i)],$
                             ION_FLUX:[maximus.ION_FLUX,dat.ION_FLUX(alfvenic_i)],$
                             ION_FLUX_UP:[maximus.ION_FLUX_UP,dat.ION_FLUX_UP(alfvenic_i)],$
                             INTEG_ION_FLUX:[maximus.INTEG_ION_FLUX,dat.INTEG_ION_FLUX(alfvenic_i)],$
                             INTEG_ION_FLUX_UP:[maximus.INTEG_ION_FLUX_UP,dat.INTEG_ION_FLUX_UP(alfvenic_i)],$
                             CHAR_ION_ENERGY:[maximus.CHAR_ION_ENERGY,dat.CHAR_ION_ENERGY(alfvenic_i)],$
                             WIDTH_TIME:[maximus.WIDTH_TIME,dat.WIDTH_TIME(alfvenic_i)],$
                             WIDTH_X:[maximus.WIDTH_X,dat.WIDTH_X(alfvenic_i)],$
                             DELTA_B:[maximus.DELTA_B,dat.DELTA_B(alfvenic_i)],$
                             DELTA_E:[maximus.DELTA_E,dat.DELTA_E(alfvenic_i)],$
                             SAMPLE_T:[maximus.SAMPLE_T,dat.SAMPLE_T(alfvenic_i)],$
                             MODE:[maximus.MODE,dat.MODE(alfvenic_i)],$
                             PROTON_FLUX_UP:[maximus.PROTON_FLUX_UP,dat.PROTON_FLUX_UP(alfvenic_i)],$
                             PROTON_CHAR_ENERGY:[maximus.PROTON_CHAR_ENERGY,dat.PROTON_CHAR_ENERGY(alfvenic_i)],$
                             OXY_FLUX_UP:[maximus.OXY_FLUX_UP,dat.OXY_FLUX_UP(alfvenic_i)],$
                             OXY_CHAR_ENERGY:[maximus.OXY_CHAR_ENERGY,dat.OXY_CHAR_ENERGY(alfvenic_i)],$
                             HELIUM_FLUX_UP:[maximus.HELIUM_FLUX_UP,dat.HELIUM_FLUX_UP(alfvenic_i)],$
                             HELIUM_CHAR_ENERGY:[maximus.HELIUM_CHAR_ENERGY,dat.HELIUM_CHAR_ENERGY(alfvenic_i)],$
                             SC_POT:[maximus.SC_POT,dat.SC_POT(alfvenic_i)],$
                             L_PROBE:[maximus.L_PROBE,dat.L_PROBE(alfvenic_i)],$
                             MAX_L_PROBE:[maximus.MAX_L_PROBE,dat.MAX_L_PROBE(alfvenic_i)],$
                             MIN_L_PROBE:[maximus.MIN_L_PROBE,dat.MIN_L_PROBE(alfvenic_i)],$
                             MEDIAN_L_PROBE:[maximus.MEDIAN_L_PROBE,dat.MEDIAN_L_PROBE(alfvenic_i)],$
                             START_TIME:[maximus.START_TIME,dat.START_TIME(alfvenic_i)],$
                             STOP_TIME:[maximus.STOP_TIME,dat.STOP_TIME(alfvenic_i)],$
                             TOTAL_ELECTRON_ENERGY_DFLUX_SINGLE:[maximus.TOTAL_ELECTRON_ENERGY_DFLUX_SINGLE,dat.TOTAL_ELECTRON_ENERGY_DFLUX_SINGLE(alfvenic_i)],$
                             TOTAL_ELECTRON_ENERGY_DFLUX_MULTIPLE_TOT:[maximus.TOTAL_ELECTRON_ENERGY_DFLUX_MULTIPLE_TOT,dat.TOTAL_ELECTRON_ENERGY_DFLUX_MULTIPLE_TOT(alfvenic_i)],$
                             TOTAL_ALFVEN_ELECTRON_ENERGY_DFLUX:[maximus.TOTAL_ALFVEN_ELECTRON_ENERGY_DFLUX,dat.TOTAL_ALFVEN_ELECTRON_ENERGY_DFLUX(alfvenic_i)],$
                             TOTAL_ION_OUTFLOW_SINGLE:[maximus.TOTAL_ION_OUTFLOW_SINGLE,dat.TOTAL_ION_OUTFLOW_SINGLE(alfvenic_i)],$
                             TOTAL_ION_OUTFLOW_MULTIPLE_TOT:[maximus.TOTAL_ION_OUTFLOW_MULTIPLE_TOT,dat.TOTAL_ION_OUTFLOW_MULTIPLE_TOT(alfvenic_i)],$
                             TOTAL_ALFVEN_ION_OUTFLOW:[maximus.TOTAL_ALFVEN_ION_OUTFLOW,dat.TOTAL_ALFVEN_ION_OUTFLOW(alfvenic_i)],$
                             TOTAL_UPWARD_ION_OUTFLOW_SINGLE:[maximus.TOTAL_UPWARD_ION_OUTFLOW_SINGLE,dat.TOTAL_UPWARD_ION_OUTFLOW_SINGLE(alfvenic_i)],$
                             TOTAL_UPWARD_ION_OUTFLOW_MULTIPLE_TOT:[maximus.TOTAL_UPWARD_ION_OUTFLOW_MULTIPLE_TOT,dat.TOTAL_UPWARD_ION_OUTFLOW_MULTIPLE_TOT(alfvenic_i)],$
                             TOTAL_ALFVEN_UPWARD_ION_OUTFLOW:[maximus.TOTAL_ALFVEN_UPWARD_ION_OUTFLOW,dat.TOTAL_ALFVEN_UPWARD_ION_OUTFLOW(alfvenic_i)]}
                 ENDIF
                 endif else begin
                    maximus=dat
                 endelse
              endif
;           filename='Dartmouth_as5_startstop_dflux'+'_'+strcompress(j,/remove_all)+'_'+strcompress(jj+1,/remove_all)
;           filename='Dartmouth_as5_dflux'+'_'+strcompress(j,/remove_all)+'_'+strcompress(jj+1,/remove_all)
           filename='Dartmouth_as5_dflux'+'_'+strcompress(j,/remove_all)+'_'+strcompress(jj+1,/remove_all)+below_aur_ovalStr
;    filename='dflux'+'_startstop_'+strcompress(j,/remove_all)+'_'+strcompress(jj+1,/remove_all)
        endfor
     endif
  endfor

  save,maximus,filename=outfile

  return

end
