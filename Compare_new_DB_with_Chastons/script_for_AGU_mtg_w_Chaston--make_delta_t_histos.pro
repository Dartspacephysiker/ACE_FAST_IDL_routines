;First, let's get one of these orbits online. I know orbit 10000, so
;let's start there.

datdir="/SPENCEdata2/Research/Cusp/ACE_FAST/Compare_new_DB_with_Chastons/txtoutput/"

max_hist=40

;orbs=[2030,2057,6065,6065,9000,10000]
;intervals=[0,0,0,1,0,0]
orbs=[2030,2057,6535,9000,10000]
intervals=[0,0,0,0,0]

for i=0,n_elements(orbs)-1 do begin & $

   ;Chaston file
   restore,datdir+"chast_dflux_"+strcompress(orbs[i],/remove_all)+'_'+strcompress(intervals[i],/remove_all)+".sav" & $
   chast_dat=dat & $

   ;Dart file
   restore,datdir+"as5/Dartmouth_as5__dflux_"+strcompress(orbs[i],/remove_all)+'_'+strcompress(intervals[i],/remove_all)+".sav" & $
   dart_dat=dat1 & $

   ;Now what? Relevant data products are...
   ;For Chaston: 'Width_time'
   ;For Dart data: 'Width_t'

   chast_histo=histogram(chast_dat.width_time,binsize=0.1)
   dart_histo=histogram(dart_dat.width_t,binsize=0.1)
   max_hist=max([chast_histo,dart_histo])

   cgPS_Open, FILENAME='Chaston_AGU_mtg_stuff/current_width_histos/Current_width--histo_comparison--Chast_Dartmouth--Orbit_'+strcompress(orbs[i],/remove_all)+'_'+strcompress(intervals[i],/remove_all)+'.png' & $

   cghistoplot,chast_dat.width_time,binsize=0.1,POLYCOLOR='navy',histdata=chast_histodata,layout=[2,1,1],/line_fill,xtitle="Current width (t)",title="Chaston db, orbit "+strcompress(orbs[i],/remove_all)+'_'+strcompress(intervals[i],/remove_all),ytitle='Number of occurrences',max_value=max_hist,maxinput=MAX([chast_dat.width_time,dart_dat.width_t]) & $

   cghistoplot,dart_dat.width_t,binsize=0.1,POLYCOLOR='forest green',histdata=chast_histodata,layout=[2,1,2],/line_fill,xtitle="Current width (t)",title="Dart db, orbit "+strcompress(orbs[i],/remove_all)+'_'+strcompress(intervals[i],/remove_all),ytitle='Number of occurrences',max_value=max_hist,maxinput=MAX([chast_dat.width_time,dart_dat.width_t]) & $

   cgps_Close & $


endfor


;cgwindow,'script_make_chast_histo',chast_dat.width_time,orbit,MAX([chast_dat.width_time,dart_dat.width_t]),chast_histodata,wbackground='WHITE'

;cgwindow,'script_make_dart_histo',dart_dat.width_t,orbit,MAX([chast_dat.width_time,dart_dat.width_t]),dart_histodata,/addcmd
