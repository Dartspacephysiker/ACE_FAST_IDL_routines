;2015/08/20
;Here's why we have to restrict maximus.sample_t to LE 0.01
;I also think we need to restrict maximus.width_time to LE 4.946*0.25, since we're only using the component of the mag field
;that is out of the spin plane.
; NOTE: Lines for ChastonDB at bottom

PRO JOURNAL__20150820__WHY_WE_SHOULD_RESTRICT_WIDTH_TIME_AND_SAMPLE_T

  ;;See? sample_ts greater than 0.01 leave this harmonic junk in the DB
  cghistoplot,maximus.sample_t,maxinput=0.2

  cghistoplot,maximus.width_time(where(maximus.sample_t LE 0.1)),maxinput=4
  cghistoplot,maximus.width_time(where(maximus.sample_t LE 0.2)),maxinput=4
  cghistoplot,maximus.width_time(where(maximus.sample_t LE 0.01)),maxinput=4

  ;;Produce the hard evidence, boys
  ;; cghistoplot,maximus.width_time(where(maximus.sample_t LE 0.1)),maxinput=4,TITLE='Temporal width of events for sample periods LT 0.1 S (GT 10 Hz)',output='maxHisto--WIDTH_TIME_for_SAMPLE_T_LT_0.1--20150820.png'
  ;; cghistoplot,maximus.width_time(where(maximus.sample_t LE 0.2)),maxinput=4,TITLE='Temporal width of events for sample periods LT 0.1 S (GT 10 Hz)',output='maxHisto--WIDTH_TIME_for_SAMPLE_T_LT_0.2--lots_of_garbage--20150820.png'
  ;; cghistoplot,maximus.width_time(where(maximus.sample_t LE 0.01)),maxinput=4,TITLE='Temporal width of events for sample periods LT 0.01 S (GT 100 Hz)',output='maxHisto--WIDTH_TIME_for_SAMPLE_T_LT_0.01--cleanest_dist--20150820.png'


  print,N_ELEMENTS(WHERE(maximus.width_time(where(maximus.sample_t LE 0.01)) GT 5))
  ;;     78
  print,N_ELEMENTS(WHERE(maximus.width_time(where(maximus.sample_t LE 0.01)) GT 10))
  ;;     18
  print,N_ELEMENTS(WHERE(maximus.width_time(where(maximus.sample_t LE 0.01)) GT 4))
  ;;     158
  print,N_ELEMENTS(WHERE(maximus.width_time(where(maximus.sample_t LE 0.01)) GT 3))
  ;;     486
  print,N_ELEMENTS(WHERE(maximus.width_time(where(maximus.sample_t LE 0.01)) GT 4.946*0.25))
  ;;     10864
  print,N_ELEMENTS(WHERE(maximus.width_time(where(maximus.sample_t LE 0.01)) GT 4.946*0.5))
  ;;     1369

  cghistoplot,maximus.width_time(where(maximus.sample_t LE 0.01)),maxinput=2.5
  

  ;; For ChastonDB
  ;; cghistoplot,maximus.mode,maxinput=0.2 
  ;; cghistoplot,maximus.width_time(where(maximus.mode LE 0.1)),maxinput=4
  ;; cghistoplot,maximus.width_time(where(maximus.mode LE 0.2)),maxinput=4
  ;; cghistoplot,maximus.width_time(where(maximus.mode LE 0.01)),maxinput=4



END