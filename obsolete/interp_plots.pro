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

minMLT = 6
maxMLT = 18

minILAT = 65
maxILAT = 85

min_magc = 10; Minimum current derived from mag data, in microA/m^2
max_negmagc = -10; Current must be less than this, if it's going to make the cut


;********************************************
;ACE data options

 delay=660 ;Delay between ACE propagated data and ChastonDB data
          ;Bin recommends something like 11min

stableIMF=3S ;Set to a time (in minutes) over which IMF stability is required
includeNoConsecData=0 ;Setting this to 1 includes Chaston data for which  
                      ;there's no way to calculate IMF stability
                      ;Only valid for stableIMF GE 1

Bx_over_ByBz_Lim=0 ;Set this to the max ratio of Bx / SQRT(By*By + Bz*Bz)


;********************************************
;Variables for histos
;Bin sizes for 2d histos

;Want medians instead of averages?
medPlot=0

;ELECTRONS
;Eflux max abs. value in interval, or integrated flux?
;NOTE: max value has negative values, which can mess with
;color bars
;options are "Integ" and "Max"
eFluxPlotType="Integ"
logEfPlot=1 ;Want log plots of e- flux?
absEFlux=1  ;Make E Flux plots absolute value?

;Poynting flux
logPfPlot=1  ;Want log plots of Poynting flux?
absPFlux=1 ;Make Poynting flux plots absolute value?

;Which IMF clock angle are we doing?
;options are 'duskward', 'dawnward', 'bzNorth', 'bzSouth'
IF batchMode EQ !NULL THEN clockStr='bzSouth'

;How to set angles? Note, clock angle is measured with
;Bz North at zero deg, ranging from -180<clock_angle<180
;Setting angle limits 45 and 135, for example, gives a 90-deg
;window for dawnward and duskward plots
angleLim1=45 ;in degrees
angleLim2=135;in degrees

;Bin sizes for 2D histos
binMLT=1
binILAT=2

;Set minimum allowable number of events for a histo bin to be displayed
maskMin=2

;********************************************
;Stuff for output
hoyDia=STRMID(SYSTIME(0), 4, 3) + "_" + $
       STRMID(SYSTIME(0), 9,1) + "_" + STRMID(SYSTIME(0), 22, 2)
plotDir='plots/'
plotType='Eflux_' +eFluxPlotType
plotType=(logEfPlot EQ 0) ? plotType : 'log' + plotType
plotType=(logPfPlot EQ 0) ? plotType : 'lopPf_' + plotType
plotDir=plotDir + plotType + '/'
;Want to make plots in plotDir?
savePlots=0
;Write output file with data params? Only possible if savePlots=1...
IF savePlots NE 0 THEN outputPlotSummary=1 $ ;Change to zero if not wanted
   ELSE outputPlotSummary=0


;********************************************
;Figure out both hemisphere and plot indices, 
;tap DBs, and setup output
IF minILAT GT 0 THEN hemStr='North' ELSE IF maxILAT LT 0 THEN hemStr='South' $
   ELSE BEGIN & printf,lun,"Which hemisphere?" & hemStr = '??' & ENDELSE

;Open file for text summary, if desired
IF outputPlotSummary EQ 1 THEN $
   OPENW,lun,plotDir+'fluxplots_'+hemStr+'_'+clockStr+'.txt',/GET_LUN $
ELSE lun=-1                     ;-1 is lun for STDOUT

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

;********************************************
;junk=where(cdbInterp_i(phi_dusk_ii) EQ cdbInterp_i(phi_dawn_ii))
IF n_elements(junk) EQ 1 THEN BEGIN & $
	IF junk NE -1 THEN PRINTF,LUN,"NO!!!! JUNK ISN'T JUNK!!!" & $
ENDIF
;********************************************************
;HISTOS

;First, histo to show where events are
h2dFluxN=hist_2d(maximus.mlt(plot_i),$
	maximus.ilat(plot_i),$
        BIN1=binMLT,BIN2=binILAT,$
	MIN1=MINMLT,MIN2=MINILAT,$
	MAX1=MAXMLT,MAX2=MAXILAT)

