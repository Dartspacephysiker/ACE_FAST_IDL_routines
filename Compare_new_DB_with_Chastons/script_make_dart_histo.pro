PRO script_make_dart_histo,dart_width_dat,orbit,max_val,dart_histodata

cghistoplot,dart_width_dat,binsize=0.1,POLYCOLOR='forest green',histdata=dart_histodata,layout=[2,1,2],/line_fill,xtitle="Current width (t)",title="Dart db, orbit "+strcompress(orbit,/remove_all),ytitle='Number of occurrences',max_value=max_val,backcolorname='WHITE'

END
