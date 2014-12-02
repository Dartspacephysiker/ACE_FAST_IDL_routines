;This script is for comparing the dflux outputs corresponding to every MagDC cal that we have available
;

;first, an array of all versions of the magcals:

interv=0

;array of magcal versions we have (Thanks, Jack [Vernetti]!)
versarr=['1.1','1.2','1.2.1.1','1.2.1.2','1.3','1.4','1.5','2.1','2.2','2.3','2.4','2.5','2.6','2.7','2.8','2.9']
;versarr=['2.6','2.7','2.8','2.9']

;for infile
drive='SPENCEdata2'
datadir='/'+drive+'/software/sdt/batch_jobs/Alfven_study/as5_14F/magcal_versions/output/'
basename='Dartmouth_as5_dflux_10000_'+STRCOMPRESS(interv,/REMOVE_ALL)+'_magcal_v'

;for outfile
outdir='/'+drive+'/Research/Cusp/ACE_FAST/Compare_new_DB_with_Chastons/txtoutput/magcal_versions/'
outbase='Dartmouth_dflux_1000_'+STRCOMPRESS(interv,/REMOVE_ALL)+'_magcal_v'

FOR i=0,N_ELEMENTS(versarr)-1 DO BEGIN & $
   curf=datadir+basename+versarr[i] & $
  outf=outdir+outbase+versarr[i]+'_max_tdiff0.016--check_c_10--time.txt' & $
;  outf=outdir+outbase+versarr[i]+'_max_tdiff0.016--time.txt' & $
  oname=outdir+outbase+versarr[i]+'.sav' & $
  ;print,curf & $
  ;print,outf & $

                                ;now make it happen--use keyword /only_alfvenic if you want to only check out alfvenic events
  compare_chastondbfile_dartdbfile_3,10000,interval=interv,max_tdiff=0.016,fname=curf,outdataf=outf,outname=oname,check_c=10,/only_alfven & $
ENDFOR