h2dFluxNTitle="Number of events"
h2dStr={h2dNStr, data: h2dFluxN, $
        title : "Number of events", $
        lim : [MIN(h2dFluxN),MAX(h2dFluxN)] }

;Now, electron flux

;Need log options?

h2dEStr={h2dNStr}

IF eFluxPlotType EQ "Integ" THEN BEGIN & $
   h2dEflux=hist2d(maximus.mlt(plot_i), $
                   maximus.ilat(plot_i),$
                   maximus.integ_elec_energy_flux(plot_i),$
                   MIN1=MINMLT,MIN2=MINILAT,$
                   MAX1=MAXMLT,MAX2=MAXILAT,$
                   BINSIZE1=binMLT,BINSIZE2=binILAT,$
                   OBIN1=h2d_ef_bins1,OBIN2=h2d_ef_bins2) & $
ENDIF ELSE IF eFluxPlotType EQ "Max" THEN BEGIN & $
   h2dEflux=hist2d(maximus.mlt(plot_i), $
                   maximus.ilat(plot_i),$
                   maximus.elec_energy_flux(plot_i),$
                   MIN1=MINMLT,MIN2=MINILAT,$
                   MAX1=MAXMLT,MAX2=MAXILAT,$
                   BINSIZE1=binMLT,BINSIZE2=binILAT,$
                   OBIN1=h2d_ef_bins1,OBIN2=h2d_ef_bins2) & $
ENDIF

h2dEflux_av=h2dEflux
h2dEflux_av(where(h2dStr[0].data NE 0))=h2dEflux(where(h2dStr[0].data NE 0))/h2dStr[0].data(where(h2dStr[0].data NE 0))
;Log plots desired?
logEstr=""
absEstr=""
IF absEFlux EQ 1 THEN BEGIN & $
   h2dEflux_av = ABS(h2dEflux_av) & $
   absEstr= "ABS" & $
ENDIF
IF logEfPlot EQ 1 THEN BEGIN & $
   logEstr="Log " & $
   h2dEflux_av(where(h2dEflux_av GT 0))=ALOG10(h2dEflux_av(where(h2dEflux_av GT 0))) & $
ENDIF
abslogEstr=absEstr + logEstr

h2dEfluxTitle= abslogEstr + "Electron Flux"

h2dEStr.title= abslogEstr + "Electron Flux"
h2dStr=[h2dStr,h2dEStr]

;Now Poynting Flux

h2dPStr={h2dNStr}

h2dPflux=hist2d(maximus.mlt(plot_i),$
	maximus.ilat(plot_i),$
	poynt_est(plot_i),$
	MIN1=MINMLT,MIN2=MINILAT,$
	MAX1=MAXMLT,MAX2=MAXILAT,$
        BINSIZE1=binMLT,BINSIZE2=binILAT,$
	OBIN1=h2d_ef_bins1,OBIN2=h2d_ef_bins2)

h2dPflux_av=h2dPflux
h2dPflux_av(where(h2dStr[0].data NE 0))=h2dPflux(where(h2dStr[0].data NE 0))/h2dStr[0].data(where(h2dStr[0].data NE 0))

;Log plots desired?
logPstr=""
absPstr=""
IF absPflux EQ 1 THEN BEGIN & $
   h2dPflux_av = ABS(h2dPflux_av) & $
   absPstr= "ABS" & $
ENDIF

IF logPfPlot EQ 1 THEN BEGIN & $
   logPstr="Log " & $
   h2dPflux_av(where(h2dPflux_av GT 0))=ALOG10(h2dPflux_av(where(h2dPflux_av GT 0))) & $
ENDIF
abslogPstr=absPstr + logPstr

h2dPStr.title= abslogEstr + "Poynting Flux (estimate)"
h2dPfluxTitle=abslogPstr + "Poynting Flux (estimate)"

