;;2015/08/14 Combining burst and survey dbs, including tag so we can distinguish between burst and
;;survey data
pro combine_two_dbfiles__add_burst_tag,maximus,cdbTime,DBFILE1=dbFile1,DB_TFILE1=db_tFile1,DBFILE2=dbFile2,DB_TFILE2=db_tFile2, $
                        SAVE_COMBINED_FILE=save_combined_file,OUTFILE=outFile,OUT_TFILE=out_tFile

  date='20150814'

  loaddataDir = '/SPENCEdata/Research/Cusp/database/dartdb/saves/'
  defPref = "Dartdb_20150611--500-16361_inc_lower_lats"
  DBFile = defPref + "--maximus.sav"

  CDBTimeFile = defPref + "--cdbtime.sav"

  burstDBFile = 'Dartdb_20150810--1000-16361--maximus--burstmode.sav'
  burstDB_tFile = 'Dartdb_20150810--1000-16361--cdbtime--burstmode.sav'

  outDir='/SPENCEdata/Research/Cusp/database/dartdb/saves/'
  outPref = 'Dartdb_'+date+'--500-16361_inc_lower_lats--burst_1000-16361'
  outFile = outPref + '--maximus.sav'
  out_tFile = outPref + '--cdbtime.sav'

  ;;Load 'em up
  print,"DB File 1: " + dbFile

  restore,loaddataDir + cdbTimeFile 
  restore,loaddataDir + dbfile

  maximus1=maximus
  cdbTime1=cdbTime

  ;second DB file
  print,"DB File 2: " + burstDBFile

  restore,loaddataDir + burstDB_tFile
  restore,loaddataDir + burstDBFile

  maximus2=maximus
  cdbTime2=cdbTime

  ;;burst tag
  burst1 = MAKE_ARRAY(N_ELEMENTS(maximus1.time),/BYTE,VALUE=0)
  burst2 = MAKE_ARRAY(N_ELEMENTS(maximus2.time),/BYTE,VALUE=1)

  ;sort 'em
  sort_i = SORT([cdbTime1,cdbTime2])

  ;save 'em
  cdbTime=([cdbTime1,cdbTime2])(sort_i)

  maximus={orbit:([maximus1.orbit,maximus2.orbit])(sort_i),$
           alfvenic:([maximus1.alfvenic,maximus2.alfvenic])(sort_i),$
           TIME:([maximus1.time,maximus2.time])(sort_i),$
           ALT:([maximus1.alt,maximus2.alt])(sort_i),$
           MLT:([maximus1.mlt,maximus2.mlt])(sort_i),$
           ILAT:([maximus1.ilat,maximus2.ilat])(sort_i),$
           MAG_CURRENT:([maximus1.MAG_CURRENT,maximus2.MAG_CURRENT])(sort_i),$
           ESA_CURRENT:([maximus1.ESA_CURRENT,maximus2.ESA_CURRENT])(sort_i),$
           ELEC_ENERGY_FLUX:([maximus1.ELEC_ENERGY_FLUX,maximus2.ELEC_ENERGY_FLUX])(sort_i),$
           INTEG_ELEC_ENERGY_FLUX:([maximus1.INTEG_ELEC_ENERGY_FLUX,maximus2.INTEG_ELEC_ENERGY_FLUX])(sort_i),$
           EFLUX_LOSSCONE_INTEG:([maximus1.EFLUX_LOSSCONE_INTEG,maximus2.EFLUX_LOSSCONE_INTEG])(sort_i),$
           total_eflux_integ:([maximus1.total_eflux_integ,maximus2.total_eflux_integ])(sort_i),$
           max_chare_losscone:([maximus1.max_chare_losscone,maximus2.max_chare_losscone])(sort_i),$
           max_chare_total:([maximus1.max_chare_total,maximus2.max_chare_total])(sort_i),$
           ION_ENERGY_FLUX:([maximus1.ION_ENERGY_FLUX,maximus2.ION_ENERGY_FLUX])(sort_i),$
           ION_FLUX:([maximus1.ION_FLUX,maximus2.ION_FLUX])(sort_i),$
           ION_FLUX_UP:([maximus1.ION_FLUX_UP,maximus2.ION_FLUX_UP])(sort_i),$
           INTEG_ION_FLUX:([maximus1.INTEG_ION_FLUX,maximus2.INTEG_ION_FLUX])(sort_i),$
           INTEG_ION_FLUX_UP:([maximus1.INTEG_ION_FLUX_UP,maximus2.INTEG_ION_FLUX_UP])(sort_i),$
           CHAR_ION_ENERGY:([maximus1.CHAR_ION_ENERGY,maximus2.CHAR_ION_ENERGY])(sort_i),$
           WIDTH_TIME:([maximus1.WIDTH_TIME,maximus2.WIDTH_TIME])(sort_i),$
           WIDTH_X:([maximus1.WIDTH_X,maximus2.WIDTH_X])(sort_i),$
           DELTA_B:([maximus1.DELTA_B,maximus2.DELTA_B])(sort_i),$
           DELTA_E:([maximus1.DELTA_E,maximus2.DELTA_E])(sort_i),$
           SAMPLE_T:([maximus1.SAMPLE_T,maximus2.SAMPLE_T])(sort_i),$
           MODE:([maximus1.MODE,maximus2.MODE])(sort_i),$
           PROTON_FLUX_UP:([maximus1.PROTON_FLUX_UP,maximus2.PROTON_FLUX_UP])(sort_i),$
           PROTON_CHAR_ENERGY:([maximus1.PROTON_CHAR_ENERGY,maximus2.PROTON_CHAR_ENERGY])(sort_i),$
           OXY_FLUX_UP:([maximus1.OXY_FLUX_UP,maximus2.OXY_FLUX_UP])(sort_i),$
           OXY_CHAR_ENERGY:([maximus1.OXY_CHAR_ENERGY,maximus2.OXY_CHAR_ENERGY])(sort_i),$
           HELIUM_FLUX_UP:([maximus1.HELIUM_FLUX_UP,maximus2.HELIUM_FLUX_UP])(sort_i),$
           HELIUM_CHAR_ENERGY:([maximus1.HELIUM_CHAR_ENERGY,maximus2.HELIUM_CHAR_ENERGY])(sort_i),$
           SC_POT:([maximus1.SC_POT,maximus2.SC_POT])(sort_i),$
           L_PROBE:([maximus1.L_PROBE,maximus2.L_PROBE])(sort_i),$
           MAX_L_PROBE:([maximus1.MAX_L_PROBE,maximus2.MAX_L_PROBE])(sort_i),$
           MIN_L_PROBE:([maximus1.MIN_L_PROBE,maximus2.MIN_L_PROBE])(sort_i),$
           MEDIAN_L_PROBE:([maximus1.MEDIAN_L_PROBE,maximus2.MEDIAN_L_PROBE])(sort_i),$
           START_TIME:([maximus1.START_TIME,maximus2.START_TIME])(sort_i),$
           STOP_TIME:([maximus1.STOP_TIME,maximus2.STOP_TIME])(sort_i),$
           TOTAL_ELECTRON_ENERGY_DFLUX_SINGLE:([maximus1.TOTAL_ELECTRON_ENERGY_DFLUX_SINGLE,maximus2.TOTAL_ELECTRON_ENERGY_DFLUX_SINGLE])(sort_i),$
           TOTAL_ELECTRON_ENERGY_DFLUX_MULTIPLE_TOT:([maximus1.TOTAL_ELECTRON_ENERGY_DFLUX_MULTIPLE_TOT,maximus2.TOTAL_ELECTRON_ENERGY_DFLUX_MULTIPLE_TOT])(sort_i),$
           TOTAL_ALFVEN_ELECTRON_ENERGY_DFLUX:([maximus1.TOTAL_ALFVEN_ELECTRON_ENERGY_DFLUX,maximus2.TOTAL_ALFVEN_ELECTRON_ENERGY_DFLUX])(sort_i),$
           TOTAL_ION_OUTFLOW_SINGLE:([maximus1.TOTAL_ION_OUTFLOW_SINGLE,maximus2.TOTAL_ION_OUTFLOW_SINGLE])(sort_i),$
           TOTAL_ION_OUTFLOW_MULTIPLE_TOT:([maximus1.TOTAL_ION_OUTFLOW_MULTIPLE_TOT,maximus2.TOTAL_ION_OUTFLOW_MULTIPLE_TOT])(sort_i),$
           TOTAL_ALFVEN_ION_OUTFLOW:([maximus1.TOTAL_ALFVEN_ION_OUTFLOW,maximus2.TOTAL_ALFVEN_ION_OUTFLOW])(sort_i),$
           TOTAL_UPWARD_ION_OUTFLOW_SINGLE:([maximus1.TOTAL_UPWARD_ION_OUTFLOW_SINGLE,maximus2.TOTAL_UPWARD_ION_OUTFLOW_SINGLE])(sort_i),$
           TOTAL_UPWARD_ION_OUTFLOW_MULTIPLE_TOT:([maximus1.TOTAL_UPWARD_ION_OUTFLOW_MULTIPLE_TOT,maximus2.TOTAL_UPWARD_ION_OUTFLOW_MULTIPLE_TOT])(sort_i),$
           TOTAL_ALFVEN_UPWARD_ION_OUTFLOW:([maximus1.TOTAL_ALFVEN_UPWARD_ION_OUTFLOW,maximus2.TOTAL_ALFVEN_UPWARD_ION_OUTFLOW])(sort_i), $
           BURST:([burst1,burst2])(sort_i)}

  ;check 'em
  IF ARRAY_EQUAL(sort(cdbTime),indgen(n_elements(cdbTime),/L64)) THEN PRINT, "They're equal!"

  PRINT,'Saving...'
  PRINT,'OUTFILE: ' + outFile
  PRINT,'OUT_TFILE: ' + out_tFile

  save,maximus,filename=outDir+outFile
  save,cdbTime,filename=outDir+out_tFile

  RETURN

END
