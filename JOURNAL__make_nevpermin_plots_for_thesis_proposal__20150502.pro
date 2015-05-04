;Saturday night...

plot_alfven_stats_imf_screening,CLOCKSTR="duskward",altituderange=[1000,5000],charerange=[4,300],BYMIN=5,/NEVENTPERMINPLOT, $
                                SMOOTHWINDOW=5,/del_ps,/NOPLOTINTEGRAL 

plot_alfven_stats_imf_screening,CLOCKSTR="dawnward",altituderange=[1000,5000],charerange=[4,300],BYMIN=5,/NEVENTPERMINPLOT, $
                                SMOOTHWINDOW=5,/del_ps,/NOPLOTINTEGRAL

plot_alfven_stats_imf_screening,CLOCKSTR="all_IMF",altituderange=[1000,5000],charerange=[4,300],BYMIN=0,/NEVENTPERMINPLOT, $
                                SMOOTHWINDOW=5,STABLEIMF=0,/del_ps,/NOPLOTINTEGRAL

plot_alfven_stats_imf_screening,CLOCKSTR="bzNorth",altituderange=[1000,5000],charerange=[4,300],BZMIN=2,BYMIN=0,/NEVENTPERMINPLOT, $
                                SMOOTHWINDOW=5,/del_ps,/NOPLOTINTEGRAL 

plot_alfven_stats_imf_screening,CLOCKSTR="bzSouth",altituderange=[1000,5000],charerange=[4,300],BZMIN=2,BYMIN=0,/NEVENTPERMINPLOT,$
                                SMOOTHWINDOW=5,/del_ps,/NOPLOTINTEGRAL

