;;2015/08/11 
;; A CURIOSITY: maximus.eflux_losscone_integ is NEGATIVE in the Southern hemisphere, and POSITIVE in the Northern hemisphere!
 
;;******************************
;;EFLUX_LOSSCONE_INTEGRATED
;;Northern hemi
plot_alfven_stats_imf_screening,/enumflplots,/logavgplot,/logenumflplot,/wholecap,clockstr='all_IMF',enumflplottype='eflux_losscone_integ',enumflplotrange=[2,4],min_nevents=3,/nonegenumfl,hemi='north',smoothwindow=5,bymin=3,/include_burstdata

plot_alfven_stats_imf_screening,/enumflplots,/logavgplot,/logenumflplot,/wholecap,clockstr='duskward',enumflplottype='eflux_losscone_integ',enumflplotrange=[2,4],min_nevents=3,/nonegenumfl,hemi='north',smoothwindow=5,bymin=3,/include_burstdata

plot_alfven_stats_imf_screening,/enumflplots,/logavgplot,/logenumflplot,/wholecap,clockstr='dawnward',enumflplottype='eflux_losscone_integ',enumflplotrange=[2,4],min_nevents=3,/nonegenumfl,hemi='north',smoothwindow=5,bymin=3,/include_burstdata

;;now Southern hemi
plot_alfven_stats_imf_screening,/enumflplots,/logavgplot,/logenumflplot,/wholecap,clockstr='all_IMF',enumflplottype='eflux_losscone_integ',enumflplotrange=[2,4],min_nevents=3,/nonegenumfl,hemi='south',smoothwindow=5,bymin=3,/include_burstdata

plot_alfven_stats_imf_screening,/enumflplots,/logavgplot,/logenumflplot,/wholecap,clockstr='duskward',enumflplottype='eflux_losscone_integ',enumflplotrange=[2,4],min_nevents=3,/noposenumfl,hemi='south',smoothwindow=5,bymin=3,/include_burstdata

plot_alfven_stats_imf_screening,/enumflplots,/logavgplot,/logenumflplot,/wholecap,clockstr='dawnward',enumflplottype='eflux_losscone_integ',enumflplotrange=[2,4],min_nevents=3,/noposenumfl,hemi='south',smoothwindow=5,bymin=3,/include_burstdata


;;******************************
;;ESA_CURRENT/ELECTRON NUMBER FLUX
plot_alfven_stats_imf_screening,/enumflplots,/logavgplot,/logenumflplot,/wholecap,clockstr='all_IMF',enumflplottype='esa_number_flux',enumflplotrange=[7,9.4],min_nevents=10,/noposenumfl,/include_burstdata

plot_alfven_stats_imf_screening,/enumflplots,/logavgplot,/logenumflplot,/wholecap,clockstr='duskward',enumflplottype='esa_number_flux',enumflplotrange=[7,9.4],min_nevents=3,/noposenumfl,bymin=4,/include_burstdata

plot_alfven_stats_imf_screening,/enumflplots,/logavgplot,/logenumflplot,/wholecap,clockstr='dawnward',enumflplottype='esa_number_flux',enumflplotrange=[7,9.4],min_nevents=3,/noposenumfl,bymin=4,/include_burstdata

plot_alfven_stats_imf_screening,/enumflplots,/logavgplot,/logenumflplot,/wholecap,clockstr='all_IMF',enumflplottype='esa_number_flux',enumflplotrange=[7,9.4],min_nevents=10,/nonegenumfl,/include_burstdata,hemi='south'

plot_alfven_stats_imf_screening,/enumflplots,/logavgplot,/logenumflplot,/wholecap,clockstr='duskward',enumflplottype='esa_number_flux',enumflplotrange=[7,9.4],min_nevents=3,/nonegenumfl,bymin=4,/include_burstdata,hemi='south'

plot_alfven_stats_imf_screening,/enumflplots,/logavgplot,/logenumflplot,/wholecap,clockstr='dawnward',enumflplottype='esa_number_flux',enumflplotrange=[7,9.4],min_nevents=3,/nonegenumfl,bymin=4,/include_burstdata,hemi='south'


