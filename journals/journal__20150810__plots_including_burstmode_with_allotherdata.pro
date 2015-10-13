;2015/08/10
;It's time to see if the inclusion of these 12000 burst-mode Alfven events buys us anything
;To me it seems like the post-noon cusp lights up a lot more easily. (See plots in plots/20150810--burstmode)

plot_alfven_stats_imf_screening,maximus,clockstr='all_IMF',/orbtotplot,/include_burstdata, $
                                /orbfreqplot, orbfreqrange=[0.0,0.35], $
                                /orbcontribplot, orbcontribrange=[0,90], $
                                /chareplots, /logchareplot, charerange=[4,4000], $
                                /neventperorbplot, neventperorbrange=[0,10], $
                                /wholecap,plotprefix='20150810--burstmode_and_alldata/all_data_burstmode_test--orbs500-16361--chare_4-4000--'

plot_alfven_stats_imf_screening,maximus,clockstr='all_IMF',/orbtotplot,/include_burstdata, $
                                /orbfreqplot, orbfreqrange=[0.0,0.35], $
                                /orbcontribplot, orbcontribrange=[0,90], $
                                /chareplots, /logchareplot, charerange=[4,300], $
                                /neventperorbplot, neventperorbrange=[0,10], $
                                /neventperminplot, $
                                /wholecap,plotprefix='20150810--burstmode_and_alldata/all_data_burstmode_test--orbs500-16361--chare_4-300--'
