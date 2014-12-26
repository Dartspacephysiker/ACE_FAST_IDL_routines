PRO plot_fast_crossings,do_gif=no_gif
  
  @startup
  
  orbits=[2030,2057,6535,9000,10000]
  
  outdir='/SPENCEdata2/Research/Cusp/ACE_FAST/Compare_new_DB_with_Chastons/post_AGU_2014_various/'


  FOR i=0,n_elements(orbits)-1 DO BEGIN
     IF KEYWORD_SET(no_gif) THEN plot_fa_crossing, orbit=orbits[i] ELSE plot_fa_crossing, orbit=orbits[i], gif=outdir+'FAST_orbit_'+strcompress(orbits[i],/remove_all)+'--trajectory.gif'
  ENDFOR

END

