pro combine_dflux_dartchast, orbit,jj, in_name=in, outname=out

  ;; fname=make_array(3,/STRING)
  ;; fname[0]='dflux_'+strcompress(orbit,/remove_all)+'_0'
  ;; fname[1]='Dartmouth_dflux_10000_0'
  ;; fname[2]='Dartmouth_dflux_10000_0_NOSMOOTH'

;;  in_name=fname[0]
  print, "File: " + in

  result=in

;  result=file_which('./',in_name)
  if result then begin
;     result=file_which('./',in_name)
;     if result then begin
     print,orbit,jj
     if (jj EQ 0 ) then begin
        rdf_dflux_fout,result,dat,out
        restore, out
        save, dat, filename=out
     endif else begin 
        if (jj eq 1 ) then begin
           rdf_dflux_fout,result,dat1,out
           restore, out
           dat1=dat
           save, dat1, filename=out
        endif else begin
           if (jj eq 2 ) then begin
              rdf_dflux_fout,result,dat_SMOOTH,out
              restore, out
              dat_SMOOTH=dat
              save, dat_SMOOTH, filename=out
           endif
        endelse
     endelse
;     endif 
  endif
  
print, 'Saved ' + out


  return

end
