PRO JOURNAL__20150608__messing_around_with_stormOrbs_16150_69

  COMMON ContVars, minM, maxM, minI, maxI,binM,binI,minMC,maxNegMC

  minI=-85
  maxI=-50
  minM=0
  maxM=24
  minMC=10
  maxNegMC=-10

  dbFile='/SPENCEdata/Research/Cusp/database/dartdb/saves/Dartdb_20150608--16150-16169--maximus.sav'
  restore,dbFile

  good_i=get_chaston_ind(maximus,'OMNI',-1,ALTITUDERANGE=[1000,4000],CHARERANGE=[4,300])
  good_i=cgsetintersection(good_i,where(ABS(maximus.mag_current) GE 10))

  mu_0 = 4.0e-7 * !PI & POYNTEST=maximus.delta_b(good_i)*maximus.delta_e(good_i)* 1.0e-9 / mu_0 
  
  key_scatterplots_polarproj,just_plot_i=good_i,dbfile='/SPENCEdata/Research/Cusp/database/dartdb/saves/Dartdb_20150608--16150-16169--maximus.sav',/SOUTH,STRANS=80

END