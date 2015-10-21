;variables to be used by interp_contplot.pro
COMMON ContVars, minMLT, maxMLT, minILAT, maxILAT

;***********************************************
;RESTRICTIONS ON CHASTON DATA
;(Originally from JOURNAL_Oct112013_orb_avg_plots_extended.pro)

;mu_0 = 4.0e-7 * !PI ;perm. of free space, for Poynt. est
mu_0 = 1 ;perm. of free space, for Poynt. est

minOrb=8100 ;8260 for Strangeway study
maxOrb=8500 ;8292 for Strangeway study
;nOrbits = maxOrb - minOrb + 1

minE = 4; 4 eV in Strangeway
maxE = 250; ~300 eV in Strangeway

minMLT = 9
maxMLT = 15

minILAT = 65
maxILAT = 85

min_magc = 10; Minimum current derived from mag data, in microA/m^2
max_negmagc = -10; Current must be less than this, if it's going to make the cut

;********************************************
;ACE data options

delay=660 ;Delay between ACE propagated data and ChastonDB data
          ;Bin recommends something like 11min

stableIMF=0S ;Set to a time (in minutes) over which IMF stability is required
includeNoConsecData=0 ;Setting this to 1 includes Chaston data for which  
                      ;there's no way to calculate IMF stability
                      ;Only valid for stableIMF GE 1
checkBothWays=0 ;

Bx_over_ByBz_Lim=0 ;Set this to the max ratio of Bx / SQRT(By*By + Bz*Bz)

;********************************************
;Variables for histos
;Bin sizes for 2d histos

;How to set angles? Note, clock angle is measured with
;Bz North at zero deg, ranging from -180<clock_angle<180
;Setting angle limits 45 and 135, for example, gives a 90-deg
;window for dawnward and duskward plots
angleLim1=45 ;in degrees
angleLim2=135;in degrees

;Bin sizes for 2D histos
binMLT=0.5
binILAT=1

;Which IMF clock angle are we doing?
;options are 'duskward', 'dawnward', 'bzNorth', 'bzSouth'
clockStr='dawnward'

;Set minimum allowable number of events for a histo bin to be displayed
maskMin=1


;********************************************
;Figure out both hemisphere and plot indices, 
;tap DBs, and setup output
IF minILAT GT 0 THEN hemStr='North' ELSE IF maxILAT LT 0 THEN hemStr='South' $
   ELSE BEGIN & printf,lun,"Which hemisphere?" & hemStr = '??' & ENDELSE

;Open file for text summary, if desired
;outputPlotSummary=0

;IF outputPlotSummary EQ 1 THEN $
;   OPENW,lun,plotDir+'fluxplots_'+hemStr+'_'+clockStr+plotSuff+hoyDia+'.txt',/GET_LUN $
;ELSE lun=-1                     ;-1 is lun for STDOUT
lun=-1

;Now run these to tap the databases and interpolate ACE data

@"get_chaston_ind.pro"
@"interp_mag_data.pro"
@"check_imf_stability.pro"

plot_i=cdbInterp_i(phiImf_ii)

;********************************************************
;WHICH ORBITS ARE UNIQUE?
uniqueOrbs_ii=UNIQ(maximus.orbit(plot_i),SORT(maximus.orbit(plot_i)))
;nOrbs=n_elements(uniqueOrbs_ii)
;printf,lun,"There are " + strtrim(nOrbs,2) + " unique orbits in the data you've provided for predominantly " + clockStr + " IMF."

;***********************************************
;Calculate Poynting flux estimate

POYNT_EST=maximus.DELTA_B * maximus.DELTA_E / mu_0

;********************************************
;Now time for data summary

