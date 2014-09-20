;run with @'load_combined_data'

fname=make_array(3,/STRING)
fname[0]='dflux_10000_0'
fname[1]='Dartmouth_dflux_10000_0'
fname[2]='Dartmouth_dflux_10000_0_NOSMOOTH'

for jj=0,2 do begin & $
   result=file_which('./',fname[jj]) & $
   if result then begin & $
      print, "fname: " + fname[jj] & $
      RESTORE, fname[jj] + '.sav' & $
   endif & $
endfor
