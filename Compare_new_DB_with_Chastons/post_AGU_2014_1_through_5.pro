;12/25/2014--Christmas Day
;My gift to myself is a few hours of work, since this stuff is eating
;me up and I'm stoked to move forward.
;Because this routine makes use of _ref_extra, you can pass it a
;'binsize' argument

;FOR TOMORROW
;1. Generate electron flux, Poynting flux histos for all orbits we showed to Chaston at AGU (DONE as of 12/25/2014)
;2. Almost inevitably there will be some garbage events--Determine what makes them garbage, write down the numbers, then find out if these values are orders of magnitude above what is ever expected in the cusp or observed in general
;(I should know order-of-magnitude values for flux, integrated and otherwise)
;3. Have plots of these ready to see if it’s an instrument error or something else--what causes them to be “bad”?
;4. Write your little screening routine to filter through, produce statistics, and (ideally) produce plots of the relevant quantities
;Would be bonus if we could slap this into Alfvèn stats 5 to make the plot generation/screening happen on the fly and get outputted in some sort of summary file.
;5. Perhaps test out the screening on a few other orbits--how does your new code compare to your going at it ‘by hand’? 
;a. If efficient, perhaps skim the whole Chaston DB to see if it improves plots/makes electron and Poynting flux plots feasible
;b. If not, go back and revise. It’s possible I’ll need to be flexible with the numbers.
;Might even want three indices to indicate quality:
;0: good
;1: warning! (within an order of magnitude or two of unacceptable value)
;2: Garbage--way below or way above acceptable value

;So, here we go. The orbits of interest are 2030, 2059, 6535, 9000,
;and 10000

;1. Electron flux and Poynting flux histos
;2. post_AGU_2014_2_through_4_find_garbage_events

PRO post_AGU_2014_1_make_comparison_histos, arr_elem, orbs=orbs, intervals=intervals, as3=as3, show_f=show_f, outdir=outdir, poynting_histo=poynting_histo, cur_thresh=cur_thresh, _ref_extra = e

  datdir="/SPENCEdata2/Research/Cusp/ACE_FAST/Compare_new_DB_with_Chastons/txtoutput/"

;the orbits to be processed
;make sure both Chaston and Dart db files exist!
;orbs=[2030,2057,6065,6065,9000,10000]
;intervals=[0,0,0,1,0,0]


  IF NOT KEYWORD_SET(outdir) THEN outdir='/SPENCEdata2/Research/Cusp/ACE_FAST/Compare_new_DB_with_Chastons/post_AGU_2014_various/histos/' 



  IF NOT KEYWORD_SET(orbs) THEN BEGIN 
     orbs=[2030,2057,6535,9000,10000] 
     intervals=[0,0,0,0,0] 
  ENDIF

;field names for as5-generated file
  fieldnames_as5=['orbit','alfvenic','time','alt','mlt','ilat','mag_current','esa_current','eflux_losscone_max','total_eflux_max',$
                  'eflux_losscone_integ','total_eflux_integ','max_chare_losscone','max_chare_total','max_ie','max_ion_flux','max_upgoing_ionflux','integ_ionf','integ_upgoing_ionf','max_char_ie',$
                  'width_t','width_spatial','db','de','fields_samp_period','fields_mode','max_hf_up','max_h_chare','max_of_up','max_o_chare',$
                  'max_hef_up','max_he_chare','sc_pot','lp_num','max_lp_current','min_lp_current','median_lp_current']