printf,lun,""
printf,lun,"**********DATA SUMMARY**********"
printf,lun,"ACE data delay: " + strtrim(delay,2) + " seconds"
printf,lun,"IMF stability requirement: " + strtrim(stableIMF,2) + " minutes"
printf,lun,"Events per bin requirement: >= " +strtrim(maskMin,2)+" events"
printf,lun,"Screening parameters: [Min] [Max]"
printf,lun,"Mag current: " + strtrim(max_negmagc,2) + " " + strtrim(min_magc,2)
printf,lun,"MLT: " + strtrim(minMLT,2) + " " + strtrim(maxMLT,2)
printf,lun,"ILAT: " + strtrim(minILAT,2) + " " + strtrim(maxILAT,2)
printf,lun,"Hemisphere: " + hemStr
printf,lun,"IMF Predominance: " + clockStr
printf,lun,"Angle lim 1: " + strtrim(angleLim1,2)
printf,lun,"Angle lim 2: " + strtrim(angleLim2,2)
printf,lun,"Number of orbits used: " + strtrim(N_ELEMENTS(uniqueOrbs_ii),2)
printf,lun,"Total number of events used: " + strtrim(N_ELEMENTS(plot_i),2)
printf,lun,"Percentage of Chaston DB used: " + $
       strtrim((N_ELEMENTS(plot_i))/134925.0*100.0,2) + "%"

;********************************************************
;histo for current event based on clock angle

;cghistoplot,phiChast,$
;	xtickvalues=(indgen(5)*90-180),$
;	xtitle="Clock angle",$
;	title="> 10 microA/m^2 current events in northern hemisphere";,$output="NORTH_INTERP_clock_angle_cur_event_histo.png"

;********************************************************
;scatterplot of Poynting estimate vs. clock angle

;cgscatter2d,phiChast,$
;	poynt_est(cdbInterp_i),$
;	xtitle="Clock angle",ytitle="|E||B| (Poynting flux estimate)",$
;	title="Poynt flux est. vs. IMF angle in northern hemisphere--"+string(delay/60)+" min. delay",$
;	/ylog,yrange=[1.0e-5,1.0e-1],$
;	xrange=[-180,180];,$output="NORTH_INTERP_poynt_est_vs_clock_angle.png"

;********************************************************
;SCATTERPLOTS

;;For phi given by check_imf_stability
;cgscatter2d,maximus.mlt(cdbInterp_i),$
;	poynt_est(cdbInterp_i),$
;	xtitle="MLT", ytitle="|E||B| (Poynt flux est.)",$
;	title="Spread in latitude of Poynting flux for all phi"
;output="Poynt_vs_MLT_Phi_all_NORTH.png"
;;write_png,'Poynt_vs_MLT_Phi_all_NORTH.png',tvrd()
;
;cgscatter2d,maximus.mlt(cdbInterp_i),$
;	maximus.elec_energy_flux(cdbInterp_i),$
;	xtitle="MLT", ytitle="Electron [number?] flux",$
;	title="Spread in latitude of electron flux for all phi",$
;output="elecflux_vs_MLT_Phi_all_NORTH.png"
;;write_png,'elecflux_vs_MLT_Phi_all_NORTH.png',tvrd()
;

;********************************************************
;HISTOS

;For multiple plots on same page...
;!P.MULTI=[0,1,3] ;three plots vertically stacked

;First, create 2D histo of current events
h2dFlux_N=hist_2d(maximus.mlt(plot_i),$
	maximus.ilat(plot_i),$
        BIN1=binMLT,BIN2=binILAT,$
	MIN1=MINMLT,MIN2=MINILAT,$
	MAX1=MAXMLT,MAX2=MAXILAT)


;Now electrons
h2dEflux=hist2d(maximus.mlt(plot_i),$
	maximus.ilat(plot_i),$
	maximus.integ_elec_energy_flux(plot_i),$
	MIN1=MINMLT,MIN2=MINILAT,$
	MAX1=MAXMLT,MAX2=MAXILAT,$
        BINSIZE1=binMLT,BINSIZE2=binILAT,$
	OBIN1=h2d_ef_bins1,OBIN2=h2d_ef_bins2)

;Now Poynting flux
h2dPflux=hist2d(maximus.mlt(plot_i),$
	maximus.ilat(plot_i),$
	poynt_est(plot_i),$
	MIN1=MINMLT,MIN2=MINILAT,$
	MAX1=MAXMLT,MAX2=MAXILAT,$
        BINSIZE1=binMLT,BINSIZE2=binILAT,$
	OBIN1=h2d_ef_bins1,OBIN2=h2d_ef_bins2)


