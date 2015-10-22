;variables to be used by interp_contplot.pro
COMMON ContVars, minMLT, maxMLT, minILAT, maxILAT,binMLT,binILAT

!EXCEPT=0
;***********************************************
tempSave=0

;Want to make plots in plotDir?
savePlots=1

saveRaw=0; save raw data plots?
saveRawDir="testcode/laTEST/"
;Write output file with data params? Only possible if savePlots=1...
IF savePlots NE 0 THEN outputPlotSummary=0 $ ;Change to zero if not wanted
   ELSE outputPlotSummary=0

;Write plot data output for Bin?

noPlots=0 ;turn off plots, if just outputting data
writeHDF5=0
writeASCII=0
writeProcessedH2d=0 ;Use this to output processed, histogrammed data

;********************************************
;Variables for histos
;Bin sizes for 2d histos

;Want medians instead of averages?
medPlot=0

polarPlot=1 ;do Polar plots instead?

nPlots=0 ; do num events plots?
ePlots = 0 ;electron flux plots?
  eFluxPlotType="Integ" ;options are "Integ" and "Max"
pPlots = 0 ;Poynting flux [estimate] plots?
iPlots = 0 ;ion Plots?
orbPlot= 1 ;Contributing orbits plot?
orbTotPlot= 0 ;"Total orbits considered" plot?
orbFreqPlot= 0 ;Contributing/total orbits plot?

;Which IMF clock angle are we doing?
;options are 'duskward', 'dawnward', 'bzNorth', 'bzSouth', and 'all_IMF'
IF batchMode EQ !NULL THEN clockStr='dawnward'

;How to set angles? Note, clock angle is measured with
;Bz North at zero deg, ranging from -180<clock_angle<180
;Setting angle limits 45 and 135, for example, gives a 90-deg
;window for dawnward and duskward plots
IF clockStr NE "all_IMF" THEN BEGIN & $
   angleLim1=45 &  $            ;in degrees
   angleLim2=135 & $            ;in degrees
ENDIF ELSE BEGIN & $
   angleLim1=180 & $            ;for doing all IMF
   angleLim2=180 & $
ENDELSE

;Bin sizes for 2D histos
binMLT=0.5
binILAT=2

;Set minimum allowable number of events for a histo bin to be displayed
maskMin=1

;######ELECTRONS
;Eflux max abs. value in interval, or integrated flux?
;NOTE: max value has negative values, which can mess with
;color bars

logEfPlot=1 ;Want log plots of e- flux?
absEFlux=1 ;Make E Flux plots absolute value?
;For linear or log EFlux plotrange
IF (~logEfPlot) THEN customERange=[-500000,500000] ELSE customERange=[1,5]

;######Poynting flux
logPfPlot=0  ;Want log plots of Poynting flux?
absPFlux=0 ;Make Poynting flux plots absolute value?
;For linear or log PFlux plotrange
IF (~logPfPlot) THEN customPRange=[0,3] ELSE customPRange=[-1,0.5]

;######Ion flux (up)
logIonFluxPlot=0
absIonFlux=0
;For linear or log ion flux plotrange
IF (~logIonFluxPlot) THEN customIonRange=[0,1.5e8] ELSE customIonRange=[1,8.5]

