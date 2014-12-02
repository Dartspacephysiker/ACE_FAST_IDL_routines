;+
; NAME: combine_dflux_dartchast_burst.pro
;
;
;
; PURPOSE: Provided a file basename, this routine loops over filenames that
; begin with the basename and end with a digit in order to create a
; master output file with all data for a given orbit. 
; For example, alfven_stats_5 might output 10 files for a given orbit
; corresponding to different intervals. Rather than laboriously run
; compare_chastondbfile_dartdbfile_3.pro for each interval, why not do
; one comparison that incorporates all intervals?
;
; CATEGORY:
;
;
;
; CALLING SEQUENCE:
;
;
;
; INPUTS:
;
;
;
; OPTIONAL INPUTS:
;
;
;
; KEYWORD PARAMETERS:
;
;
;
; OUTPUTS:
;
;
;
; OPTIONAL OUTPUTS:
;
;
;
; COMMON BLOCKS:
;
;
;
; SIDE EFFECTS:
;
;
;
; RESTRICTIONS:
;
;
;
; PROCEDURE:
;
;
;
; EXAMPLE:
;
;
;
; MODIFICATION HISTORY:
;
;-
pro combine_dflux_dartchast_burst, orbit,jj, base_name=base, outname=out

  ;; fname=make_array(3,/STRING)
  ;; fname[0]='dflux_'+strcompress(orbit,/remove_all)+'_0'
  ;; fname[1]='Dartmouth_dflux_10000_0'
  ;; fname[2]='Dartmouth_dflux_10000_0_NOSMOOTH'

;;  in_name=fname[0]
print, "File: " + base

result=base

;  result=file_which('./',base_name)

i = 0
curfile = base + '_' + strcompress(i,/remove_all)
while ( file_test(curfile ) do begin

   if curfile then begin
;     curfile=file_which('./',base_name)
;     if curfile then begin
     print,orbit,jj
     CASE jj OF
      0: BEGIN
        rdf_dflux_fout,curfile,dat,out 
        restore, out
        save, dat,filename=out
        END
      1: BEGIN
        rdf_dflux_fout,curfile,dat1,out 
        restore, out 
        dat1=dat 
        save, dat1, filename=out
        END
      2: BEGIN
        rdf_dflux_fout,curfile,dat_SMOOTH,out 
        restore, out 
        dat_SMOOTH=dat 
        save, dat_SMOOTH, filename=out
        END
      3: BEGIN
        rdf_dflux_fout_as5,curfile,dat,out
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
 i++
 curfile = base + '_' + strcompress(i,/remove_all)
endwhile

  
print, 'Saved ' + out


  return

end
