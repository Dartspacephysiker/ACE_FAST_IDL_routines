;;FORMAT OF THIS TABLE
;; column-index in current_intervals array in AS5--name of data product in maximus struct--description of data product
;; 1-21--'orbit'--Orbit number
;; 2-22--'alfvenic'--Alfvenic = 1 non-Alfvenic = 0
;; 3-23--'time'--max current time (based on location of max current 
;; 4-4--'alt'--max current altitude
;; 5-5--'mlt'--max current MLT
;; 6-6--'ilat'--max current ILAT			
;; 7-40--'MAG_CURRENT'--maximum size of the delta B current in that interval
;; 8-7--'ESA_CURRENT'--maximum size of the current from the Electron esa at s/c alt.
;; 9-41--'ELEC_ENERGY_FLUX'--maximum size of the electron energy flux from loss cone mapped to the ionosphere-positive is downwards
;; 10-8--'INTEG_ELEC_ENERGY_FLUX'--maximum size of the electron energy flux from total distribution mapped to the ionosphere-positive is downwards
;; 11-39--'eflux_losscone_integ'--integrated electron flux from loss cone over that interval at ionosphere
;; 12-9--'total_eflux_integ'--integrated electron flux from total distribution over that interval at ionosphere
;; 13-10--'max_chare_losscone'--maximum characteristic electron energy from loss cone over that interval
;; 14-11--'max_chare_total'--maximum characteristic electron energy from total distribution over that interval
;; 15-12--'ION_ENERGY_FLUX'maximum ion energy flux at the s/c altitude
;; 16-13--'ION_FLUX'--maximum ion flux at the s/c altitude
;; 17-14--'ION_FLUX_UP'--maximum upgoing ion flux at the s/c altitude
;; 18-15--'INTEG_ION_FLUX'--integrated ion flux over the interval at ionosphere
;; 19-16--'INTEG_ION_FLUX_UP'--integrated upgoing only ion flux over the interval at ionosphere
;; 20-17--'CHAR_ION_ENERGY'--maximum characteristic ion energy
;; 21-18--'WIDTH_TIME'--width of the current fiament in time (s)
;; 22-26--'WIDTH_X'--width of the current filament in m at the s/c altitude
;; 23-27--'DELTA_B'--magnetic field amplitude (nT)
;; 24-28--'DELTA_E'--electric field amplitude (mV/m)
;; 25-29--'SAMPLE_T'--fields sample period
;; 26-30--'MODE'--fields mode
;; 27-31--'PROTON_FLUX_UP'--maximum upgoing proton flux
;; 28-32--'PROTON_CHAR_ENERGY'--maximum upgoing proton characteristic energy
;; 29-33--'OXY_FLUX_UP'--maximum upgoing oxygen flux
;; 30-34--'OXY_CHAR_ENERGY'--maximum upgoing oxygen characteristic energy
;; 31-35--'HELIUM_FLUX_UP'--maximum upgoing helium flux
;; 32-36--'HELIUM_CHAR_ENERGY'--maximum upgoing helium characteristic energy
;; 33-37--'SC_POT'--spacecraft potential
;; 34-38--'L_PROBE'--Langmuir probe number
;; 35-'MAX_L_PROBE'--max langmuir probe current over interval
;; 36-'MIN_L_PROBE'--min lamgmuir probe current over interval
;; 37-'MEDIAN_L_PROBE'--median langmuir probe current over interval
;; 38-0*--'START_TIME'--interval start time
;; 39-1*--'STOP_TIME'--interval stop time
     
;; 1-19--'orbit'--Orbit number
;; 2-3--'alfvenic'--Alfvenic = 1 non-Alfvenic = 0
;; 3-20--'time'--max current time (based on location of max current 
;; 4-21--'alt'--max current altitude
;; 5-22--'mlt'--max current MLT
;; 6-23--'ilat'--max current ILAT			
;; 7-4--'MAG_CURRENT'--maximum size of the delta B current in that interval
;; 8-5--'ESA_CURRENT'--maximum size of the current from the Electron esa at s/c alt.
;; 9-6--'ELEC_ENERGY_FLUX'--maximum size of the electron energy flux from loss cone mapped to the ionosphere-positive is downwards
;; 10-40--'INTEG_ELEC_ENERGY_FLUX'--maximum size of the electron energy flux from total distribution mapped to the ionosphere-positive is downwards
;; 11-7--'eflux_losscone_integ'--integrated electron flux from loss cone over that interval at ionosphere
;; 12-41--'total_eflux_integ'--integrated electron flux from total distribution over that interval at ionosphere
;; 13-8--'max_chare_losscone'--maximum characteristic electron energy from loss cone over that interval
;; 14-39--'max_chare_total'--maximum characteristic electron energy from total distribution over that interval
;; 15-9--'ION_ENERGY_FLUX'maximum ion energy flux at the s/c altitude
;; 16-10--'ION_FLUX'--maximum ion flux at the s/c altitude
;; 17-11--'ION_FLUX_UP'--maximum upgoing ion flux at the s/c altitude
;; 18-12--'INTEG_ION_FLUX'--integrated ion flux over the interval at ionosphere
;; 19-13--'INTEG_ION_FLUX_UP'--integrated upgoing only ion flux over the interval at ionosphere
;; 20-14--'CHAR_ION_ENERGY'--maximum characteristic ion energy
;; 21-15--'WIDTH_TIME'--width of the current fiament in time (s)
;; 22-16--'WIDTH_X'--width of the current filament in m at the s/c altitude
;; 23-17--'DELTA_B'--magnetic field amplitude (nT)
;; 24-18--'DELTA_E'--electric field amplitude (mV/m)
;; 25-26--'SAMPLE_T'--fields sample period
;; 26-27--'MODE'--fields mode
;; 27-28--'PROTON_FLUX_UP'--maximum upgoing proton flux
;; 28-29--'PROTON_CHAR_ENERGY'--maximum upgoing proton characteristic energy
;; 29-30--'OXY_FLUX_UP'--maximum upgoing oxygen flux
;; 30-31--'OXY_CHAR_ENERGY'--maximum upgoing oxygen characteristic energy
;; 31-32--'HELIUM_FLUX_UP'--maximum upgoing helium flux
;; 32-33--'HELIUM_CHAR_ENERGY'--maximum upgoing helium characteristic energy
;; 33-34--'SC_POT'--spacecraft potential
;; 34-35--'L_PROBE'--Langmuir probe number
;; 35-36-'MAX_L_PROBE'--max langmuir probe current over interval
;; 36-37-'MIN_L_PROBE'--min lamgmuir probe current over interval
;; 37-38-'MEDIAN_L_PROBE'--median langmuir probe current over interval
;; 38-0*--'START_TIME'--interval start time
;; 39-1*--'STOP_TIME'--interval stop time


current_intervals(jj,13),current_intervals(jj,14),current_intervals(jj,15),current_intervals(jj,16),$
current_intervals(jj,17),current_intervals(jj,18),current_intervals(jj,26),current_intervals(jj,27),$
current_intervals(jj,28),current_intervals(jj,29),current_intervals(jj,30),current_intervals(jj,31),$
current_intervals(jj,32),current_intervals(jj,33),current_intervals(jj,34),current_intervals(jj,35),$
current_intervals(jj,36),current_intervals(jj,37),current_intervals(jj,38), $
time_to_str(magz.x(current_intervals(jj,0)),/ms), time_to_str(magz.x(current_intervals(jj,1)),/ms)

'("total electron dflux at ionosphere from single integ.",T68,G16.6)',Jee_tot(jjj)
'("total electron dflux at ionosphere from total of intervals",T68,G16.6)',total(current_intervals(*,7))
'("total Alfven electron dflux at ionosphere",T68,G16.6)',total(current_intervals(keep,7))
'("total ion outflow at ionosphere from single integ",T68,G16.6)',Ji_tot(jjj)
'("total ion outflow at ionosphere from total of intervals",T68,G16.6)',total(current_intervals(*,12))
'("total Alfven ion outflow at ionosphere",T68,G16.6)',total(current_intervals(keep,12))
'("total upward only ion outflow at ionosphere from single integ.",T68,G16.6)',Ji_up_tot(jjj)
'("total upward only ion outflow at ionosphere from total of intervals",T68,G16.6)',total(current_intervals(*,13))
'("total Alfven upward only ion outflow at ionosphere",T68,G16.6)',total(current_intervals(keep,13))				