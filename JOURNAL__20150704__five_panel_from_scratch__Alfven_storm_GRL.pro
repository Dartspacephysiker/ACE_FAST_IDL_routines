;+
;2015/07/04
;
;-
PRO JOURNAL__20150704__bring_together_cdfs_for_five_panel_plot__Alfven_storm_GRL

  ;; orbs=14369

  ;; LOAD_FA_K0_ORB,FILENAMES=orb_p+STRCOMPRESS(orbs[0],/REMOVE_ALL)+orb_s,DIR='/SPENCEdata/Research/Cusp/database/FAST_sum_cdfs__20000406-07/'
  ;; LOAD_FA_K0_EES,FILENAMES=ees_p+STRCOMPRESS(orbs[0],/REMOVE_ALL)+ees_s,DIR='/SPENCEdata/Research/Cusp/database/FAST_sum_cdfs__20000406-07/'
  ;; LOAD_FA_K0_IES,FILENAMES=ies_p+STRCOMPRESS(orbs[0],/REMOVE_ALL)+ies_s,DIR='/SPENCEdata/Research/Cusp/database/FAST_sum_cdfs__20000406-07/'
  ;; LOAD_FA_K0_TMS,FILENAMES=tms_p+STRCOMPRESS(orbs[0],/REMOVE_ALL)+tms_s,DIR='/SPENCEdata/Research/Cusp/database/FAST_sum_cdfs__20000406-07/'
  ;; LOAD_FA_K0_ACF,FILENAMES=acf_p+STRCOMPRESS(orbs[0],/REMOVE_ALL)+acf_s,DIR='/SPENCEdata/Research/Cusp/database/FAST_sum_cdfs__20000406-07/'
  ;; LOAD_FA_K0_DCF,FILENAMES=dcf_p+STRCOMPRESS(orbs[0],/REMOVE_ALL)+dcf_s,DIR='/SPENCEdata/Research/Cusp/database/FAST_sum_cdfs__20000406-07/'
     
;In Yao et al. [2008], Figure 2 has seven panels from orbit 16166 (with BG correction):
;!!!!!;  ) Electron energy          (eV)     [1e1,1e4], bar* [1e5,1e9]