;field names for as3-generated file
  fieldnames_as3=['orbit','time','alt','mlt','ilat','mag_current','esa_current','elec_energy_flux','integ_elec_energy_flux','char_elec_energy',$
                  'ion_energy_flux','ion_flux','ion_flux_up','integ_ion_flux','integ_ion_flux_up','char_ion_energy','width_time','width_x','delta_B','delta_E',$
                  'mode','sample_t','proton_flux_up','proton_energy_flux_up','oxy_flux_up','oxy_energy_flux_up','helium_flux_up','helium_energy_flux_up','sc_pot']
  
  ;just want to see the possibilities?
  IF KEYWORD_SET(show_f) THEN BEGIN

     PRINT,"NOTE: arr_elem defaults to as5 format!"
     PRINT,""

     fieldind_as5=indgen(n_elements(fieldnames_as5))
     PRINT, "AS5 Field indices and corresponding data:"
     for j=0,((N_ELEMENTS(fieldind_as5)-1)/5 - 1) DO BEGIN
        PRINT, format='(5(I2,": ",A-22,:))',fieldind_as5[j*5],fieldnames_as5[j*5],fieldind_as5[j*5+1],fieldnames_as5[j*5+1], $
               fieldind_as5[j*5+2],fieldnames_as5[j*5+2],fieldind_as5[j*5+3],fieldnames_as5[j*5+3],fieldind_as5[j*5+4],fieldnames_as5[j*5+4]
     endfor
     
     fieldind_as3=indgen(n_elements(fieldnames_as3))
     PRINT, "AS3 Field indices and corresponding data:"
     for j=0,((N_ELEMENTS(fieldind_as3)-1)/5 - 1) DO BEGIN
        PRINT, format='(5(I2,": ",A-22,:))',fieldind_as3[j*5],fieldnames_as3[j*5],fieldind_as3[j*5+1],fieldnames_as3[j*5+1], $
               fieldind_as3[j*5+2],fieldnames_as3[j*5+2],fieldind_as3[j*5+3],fieldnames_as3[j*5+3],fieldind_as3[j*5+4],fieldnames_as3[j*5+4]
     endfor
     
     RETURN
     
  ENDIF
  
  IF NOT KEYWORD_SET(as3) AND NOT KEYWORD_SET(POYNTING_HISTO) THEN BEGIN
     
                                ;Array to match as5 data with as3 data
     dart_as5_arr_elem = [0,-1,1,2,3,4,5,6,7,-1,$ ; Not sure if max_chare_losscone [i=12] or max_chare_total correspond to char_elec_energy
                          8,-1,9,-1,10,11,12,13,14,15,$
                          16,17,18,19,21,20,22,23,24,25,$ ;fields mode [i=25 here, or 20]
                          26,27,28,-1,-1,-1,-1]  
     chast_arr_elem = dart_as5_arr_elem[arr_elem]
     IF chast_arr_elem LE -1.0 THEN BEGIN
        PRINT, "ERROR! You're attempting to use Alfven_Stats_5 array element " +string(arr_elem) + " for comparison, but the Chaston DB doesn't include this calculation!"
        PRINT, "Exiting..."
        RETURN
     ENDIF

     IF KEYWORD_SET(cur_thresh) THEN curthresh_string = '--curthresh_'+strcompress(cur_thresh,/remove_all) ELSE curthresh_string = ''

     dartTitle = fieldnames_as5[arr_elem]
     chastTitle=fieldnames_as3[chast_arr_elem]

  ENDIF ELSE BEGIN 
     IF NOT KEYWORD_SET(POYNTING_HISTO) THEN BEGIN

        chast_arr_elem = arr_elem
        dartTitle = fieldnames_as3[arr_elem]
        chastTitle=dartTitle
     ENDIF 
  ENDELSE
  
  ;produce the histos
  for i=0,n_elements(orbs)-1 do begin
     
     ;Chaston file
     restore,datdir+"chast_dflux_"+strcompress(orbs[i],/remove_all)+'_'+strcompress(intervals[i],/remove_all)+".sav"
     chast_struct=dat
     
     ;Dart file
     restore,datdir+"as5/Dartmouth_as5__dflux_"+strcompress(orbs[i],/remove_all)+'_'+strcompress(intervals[i],/remove_all)+".sav"
     dart_struct=dat1 
     
     IF NOT KEYWORD_SET(POYNTING_HISTO) THEN BEGIN 
        
        chast_data = chast_struct.(chast_arr_elem)
        dart_data = dart_struct.(arr_elem)
        
     ENDIF ELSE BEGIN 
        
        mu_0 = 4.0e-7 * !PI     ;perm. of free space, for Poynt. est
        
        chast_data = chast_struct.delta_e * chast_struct.delta_b * mu_0 
        dart_data = dart_struct.db * dart_struct.de * mu_0 

        dartTitle='Poynting_flux'
        chastTitle=dartTitle
     ENDELSE 

     ;to achieve a binsize that is an order of magnitude below the median value of both arrays
     exponent=floor(alog10(abs(median([chast_data,dart_data]))))
     binS=10.0^(exponent)

     print,'exponent: ',exponent
     print,'binsize: ',binS

     IF KEYWORD_SET(cur_thresh) THEN BEGIN
        winnow_chast_and_dart_data_array,cur_thresh=cur_thresh,chast_arr_elem=chast_arr_elem,arr_elem=arr_elem, $
                                         chast_data=chast_data,dart_data=dart_data,chast_struct=chast_struct,dart_struct=dart_struct,as3=as3
     ENDIF

     ;few things for the plots
     chast_histo=histogram(chast_data) 
     dart_histo=histogram(dart_data)
     maxHist=max([chast_histo,dart_histo])
     datMax=MAX([chast_data,dart_data])
     datMin=MIN([chast_data,dart_data])

     ;open postscript file
     fname = outdir+'histo_comparison--'+dartTitle+'--Chast_Dartmouth--Orbit_'+strcompress(orbs[i],/remove_all)+'_'+strcompress(intervals[i],/remove_all)
     IF KEYWORD_SET(cur_thresh) THEN fname += '--curthresh_' + strcompress(cur_thresh,/remove_all)
     fname +='.png'

