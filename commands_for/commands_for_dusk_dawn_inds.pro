;02/02/2015
;A quicker(?) way to make all the inds I want

PRO commands_for_dusk_dawn_inds

  date='03292015'

  hemi='North'

  ;dirs='all_IMF'
  ;; dirs=['dawn-north', 'dawn-south', 'dusk-north', 'dusk-south']
  ;; dirs=['duskward', 'dawnward','bzSouth','bzNorth']
  dirs=['duskward', 'dawnward']
  ;; dirs=['bzNorth','bzSouth']

;;  indSuff="Dartdb_" + dbDate + "--" + "pFlux_GE_0.1"
;;  indSuff="Dartdb_" + dbDate + "--" + "charE_3e2_to_5e3--"
  indSuff=date
  ;; indprf="LaBelle_Bin_mtg--" + date + "/Dartdb_" + dbDate

  ;; byMin?
  byMin=5.0 ;for bzNorth, bzSouth plots
  ;; byMin=3.0
  numOrbLim=!NULL
  ;; numOrbLim=2

  ;; whole cap?
  wc=!NULL
;;   wc=1

  ;;different delay?
  delay=!NULL
  ;;delay=1020

  ;;smooth IMF data?
  ;; smoothWindow=!NULL
  smoothWindow=5 ;in Min

  ;;stability requirement?
  ;; stableIMF = !NULL
  stableIMF = 1 ; in Min

  ;charERange?
;;  charERange=[250,5e3]
  charERange=[4,250]

  ;;Poynt range?
  poyntRange=!NULL
  ;; poyntRange=[1e-4,1e3]

  ;;altitude range?
  altitudeRange=[1000.0, 5000.0]
  
  ;; do it
  batch_get_inds_from_db,INDSUFFIX=indSuff,directions=dirs,maskmin=mskm, NUMORBLIM=numOrbLim, $
                                       WHOLECAP=wc,midnight=midn, BYMIN=byMin, $
                                       ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, POYNTRANGE=poyntRange, $
                                       SMOOTHWINDOW=smoothWindow, STABLEIMF=stableIMF, HEMI=hemi, MIRROR=mirror

END