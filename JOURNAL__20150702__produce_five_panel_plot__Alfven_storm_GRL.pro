;+
;2015/07/02
;Trying to generate this five-panel plot that Chris and Jim were preaching about on our telecon two days ago.
;I got a bunch of summary CDFs from the FAST website, and this is my maiden voyage with the routines used for loading and plotting them.
;I think orbits 14368–69 are the priority here
;
; (A little later in the day) I'm proposing an expanded plot of 2000-04-06/21:53:38–2000-04-06/22:11:16, since there are 120
;   Alfven events during those 17 minutes and 38 seconds. That's a lot!
; I further propose that we show all B field plots and all E field plots, along with the same first 5 panels shown by Yao et
;   al. [2008], as detailed below.

;In Yao et al. [2008], Figure 2 has seven panels from orbit 16166 (with BG correction):
;  ) Electron energy          (eV)     [1e1,1e4], bar* [1e5,1e9]
;  ) Electron angle (>80eV)   (deg)    [-90,270], bar* [1e5,1e9]
;  ) H&He++ energy            (eV)     [1e1,1e4], bar* [1e3.5,1e7.5]
;  ) O+ energy                (eV)     [1e1,1e4], bar* [1e3.5,1e7.5]
;  ) Ion angle (>80eV)        (deg)    [-90,270], bar* [1e3.5,1e7.5]
;  ) ESA Background           (cnts/s) [0,250]
;  ) Pressure_ion (eV/cm^3)            [1e2,1e6]
;    -->P_H+ (blue)
;    -->P_O+ (red)
;  UT
;  ALT
;  ILAT
;  MLT
;  "Hours from 2000-09-18/04:30:00"
;
;  *All bars have units Log(eV/cm^2-s-sr-eV)
;
;For our figure, at the bottom of the plot we will surely want
;    UT, ALT, L-SH[!], ILAT, MLT
;  at the bottom.
; 
;Which of the available sumplots would we like? 
;  Definitely ions and electrons, but which?
;  SYM-H?
;  What about...AC E field, AC B field, where Alfven waves happen?
;-