;DOESN'T WORK     cgps_open, xsize=800, ysize=600, FILENAME=fname, font=1, /nomatch
     cgps_open, FILENAME=fname, font=1
     
     ;; !p.thick=2
     ;; !x.thick=2
     ;; !y.thick=2
     ;; !p.charthick=2.0
     ;; !p.font=1
     !p.charsize=1.25

     cghistoplot,chast_data,POLYCOLOR='navy',/fillpolygon, datacolorname='blue', binsize=binS, histdata=chast_histodata,layout=[2,1,1],xtitle=chastTitle,title="Chaston db, orbit "+strcompress(orbs[i],/remove_all)+'_'+strcompress(intervals[i],/remove_all),ytitle='Number of occurrences',max_value=maxHist,maxinput=datmax*1.05, mininput=datMin*0.95, charsize=1.3, _extra = e 
     
     cghistoplot,dart_data,POLYCOLOR='forest green', /fillpolygon, datacolorname='green', binsize=binS, histdata=dart_histodata,layout=[2,1,2],xtitle=dartTitle,title="Dart db, orbit "+strcompress(orbs[i],/remove_all)+'_'+strcompress(intervals[i],/remove_all),ytitle='Number of occurrences',max_value=maxHist,maxinput=datmax*1.05, mininput=datMin*0.95, charsize=1.3, _extra = e 

     chast_integral=total(chast_data)
     dart_integral=total(dart_data)
     chast_nevents=n_elements(chast_data)
     dart_nevents=n_elements(dart_data)

     cSize=1

     ;; cgText,0.46,0.2,  'Binsize             : ' + strcompress(binS,/remove_all),/normal,charsize=cSize
     ;; cgText,0.46,0.175,'Chaston integral    : ' + strcompress(chast_integral,/remove_all),/normal,charsize=cSize
     ;; cgText,0.46,0.155,'Dartmouth integral  : ' + strcompress(dart_integral,/remove_all),/normal,charsize=cSize
     ;; cgText,0.46,0.13, 'Chaston # events    : ' + strcompress(chast_nevents,/remove_all),/normal,charsize=cSize
     ;; cgText,0.46,0.11, 'Dartmouth # events  : ' + strcompress(dart_nevents,/remove_all),/normal,charsize=cSize
     ;; IF KEYWORD_SET(cur_thresh) THEN $
     ;;    cgText,0.46,0.095, 'microA/m^2 threshold: ' + strcompress(cur_thresh,/remove_all),/normal,charsize=cSize

     cgText,0.46,0.25,string(format='("Binsize",T22,":",T25,G0.4)',binS),/normal,charsize=cSize
     cgText,0.46,0.225,string(format='("Chaston integral",T22,":",T25,G0.4)',chast_integral),/normal,charsize=cSize
     cgText,0.46,0.205,string(format='("Dartmouth integral",T22,":",T25,G0.4)',dart_integral),/normal,charsize=cSize
     cgText,0.46,0.18,string(format='("Chaston # events",T22,":",T25,I0)',chast_nevents),/normal,charsize=cSize
     cgText,0.46,0.16,string(format='("Dartmouth # events",T22,":",T25,I0)',dart_nevents),/normal,charsize=cSize
     IF KEYWORD_SET(cur_thresh) THEN $
        cgText,0.46,0.145, string(format='("microA/m^2 threshold",T22,":",T25,G0.4)',cur_thresh),/normal,charsize=cSize


     cgps_Close 
        
  endfor
  
