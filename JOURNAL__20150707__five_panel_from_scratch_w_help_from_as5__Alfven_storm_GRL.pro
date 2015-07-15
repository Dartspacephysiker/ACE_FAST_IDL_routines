;+
;2015/07/07 in Boulder
;
;-
PRO JOURNAL__20150707__bring_together_cdfs_for_five_panel_plot_w_help_from_as5__Alfven_storm_GRL

  ;; orbs=14369
  
  if not keyword_set(energy_electrons) then energy_electrons=[0.,30000.] ;use 0.0 for lower bound since the sc_pot is used to set this
  if not keyword_set(energy_ions) then energy_ions=[0.,500.]             ;use 0.0 for lower bound since the sc_pot is used to set this
  
  ;; If no data exists, return to main
  
  t=0
  dat = get_fa_ees(t,/st)
  if dat.valid eq 0 then begin
     print,' ERROR: No FAST electron survey data -- get_fa_ees(t,/st) returned invalid data'
     return
  endif
  
  
  
  ;; Electron current - line plot
  
  if keyword_set(burst) then begin
     get_2dt_ts,'j_2d_b','fa_eeb',t1=t1,t2=t2,name='Je',energy=energy_electrons
  endif else begin
     get_2dt_ts,'j_2d_b','fa_ees',t1=t1,t2=t2,name='Je',energy=energy_electrons
  endelse
  
  ;;remove spurious crap
  get_data,'Je',data=tmpj
  
  keep=where(finite(tmpj.y) NE 0)
  tmpj.x=tmpj.x(keep)
  tmpj.y=tmpj.y(keep)
  
  keep=where(abs(tmpj.y) GT 0.0)
  tx=tmpj.x(keep)
  ty=tmpj.y(keep)
  
  ;;get timescale monotonic
  
  time_order=sort(tx)
  tx=tx(time_order)
  ty=ty(time_order)
  
  
  ;;throw away the first 10  points since they are often corrupted
  if not keyword_set(burst) then begin
     store_data,'Je',data={x:tx(10:n_elements(tx)-1),y:ty(10:n_elements(tx)-1)}
  endif else begin
     store_data,'Je',data={x:tx,y:ty}
  endelse
  
  ;;eliminate data from latitudes below the Holzworth/Meng auroral oval 
  get_data,'Je',data=je
  get_fa_orbit,/time_array,je.x
  get_data,'MLT',data=mlt
  get_data,'ILAT',data=ilat
  keep=where(abs(ilat.y) GT auroral_zone(mlt.y,7,/lat)/(!DPI)*180.)
  
  store_data,'Je',data={x:je.x(keep),y:je.y(keep)}

  ;;Use the electron data to define the time ranges for this orbit	
  
  get_data,'Je',data=je
  part_res_je=make_array(n_elements(Je.x),/double)
  for j=1,n_elements(Je.x)-1 do begin
     part_res_je(j)=abs(Je.x(j)-Je.x(j-1))
  endfor
  part_res_Je(0)=part_res_Je(1)
  gap=where(part_res_je GT 10.0)
  if gap(0) NE -1 then begin
     separate_start=[0,where(part_res_je GT 10.0)]
     separate_stop=[where(part_res_je GT 10.0),n_elements(Je.x)-1]
  endif else begin
     separate_start=[0]
     separate_stop=[n_elements(Je.x)-1]
  endelse
	
  ;;remove esa burp when switched on
  if not keyword_set(burst) then begin
     turn_on=where(part_res_je GT 300.0)
     if turn_on(0) NE -1 then begin
        turn_on_separate=make_array(n_elements(turn_on),/double)
        for j=0,n_elements(turn_on)-1 do turn_on_separate(j)=where(separate_start EQ turn_on(j))
        separate_start(turn_on_separate+1)=separate_start(turn_on_separate+1)+5
     endif
  endif
  ;;identify time indices for each interval
  
  count=0.0
  for j=0,n_elements(separate_start)-1 do begin
     if (separate_stop(j)-separate_start(j)) GT 10 then begin
        count=count+1
        if count EQ 1.0 then begin
           time_range_indices=transpose([separate_start(j)+1,separate_stop(j)-1])
        endif else begin
           time_range_indices=[time_range_indices,transpose([separate_start(j),separate_stop(j)-1])]
        endelse
     endif
  endfor
  
  ;;identify interval times
  
  time_ranges=je.x(time_range_indices)
  number_of_intervals=n_elements(time_ranges(*,0))
  
  print,'number_of_intervals',number_of_intervals
  
  ;;loop over each time interval
  ji_tot=make_array(number_of_intervals,/double)
  ji_up_tot=make_array(number_of_intervals,/double)
  jee_tot=make_array(number_of_intervals,/double)
  Ji_tot_alf=make_array(number_of_intervals,/double)
  Ji_up_tot_alf=make_array(number_of_intervals,/double)
  Jee_tot_alf=make_array(number_of_intervals,/double)
  
  
  ;;get despun mag data if keyword set
  if keyword_set(ucla_mag_despin) then ucla_mag_despin
  
  
  ;;begin looping each interval
  ;; for jjj=0,number_of_intervals-1 do begin
  jjj=1
     t1=time_ranges(jjj,0)
     t2=time_ranges(jjj,1)
     print,'time_range',time_to_str(time_ranges(jjj,0)),time_to_str(time_ranges(jjj,1))
     
     je_tmp_time=je.x(time_range_indices(jjj,0):time_range_indices(jjj,1))
     je_tmp_data=je.y(time_range_indices(jjj,0):time_range_indices(jjj,1))
     
     store_data,'Je_tmp',data={x:je_tmp_time,y:je_tmp_data}
     
     ;;get fields quantities
     data_valid=1.0
     dat=get_fa_fields('MagDC',t,/start)
     if dat.valid eq 0 then begin
        print,' ERROR: No FAST mag data-get_fa_fields returned invalid data'
        data_valid=0.0
     endif else begin
        if not keyword_set(ucla_mag_despin) then field=get_fa_fields('MagDC',time_ranges(jjj,0),time_ranges(jjj,1),/store)
        dat=get_fa_fields('V5-V8_S',t,/start)
        if dat.valid eq 0 then begin
           print,' ERROR: No FAST V5-V8 data-get_fa_fields returned invalid data'
           data_valid=0.0
        endif else begin
           spacecraft_potential=get_fa_fields('V8_S',time_ranges(jjj,0),time_ranges(jjj,1))
           efieldV58=get_fa_fields('V5-V8_S',time_ranges(jjj,0),time_ranges(jjj,1))
           efieldV1214=get_fa_fields('V1-V2_S',time_ranges(jjj,0),time_ranges(jjj,1))
           if efieldV1214.valid eq 0 then begin
              print,'No V1-V2 data - trying V1-V4'
              efieldV1214=get_fa_fields('V1-V4_S',time_ranges(jjj,0),time_ranges(jjj,1))
              if efieldV1214.valid eq 0 then begin
                 print,' ERROR: No FAST fields data - get_fa_fields returned invalid data'
                 data_valid=0.0
              endif 
           endif 
        endelse

        Langmuir_2=get_fa_fields('NE2_S',time_ranges(jjj,0),time_ranges(jjj,1))
        Langmuir_6=get_fa_fields('NE6_S',time_ranges(jjj,0),time_ranges(jjj,1))
        Langmuir_9=get_fa_fields('NE9_S',time_ranges(jjj,0),time_ranges(jjj,1))
        Langmuir_data=[0]
        Langmuir_time=[0]
        Langmuir_prob=[0]
        if Langmuir_2.valid NE 0 then begin
           langmuir_data=[Langmuir_data,Langmuir_2.comp1]
           langmuir_time=[Langmuir_time,Langmuir_2.time]
           langmuir_prob=[Langmuir_prob,replicate(2,n_elements(Langmuir_2.time))]
        endif
        if Langmuir_6.valid NE 0 then begin
           langmuir_data=[Langmuir_data,Langmuir_6.comp1]
           langmuir_time=[Langmuir_time,Langmuir_6.time]
           langmuir_prob=[Langmuir_prob,replicate(6,n_elements(Langmuir_6.time))]
        endif
        if Langmuir_9.valid NE 0 then begin
           langmuir_data=[Langmuir_data,Langmuir_9.comp1]
           langmuir_time=[Langmuir_time,Langmuir_9.time]
           langmuir_prob=[Langmuir_prob,replicate(9,n_elements(Langmuir_9.time))]
        endif
        if n_elements(langmuir_data) GT 1 then  begin
           langmuir_time=langmuir_time(1:n_elements(Langmuir_time)-1)
           langmuir_data=langmuir_data(1:n_elements(Langmuir_time)-1)
           langmuir_prob=langmuir_prob(1:n_elements(Langmuir_time)-1)
           time_order_langmuir=sort(langmuir_time)
           langmuir={x:langmuir_time(time_order_langmuir),y:langmuir_data(time_order_langmuir)}
           dens_probe={x:langmuir_time(time_order_langmuir),y:langmuir_prob(time_order_langmuir)}
        endif else data_valid=0.0
     endelse	
     
     
     if data_valid NE 0.0 then begin
        
        ;;get E field and B field on same time scale
        
        
        FA_FIELDS_COMBINE,efieldV1214,efieldV58,result=efields_combine,/talk

        ;; efields_combine=combinets({x:efieldV1214.time,y:efieldV1214.comp1},{x:efieldV58.time,y:efieldV58.comp1})
        
        ;;get magnitude of electric and magnetic field
        
        ;; efield={x:efieldV1214.time,y:sqrt(efields_combine.comp1^2+efields_combine.comp2^2)}
        efield={x:efieldV1214.time,y:sqrt(efieldV1214.comp1^2+efields_combine^2)}
        if not keyword_set(ucla_mag_despin) then begin
           get_data,'MagDCcomp1',data=magx
           get_data,'MagDCcomp2',data=magy
           get_data,'MagDCcomp3',data=magz
        endif else begin
           get_data,'dB_fac_v',data=db_fac
           mintime=min(abs(time_ranges(jjj,0)-db_fac.x),ind1)
           mintime=min(abs(time_ranges(jjj,1)-db_fac.x),ind2)
           
           magx={x:db_fac.x(ind1:ind2),y:db_fac.y(ind1:ind2,0)}
           magy={x:db_fac.x(ind1:ind2),y:db_fac.y(ind1:ind2,2)}
           magz={x:db_fac.x(ind1:ind2),y:db_fac.y(ind1:ind2,1)}
        endelse
        
        store_data,'MagZ',data=magz
        ;;magz.y=smooth(magz.y,40)
        store_data,'Magz_smooth',data={x:magz.x,y:magz.y}
        if keyword_set(filterfreq) then begin
           
           magz=filter(magz,filterfreq,'magfilt','l')
           ;;remove end effects of the filter by cutting off the first/last 2s
           sf=magz.x(1)-magz.x(0)
           np=n_elements(magz.x)
           padding=round(2.0/sf)
           magz={x:magz.x(padding:np-padding),y:magz.y(padding:np-padding)}
           store_data,'MagZ',data=magz
        endif
        
        
        ;;get mag and efield data on same time scale
        magz={time:magz.x,comp1:magz.y,ncomp:1}
        efield={time:efield.x,comp1:efield.y}
        FA_FIELDS_COMBINE,magz,efield,result=fields,/interp,delt_t=50.,/talk
        fields={time:magz.time,comp1:magz.comp1,comp2:fields,ncomp:2}

        langmuir={time:langmuir.x,comp1:langmuir.y,ncomp:1}
        FA_FIELDS_COMBINE,magz,langmuir,result=dens,/talk
        dens={time:magz.time,comp1:magz.comp1,comp2:dens,ncomp:2}

        magz={x:magz.time,y:magz.comp1}
        langmuir={x:langmuir.time,y:langmuir.comp1}

        ;;get the prootn cyc frequency for smoothing the e field data later
        proton_cyc_freq=1.6e-19*sqrt(magx.y^2+magy.y^2+magz.y^2)*1.0e-9/1.67e-27/(2.*!DPI) ; in Hz
        
        ;;get_orbit data
        get_fa_orbit,je_tmp_time,/time_array,/all
        
        ;;define loss cone angle
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
           e_angle=[360.-lcw,lcw] ;	for Northern Hemis.
           ;;i_angle=[90.,270.0]
           ;;eliminate ram from data
           i_angle=[0.0,180.0]
           i_angle_up=[90.0,180.0]
           
        endelse
        
        
        ;;get fields mode
        
        fields_mode=get_fa_fields('DataHdr_1032',time_ranges(jjj,0),time_ranges(jjj,1))
        
        
        
        ;;get the spacecraft potential per spin
        
        spin_period=4.946       ; seconds
        
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
        
        
        
        
        
        if keyword_set(burst) then begin
           
           get_2dt_ts,'je_2d_b','fa_eeb',t1=time_ranges(jjj,0),t2=time_ranges(jjj,1),name='JEe_tot',energy=energy_electrons
           get_2dt_ts,'je_2d_b','fa_eeb',t1=time_ranges(jjj,0),t2=time_ranges(jjj,1),name='JEe',angle=e_angle,energy=energy_electrons
           get_2dt_ts,'j_2d_b','fa_eeb',t1=time_ranges(jjj,0),t2=time_ranges(jjj,1),name='Je',energy=energy_electrons
           get_2dt_ts,'j_2d_b','fa_eeb',t1=time_ranges(jjj,0),t2=time_ranges(jjj,1),name='Je_lc',energy=energy_electrons,angle=e_angle
           
           
           get_2dt_ts,'je_2d_b','fa_ieb',t1=time_ranges(jjj,0),t2=time_ranges(jjj,1),name='JEi',energy=energy_ions
           get_2dt_ts,'j_2d_b','fa_ieb',t1=time_ranges(jjj,0),t2=time_ranges(jjj,1),name='Ji',energy=energy_ions
           get_2dt_ts,'je_2d_b','fa_ieb',t1=time_ranges(jjj,0),t2=time_ranges(jjj,1),name='JEi_up',energy=energy_ions,angle=i_angle
           get_2dt_ts,'j_2d_b','fa_ieb',t1=time_ranges(jjj,0),t2=time_ranges(jjj,1),name='Ji_up',energy=energy_ions,angle=i_angle
           
        endif else begin
           
           get_2dt_ts_pot,'je_2d_b','fa_ees',t1=time_ranges(jjj,0),t2=time_ranges(jjj,1),name='JEe_tot',energy=energy_electrons,sc_pot=sc_pot
           get_2dt_ts_pot,'je_2d_b','fa_ees',t1=time_ranges(jjj,0),t2=time_ranges(jjj,1),name='JEe',angle=e_angle,energy=energy_electrons,sc_pot=sc_pot
           get_2dt_ts_pot,'j_2d_b','fa_ees',t1=time_ranges(jjj,0),t2=time_ranges(jjj,1),name='Je',energy=energy_electrons,sc_pot=sc_pot
           get_2dt_ts_pot,'j_2d_b','fa_ees',t1=time_ranges(jjj,0),t2=time_ranges(jjj,1),name='Je_lc',energy=energy_electrons,angle=e_angle,sc_pot=sc_pot
           
           
           get_2dt_ts_pot,'je_2d_b','fa_ies',t1=time_ranges(jjj,0),t2=time_ranges(jjj,1),name='JEi',energy=energy_ions,angle=i_angle,sc_pot=sc_pot
           get_2dt_ts_pot,'j_2d_b','fa_ies',t1=time_ranges(jjj,0),t2=time_ranges(jjj,1),name='Ji',energy=energy_ions,angle=i_angle,sc_pot=sc_pot
           get_2dt_ts_pot,'je_2d_b','fa_ies',t1=time_ranges(jjj,0),t2=time_ranges(jjj,1),name='JEi_up',energy=energy_ions,angle=i_angle_up,sc_pot=sc_pot
           get_2dt_ts_pot,'j_2d_b','fa_ies',t1=time_ranges(jjj,0),t2=time_ranges(jjj,1),name='Ji_up',energy=energy_ions,angle=i_angle_up,sc_pot=sc_pot
           
           
           
           if keyword_set(heavy) then begin
              
              get_2dt_pot,'je_2d','fa_tsp_eq',t1=time_ranges(jjj,0),t2=time_ranges(jjj,1),name='JEp_up',energy=energy_ions,angle=i_angle_up,sc_pot=sc_pot
              get_2dt_pot,'je_2d','fa_tso_eq',t1=time_ranges(jjj,0),t2=time_ranges(jjj,1),name='JEo_up',energy=energy_ions,angle=i_angle_up,sc_pot=sc_pot
              get_2dt_pot,'je_2d','fa_tsh_eq',t1=time_ranges(jjj,0),t2=time_ranges(jjj,1),name='JEh_up',energy=energy_ions,angle=i_angle_up,sc_pot=sc_pot
              
              get_2dt_pot,'j_2d','fa_tsp_eq',t1=time_ranges(jjj,0),t2=time_ranges(jjj,1),name='Jp_up',energy=energy_ions,angle=i_angle_up,sc_pot=sc_pot
              get_2dt_pot,'j_2d','fa_tso_eq',t1=time_ranges(jjj,0),t2=time_ranges(jjj,1),name='Jo_up',energy=energy_ions,angle=i_angle_up,sc_pot=sc_pot
              get_2dt_pot,'j_2d','fa_tsh_eq',t1=time_ranges(jjj,0),t2=time_ranges(jjj,1),name='Jh_up',energy=energy_ions,angle=i_angle_up,sc_pot=sc_pot
              
           endif
           
        endelse
        
        get_data,'Je',data=tmp
        get_data,'Ji',data=tmpi
        ;;remove crap
        keep1=where(finite(tmp.y) NE 0 and finite(tmpi.y) NE 0)
        tmp.x=tmp.x(keep1)
        tmp.y=tmp.y(keep1)
        keep2=where(abs(tmp.y) GT 0.0 and abs(tmpi.y) GT 0.0)
        je_tmp_time=tmp.x(keep2)
        je_tmp_data=tmp.y(keep2)
        store_data,'Je',data={x:je_tmp_time,y:je_tmp_data}
        
        get_data,'JEe',data=tmp
        ;;remove crap
        ;;keep=where(finite(tmp.y) NE 0)
        tmp.x=tmp.x(keep1)
        tmp.y=tmp.y(keep1)
        ;;keep=where(abs(tmp.y) GT 0.0)
        jee_tmp_time=tmp.x(keep2)
        jee_tmp_data=tmp.y(keep2)
        store_data,'JEe',data={x:jee_tmp_time,y:jee_tmp_data}
        
        get_data,'JEe_tot',data=tmp
        ;;remove crap
        ;;keep=where(finite(tmp.y) NE 0)
        tmp.x=tmp.x(keep1)
        tmp.y=tmp.y(keep1)
        ;;keep=where(abs(tmp.y) GT 0.0)
        jee_tot_tmp_time=tmp.x(keep2)
        jee_tot_tmp_data=tmp.y(keep2)
        store_data,'JEe_tot',data={x:jee_tot_tmp_time,y:jee_tot_tmp_data}
        
        get_data,'Je_lc',data=tmp
        ;;remove_crap
        ;;keep=where(finite(tmp.y) NE 0)
        tmp.x=tmp.x(keep1)
        tmp.y=tmp.y(keep1)
        ;;keep=where(abs(tmp.y) GT 0.0)
        je_lc_tmp_time=tmp.x(keep2)
        je_lc_tmp_data=tmp.y(keep2)
        store_data,'Je_lc',data={x:je_lc_tmp_time,y:je_lc_tmp_data}
        
        
        
        get_data,'Ji',data=tmp
        ;;remove crap	
        ;;keep1=where(finite(tmp.y) NE 0)
        tmp.x=tmp.x(keep1)
        tmp.y=tmp.y(keep1)
        ;;keep2=where(abs(tmp.y) GT 0.0)
        ji_tmp_time=tmp.x(keep2)
        ji_tmp_data=2.0*tmp.y(keep2) ;the 2.0 here is because of the 1/2 angular range I use to exclude ram ions
        store_data,'Ji',data={x:ji_tmp_time,y:ji_tmp_data}
        
        get_data,'JEi',data=tmp
        ;;remove crap
        ;;keep=where(finite(tmp.y) NE 0)
        tmp.x=tmp.x(keep1)
        tmp.y=tmp.y(keep1)
        ;;keep=where(abs(tmp.y) GT 0.0)
        jEi_tmp_time=tmp.x(keep2)
        jEi_tmp_data=tmp.y(keep2)
        store_data,'JEi',data={x:jEi_tmp_time,y:jEi_tmp_data}
        
        get_data,'JEi_up',data=tmp
        ;;remove crap
        ;;keep=where(finite(tmp.y) NE 0)
        tmp.x=tmp.x(keep1)
        tmp.y=tmp.y(keep1)
        ;;keep=where(abs(tmp.y) GT 0.0)
        jEi_up_tmp_time=tmp.x(keep2)
        jEi_up_tmp_data=tmp.y(keep2)
        store_data,'JEi_up',data={x:jEi_up_tmp_time,y:jEi_up_tmp_data}
        
        get_data,'Ji_up',data=tmp
        ;;remove crap
        ;;keep=where(finite(tmp.y) NE 0)
        tmp.x=tmp.x(keep1)
        tmp.y=tmp.y(keep1)
        ;;keep=where(abs(tmp.y) GT 0.0)
        ji_up_tmp_time=tmp.x(keep2)
        ji_up_tmp_data=2.0*tmp.y(keep2) ;the 2.0 here is because of the 1/2 angular range I use to exclude ram ions
        store_data,'Ji_up',data={x:ji_up_tmp_time,y:ji_up_tmp_data}
        
        
        if keyword_set(heavy) then begin
           
           get_data,'JEp_up',data=tmp
           ;;remove crap
           keep1=where(finite(tmp.y) NE 0)
           tmp.x=tmp.x(keep1)
           tmp.y=tmp.y(keep1)
           keep2=where(abs(tmp.y) GT 0.0)
           jEp_up_tmp_time=tmp.x(keep2)
           jEp_up_tmp_data=tmp.y(keep2)
           store_data,'JEp_up',data={x:jEp_up_tmp_time,y:jEp_up_tmp_data}
           
           get_data,'Jp_up',data=tmp
           ;;remove crap
           ;;keep=where(finite(tmp.y) NE 0)
           tmp.x=tmp.x(keep1)
           tmp.y=tmp.y(keep1)
           ;;keep=where(abs(tmp.y) GT 0.0)
           jp_up_tmp_time=tmp.x(keep2)
           jp_up_tmp_data=2.0*tmp.y(keep2) ;the 2.0 here is because of the 1/2 angular range I use to exclude ram ions
           store_data,'Jp_up',data={x:jp_up_tmp_time,y:jp_up_tmp_data}
           
           
           get_data,'JEo_up',data=tmp
           ;;remove crap
           ;;keep=where(finite(tmp.y) NE 0)
           tmp.x=tmp.x(keep1)
           tmp.y=tmp.y(keep1)
           ;;keep=where(abs(tmp.y) GT 0.0)
           jEo_up_tmp_time=tmp.x(keep2)
           jEo_up_tmp_data=tmp.y(keep2)
           store_data,'JEo_up',data={x:jEo_up_tmp_time,y:jEo_up_tmp_data}
           
           get_data,'Jo_up',data=tmp
           ;;remove crap
           ;;keep=where(finite(tmp.y) NE 0)
           tmp.x=tmp.x(keep1)
           tmp.y=tmp.y(keep1)
           ;;keep=where(abs(tmp.y) GT 0.0)
           jo_up_tmp_time=tmp.x(keep2)
           jo_up_tmp_data=2.0*tmp.y(keep2) ;the 2.0 here is because of the 1/2 angular range I use to exclude ram ions
           store_data,'Jo_up',data={x:jo_up_tmp_time,y:jo_up_tmp_data}
           
           
           get_data,'JEh_up',data=tmp
           ;;remove crap
           keep1=where(finite(tmp.y) NE 0)
           tmp.x=tmp.x(keep1)
           tmp.y=tmp.y(keep1)
           keep2=where(abs(tmp.y) GT 0.0)
           jEh_up_tmp_time=tmp.x(keep2)
           jEh_up_tmp_data=tmp.y(keep2)
           store_data,'JEh_up',data={x:jEh_up_tmp_time,y:jEh_up_tmp_data}
           
           get_data,'Jh_up',data=tmp
           ;;remove crap
           ;;keep=where(finite(tmp.y) NE 0)
           tmp.x=tmp.x(keep1)
           tmp.y=tmp.y(keep1)
           ;;keep=where(abs(tmp.y) GT 0.0)
           jh_up_tmp_time=tmp.x(keep2)
           jh_up_tmp_data=2.0*tmp.y(keep2) ;the 2.0 here is because of the 1/2 angular range I use to exclude ram ions
           store_data,'Jh_up',data={x:jh_up_tmp_time,y:jh_up_tmp_data}
           
        endif
        ;;get ion end electron characteristic energies
        
        chare=(jee_tmp_data/je_lc_tmp_data)*6.242*1.0e11
        chare_tot=(jee_tot_tmp_data/je_tmp_data)*6.242*1.0e11
        charei=(JEi_up_tmp_data/ji_up_tmp_data)*6.242*1.0e11
        store_data,'CharE',data={x:jee_tmp_time,y:chare}
        store_data,'CharE_tot',data={x:jee_tot_tmp_time,y:chare_tot}
        store_data,'CharEi',data={x:jei_up_tmp_time,y:charei}
        
        ;;get orbit number for filenames	
        get_data,'ORBIT',data=tmp
        orbit=tmp.y(0)
        orbit_num=strcompress(string(tmp.y(0)),/remove_all)
        
        ;;Scale electron energy flux to 100km, pos flux earthward
        get_data,'ILAT',data=tmp
        sgn_flx = tmp.y/abs(tmp.y)
        get_data,'B_model',data=tmp1
        get_data,'BFOOT',data=tmp2
        mag1 = (tmp1.y(*,0)*tmp1.y(*,0)+tmp1.y(*,1)*tmp1.y(*,1)+tmp1.y(*,2)*tmp1.y(*,2))^0.5
        mag2 = (tmp2.y(*,0)*tmp2.y(*,0)+tmp2.y(*,1)*tmp2.y(*,1)+tmp2.y(*,2)*tmp2.y(*,2))^0.5
        ratio = (mag2/mag1)
        jee_ionos_tmp_data = sgn_flx*jee_tmp_data*ratio
        store_data,'JEei',data={x:jee_tmp_time,y:jee_ionos_tmp_data}
        
        jee_tot_ionos_tmp_data=sgn_flx*jee_tot_tmp_data*ratio
        store_data,'JEei_tot',data={x:jee_tot_tmp_time,y:jee_tot_ionos_tmp_data}
        
        get_data,'fa_vel',data=vel
        speed=sqrt(vel.y(*,0)^2+vel.y(*,1)^2+vel.y(*,2)^2)*1000.0
        
        ;;get position of each mag point
        
        ;;samplingperiod=magz.x(300)-magz.x(299)
        ;;position=make_array(n_elements(magz.x),/double)
        ;;position=speed(300)*samplingperiod*findgen(n_elements(magz.x))
        ;;speed_mag_point=speed(300)

        old_pos=0.
        position=make_array(n_elements(magz.x),/double)
        speed_mag_point=make_array(n_elements(magz.x),/double)
        for j=0L,n_elements(magz.x)-2 do begin
           speed_point_ind=min(abs(vel.x-magz.x(j)),ind)
           ;;print,ind
           speed_mag_point(j)=speed(ind)
           samplingperiod=magz.x(j+1)-magz.x(j)
           ;;position=make_array(n_elements(magz.x),/double)
           position(j)=old_pos+speed_mag_point(j)*samplingperiod
           old_pos=position(j)
        endfor
        
        
        window,0,xsize=600,ysize=800
        loadct,39
        !p.charsize=1.3
        tplot,['Je','CharE','JEei','Ji','JEi','MagZ'] ,var_label=['ALT','MLT','ILAT'],trange=[time_ranges(jjj,0),time_ranges(jjj,1)]
        
        
     endif
  ;; ENDFOR

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; Electron spectrogram - survey data, remove retrace, downgoing electrons
  get_en_spec,"fa_ees_c",units='eflux',name='el_0',angle=e_angle,retrace=1,t1=t1,t2=t2,/calib
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