h2dStr=[h2dStr,h2dPStr]

;Now do orbit data to show how many orbits contributed to each thingy,
;and a little extra tomfoolery is in order to get this right
;h2dOrbN is a 2d histo just like the others
;orbArr, on the other hand, is a 3D array, where the
;2D array pointed to is indexed by MLTbin and ILATbin. The contents of
;the 3D array are of the format [UniqueOrbs_ii index,MLT,ILAT]

h2dOrbN=INTARR(N_ELEMENTS(h2dStr[0].data(*,0)),N_ELEMENTS(h2dStr[0].data(0,*)))
orbArr=INTARR(N_ELEMENTS(uniqueorbs_ii),N_ELEMENTS(h2dStr[0].data(*,0)),N_ELEMENTS(h2dStr[0].data(0,*)))

h2dOrbStr={h2dNStr}

FOR j=0, N_ELEMENTS(uniqueorbs_ii)-1 DO BEGIN & $
   tempOrb=maximus.orbit(plot_i(uniqueOrbs_ii(j))) & $
   temp_ii=WHERE(maximus.orbit(plot_i) EQ tempOrb) & $
   h2dOrbTemp=hist_2d(maximus.mlt(plot_i(temp_ii)),$
                      maximus.ilat(plot_i(temp_ii)),$
                      BIN1=binMLT,BIN2=binILAT,$
                      MIN1=MINMLT,MIN2=MINILAT,$
                      MAX1=MAXMLT,MAX2=MAXILAT) & $
   orbARR[j,*,*]=h2dOrbTemp & $
   h2dOrbTemp(WHERE(h2dOrbTemp GT 0)) = 1 & $
   h2dOrbN += h2dOrbTemp & $
ENDFOR

h2dOrbNTitle="Number of Contributing Orbits"
h2dOrbStr.title="Number of Contributing Orbits"

h2dOrbStr.lim=[MIN(h2dOrbN),MAX(h2dOrbN)]

h2dStr=[h2dStr,h2dOrbStr]

;Make a mask for plots so that we can show where no data exists
h2dMaskStr={h2dNStr}
h2dMaskStr.data=h2dStr[0].data
h2dMaskStr.data(where(h2dStr[0].data LT maskMin))=255
h2dMaskStr.data(where(h2dStr[0].data GE maskMin))=0

;If something screwy goes on, better take stock of it and alert user
IF n_elements(where(h2dEflux EQ 0)) NE n_elements(where(h2dStr[0].data EQ 0)) THEN BEGIN & $
printf,lun,"Eflux has", n_elements(where(h2dEflux EQ 0))," elements that are zero, whereas eflux_n has", n_elements(where(h2dStr[0].data EQ 0)),"." & $
printf,lun,"Sorry, can't plot anything meaningful." & ENDIF

IF n_elements(where(h2dPflux EQ 0)) NE n_elements(where(h2dStr[0].data EQ 0)) THEN BEGIN & $
printf,lun,"Pflux has", n_elements(where(h2dPflux EQ 0))," elements that are zero, whereas pflux_n has", n_elements(where(h2dStr[0].data EQ 0)),"." & $
printf,lun,"Sorry, can't plot anything meaningful." & ENDIF  

;********************************************************
;Handle Plots all at once

;Make sure N events and mask are penultimate and ultimate arrays, respectively

h2dData=[[[h2dEflux_av]],[[h2dPflux_av]],[[h2dOrbN]],[[h2dFluxN]],[[h2dMask]]]
h2dTitle=[h2dEfluxTitle,$
          h2dPfluxTitle,$
          h2dOrbNTitle,$
          h2dFluxNTitle]

