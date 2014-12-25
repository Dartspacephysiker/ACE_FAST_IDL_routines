PRO script_make_chast_histo,chast_width_dat,orbit,max_val,chast_histodata

cghistoplot,chast_width_dat,binsize=0.1,POLYCOLOR='navy',histdata=chast_histodata,layout=[2,1,1],/line_fill,xtitle="Current width (t)",title="Chaston db, orbit "+strcompress(orbit,/remove_all),ytitle='Number of occurrences',max_value=FLOAT(max_val),backcolorname='WHITE'

END