;Now averages of each
h2dEflux_av=h2dEflux
h2dEflux_av(where(h2dFlux_N NE 0))=h2dEflux(where(h2dFlux_N NE 0))/h2dFlux_N(where(h2dFlux_N NE 0))

h2dPflux_av=h2dPflux
h2dPflux_av(where(h2dFlux_N NE 0))=h2dPflux(where(h2dFlux_N NE 0))/h2dFlux_N(where(h2dFlux_N NE 0))

;If something screwy goes on, better take stock of it and alert user
IF n_elements(where(h2dEflux EQ 0)) NE n_elements(where(h2dFlux_N EQ 0)) THEN BEGIN & $
print,"Eflux has", n_elements(where(h2dEflux EQ 0))," elements that are zero, whereas Flux_N has", n_elements(where(h2dFlux_N EQ 0)),"." & $
print,"Sorry, can't plot anything meaningful." & ENDIF

IF n_elements(where(h2dPflux EQ 0)) NE n_elements(where(h2dFlux_N EQ 0)) THEN BEGIN & $
print,"Pflux has", n_elements(where(h2dPflux EQ 0))," elements that are zero, whereas Flux_N has", n_elements(where(h2dFlux_N EQ 0)),"." & $
print,"Sorry, can't plot anything meaningful." & ENDIF

;********************************************
;2D histo, weighted by eflux and averaged by number of events
;cgsurf,h2dEflux_av,h2d_ef_bins1,h2d_ef_bins2,/traditional
	;shades=bytscl(h2dEflux_av),shaded=1


;********************************************
;Courtesy of David Fanning

; This main program shows how to call the program and produce
; various types of output.

;print,"interp_contplot","h2dEflux_av"
;print,"interp_contplot","h2dPflux_av"
;print,"interp_contplot","h2dFlux_N"

;The mayic for getting log scale plots for Eflux
;h2dEflux_av(where(h2dEflux_av NE 0)) = ALOG10(h2dEflux_av(where(h2dEflux_av NE 0)))   
;Display the plots in a resizeable graphics window.
;cgWindow,'interp_contplot_polar',h2dEflux_av,"E flux for predominantly duskward IMF",Background='White', $
;          WTitle='Flux plots for northern hemi, duskward IMF'

;cgWindow,'interp_contplot_polar',h2dPflux_av,"Poynting flux for predominantly duskward IMF",Background='White', $
;          WTitle='Poynting Flux Plot'

;cgWindow,'interp_contplot_polar',h2dFlux_N,"# of events for predominantly duskward IMF",Background='White', $
;          WTitle='Flux number of events'

  
;;Create PostScript files.

psWidth=800

plotDir='Fluxplots/LOG_Eflux_Integ/'
plotsuff='_northern_duskward'

;Electrons
;cgPS_Open, plotDir + 'eflux' + plotsuff + '.ps'
;interp_contplot,h2dEflux_av,'Electron Flux' + plotsuff
;cgPS_Close
;
;;Create a PNG file with a width of 800 pixels.
;cgPS2Raster, plotDir + 'eflux' + plotsuff + '.ps', /PNG, Width=psWidth


;Poynting
;cgPS_Open, plotDir + 'pflux' + plotsuff + '.ps'
;interp_contplot,h2dPflux_av,'Poynting Flux' + plotsuff
;cgPS_Close
;  
;;Create a PNG file with a width of 800 pixels.
;cgPS2Raster, plotDir + 'pflux' + plotsuff + '.ps', /PNG, Width=psWidth


;Number of events
;cgPS_Open, plotDir + 'n_flux' + plotsuff + '.ps'
;interp_contplot,h2dFlux_N,'Number of Events' + plotsuff
;cgPS_Close

;cgPS2Raster, plotDir + 'n_flux' + plotsuff + '.ps', /PNG, Width=psWidth

  

