pro combine_dflux_10000_0




  j=10000

  fname=make_array(3,/STRING)
  fname[0]='dflux_10000_0'
  fname[1]='Dartmouth_dflux_10000_0'
  fname[2]='Dartmouth_dflux_10000_0_NOSMOOTH'

  filename=fname[0]
  print, "First file: " + fname[0]

  result=file_which('./',filename)
  if result then begin
     print, "File " + filename
     for jj=0,2 do begin
        filename=fname[jj]
        result=file_which('./',filename)
        if result then begin
           print,j,jj
           if (jj EQ 0 ) then begin
              rdf_dflux,result,dat 
              save, dat, filename=filename + ".sav"
           endif else begin 
              if (jj eq 1 ) then begin
                 rdf_dflux,result,dat1
                 save, dat1, filename=filename + ".sav"
              endif else begin
                 if (jj eq 2 ) then begin
                    rdf_dflux,result,dat_NOSMOOTH
                    save, dat_NOSMOOTH, filename=filename + ".sav"
                 endif
              endelse
           endelse
        endif 
        ;; if ( jj EQ 0 ) then begin
        ;;    print, "Making replicas of 'dat'"
        ;;    dats=replicate(dat, 3)
        ;; ;; endif
        ;; dats[jj] = dat
     endfor
  endif
  return
end