END

;I think I want to use this to make box plots
PRO post_AGU_2014_2_through_4_find_garbage_events, arr_elem, orbs=orbs, intervals=intervals, as3=as3, show_f=show_f, poynting_boxplot=poynting_boxplot, $
   cur_thresh=cur_thresh, logplots=logplots, _ref_extra = e

  datdir="/SPENCEdata2/Research/Cusp/ACE_FAST/Compare_new_DB_with_Chastons/txtoutput/"

  IF NOT KEYWORD_SET(outdir) THEN outdir='/SPENCEdata2/Research/Cusp/ACE_FAST/Compare_new_DB_with_Chastons/post_AGU_2014_various/boxplots/' 

  IF NOT KEYWORD_SET(orbs) THEN BEGIN 
     orbs=[2030,2057,6535,9000,10000] 
;     orbs=[10000] 
     intervals=[0,0,0,0,0] 
  ENDIF

  ;field names for as5-generated file
  fieldnames_as5=['orbit','alfvenic','time','alt','mlt','ilat','mag_current','esa_current','eflux_losscone_max','total_eflux_max',$
                  'eflux_losscone_integ','total_eflux_integ','max_chare_losscone','max_chare_total','max_ie','max_ion_flux','max_upgoing_ionflux','integ_ionf','integ_upgoing_ionf','max_char_ie',$
                  'width_t','width_spatial','db','de','fields_samp_period','fields_mode','max_hf_up','max_h_chare','max_of_up','max_o_chare',$
                  'max_hef_up','max_he_chare','sc_pot','lp_num','max_lp_current','min_lp_current','median_lp_current']

  ;field names for as3-generated file
  fieldnames_as3=['orbit','time','alt','mlt','ilat','mag_current','esa_current','elec_energy_flux','integ_elec_energy_flux','char_elec_energy',$
                  'ion_energy_flux','ion_flux','ion_flux_up','integ_ion_flux','integ_ion_flux_up','char_ion_energy','width_time','width_x','delta_B','delta_E',$
                  'mode','sample_t','proton_flux_up','proton_energy_flux_up','oxy_flux_up','oxy_energy_flux_up','helium_flux_up','helium_energy_flux_up','sc_pot']
  
  ;just want to see the possibilities?
  IF KEYWORD_SET(show_f) THEN BEGIN

     PRINT,"NOTE: arr_elem defaults to as5 format!"
     PRINT,""

     fieldind_as5=indgen(n_elements(fieldnames_as5))
     PRINT, "AS5 Field indices and corresponding data:"
     for j=0,((N_ELEMENTS(fieldind_as5)-1)/5 - 1) DO BEGIN
        PRINT, format='(5(I2,": ",A-22,:))',fieldind_as5[j*5],fieldnames_as5[j*5],fieldind_as5[j*5+1],fieldnames_as5[j*5+1], $
               fieldind_as5[j*5+2],fieldnames_as5[j*5+2],fieldind_as5[j*5+3],fieldnames_as5[j*5+3],fieldind_as5[j*5+4],fieldnames_as5[j*5+4]
     endfor
     
     fieldind_as3=indgen(n_elements(fieldnames_as3))
     PRINT, "AS3 Field indices and corresponding data:"
     for j=0,((N_ELEMENTS(fieldind_as3)-1)/5 - 1) DO BEGIN
        PRINT, format='(5(I2,": ",A-22,:))',fieldind_as3[j*5],fieldnames_as3[j*5],fieldind_as3[j*5+1],fieldnames_as3[j*5+1], $
               fieldind_as3[j*5+2],fieldnames_as3[j*5+2],fieldind_as3[j*5+3],fieldnames_as3[j*5+3],fieldind_as3[j*5+4],fieldnames_as3[j*5+4]
     endfor
     
     RETURN
     
  ENDIF
  
  IF NOT KEYWORD_SET(as3) AND NOT KEYWORD_SET(POYNTING_BOXPLOT) THEN BEGIN
     
     ;Array to match as5 data with as3 data
     dart_as5_arr_elem = [0,-1,1,2,3,4,5,6,7,-1,$ ; Not sure if max_chare_losscone [i=12] or max_chare_total correspond to char_elec_energy
                          8,-1,9,-1,10,11,12,13,14,15,$
                          16,17,18,19,21,20,22,23,24,25,$ ;fields mode [i=25 here, or 20]
                          26,27,28,-1,-1,-1,-1]  
     chast_arr_elem = dart_as5_arr_elem[arr_elem]
     IF chast_arr_elem LE -1.0 THEN BEGIN
        PRINT, "ERROR! You're attempting to use Alfven_Stats_5 array element " +string(arr_elem) + " for comparison, but the Chaston DB doesn't include this calculation!"
        PRINT, "Exiting..."
        RETURN
     ENDIF
     
     dartTitle = fieldnames_as5[arr_elem]
     chastTitle=fieldnames_as3[chast_arr_elem]

  ENDIF ELSE BEGIN 
     IF NOT KEYWORD_SET(POYNTING_BOXPLOT) THEN BEGIN
        
        chast_arr_elem = arr_elem
        
        dartTitle = fieldnames_as3[arr_elem]
        chastTitle=fieldnames_as3[chast_arr_elem]

     ENDIF ELSE BEGIN
        dartTitle='Poynting_flux' 
        chastTitle=dartTitle
     ENDELSE
  ENDELSE

  IF KEYWORD_SET(logplots) THEN BEGIN
     logTitle='--abslog'
     
     dartTitle+=logTitle
     chastTitle+=logTitle
  ENDIF
  
  ;produce the boxplots
  for i=0,n_elements(orbs)-1 do begin 
     
     ;Chaston file
     restore,datdir+"chast_dflux_"+strcompress(orbs[i],/remove_all)+'_'+strcompress(intervals[i],/remove_all)+".sav" 
     chast_struct=dat 
     
     ;Dart file
     restore,datdir+"as5/Dartmouth_as5__dflux_"+strcompress(orbs[i],/remove_all)+'_'+strcompress(intervals[i],/remove_all)+".sav" 
     dart_struct=dat1 
     
     IF NOT KEYWORD_SET(POYNTING_BOXPLOT) THEN BEGIN 
        
        chast_boxdata = chast_struct.(chast_arr_elem)
        dart_boxdata = dart_struct.(arr_elem)
   
     ENDIF ELSE BEGIN 
        mu_0 = 4.0e-7 * !PI     ;perm. of free space, for Poynt. est
   
        chast_boxdata=chast_struct.delta_e * chast_struct.delta_b * mu_0 
        dart_boxdata = dart_struct.db * dart_struct.de * mu_0 
        
     ENDELSE 
     
     ;generate array of signs for each data set
     neg_arr_chast = chast_boxdata
     neg_arr_chast(where(neg_arr_chast NE 0)) = neg_arr_chast(where(neg_arr_chast NE 0)) / abs(neg_arr_chast(where(neg_arr_chast NE 0)))

     neg_arr_dart = dart_boxdata
     neg_arr_dart(where(neg_arr_dart NE 0)) = neg_arr_dart(where(neg_arr_dart NE 0)) / abs(neg_arr_dart(where(neg_arr_dart NE 0)))

     IF KEYWORD_SET(logplots) THEN BEGIN
        chast_boxdata=abs(alog10(chast_boxdata))
        dart_boxdata=abs(alog10(dart_boxdata))
        
     ENDIF 

     ;bounds for plots
     datMax=MAX([chast_boxdata,dart_boxdata]) 
     datMin=MIN([chast_boxdata,dart_boxdata]) 

     IF KEYWORD_SET(cur_thresh) THEN BEGIN
        winnow_chast_and_dart_data_array,cur_thresh=cur_thresh,chast_arr_elem=chast_arr_elem,arr_elem=arr_elem, $
                                         chast_data=chast_boxdata,dart_data=dart_boxdata,chast_struct=chast_struct,dart_struct=dart_struct,as3=as3
     ENDIF


     ;open postscript file
     fname = outdir+'boxplot_comparison--'+dartTitle+'--Chast_Dartmouth--Orbit_'+strcompress(orbs[i],/remove_all)+'_'+strcompress(intervals[i],/remove_all)
     IF KEYWORD_SET(cur_thresh) THEN fname += '--curthresh_' + strcompress(cur_thresh,/remove_all)
     fname +='.png'