;!!!!!;  ) Electron angle (4-300eV)   (deg)    [-90,270], bar* [1e5,1e9]
;  ) H&He++ energy            (eV)     [1e1,1e4], bar* [1e3.5,1e7.5]
;  ) O+ energy                (eV)     [1e1,1e4], bar* [1e3.5,1e7.5]
;!!!!!;  ) Ion angle (>80eV)        (deg)    [-90,270], bar* [1e3.5,1e7.5]
;  ) ESA Background           (cnts/s) [0,250]
;  ) Pressure_ion (eV/cm^3)            [1e2,1e6]
;    -->P_H+ (blue)
;    -->P_O+ (red)
;  UT
;  ALT
;  ILAT
;  MLT
;  LSHELL
;  "Hours from 2000-09-18/04:30:00"

  @startup

  ;; time range of interest
  ;; t1=str_to_time('2000-04-06/21:53:38')
  ;; t2=str_to_time('2000-04-06/22:11:16')
  t1=str_to_time('2000-04-06/21:50:00')
  t2=str_to_time('2000-04-06/22:12:00')

  ;; Yank out relevant B plots

  ;; Yank out relevant Je, Jee plots
  ;; get_2dt,'j_2d_fs','fa_ees',name='Je',t1=t1,t2=t2,energy=[100,30000]
  ;; get_en_spec,'fa_ees',units='eflux',name='el',retrace=1,t1=t1,t2=t2
  ;; tplot,['Je','el']

  ;; get_2dt,'je_2d_fs','fa_ees',name='Jee',t1=t1,t2=t2,energy=[100,30000]
  ;; get_en_spec,'fa_ees',units='eflux',name='el',retrace=1,t1=t1,t2=t2
  ;; tplot,['Je','el']


  ;; Electron spectrogram - survey data, remove retrace, downgoing electrons
  get_en_spec,"fa_ees_c",units='eflux',name='el_0',angle=[-22.5,22.5],retrace=1,t1=t1,t2=t2,/calib
  get_data,'el_0', data=tmp                                          ; get data structure
  tmp.y = tmp.y>1.e1                                                 ; Remove zerostmp.y = alog10(tmp.y) ; Pre-log
  store_data,'el_0', data=tmp                                        ; store data structure
  options,'el_0','spec',1                                            ; set for spectrogram
  zlim,'el_0',6,9,0                                                  ; set z limits
  ylim,'el_0',4,40000,1                                              ; set y limits
  options,'el_0','ytitle','e- downgoing !C!CEnergy (eV)'             ; y title
  options,'el_0','ztitle','Log Eflux!C!CeV/cm!U2!N-s-sr-eV'          ; z title
  options,'el_0','x_no_interp',1                                     ; don't interpolate
  options,'el_0','y_no_interp',1                                     ; don't interpolate
  options,'el_0','yticks',3                                          ; set y-axis labels
  options,'el_0','ytickname',['10!A1!N','10!A2!N','10!A3!N','10!A4!N'] ; set y-axis labels
  options,'el_0','ytickv',[10,100,1000,10000]                          ; set y-axis labels
  options,'el_0','panel_size',2                                        ; set panel size
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Get electron, ion pitch-angle spectra
  ;;Electron pitch angle spectrogram - survey data, remove retrace, >=4–300-eV electrons
  ;; get_pa_spec,"fa_ees_c",units='eflux',name='el_pa',energy=[4,300],retrace=1,/shift90,t1=t1,t2=t2,/calib
  get_pa_spec,"fa_ees_c",units='eflux',name='el_pa',energy=[100,30000],/shift90,t1=t1,t2=t2,/calib
  get_data,'el_pa', data=tmp                               ; get data structure
  tmp.y = tmp.y>1.e1                                       ; Remove zeros
  tmp.y = alog10(tmp.y)                                    ; Pre-log
  store_data,'el_pa', data=tmp                             ; store data structure
  options,'el_pa','spec',1                                 ; set for spectrogram
  zlim,'el_pa',6,9,0                                       ; set z limits
  ylim,'el_pa',-100,280,0                                  ; set y limits
  options,'el_pa','ytitle','e- 4-300 eV!C!C Pitch Angle'    ; y title
  options,'el_pa','ztitle','Log Eflux!C!CeV/cm!U2!N-s-sr-eV' ; z title
  options,'el_pa','x_no_interp',1                            ; don't interpolate
  options,'el_pa','y_no_interp',1                            ; don't interpolate
  options,'el_pa','yticks',4                                 ; set y-axis labels
  options,'el_pa','ytickname',['-90','0','90','180','270']   ; set y-axis labels
  options,'el_pa','ytickv',[-90,0,90,180,270]                ; set y-axis labels
  options,'el_pa','panel_size',2                             ; set panel size
  
  ;; Ion pitch angle spectrogram - survey data, remove retrace, >30 ions
  ;; get_pa_spec,"fa_ies_c",units='eflux',name='ion_pa',energy=[30,30000],retrace=1,/shift90,t1=t1,t2=t2
  get_pa_spec,"fa_ies_c",units='eflux',name='ion_pa',energy=[30,30000],/shift90,t1=t1,t2=t2
  get_data,'ion_pa',data=tmp                                ; get data structure
  tmp.y=tmp.y > 1.                                          ; Remove zeros
  tmp.y = alog10(tmp.y)                                     ; Pre-log
  store_data,'ion_pa',data=tmp                              ; store data structure
  options,'ion_pa','spec',1                                 ; set for spectrogram
  zlim,'ion_pa',5,7,0                                       ; set z limits
  ylim,'ion_pa',-100,280,0                                  ; set y limits
  options,'ion_pa','ytitle','i+ >30 eV!C!C Pitch Angle'     ; y title
; options,'ion_pa','ztitle','Log Eflux!C!CeV/cm!U2!N-s-sr-eV' ; z title
  options,'ion_pa','x_no_interp',1                          ; don't interpolate
  options,'ion_pa','y_no_interp',1                          ; don't interpolate
  options,'ion_pa','yticks',4                               ; set y-axis labels
  options,'ion_pa','ytickname',['-90','0','90','180','270'] ; set y-axis labels
  options,'ion_pa','ytickv',[-90,0,90,180,270]              ; set y-axis labels
  options,'ion_pa','panel_size',2                           ; set panel size
  
  ;;get orbit data
  get_data,'ion_pa',data=tmp_pa
  get_fa_orbit,tmp_pa.x,/time_array,/all

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
  
  ;; loadct2,39
  ;; Plot the data
  DEVICE,decomposed=0
  loadct2,43
  ;; tplot,['el_0','el_pa','ion_pa','JEe','Je','Ji'],$
  tplot,['el_0','el_pa','ion_pa'],$
        var_label=['ALT','ILAT','LSHELL','MLT'],title='FAST ORBIT '+orbit_num
  
END