;######Oxy flux
logOFluxPlot=0
absOFlux=0
;For linear or log ion flux plotrange
;IF logOFluxPlot EQ 0 THEN customORange=[0,1e4] ELSE customRange=ALOG10([0,1e4]

;***********************************************
;RESTRICTIONS ON CHASTON DATA
;(Originally from JOURNAL_Oct112013_orb_avg_plots_extended.pro)

mu_0 = 4.0e-7 * !PI ;perm. of free space, for Poynt. est
;mu_0 = 1 ;perm. of free space, for Poynt. est

minOrb=8100 ;8260 for Strangeway study
maxOrb=8500 ;8292 for Strangeway study
;nOrbits = maxOrb - minOrb + 1

minE = 4; 4 eV in Strangeway
maxE = 250; ~300 eV in Strangeway

minMLT = 9
maxMLT = 15

minILAT = 68
maxILAT = 84

min_magc = 10; Minimum current derived from mag data, in microA/m^2
max_negmagc = -10; Current must be less than this, if it's going to make the cut


;********************************************
;satellite data options

satellite="wind_ACE" ;either "ACE", "wind", or "wind_ACE"

delay=660 ;Delay between ACE propagated data and ChastonDB data
          ;Bin recommends something like 11min

stableIMF=0S ;Set to a time (in minutes) over which IMF stability is required
includeNoConsecData=0 ;Setting this to 1 includes Chaston data for which  
                      ;there's no way to calculate IMF stability
                      ;Only valid for stableIMF GE 1
checkBothWays=0 ;

Bx_over_ByBz_Lim=0 ;Set this to the max ratio of Bx / SQRT(By*By + Bz*Bz)

;********************************************
;Stuff for output
hoyDia= "_" + STRMID(SYSTIME(0), 4, 3) + "_" + $
       STRMID(SYSTIME(0), 8,2) + "_" + STRMID(SYSTIME(0), 22, 2)
plotDir='plots/combined_Chast_Dart_db/'
IF medPlot GT 0 THEN plotSuff = "_med" ELSE plotSuff = "_avg"
plotType='Eflux_' +eFluxPlotType
plotType=(logEfPlot EQ 0) ? plotType : 'log' + plotType
plotType=(logPfPlot EQ 0) ? plotType : 'logPf_' + plotType
plotDir=(polarPlot) ? plotDir + "polar/" + plotType + '/' : plotDir + plotType

;********************************************
;Figure out both hemisphere and plot indices, 
;tap DBs, and setup output
IF minILAT GT 0 THEN hemStr='North' ELSE IF maxILAT LT 0 THEN hemStr='South' $
   ELSE BEGIN & printf,lun,"Which hemisphere?" & hemStr = '??' & ENDELSE

;Open file for text summary, if desired
IF (outputPlotSummary) THEN $
   OPENW,lun,plotDir+'fluxplots_'+hemStr+'_'+clockStr+plotSuff+"_"+strtrim(stableIMF,2)+"stable"+satellite+"_"+hoyDia+'.txt',/GET_LUN $
ELSE lun=-1                     ;-1 is lun for STDOUT

;Now run these to tap the databases and interpolate satellite data

@"get_chaston_ind.pro"
@"interp_mag_data.pro"
@"check_imf_stability.pro"

plot_i=cdbInterp_i(phiImf_ii)

;********************************************************
;WHICH ORBITS ARE UNIQUE?
uniqueOrbs_ii=UNIQ(maximus.orbit(plot_i),SORT(maximus.orbit(plot_i)))
nOrbs=n_elements(uniqueOrbs_ii)
printf,lun,"There are " + strtrim(nOrbs,2) + " unique orbits in the data you've provided for predominantly " + clockStr + " IMF."

;***********************************************
;Calculate Poynting flux estimate

;1.0e-9 to take stock of delta_b being recordin in nT
POYNT_EST=maximus.DELTA_B * maximus.DELTA_E * 1.0e-9 / mu_0 
goodpoynt=where(poynt_est(plot_i) GT 0)
plot_i=plot_i(goodpoynt)
;********************************************
;Now time for data summary

printf,lun,""
printf,lun,"**********DATA SUMMARY**********"
printf,lun,satellite+" satellite data delay: " + strtrim(delay,2) + " seconds"
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
;; printf,lun,"Percentage of Chaston DB used: " + $
;;        strtrim((N_ELEMENTS(plot_i))/134925.0*100.0,2) + "%"
printf,lun,"Percentage of current DB used: " + $
       strtrim((N_ELEMENTS(plot_i))/FLOAT(n_elements(maximus.orbit))*100.0,2) + "%"

;********************************************
;junk=where(cdbInterp_i(phi_dusk_ii) EQ cdbInterp_i(phi_dawn_ii))
;IF n_elements(junk) EQ 1 THEN BEGIN & $
;	IF junk NE -1 THEN PRINTF,LUN,"NO!!!! JUNK ISN'T JUNK!!!" & $
;ENDIF
;********************************************************
;HISTOS


;########Flux_N and Mask########
;First, histo to show where events are
h2dFluxN=hist_2d(maximus.mlt(plot_i),$
	maximus.ilat(plot_i),$
        BIN1=binMLT,BIN2=binILAT,$
	MIN1=MINMLT,MIN2=MINILAT,$
	MAX1=MAXMLT,MAX2=MAXILAT)

h2dFluxNTitle="Number of events"
IF (writeASCII) OR (writeHDF5) OR (polarPlot) OR (saveRaw) THEN BEGIN & $
  dataName="nEvents_" & $
  dataRawPtr=PTR_NEW() & $
ENDIF

h2dStr={h2dStr, data: DOUBLE(h2dFluxN), $
        title : "Number of events", $
        lim : DOUBLE([MIN(h2dFluxN),MAX(h2dFluxN)]) }

;Make a mask for plots so that we can show where no data exists
h2dMaskStr={h2dStr}
h2dMaskStr.data=h2dStr.data
h2dMaskStr.data(where(h2dStr.data LT maskMin,/NULL))=255
h2dMaskStr.data(where(h2dStr.data GE maskMin,NULL))=0
h2dMaskStr.title="Histogram mask"

IF (writeASCII) OR (writeHDF5) OR (polarPlot) OR (saveRaw) THEN BEGIN & $
  dataName=[dataName,"histoMask_"] & $
  dataRawPtr=[dataRawPtr,PTR_NEW()] & $
ENDIF

IF (nPlots) THEN h2dStr=[h2dStr,TEMPORARY(h2dMaskStr)] ELSE h2dStr = TEMPORARY(h2dMaskStr)

;h2dStr={h2dStr, data : DBLARR(N_ELEMENTS(h2dFluxN(*,0)),N_ELEMENTS(h2dFluxN(0,*))), title : "", lim : DBLARR(2) }


;########Medians?########
;IF medPlot GT 0 THEN $
;medHist=median_hist(maximus.mlt(plot_i),maximus.ILAT(plot_i),$
;                           plot_i,MIN1=MINMLT,MIN2=MINILAT,$
;                           MAX1=MAXMLT,MAX2=MAXILAT,$
;                           BINSIZE1=binMLT,BINSIZE2=binILAT,$
;                           OBIN1=h2dBinsMLT,OBIN2=h2dBinsILAT)


;########ELECTRON FLUX########

h2dEStr={h2dStr}

IF eFluxPlotType EQ "Integ" THEN elecData=maximus.integ_elec_energy_flux(plot_i) $
ELSE IF eFluxPlotType EQ "Max" THEN elecData=maximus.elec_energy_flux(plot_i)

IF (medPlot) THEN BEGIN & $
  h2dEstr.data=median_hist(maximus.mlt(plot_i),maximus.ILAT(plot_i),$
                           elecData,$
                           MIN1=MINMLT,MIN2=MINILAT,$
                           MAX1=MAXMLT,MAX2=MAXILAT,$
                           BINSIZE1=binMLT,BINSIZE2=binILAT,$
                           OBIN1=h2dBinsMLT,OBIN2=h2dBinsILAT,$
                           ABSMED=absEFlux) & $
ENDIF ELSE BEGIN & $
   h2dEStr.data=hist2d(maximus.mlt(plot_i), $
                       maximus.ilat(plot_i),$
                       elecData,$
                       MIN1=MINMLT,MIN2=MINILAT,$
                       MAX1=MAXMLT,MAX2=MAXILAT,$
                       BINSIZE1=binMLT,BINSIZE2=binILAT,$
                       OBIN1=h2dBinsMLT,OBIN2=h2dBinsILAT) & $
   h2dEStr.data(where(h2dFluxN NE 0,/NULL))=h2dEStr.data(where(h2dFluxN NE 0,/NULL))/h2dFluxN(where(h2dFluxN NE 0,/NULL)) & $
ENDELSE 

;Log plots desired?
logEstr=""
absEstr=""
IF absEFlux EQ 1 THEN BEGIN & $
   h2dEStr.data = ABS(h2dEStr.data) & $
   absEstr= "ABS" & $
   IF (writeASCII) OR (writeHDF5) OR (polarPlot) OR (saveRaw) THEN elecData=ABS(elecData) & $
ENDIF
IF logEfPlot EQ 1 THEN BEGIN & $
   logEstr="Log " & $
   h2dEStr.data(where(h2dEStr.data GT 0,/NULL))=ALOG10(h2dEStr.data(where(h2dEStr.data GT 0,/null))) & $
   IF (writeASCII) OR (writeHDF5) OR (polarPlot) OR (saveRaw) THEN elecData(where(elecData GT 0,/null))=ALOG10(elecData(where(elecData GT 0,/null))) & $
ENDIF
abslogEstr=absEstr + logEstr

;Do custom range for Eflux plots, if requested
IF customERange NE !NULL THEN h2dEStr.lim=TEMPORARY(customERange)$
   ELSE h2dEStr.lim = [MIN(h2dEstr.data),MAX(h2dEstr.data)]

h2dEStr.title= abslogEstr + "Electron Flux (ergs/cm!U2!N-s)"
IF (ePlots) THEN BEGIN & h2dStr=[h2dStr,TEMPORARY(h2dEStr)] & $
  IF (writeASCII) OR (writeHDF5) OR (polarPlot) OR (saveRaw) THEN BEGIN & $
    dataName=[dataName,STRTRIM(abslogEstr,2)+"eFlux"+eFluxPlotType+"_"] & $
    dataRawPtr=[dataRawPtr,PTR_NEW(elecData)] & $
   ENDIF & $
ENDIF

undefine,h2dEStr ;,elecData 


;########Poynting Flux########

h2dPStr={h2dStr}

IF medPlot GT 0 THEN BEGIN & $
   h2dPstr.data=median_hist(maximus.mlt(plot_i),maximus.ILAT(plot_i),$
                            poynt_est(plot_i),$
                            MIN1=MINMLT,MIN2=MINILAT,$
                            MAX1=MAXMLT,MAX2=MAXILAT,$
                            BINSIZE1=binMLT,BINSIZE2=binILAT,$
                            OBIN1=h2dBinsMLT,OBIN2=h2dBinsILAT,$
                            ABSMED=absPFlux) & $
ENDIF ELSE BEGIN & $
   h2dPStr.data=hist2d(maximus.mlt(plot_i),$
                       maximus.ilat(plot_i),$
                       poynt_est(plot_i),$
                       MIN1=MINMLT,MIN2=MINILAT,$
                       MAX1=MAXMLT,MAX2=MAXILAT,$
                       BINSIZE1=binMLT,BINSIZE2=binILAT) & $
   h2dPStr.data(where(h2dFluxN NE 0,/null))=h2dPStr.data(where(h2dFluxN NE 0,/null))/h2dFluxN(where(h2dFluxN NE 0,/null)) & $
ENDELSE

IF (writeHDF5) or (writeASCII) OR (polarPlot) OR (saveRaw) THEN pData=poynt_est(plot_i)

;Log plots desired?
logPstr=""
absPstr=""
IF absPflux EQ 1 THEN BEGIN & $
   h2dPStr.data = ABS(h2dPStr.data) & $
   absPstr= "ABS" & $
   IF (writeASCII) OR (writeHDF5) OR (polarPlot) OR (saveRaw) THEN pData=ABS(pData) & $
ENDIF

IF logPfPlot EQ 1 THEN BEGIN & $
   logPstr="Log " & $
   h2dPStr.data(where(h2dPStr.data GT 0,/null))=ALOG10(h2dPStr.data(where(h2dPStr.data GT 0,/NULL))) & $
IF (writeASCII) OR (writeHDF5) OR (polarPlot) OR (saveRaw) THEN pData(where(pData GT 0,/NULL))=ALOG10(pData(where(pData GT 0,/NULL))) & $
ENDIF
abslogPstr=absPstr + logPstr

h2dPStr.title= abslogPstr + "Poynting Flux (mW/m!U2!N)"

;Do custom range for Pflux plots, if requested
IF customPRange NE !NULL THEN h2dPStr.lim=TEMPORARY(customPRange)$
   ELSE h2dPStr.lim = [MIN(h2dPstr.data),MAX(h2dPstr.data)]

;IF pPlots NE 0 THEN BEGIN & $
;  IF ePlots NE 0 THEN h2dStr=[h2dStr,TEMPORARY(h2dPStr)] $
;  ELSE h2dStr=[TEMPORARY(h2dPStr)] & $
;ENDIF
IF (pPlots) THEN BEGIN & h2dStr=[h2dStr,TEMPORARY(h2dPStr)] & $
  IF (writeASCII) OR (writeHDF5) OR (polarPlot) OR (saveRaw) THEN BEGIN & $
    dataName=[dataName,STRTRIM(abslogPstr,2)+"pFlux_"] & $
    dataRawPtr=[dataRawPtr,PTR_NEW(pData)] & $
   ENDIF & $ 
ENDIF

undefine,h2dPStr

;use these n stuff
IF (tempSAVE) THEN BEGIN & $
  print,"saving tempdata..." & $
  save,elecData,filename="testcode/elecdata.dat" & $
  mlts=maximus.mlt(plot_i) & $
  ilats=maximus.ilat(plot_i) & $
  save,mlts,ilats,filename="testcode/mlts_ilats.dat" & $
  pData=poynt_est(plot_i) & $
  save,pData,filename="testcode/pData.dat" & $
ENDIF

IF (writeASCII) OR (writeHDF5) OR (polarPlot) OR (saveRaw) THEN undefine,pData

;if iPlots NE 0 THEN @interp_plots_ions.pro

;########################################
;
;########Orbits########
;Now do orbit data to show how many orbits contributed to each thingy.
;A little extra tomfoolery is in order to get this right
;h2dOrbN is a 2d histo just like the others
;orbArr, on the other hand, is a 3D array, where the
;2D array pointed to is indexed by MLTbin and ILATbin. The contents of
;the 3D array are of the format [UniqueOrbs_ii index,MLT,ILAT]


h2dOrbStr={h2dStr}

h2dOrbN=INTARR(N_ELEMENTS(h2dStr[0].data(*,0)),N_ELEMENTS(h2dStr[0].data(0,*)))
orbArr=INTARR(N_ELEMENTS(uniqueorbs_ii),N_ELEMENTS(h2dFluxN(*,0)),N_ELEMENTS(h2dFluxN(0,*)))

FOR j=0, N_ELEMENTS(uniqueorbs_ii)-1 DO BEGIN & $
   tempOrb=maximus.orbit(plot_i(uniqueOrbs_ii(j))) & $
   temp_ii=WHERE(maximus.orbit(plot_i) EQ tempOrb,/NULL) & $
   h2dOrbTemp=hist_2d(maximus.mlt(plot_i(temp_ii)),$
                      maximus.ilat(plot_i(temp_ii)),$
                      BIN1=binMLT,BIN2=binILAT,$
                      MIN1=MINMLT,MIN2=MINILAT,$
                      MAX1=MAXMLT,MAX2=MAXILAT) & $
   orbARR[j,*,*]=h2dOrbTemp & $
   h2dOrbTemp(WHERE(h2dOrbTemp GT 0,/NULL)) = 1 & $
   h2dOrbStr.data += h2dOrbTemp & $
ENDFOR

h2dOrbStr.title="Num Contributing Orbits"

;h2dOrbStr.lim=[MIN(h2dOrbStr.data),MAX(h2dOrbStr.data)]
h2dOrbStr.lim=[1,20]

IF (orbPlot) THEN BEGIN & h2dStr=[h2dStr,h2dOrbStr] & $
  IF (writeASCII) OR (writeHDF5) OR (polarPlot) OR (saveRaw) THEN dataName=[dataName,"orbsContributing_"] & $
ENDIF

;########TOTAL Orbits########

;uniqueOrbs_ii=UNIQ(maximus.orbit(ind_region_magc_geabs10_acestart),SORT(maximus.orbit(ind_region_magc_geabs10_acestart)))
uniqueOrbs_ii=UNIQ(maximus.orbit,SORT(maximus.orbit))

h2dTotOrbStr={h2dStr}
orbArr=INTARR(N_ELEMENTS(uniqueorbs_ii),N_ELEMENTS(h2dFluxN(*,0)),N_ELEMENTS(h2dFluxN(0,*)))
h2dOrbN=INTARR(N_ELEMENTS(h2dStr[0].data(*,0)),N_ELEMENTS(h2dStr[0].data(0,*)))


;FOR j=0, N_ELEMENTS(uniqueorbs_ii)-1 DO BEGIN & $
;   tempOrb=maximus.orbit(ind_region_magc_geabs10_acestart(uniqueOrbs_ii(j))) & $
;   temp_ii=WHERE(maximus.orbit(ind_region_magc_geabs10_acestart) EQ tempOrb) & $
;   h2dOrbTemp=hist_2d(maximus.mlt(ind_region_magc_geabs10_acestart(temp_ii)),$
;                      maximus.ilat(ind_region_magc_geabs10_acestart(temp_ii)),$
;                      BIN1=binMLT,BIN2=binILAT,$
;                      MIN1=MINMLT,MIN2=MINILAT,$
;                      MAX1=MAXMLT,MAX2=MAXILAT) & $
;   orbARR[j,*,*]=h2dOrbTemp & $
;   h2dOrbTemp(WHERE(h2dOrbTemp GT 0)) = 1 & $
;   h2dTotOrbStr.data += h2dOrbTemp & $
;ENDFOR

FOR j=0, N_ELEMENTS(uniqueorbs_ii)-1 DO BEGIN & $
   tempOrb=maximus.orbit(uniqueOrbs_ii(j)) & $
   temp_ii=WHERE(maximus.orbit EQ tempOrb,/NULL) & $
   h2dOrbTemp=hist_2d(maximus.mlt(temp_ii),$
                      maximus.ilat(temp_ii),$
                      BIN1=binMLT,BIN2=binILAT,$
                      MIN1=MINMLT,MIN2=MINILAT,$
                      MAX1=MAXMLT,MAX2=MAXILAT) & $
   orbARR[j,*,*]=h2dOrbTemp & $
   h2dOrbTemp(WHERE(h2dOrbTemp GT 0,/NULL)) = 1 & $
   h2dTotOrbStr.data += h2dOrbTemp & $
ENDFOR

h2dTotOrbStr.title="Total Orbits"
h2dTotOrbStr.lim=[MIN(h2dTotOrbStr.data),MAX(h2dTotOrbStr.data)]

IF (orbTotPlot) THEN BEGIN & h2dStr=[h2dStr,h2dTotOrbStr] & $
  IF (writeASCII) OR (writeHDF5) OR (polarPlot) OR (saveRaw) THEN dataName=[dataName,"orbTot_"] & $
  ENDIF
;########Orbit FREQUENCY########
h2dFreqOrbStr={h2dStr}
h2dFreqOrbStr.data=h2dOrbStr.data
h2dFreqOrbStr.data(WHERE(h2dTotOrbStr.data NE 0,/NULL))=h2dOrbStr.data(WHERE(h2dTotOrbStr.data NE 0,/NULL))/h2dTotOrbStr.data(WHERE(h2dTotOrbStr.data NE 0,/NULL))
h2dFreqOrbStr.title="Orbit Frequency"
;h2dFreqOrbStr.lim=[MIN(h2dFreqOrbStr.data),MAX(h2dFreqOrbStr.data)]
h2dFreqOrbStr.lim=[0,0.3]

IF (orbFreqPlot) THEN BEGIN & h2dStr=[h2dStr,TEMPORARY(h2dFreqOrbStr)] & $
  IF (writeASCII) OR (writeHDF5) OR (polarPlot) OR (saveRaw) THEN dataName=[dataName,"orbFreq_"] & $
ENDIF

undefine,h2dTotOrbStr
undefine,h2dOrbStr
undefine,h2dFreqOrbStr

;********************************************************
;If something screwy goes on, better take stock of it and alert user

FOR i = 2, N_ELEMENTS(h2dStr)-1 DO BEGIN & $
   IF n_elements(where(h2dStr[i].data EQ 0,/NULL)) NE $
   n_elements(where(h2dStr[0].data EQ 0,/NULL)) THEN BEGIN & $
     printf,lun,"h2dStr."+h2dStr[i].title + " has ", strtrim(n_elements(where(h2dStr[i].data EQ 0)),2)," elements that are zero, whereas FluxN has ", strtrim(n_elements(where(h2dStr[0].data EQ 0)),2),"." & $
printf,lun,"Sorry, can't plot anything meaningful." & ENDIF
ENDFOR

;********************************************************
;Handle Plots all at once

;!!Make sure mask and FluxN are ultimate and penultimate arrays, respectively

h2dStr=SHIFT(h2dStr,-1-(nPlots))
IF (writeASCII) OR (writeHDF5) OR (polarPlot) OR (saveRaw) THEN BEGIN & $
  dataName=SHIFT(dataName,-2) & $
  dataRawPtr=SHIFT(dataRawPtr,-2) & $
ENDIF

IF (polarPlot) THEN save,h2dStr,dataName,maxMLT,minMLT,maxILAT,minILAT,binMLT,binILAT,$
                       saveRawDir,clockStr,plotsuff,stableIMF,hoyDia,hemstr,$
;                       filename=saveRawDir+'fluxplots_'+hemStr+'_'+clockStr+plotsuff+"_"+strtrim(stableIMF,2)+"stable"+satellite+"_"+hoyDia+".dat"
                       filename='temp/polarplots_'+hemStr+'_'+clockStr+plotsuff+"_"+strtrim(stableIMF,2)+"stable"+satellite+"_"+hoyDia+".dat"

;if not saving plots and plots not turned off, do some stuff; otherwise, make output
IF (~savePlots) THEN BEGIN & $
  IF (~noPlots) AND (~polarPlot) THEN $
   cgWindow, 'interp_contplotmulti_str', h2dStr,$
;             SAVERAW=(saveRaw) ? saveRawDir + 'fluxplots_'+hemStr+'_'+clockStr+plotsuff+"_"+strtrim(stableIMF,2)+"stable"+satellite+"_"+hoyDia : 0,$
             Background='White', $
             WTitle='Flux plots for '+hemStr+'ern Hemisphere, '+clockStr+ $
                    ' IMF, ' + strmid(plotSuff,1) $
  ELSE IF (~noPlots) THEN $;FOR j=0, N_ELEMENTS(h2dStr)-1 DO $
;    cgWindow,'interp_polar_plot',[[*dataRawPtr[0]],[maximus.mlt(plot_i)],[maximus.ilat(plot_i)]],$
;             h2dStr[0].lim,Background="White",wxsize=800,wysize=600, $
;             WTitle='Polar plot_'+dataName[0]+','+hemStr+'ern Hemisphere, '+clockStr+ $
;             ' IMF, ' + strmid(plotSuff,1) $
    FOR i = 0, N_ELEMENTS(h2dStr) - 2 DO $ 
      cgWindow,'ploth2d_stereographic',h2dStr[i],dataName[i],'temp/polarplots_'+hemStr+'_'+clockStr+plotsuff+"_"+strtrim(stableIMF,2)+"stable"+satellite+"_"+hoyDia+".dat",$
               Background="White",wxsize=800,wysize=600, $
               WTitle='Polar plot_'+dataName[i]+','+hemStr+'ern Hemisphere, '+clockStr+ $
               ' IMF, ' + strmid(plotSuff,1) $

  ELSE PRINTF,LUN,"**Plots turned off with noPlots**" & $
ENDIF ELSE BEGIN & $
  IF (~polarPlot) AND (~noPlots) THEN BEGIN & $
   CD, CURRENT=c & PRINTF,LUN, "Current directory is " + c + "/" + plotDir & $
   PRINTF,LUN, "Creating output files..." & $
   ;Create a PostScript file.
   cgPS_Open, plotDir + 'fluxplots_'+hemStr+'_'+clockStr+plotsuff+"_"+strtrim(stableIMF,2)+"stable"+satellite+"_"+hoyDia+'.ps' & $
   interp_contplotmulti_str,h2dStr & $
   cgPS_Close & $
   ;Create a PNG file with a width of 800 pixels.
   cgPS2Raster, plotDir + 'fluxplots_'+hemStr+'_'+clockStr+plotsuff+"_"+strtrim(stableIMF,2)+"stable"+satellite+"_"+hoyDia+'.ps', /PNG, Width=1000 & $
  ENDIF ELSE IF (~noPlots) THEN BEGIN & $
   CD, CURRENT=c & PRINTF,LUN, "Current directory is " + c + "/" + plotDir & $
 PRINTF,LUN, "Creating output files..." & $

    FOR i = 0, N_ELEMENTS(h2dStr) - 2 DO BEGIN & $ 
      ;Create a PostScript file.
      cgPS_Open, plotDir + 'plot_'+dataName[i]+hemStr+'_'+clockStr+plotsuff+"_"+strtrim(stableIMF,2)+"stable"+satellite+"_"+hoyDia+'.ps' & $
      ;interp_polar_plot,[[*dataRawPtr[0]],[maximus.mlt(plot_i)],[maximus.ilat(plot_i)]],$
      ;          h2dStr[0].lim & $
     ploth2d_stereographic,h2dStr[i],dataName[i],'temp/polarplots_'+hemStr+'_'+clockStr+plotsuff+"_"+strtrim(stableIMF,2)+"stable"+satellite+"_"+hoyDia+".dat" & $
     cgPS_Close & $
     ;Create a PNG file with a width of 800 pixels.
     cgPS2Raster, plotDir + 'plot_'+dataName[i]+hemStr+'_'+clockStr+plotsuff+"_"+strtrim(stableIMF,2)+"stable"+satellite+"_"+hoyDia+'.ps', /PNG, Width=1000 & $
    ENDFOR    & $

  ENDIF & $
ENDELSE

;For altitude histograms
;cgWindow,"cgHistoPlot",maximus.alt(plot_i),title="Current events for predom. " +clockStr+" IMF, 15Min stability",fill="red"

IF (outputPlotSummary) THEN BEGIN & CLOSE,lun & FREE_LUN,lun & ENDIF


;********************************************************
;Thanks, IDL Coyote--time to write out lots of data

IF (writeHDF5) THEN BEGIN & $
;write out raw data here
  FOR j=0, N_ELEMENTS(h2dStr)-2 DO BEGIN & $
    fname=plotDir+dataName[j]+hemStr+'_'+clockStr+plotsuff+"_"+strtrim(stableIMF,2)+"stable"+satellite+"_"+hoyDia+'.h5' & $
    PRINT,"Writing HDF5 file: " + fname & $
    fileID=H5F_CREATE(fname) & $
    datatypeID=H5T_IDL_CREATE(h2dStr[j].data) & $
    dataspaceID=H5S_CREATE_SIMPLE(SIZE(h2dStr[j].data,/DIMENSIONS)) & $
    datasetID = H5D_CREATE(fileID,dataName[j], datatypeID, dataspaceID) & $
    H5D_WRITE,datasetID, h2dStr[j].data & $
    H5F_CLOSE,fileID & $
  ENDFOR & $
;loop style for individual structures
;   FOR i=0, N_ELEMENTS(h2dStr)-1 DO BEGIN & $
;      fname=plotDir+h2dStr[i].title+'_'+ $
;            hemStr+'_'+clockStr+plotsuff+"_"+strtrim(stableIMF,2)+"stable"+satellite+"_"+hoyDia+'.h5' & $
;      fileID=H5F_CREATE(fname) & $
;      datatypeID=H5T_IDL_CREATE(h2dStr[i]) & $
;      dataspaceID=H5S_CREATE_SIMPLE(1) & $
;      datasetID = H5D_CREATE(fileID,$
;                             h2dStr[i].title+'_'+hemStr+'_'+clockStr+plotSuff, $
;                             datatypeID, dataspaceID) & $
;      H5D_WRITE,datasetID, h2dStr[i] & $
;      H5F_CLOSE,fileID & $   
;   ENDFOR & $

;To read your newly produced HDF5 file, do this:
;s = H5_PARSE(fname, /READ_DATA)
;HELP, s.mydata._DATA, /STRUCTURE  
  IF (writeProcessedH2d) THEN BEGIN & $
    FOR j=0, N_ELEMENTS(h2dStr)-2 DO BEGIN & $
      fname=plotDir+dataName[j]+hemStr+'_'+clockStr+plotsuff+"_"+strtrim(stableIMF,2)+"stable"+satellite+"_"+hoyDia+'.h5' & $
      PRINT,"Writing HDF5 file: " + fname & $
      fileID=H5F_CREATE(fname) & $
   
  ;    datatypeID=H5T_IDL_CREATE() & $
      dataspaceID=H5S_CREATE_SIMPLE(SIZE(h2dStr[j].data,/DIMENSIONS)) & $
      datasetID = H5D_CREATE(fileID,dataName[j], datatypeID, dataspaceID) & $
      H5D_WRITE,datasetID, h2dStr[j].data & $
   
      datatypeID=H5T_IDL_CREATE(h2dStr[j].data) & $
      dataspaceID=H5S_CREATE_SIMPLE(SIZE(h2dStr[j].data,/DIMENSIONS)) & $
      datasetID = H5D_CREATE(fileID,dataName[j], datatypeID, dataspaceID) & $
      H5D_WRITE,datasetID, h2dStr[j].data & $    
          
      
      datatypeID=H5T_IDL_CREATE(h2dStr[j].data) & $
      dataspaceID=H5S_CREATE_SIMPLE(SIZE(h2dStr[j].data,/DIMENSIONS)) & $
      datasetID = H5D_CREATE(fileID,dataName[j], datatypeID, dataspaceID) & $
      H5D_WRITE,datasetID, h2dStr[j].data & $
      H5F_CLOSE,fileID & $
    ENDFOR & $
  ENDIF & $
ENDIF

;IF writeASCII NE 0 THEN BEGIN & $
;  fname=plotDir+'fluxplots_'+hemStr+'_'+clockStr+plotsuff+"_"+strtrim(stableIMF,2)+"stable"+satellite+"_"+hoyDia+'.ascii' & $
;   PRINT,"Writing ASCII file: " + fname & $
;   OPENW,lun2, fname, /get_lun & $
;   PRINT_STRUCT,h2dStr,LUN_OUT=lun2 & $
;   FOR i = 0, N_ELEMENTS(h2dStr) - 2 DO BEGIN & $
;    PRINTF,lun2,h2dStr[i].title & $
;    PRINT,h2dStr[i].title & $
;    PRINTF,lun2,h2dStr[i].data & $
;    PRINTF,lun2,"" & $
;   ENDFOR & $
;   CLOSE, lun2 & $
;   FREE_LUN, lun2 & $
;ENDIF

IF (writeASCII) THEN BEGIN & $
;These are the "raw" data, just as we got them from Chris
  FOR j = 0, n_elements(dataRawPtr)-3 DO BEGIN & $
    fname=plotDir+dataName[j]+hemStr+'_'+clockStr+"_"+strtrim(stableIMF,2)+"stable"+satellite+"_"+hoyDia+'.ascii' & $
    PRINT,"Writing ASCII file: " + fname & $
    OPENW,lun2, fname, /get_lun & $
    FOR i = 0, N_ELEMENTS(plot_i) - 1 DO BEGIN & $
      PRINTF,lun2,(maximus.ILAT(plot_i))[i],(maximus.MLT(plot_i))[i],$
                  (*dataRawPtr[j])[i],$
                  FORMAT='(F7.2,1X,F7.2,1X,F7.2)' & $
    ENDFOR & $
  CLOSE, lun2 & $  
  FREE_LUN, lun2 & $
  ENDFOR & $
 
 ;NOW DO PROCESSED H2D DATA 
  IF (writeProcessedH2d) THEN BEGIN & $
    FOR i = 0, n_elements(h2dStr)-1 DO BEGIN & $
      fname=plotDir+"h2d_"+dataName[i]+hemStr+'_'+clockStr+plotsuff+"_"+strtrim(stableIMF,2)+"stable"+satellite+"_"+hoyDia+'.ascii' & $
      PRINT,"Writing ASCII file: " + fname & $
      OPENW,lun2, fname, /get_lun & $
      FOR j = 0, N_ELEMENTS(h2dBinsMLT) - 1 DO BEGIN & $
        FOR k = 0, N_ELEMENTS(h2dBinsILAT) -1 DO BEGIN & $
          PRINTF,lun2,h2dBinsILAT[k],$
                      h2dBinsMLT[j],$
                      (h2dStr[i].data)[j,k],$
                      FORMAT='(F7.2,1X,F7.2,1X,F7.2)' & $
        ENDFOR & $
      ENDFOR & $
      CLOSE, lun2 & $  
      FREE_LUN, lun2 & $
    ENDFOR & $
  ENDIF & $
ENDIF

IF (writeHDF5) OR (writeASCII) THEN BEGIN & undefine,dataRawPtr & HEAP_GC & ENDIF
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

;For all phi
;cgscatter2d,maximus.mlt(cdbInterp_i),$
; poynt_est(cdbInterp_i),$
; xtitle="MLT", ytitle="|E||B| (Poynt flux est.)",$
; title="Spread in latitude of Poynting flux for all phi"
;output="Poynt_vs_MLT_Phi_all_'+hemStr+'.png"
;write_png,'Poynt_vs_MLT_Phi_all_'+hemStr+'.png',tvrd()
;
;cgscatter2d,maximus.mlt(cdbInterp_i),$
; maximus.elec_energy_flux(cdbInterp_i),$
; xtitle="MLT", ytitle="Electron [number?] flux",$
; title="Spread in latitude of electron flux for all phi",$
;output="elecflux_vs_MLT_Phi_all_'+hemStr+'.png"
;;write_png,'elecflux_vs_MLT_Phi_all_'+hemStr+'.png',tvrd()
;
;For phi based on clockStr
;window,0
;cgscatter2d,maximus.mlt(plot_i),$
; poynt_est(plot_i),$
; xtitle="MLT", ytitle="|E||B| (Poynt flux est.)",$
; title="Spread in latitude of Poynting flux for phiClock " + clockStr,$
;output="Poynt_vs_MLT_'+clockStr+'_'+hemStr+'.png"
;write_png,'Poynt_vs_MLT_'+clockStr+'.png',tvrd()
;
;window,2
;cgscatter2d,maximus.mlt(plot_i),$
; maximus.elec_energy_flux(plot_i),$
; xtitle="MLT", ytitle="Electron [number?] flux",$
; title="Spread in latitude of electron flux for phiClock " + clockStr,$
;output="elecflux_vs_MLT_'+clockStr+'_'+hemStr+'.png"
;write_png,'elecflux_vs_MLT_' + clockStr + '_'+hemStr+'.png',tvrd()
