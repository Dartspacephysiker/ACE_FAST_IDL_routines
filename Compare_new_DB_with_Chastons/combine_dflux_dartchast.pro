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
     CASE jj OF
      0: BEGIN
        rdf_dflux_fout,result,dat,out 
        restore, out
        save, dat,filename=out
        END
      1: BEGIN
        rdf_dflux_fout,result,dat1,out 
        restore, out 
        dat1=dat 
        save, dat1, filename=out
        END
      2: BEGIN
        rdf_dflux_fout,result,dat_SMOOTH,out 
        restore, out 
        dat_SMOOTH=dat 
        save, dat_SMOOTH, filename=out
        END
      3: BEGIN
        rdf_dflux_fout_as5,result,dat,out
        restore, out
        dat1=dat
        save, dat1, filename=out
        END
      ELSE: PRINT, "WHAT HAVE YOU DONE?! RDF_FLUX_OUT WILL NEVER BE ABLE TO HANDLE THIS!" 
     ENDCASE
;     if (jj EQ 0 ) then begin        
;     endif else begin 
;        if (jj eq 1 ) then begin
;        endif else begin
;           if (jj eq 2 ) then begin
;           endif
;        endelse
;     endelse
;     endif 
  endif
  
print, 'Saved ' + out


  return

end
