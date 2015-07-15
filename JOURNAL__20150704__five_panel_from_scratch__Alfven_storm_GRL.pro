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
  OK=get_fa_orbit_times(14369,t1,t2)

  IF ~OK THEN BEGIN
     t1=str_to_time('2000-04-06/21:50:00')
     t2=str_to_time('2000-04-06/22:12:00')
  ENDIF 

  print,'TIMES :',time_to_str([t1,t2])

  dat = get_fa_ees(t1,/st)                     ; get electron esa survey
  ;; spec2d,dat,/label                       ; plot spectra
  ;; pitch2d,dat,/label,energy=[2000,10000]  ; plot pitch angle
  ;; contour2d,dat,/label,ncont=20           ; plot contour plot
  ;; dat = get_fa_ies(t1)                     ; get ion esa survey data
  ;; contour2d,dat,/label,ncont=20           ; plot contour plot
  ;; fu_spec2d,'n_2d_fs',dat,/integ_f,/integ_r ; plot partial density, partial integral densities  
  ;; Yank out relevant B plots

  ;; Yank out relevant Je, Jee plots
  ;; get_2dt,'j_2d_fs','fa_ees',name='Je',t1=t1,t2=t2,energy=[100,30000]
  ;; get_en_spec,'fa_ees',units='eflux',name='el',retrace=1,t1=t1,t2=t2
  ;; tplot,['Je','el']

  ;; get_2dt,'je_2d_fs','fa_ees',name='Jee',t1=t1,t2=t2,energy=[100,30000]
  ;; get_en_spec,'fa_ees',units='eflux',name='el',retrace=1,t1=t1,t2=t2
  ;; tplot,['Je','el']


  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
  ;; get_pa_spec,"fa_ies_c",units='eflux',name='ion_pa',energy=[30,30000],/shift90,t1=t1,t2=t2
  get_pa_spec_ts,"fa_ies",units='eflux',name='ion_pa',energy=[30,30000],/shift90,t1=t1,t2=t2
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
  
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; For getting s/c pot
  spacecraft_potential=get_fa_fields('V8_S',t1,t2)

  spin_period=4.946             ; seconds
  
  ;;get_sample_rate
  
  v8={x:spacecraft_potential.time,y:spacecraft_potential.comp1}
  
  v8_dt=abs(v8.x-shift(v8.x,-1))
  v8_dt(0)=v8_dt(1)
  v8_dt(n_elements(v8.x)-1)=v8_dt(n_elements(v8.x)-2)
  
  ;;get maxima within a 1 spin window
  j_range=where(v8.x LT v8.x(n_elements(v8.x)-1)-spin_period)
  index_max=max(j_range)
  print,index_max
  pot=make_array(n_elements(v8.x),/double)
  for j=0L,index_max do begin
     ;;spin_range=where(v8.x GE v8.x(j) and v8.x LE v8.x(j)+spin_period)
     spin_range=j+findgen(ceil(spin_period/V8_dt(j)))
     pot(j)=max(abs(v8.y(spin_range)),ind)
     sign=v8.y(spin_range(ind))/abs(v8.y(spin_range(ind)))
     pot(j)=sign*pot(j)
     ;;print,j,pot(j)
  endfor
  pot(index_max+1:n_elements(v8.x)-1)=pot(j_range(index_max))
  sc_pot={x:v8.x,y:pot}
  store_data,'S_Pot',data=sc_pot ;note this is actualy the negative of the sp. potential this corrected in the file output
  
  ;;Which angle depends on which hemisphere
  ;;For the orbit in question, 14369, the expansion I want to do is in the Southern hemi
  get_data,'ALT',data=alt
  loss_cone_alt=alt.y(0)*1000.0
  lcw=loss_cone_width(loss_cone_alt)*180.0/!DPI
  get_data,'ILAT',data=ilat
  north_south=abs(ilat.y(0))/ilat.y(0)
  
  if north_south EQ -1 then begin
     e_angle=[180.-lcw,180+lcw] ; for Southern Hemis.
     ;;i_angle=[270.0,90.0]	
     ;;elimnate ram from data
     i_angle=[180.0,360.0]
     i_angle_up=[270.0,360.0]
     
  endif else begin
     e_angle=[360.-lcw,lcw]     ;	for Northern Hemis.
     ;;i_angle=[90.,270.0]
     ;;eliminate ram from data
     i_angle=[0.0,180.0]
     i_angle_up=[90.0,180.0]
     
  endelse

  IF NOT KEYWORD_SET(energy_electrons) THEN energy_electrons=[0.,30000.] ;use 0.0 for lower bound since the sc_pot is used to set this
  IF NOT KEYWORD_SET(energy_ions) THEN energy_ions=[0.,500.]             ;use 0.0 for lower bound since the sc_pot is used to set this

  ;; Electron and ion fluxes from alfven_stats_5
  get_2dt_ts_pot,'je_2d_b','fa_ees',t1=t1,t2=t2,name='JEe_tot',energy=energy_electrons,sc_pot=sc_pot
  get_2dt_ts_pot,'je_2d_b','fa_ees',t1=t1,t2=t2,name='JEe',angle=e_angle,energy=energy_electrons,sc_pot=sc_pot
  get_2dt_ts_pot,'j_2d_b','fa_ees',t1=t1,t2=t2,name='Je',energy=energy_electrons,sc_pot=sc_pot
  get_2dt_ts_pot,'j_2d_b','fa_ees',t1=t1,t2=t2,name='Je_lc',energy=energy_electrons,angle=e_angle,sc_pot=sc_pot
  
  get_2dt_ts_pot,'je_2d_b','fa_ies',t1=t1,t2=t2,name='JEi',energy=energy_ions,angle=i_angle,sc_pot=sc_pot
  get_2dt_ts_pot,'j_2d_b','fa_ies',t1=t1,t2=t2,name='Ji',energy=energy_ions,angle=i_angle,sc_pot=sc_pot
  get_2dt_ts_pot,'je_2d_b','fa_ies',t1=t1,t2=t2,name='JEi_up',energy=energy_ions,angle=i_angle_up,sc_pot=sc_pot
  get_2dt_ts_pot,'j_2d_b','fa_ies',t1=t1,t2=t2,name='Ji_up',energy=energy_ions,angle=i_angle_up,sc_pot=sc_pot
  

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; want Je and Ji
  ylim,'Je',1.e7,1.e9,1 ; set y limits
  options,'Je','ytitle','Electrons!C!C1/(cm!U2!N-s)'                   ; set y title
  options,'Je','tplot_routine','pmplot'                                ; set 2 color plot
  options,'Je','labels',['Downgoing!C Electrons','Upgoing!C Electrons '] ; set color label
  options,'Je','labflag',3                                               ; set color label
  options,'Je','labpos',[4.e8,5.e7]                                      ; set color label
  options,'Je','panel_size',1                                            ; set panel size

  ylim,'Ji',1.e5,1.e8,1                                        ; set y limits
  options,'Ji','ytitle','Ions!C!C1/(cm!U2!N-s)'              ; set y title
  options,'Ji','tplot_routine','pmplot'                      ; set 2 color plot
  options,'Ji','labels',['Downgoing!C Ions','Upgoing!C Ions '] ; set color label
  options,'Ji','labflag',3                                     ; set color label
  options,'Ji','labpos',[2.e7,1.e6]                            ; set color label
  options,'Ji','panel_size',1                                  ; set panel size
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; and then the plots
  ;; loadct2,39
  ;; Plot the data
  DEVICE,decomposed=0
  loadct2,43
  ;; tplot,['el_0','el_pa','ion_pa','JEe','Je','Ji'],$
  tplot,['el_0','el_pa','ion_pa','Je','Ji'],$
        var_label=['ALT','ILAT','LSHELL','MLT'],title='FAST ORBIT '+orbit_num
  
END