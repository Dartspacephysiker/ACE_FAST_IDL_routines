;2015/05/22
;The idea here is to grab a few orbits at random and see if I can figure out what determines fast
;vs. slow-survey modes for the EESA

;Chris Chaston thinks there could very well be a bias in the way Alfvén-wave observations are
;distributed based on which mode the EESA was in

;************************************************************
;The following commented code is the way I selected the random orbits
;; dbDir='/SPENCEdata/Research/Cusp/ACE_FAST/scripts_for_processing_Dartmouth_data/'
;; dbFile='Dartdb_02282015--500-14999--maximus--cleaned.sav'
;; dbTimeFile='Dartdb_02282015--500-14999--cdbTime--cleaned.sav'

;; ;load DB
;; restore,dbDir+dbFile
;; restore,dbDir+dbTimeFile

;; sorted_orbs=maximus.orbit(sort(maximus.orbit))
;; orbits=sorted_orbs(uniq(sorted_orbs))
;; nOrbs=n_elements(orbits)

;; nRandom=10
;; rand_orb_i=FIX(nOrbs * RANDOMU(Seed, nRandom))
;; rand_orbs=orbits(rand_orb_i)
;; IDL> print,orbits(rand_orb_i)
;;     5423    8099    9601    7267    8304    7889    5420    2396    7010    4019

;; For orbit 5423, seems fast and slow mode correspond to inter-sample times of 0.631 s and 2.5248 s, respectively
;; For orbit 8099, fast and slow mode correspond to inter-sample times of 0.626468 s and 2.5059 s, respectively
;; For orbit 9601, fast and slow mode correspond to inter-sample times of 0.637573 s and 2.5503 s, respectively
;; For orbit 7889, fast and slow mode correspond to inter-sample times of 0.63587  s and 2.5437 s, respectively
;; For orbit 5420, fast and slow mode correspond to inter-sample times of 0.63587  s and 2.5437 s, respectively
;; For orbit 2396, fast and slow mode correspond to inter-sample times of 0.63587  s and 2.5437 s, respectively
;; For orbit 7010, standard, although there is a preponderance of values with ~2.5 s

;; For orbit 8304, things aren't so clear. It looks like there are instances of samples with
;; T_is of ~0.625 and ~2.5, but there are also many with T_is = 0.3138... I'm not sure what
;;to make of it.

;; For orbit 5420, I am caused to wonder if I'm getting true sample-to-sample times or if
;;these represent some integrated time. It looks like there are instances of samples with
;; T_is of ~0.631 and ~2.5, but there are also many with T_is = 0.3156 s. 

;; For orbit 4019, mostly values with T_is ~= 0.316 s.

PRO JOURNAL__20150522_fast_or_slow_survey

  orbit=4019

  @startup

  timeDelta=0.1

  ;;energy ranges
  if not keyword_set(energy_electrons) then energy_electrons=[0.,30000.] ;use 0.0 for lower bound since the sc_pot is used to set this
  if not keyword_set(energy_ions) then energy_ions=[0.,500.]             ;use 0.0 for lower bound since the sc_pot is used to set this

  current_threshold=1.0    ;microA/m^2
  delta_b_threshold=5.0    ; nT
  delta_E_threshold=10.0   ; mV/m
  esa_j_delta_bj_ratio_threshold=0.02
  electron_eflux_ionos_threshold=0.05 ;ergs/cm^2/s
  eb_to_alfven_speed=10.0 

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

  ;;Use this to figure out time diff between samples
  timeDiffs=tmpj.x-shift(tmpj.x,1)
  print,timeDiffs(1:100) ;last point is junk

  nSamps=n_elements(timeDiffs)

  orbString=string(format='(I0)',orbit)
  cghistoplot,timeDiffs,BINSIZE=timeDelta,mininput=0,maxinput=5, $
              xtitle='Difference between time samples (s)',title='Difference between time samples for orbit ' +orbString, $
              output='tDiffs_between_EESA_survey_samps_for_orb'+orbString+'.png'

END