;     cgps_open, xsize=800, ysize=600, FILENAME=fname, font=1 
     cgps_open, FILENAME=fname, font=1

     !p.charsize=1.25

     cgboxplot_wnegs,chast_boxdata, BoxColor='navy', outliercolor='red', neg_outliercolor='blue', NEG_ARR=neg_arr_chast, stats=chast_boxstats,layout=[2,1,1],ytitle=chastTitle,title="Chaston db, orbit "+strcompress(orbs[i],/remove_all)+'_'+strcompress(intervals[i],/remove_all), yrange=[datMin,datMax], LABELS=[''],  _extra = e 
        
     cgboxplot_wnegs,dart_boxdata, BoxColor='forest green', outliercolor='red', neg_outliercolor='blue', NEG_ARR=neg_arr_dart, stats=dart_boxstats,layout=[2,1,2],ytitle=dartTitle,title="Dart db, orbit "+strcompress(orbs[i],/remove_all)+'_'+strcompress(intervals[i],/remove_all), yrange=[datMin,datMax], LABELS=[''],  _extra = e 
        
     cSize=1.0
     
     boxtags=tag_names(chast_boxstats)
     FOR k=0, n_elements(boxtags)-1 DO BEGIN
        
        xpos1=0.1 + (k LT 6 ? 0.0 : 1.0 ) * 0.18
        ypos1=0.15 - 0.02 * (k MOD 6.0)
        xpos2=0.6 + (k LT 6 ? 0.0 : 1.0 ) * 0.18
        ypos2=0.15 - 0.02 * (k MOD 6.0)
        
;        print,xpos1,ypos1
;        print,xpos2,ypos2

        ;labels for boxplot statistics 
        cgtext,xpos1,ypos1,str(boxtags[k]),/normal,charsize=cSize
        cgtext,xpos2,ypos2,str(boxtags[k]),/normal,charsize=cSize
        
        ;values
        cgtext,xpos1+0.09,ypos1,strcompress(chast_boxstats.(k),/remove_all),/normal,charsize=cSize
        cgtext,xpos2+0.09,ypos2,strcompress(dart_boxstats.(k),/remove_all),/normal,charsize=cSize
        
     ENDFOR
     
     
     cgps_Close 
     
     
  endfor
  
END

