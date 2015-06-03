;First, we need the indices for all IMF ranges for both our DB and Chaston's

  date='20150402'
  dbDate = '02282015'

  dirs='all_IMF'
  ;; dirs=['duskward', 'dawnward']

  ;; plotSuff="Dartdb_" + dbDate 
  ;; plotDir="LaBelle_Bin_mtg--02042015/Chaston_2003_fig4a-d/"

  ;;hemisphere?
  hemi="North"
  ;; hemi="South"

  ;charERange?
  charERange=[4.0,4e3]

  ;altRange?
  altitudeRange=[0.0,5000.0]

  ;stability requirement?
  stableIMF = 0

  ;For Chaston inds
  get_inds_from_db,/DO_CHASTDB, $
                   CLOCKSTR='all_IMF', $
                   HEMI=hemi, $
                   MINMLT=0,MAXMLT=24, $
                   ALTITUDERANGE=altitudeRange,CHARERANGE=charERange, $
                   INDPREFIX='original_ChastDB--',STABLEIMF=stableIMF

  ;For Dartmouth inds
  get_inds_from_db, $
                   CLOCKSTR='all_IMF', $
                   HEMI=hemi, $
                   MINMLT=0,MAXMLT=24, $
                   ALTITUDERANGE=altitudeRange,CHARERANGE=charERange, $
                   INDPREFIX='DartDB_'+dbDate,STABLEIMF=stableIMF