PRO JOURNAL__20150702__produce_five_panel_plot__Alfven_storm_GRL

  DEVICE,DECOMPOSED=0

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Get relevant SYM-H plots AND when Alfven events are happening

  ;; First a broad plot to get an idea of the storm development...
  ;; sw_data_plotter_and_dartdb_ind_getter,prod='SYM-H',center_t='2000-04-07/00:00:00',before_t=30,after_t=10,OUTFILE='SYM-H--Storm_2000-04-07.gif'
  ;; ;; ...then something a little narrower to focus in on FAST things
  ;; sw_data_plotter_and_dartdb_ind_getter,prod='SYM-H',center_t='2000-04-07/00:00:00',before_t=2,after_t=2,OUTFILE='/home/spencerh/Desktop/SYM-H--Storm_2000-04-07--zoomed_for_orb14370.gif',DARTDB_INDS_LIST=dartDB_14370_inds

  ;;just the inds, please
  sw_data_plotter_and_dartdb_ind_getter,prod='SYM-H',center_t='2000-04-07/00:00:00',before_t=2,after_t=2,DARTDB_INDS_LIST=storm_i_list
  storm_i=storm_i_list[0]

  restore,'../database/dartdb/saves/Dartdb_20150611--500-16361_inc_lower_lats--maximus.sav'
  print,maximus.time[storm_i]

  tmpTime=str_to_time(maximus.time[storm_i[0]])
  baseTime=tmpTime-(tmpTime MOD 3600)
  plot=plot((str_to_time(maximus.time[storm_i])-baseTime)/3600.,maximus.mag_current, $
            XTITLE='Hours since ' + time_to_str(baseTime), $
            LINESTYLE='', $
            SYMBOL='x', $
            SYM_SIZE=1.5)

  ;; ;; From the following command, we know that the events happen on orbit 14369 OUTGOING SOUTH,
  ;; and orbit 14370, both OUTGOING NORTH and OUTGOING SOUTH
  ;; For orbit 14370, 2000-04-07/00:21:00 is a very fruitful minute
  ;; For orbit14369, 2000-04-06/22:09-10 are two incredibly fruitful minutes
  ;; print,maximus.ilat[cgsetintersection(WHERE(maximus.orbit EQ 14370),storm_i)]
  ;; print,maximus.orbit[storm_i]
  
  acf_p='fa_k0_acf_'            ;AC fields prefix
  dcf_p='fa_k0_dcf_'            ;DC fields prefix
  ees_p='fa_k0_ees_'            ;Electron survey prefix
  ies_p='fa_k0_ies_'            ;Ion survey prefix
  orb_p='fa_k0_orb_'            ;Orbit/ephemeris prefix
  tms_p='fa_k0_tms_'            ;TEAMS prefix
  
  acf_s='_v03.cdf'              ;AC fields suffix
  dcf_s='_v02.cdf'              ;DC fields suffix
  ees_s='_v04.cdf'              ;Electron survey suffix
  ies_s='_v04.cdf'              ;Ion survey suffix
  orb_s='_v01.cdf'              ;Orbit/ephemeris suffix
  tms_s='_v04.cdf'              ;TEAMS suffix
  
  ;;Orbits to use
  ;;Priority orbs: 14368-69
  ;;That is, orbs[9:10]
  
  ;;TEAMS, EES, IES are missing orb 14380
  ;;DC,AC fields missing orbs 14379-80
  ;;That is, don't use orbs[20:21]

  firstOrb=14359
  firstOrb=14369
  orbs=INDGEN(23,/L64)+firstOrb

  ;; This works great for loading, plotting, and making hard copies of plots of TEAMS data.
  ;; The issue is to decide which data products are most relevant
  FOR i=9,10 DO BEGIN
     LOAD_FA_K0_ORB,FILENAMES=orb_p+STRCOMPRESS(orbs[i],/REMOVE_ALL)+orb_s,DIR='/SPENCEdata/Research/Cusp/database/FAST_sum_cdfs__20000406-07/'
     PLOT_FA_K0_ORB

     LOAD_FA_K0_TMS,FILENAMES=tms_p+STRCOMPRESS(orbs[i],/REMOVE_ALL)+tms_s,DIR='/SPENCEdata/Research/Cusp/database/FAST_sum_cdfs__20000406-07/'
     PLOT_FA_K0_TMS
     GEN_FA_K0_TMS_GIFPS

     LOAD_FA_K0_EES,FILENAMES=ees_p+STRCOMPRESS(orbs[i],/REMOVE_ALL)+ees_s,DIR='/SPENCEdata/Research/Cusp/database/FAST_sum_cdfs__20000406-07/'
     PLOT_FA_K0_EES
     GEN_FA_K0_EES_GIFPS

     LOAD_FA_K0_IES,FILENAMES=ies_p+STRCOMPRESS(orbs[i],/REMOVE_ALL)+ies_s,DIR='/SPENCEdata/Research/Cusp/database/FAST_sum_cdfs__20000406-07/'
     PLOT_FA_K0_IES
     GEN_FA_K0_IES_GIFPS

     LOAD_FA_K0_ACF,FILENAMES=acf_p+STRCOMPRESS(orbs[i],/REMOVE_ALL)+acf_s,DIR='/SPENCEdata/Research/Cusp/database/FAST_sum_cdfs__20000406-07/'
     PLOT_FA_K0_ACF
     GEN_FA_K0_ACF_GIFPS

     LOAD_FA_K0_DCF,FILENAMES=dcf_p+STRCOMPRESS(orbs[i],/REMOVE_ALL)+dcf_s,DIR='/SPENCEdata/Research/Cusp/database/FAST_sum_cdfs__20000406-07/'
     GEN_FA_K0_DCF_GIFPS

  ENDFOR



END