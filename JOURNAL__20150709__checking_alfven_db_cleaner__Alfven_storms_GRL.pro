
restore,'../database/dartdb/saves/Dartdb_20150611--500-16361_inc_lower_lats--maximus.sav'

maximus=resize_maximus(maximus,maximus_ind=6,max_for_ind=1.0e3,min_for_ind=10,/ONLY_ABSVALS)

these=where(maximus.delta_e GT 8.0e3 AND maximus.delta_e LT 20.0e3)
print,n_elements(these)

these=where(maximus.delta_e GT 8.0e3 AND maximus.delta_e LT 20.0e3)

cghistoplot,maximus.delta_e(these)


good_i=alfven_db_cleaner(maximus)

print,n_elements(good_i)