;{h2dStr, $
; h2dData : [[[h2dEflux_av]],[[h2dPflux_av]],[[h2dOrbN]],[[h2dFluxN]],[[h2dMask]]], $
; h2dTitle : [h2dEfluxTitle, h2dPfluxTitle, h2dOrbNTitle, h2dFluxNTitle], $
; h2dMaxMin : 


IF savePlots EQ 0 THEN BEGIN & $
   cgWindow, 'interp_contplot_multi', h2dData, h2dTitle, Background='White', $
             WTitle='Flux plots for ' + hemStr + 'ern Hemisphere, ' + clockStr + ' IMF' & $
ENDIF ELSE BEGIN & $
   CD, CURRENT=c & PRINTF,LUN, "Current directory is " + c + "/" + plotDir & $
   PRINTF,LUN, "Creating output files..." & $
   ;Create a PostScript file.
   cgPS_Open, plotDir + 'fluxplots_'+hemStr+'_'+clockStr+hoyDia+'.ps' & $
   interp_contplot_multi,h2dData,h2dTitle & $
   cgPS_Close & $
   ;Create a PNG file with a width of 800 pixels.
   cgPS2Raster, plotDir + 'fluxplots_'+hemStr+'_'+clockStr+hoyDia+'.ps', /PNG, Width=1000 & $
ENDELSE


;********************************************************
;OLD THINGS FOR SINGLE PLOTS FOLLOW HERE

;********************************************************
;histo for current event based on clock angle

;cghistoplot,phiChast,$
; xtickvalues=(indgen(5)*90-180),$
; xtitle="Clock angle",$
; title="> 10 microA/m^2 current events in "+hemStr+"ern hemisphere";,$output=hemStr+"_INTERP_clock_angle_cur_event_histo.png"

;********************************************************
;scatterplot of Poynting estimate vs. clock angle

;cgscatter2d,phiChast,$
; poynt_est(cdbInterp_i),$
; xtitle="Clock angle",ytitle="|E||B| (Poynting flux estimate)",$
; title="Poynt flux est. vs. IMF angle in "+hemStr+"ern hemisphere--"+strtrim(delay/60,2)+" min. delay",$
; /ylog,yrange=[1.0e-5,1.0e-1],$
; xrange=[-180,180];,$output=hemStr+"_INTERP_poynt_est_vs_clock_angle.png"

;********************************************************
;SCATTERPLOTS

;;For all phi
;cgscatter2d,maximus.mlt(cdbInterp_i),$
; poynt_est(cdbInterp_i),$
; xtitle="MLT", ytitle="|E||B| (Poynt flux est.)",$
; title="Spread in latitude of Poynting flux for all phi"
;output="Poynt_vs_MLT_Phi_all_'+hemStr+'.png"
;;write_png,'Poynt_vs_MLT_Phi_all_'+hemStr+'.png',tvrd()
;
;cgscatter2d,maximus.mlt(cdbInterp_i),$
; maximus.elec_energy_flux(cdbInterp_i),$
; xtitle="MLT", ytitle="Electron [number?] flux",$
; title="Spread in latitude of electron flux for all phi",$
;output="elecflux_vs_MLT_Phi_all_'+hemStr+'.png"
;;write_png,'elecflux_vs_MLT_Phi_all_'+hemStr+'.png',tvrd()
;
;;For phi based on clockStr
;window,0
;cgscatter2d,maximus.mlt(plot_i),$
; poynt_est(plot_i),$
; xtitle="MLT", ytitle="|E||B| (Poynt flux est.)",$
; title="Spread in latitude of Poynting flux for phiClock " + clockStr,$
;output="Poynt_vs_MLT_'+clockStr+'_'+hemStr+'.png"
;;write_png,'Poynt_vs_MLT_'+clockStr+'.png',tvrd()
;
;;window,2
;cgscatter2d,maximus.mlt(plot_i),$
; maximus.elec_energy_flux(plot_i),$
; xtitle="MLT", ytitle="Electron [number?] flux",$
; title="Spread in latitude of electron flux for phiClock " + clockStr,$
;output="elecflux_vs_MLT_'+clockStr+'_'+hemStr+'.png"
;;write_png,'elecflux_vs_MLT_' + clockStr + '_'+hemStr+'.png',tvrd()
;

