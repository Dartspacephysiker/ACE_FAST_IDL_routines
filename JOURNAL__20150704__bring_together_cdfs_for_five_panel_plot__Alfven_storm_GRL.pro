;+
;2015/07/04
;
;-
PRO JOURNAL__20150704__bring_together_cdfs_for_five_panel_plot__Alfven_storm_GRL

  orbs=14369

  LOAD_FA_K0_ORB,FILENAMES=orb_p+STRCOMPRESS(orbs[0],/REMOVE_ALL)+orb_s,DIR='/SPENCEdata/Research/Cusp/database/FAST_sum_cdfs__20000406-07/'
  LOAD_FA_K0_EES,FILENAMES=ees_p+STRCOMPRESS(orbs[0],/REMOVE_ALL)+ees_s,DIR='/SPENCEdata/Research/Cusp/database/FAST_sum_cdfs__20000406-07/'
  LOAD_FA_K0_IES,FILENAMES=ies_p+STRCOMPRESS(orbs[0],/REMOVE_ALL)+ies_s,DIR='/SPENCEdata/Research/Cusp/database/FAST_sum_cdfs__20000406-07/'
  LOAD_FA_K0_TMS,FILENAMES=tms_p+STRCOMPRESS(orbs[0],/REMOVE_ALL)+tms_s,DIR='/SPENCEdata/Research/Cusp/database/FAST_sum_cdfs__20000406-07/'
  LOAD_FA_K0_ACF,FILENAMES=acf_p+STRCOMPRESS(orbs[0],/REMOVE_ALL)+acf_s,DIR='/SPENCEdata/Research/Cusp/database/FAST_sum_cdfs__20000406-07/'
  LOAD_FA_K0_DCF,FILENAMES=dcf_p+STRCOMPRESS(orbs[0],/REMOVE_ALL)+dcf_s,DIR='/SPENCEdata/Research/Cusp/database/FAST_sum_cdfs__20000406-07/'
     
  ;; Yank out relevant B plots

  ;; Make L-shell data
  get_data,'ILAT',data=ilat
  lShell={x:ilat.x,y:(cos(ilat.y*!PI/180.))^(-2),yTitle:"L-shell"}
  store_data,'LSHELL',data={x:ilat.x,y:(cos(ilat.y*!PI/180.))^(-2),yTitle:"L-shell"}

  get_data,'ORBIT',data=tmp
  ntmp=n_elements(tmp.y)
  if ntmp gt 5 then begin
     orb=tmp.y(5)
     orbit_num=strcompress(string(orb),/remove_all)
     if ntmp gt 11 and orb ne tmp.y(ntmp-5) then begin
        orbit_num=orbit_num+'-'+strcompress(string(tmp.y(ntmp-5)),/remove_all)
     endif
  endif else begin
     orb=tmp.y(ntmp-1)
     orbit_num=strcompress(string(orb),/remove_all)
  endelse
  
  loadct2,39

  tplot,['el_0','el_90','el_180','el_low','el_high','JEe','Je'] $
        ,var_label=['MLT','ALT','ILAT','LSHELL'],title='FAST Electrons  Orbit '+orbit_num
  
  
END