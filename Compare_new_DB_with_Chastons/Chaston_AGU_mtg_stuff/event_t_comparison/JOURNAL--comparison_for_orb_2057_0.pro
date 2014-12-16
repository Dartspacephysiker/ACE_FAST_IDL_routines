; IDL Version 8.3 (linux x86_64 m64)
; Journal File for spencerh@tadrith
; Working directory: /SPENCEdata2/Research/Cusp/ACE_FAST/Compare_new_DB_with_Chastons/Chaston_AGU_mtg_stuff/event_t_comparison
; Date: Mon Dec 15 10:58:15 2014
 
;For orbit 2057, Chaston identifies 16 events about 5microA/m^2, whereas we only identify 14.
;For Chaston events 29 and 30, our event 37 occurs beforehand and might combine the two.
;52                             1997-02-27/15:59:38.021                   37  
;53    1997-02-27/15:59:38.232                              29  
;54    1997-02-27/15:59:38.521                              30  
;55                             1997-02-27/15:59:38.771                   38  
;The Chaston events that we don't match are at line number 54, 61, 64, 66, 68 ,69, 70, 83, 85, 87, 91 and 95
;These correspond to Chaston events 30, 36, 37, 38, 39, 40, 41, 52, 53, and 54, 57, and 59

;For Chaston event 30, we have event 38:
;Chast evt 30 time:                 1997-02-27/15:59:38.521
;Evt 38 peak current time:          1997-02-27/15:59:38.771
;Evt 38 start/stop times:        38 1997-02-27/15:59:38.451 1997-02-27/15:59:39.224

;For Chaston event 36, we have event 42:
;Chast evt 36 time:                 1997-02-27/15:59:45.388
;Evt 42 peak current time:          1997-02-27/15:59:45.654
;Evt 42 start/stop times:        42 1997-02-27/15:59:45.349 1997-02-27/15:59:45.717

;For Chaston event 37, we have no corresponding event:
;Chast evt 37 time:                 1997-02-27/15:59:46.373
;Closest Dartmouth events...
;Evt 43 peak current time:          1997-02-27/15:59:45.818
;Evt 43 start/stop times:        43 1997-02-27/15:59:45.756 1997-02-27/15:59:46.271
;Evt 44 peak current time:          1997-02-27/15:59:46.888
;Evt 44 start/stop times:        44 1997-02-27/15:59:46.513 1997-02-27/15:59:47.381     
;2478     1997-02-27/15:59:46.310     Current too low   :   0.4887
;2478     1997-02-27/15:59:46.310     Delta-b too low   :   0.1645
;2479     1997-02-27/15:59:46.388     Delta-b too low   :   0.5778
;Several other 'delta-b too low' issues for nearby times

;For Chaston event 38, we have event 44:
;Chast evt 38 time:                 1997-02-27/15:59:38.521
;Evt 44 peak current time:          1997-02-27/15:59:46.888
;Evt 44 start/stop times:        44 1997-02-27/15:59:46.513 1997-02-27/15:59:47.381     

;For Chaston event 39, we have event 42:
;Chast evt 39 time:                 1997-02-27/15:59:48.013
;Evt 45 peak current time:          1997-02-27/15:59:47.803
;Evt 45 start/stop times:        45 1997-02-27/15:59:47.576 1997-02-27/15:59:48.107

;For Chaston event 40, we have no event... 45 is closest on list:
;Chast evt 40 time:                 1997-02-27/15:59:49.779
;Evt 45 peak current time:          1997-02-27/15:59:47.803
;Evt 45 start/stop times:        45 1997-02-27/15:59:47.576 1997-02-27/15:59:48.107
;From reject list:
;2493     1997-02-27/15:59:49.779     ESA_j/delta_bj low:   0.0129


;For Chaston event 41, we have no event... 46 is closest on list:
;Chast evt 41 time:                 1997-02-27/15:59:50.490
;Evt 46 peak current time:          1997-02-27/15:59:51.162
;Evt 46 start/stop times:        46 1997-02-27/15:59:50.365 1997-02-27/15:59:51.490
;From reject list:
;2494     1997-02-27/15:59:50.334     Delta-b too low   :   0.5603


;For Chaston event 52, we have event 57:
;Chast evt 52 time:                 1997-02-27/15:59:59.826 
;Evt 57 peak current time:          1997-02-27/16:00:00.123
;Evt 57 start/stop times:        57 1997-02-27/15:59:59.631 1997-02-27/16:00:00.717

;For Chaston event 53, we AGAIN have event 57:
;Chast evt 53 time:                 1997-02-27/16:00:00.623
;Evt 57 peak current time:          1997-02-27/16:00:00.123
;Evt 57 start/stop times:        57 1997-02-27/15:59:59.631 1997-02-27/16:00:00.717

;For Chaston event 54, we have event 59:
;Chast evt 54 time:                 1997-02-27/16:00:01.467
;Evt 59 peak current time:          1997-02-27/16:00:01.756
;Evt 59 start/stop times:        59 1997-02-27/16:00:01.099 1997-02-27/16:00:01.842

;For Chaston event 57, we have event 62:
;Chast evt 57 time:                 1997-02-27/16:00:02.732
;Evt 62 peak current time:          1997-02-27/16:00:02.904
;Evt 62 start/stop times:        62 1997-02-27/16:00:02.662 1997-02-27/16:00:03.092

;For Chaston event 59, we have no event...Closest is Evt 64:
;Chast evt 59 time:                 1997-02-27/16:00:04.045
;Evt 64 peak current time:          1997-02-27/16:00:03.920
;Evt 64 start/stop times:        64 1997-02-27/16:00:03.865
;1997-02-27/16:00:03.967
;From reject list:
;2543     1997-02-27/16:00:04.037     ESA_j/delta_bj low:   0.0015
;2543     1997-02-27/16:00:04.037     Jee ionos low     :   0.0031

