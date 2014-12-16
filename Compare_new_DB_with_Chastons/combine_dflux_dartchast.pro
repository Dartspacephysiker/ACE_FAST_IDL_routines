pro combine_dflux_dartchast, orbit,jj, in_name=in, outname=out

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
;        rdf_dflux_fout_as5,result,dat,out
        rdf_stats_Dartmouth_as5_startstop_inc,result,dat,out
        restore, out
        dat1=dat
        save, dat1, filename=out
        END
      ELSE: PRINT, "WHAT HAVE YOU DONE?! RDF_FLUX_OUT WILL NEVER BE ABLE TO HANDLE THIS!" 
     ENDCASE
  endif
  
print, 'Saved ' + out


  return

end
