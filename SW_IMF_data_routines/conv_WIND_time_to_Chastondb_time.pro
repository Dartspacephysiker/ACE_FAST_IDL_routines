;What a nuisance, but finally!!!!!

restore,dataDir + "/processed/idl_acedata.dat"
mag_jultime=julday(mag_prop.MONTH,mag_prop.day,mag_prop.year,mag_prop.HOUR,mag_prop.MINUTE,mag_prop.SEC)
mag_utc=(mag_jultime-2440587.5)*86400.0
