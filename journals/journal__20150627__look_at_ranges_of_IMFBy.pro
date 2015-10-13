;+
;Looking at the way Alfvén events move if we restrict By to certain ranges, like 0-5,5-10,10-15,15-20
;-

PRO JOURNAL__20150627__look_at_ranges_of_IMFBy

  plot_alfven_stats_imf_screening,clockstr='duskward',bymin=0,bymax=5,/nplots,charerange=[4,300],SATELLITE='OMNI'
  plot_alfven_stats_imf_screening,clockstr='dawnward',bymin=0,bymax=5,/nplots,charerange=[4,300],SATELLITE='OMNI'

  plot_alfven_stats_imf_screening,clockstr='duskward',bymin=5,bymax=10,/nplots,charerange=[4,300],SATELLITE='OMNI'
  plot_alfven_stats_imf_screening,clockstr='dawnward',bymin=5,bymax=10,/nplots,charerange=[4,300],SATELLITE='OMNI'

  plot_alfven_stats_imf_screening,clockstr='duskward',bymin=10,bymax=15,/nplots,charerange=[4,300],SATELLITE='OMNI'
  plot_alfven_stats_imf_screening,clockstr='dawnward',bymin=10,bymax=15,/nplots,charerange=[4,300],SATELLITE='OMNI'

  plot_alfven_stats_imf_screening,clockstr='duskward',bymin=15,bymax=20,/nplots,charerange=[4,300],SATELLITE='OMNI'
  plot_alfven_stats_imf_screening,clockstr='dawnward',bymin=15,bymax=20,/nplots,charerange=[4,300],SATELLITE='OMNI'

  plot_alfven_stats_imf_screening,clockstr='duskward',bymin=20,bymax=40,/nplots,charerange=[4,300],SATELLITE='OMNI'
  plot_alfven_stats_imf_screening,clockstr='dawnward',bymin=20,bymax=40,/nplots,charerange=[4,300],SATELLITE='OMNI'

  plot_alfven_stats_imf_screening,clockstr='duskward',bymin=10,bymax=20,/nplots,charerange=[4,300],SATELLITE='OMNI',/WHOLECAP
  plot_alfven_stats_imf_screening,clockstr='dawnward',bymin=10,bymax=20,/nplots,charerange=[4,300],SATELLITE='OMNI',/WHOLECAP

END
