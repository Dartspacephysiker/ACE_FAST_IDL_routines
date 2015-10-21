;variables to be used by interp_contplot.pro
COMMON ContVars, minMLT, maxMLT, minILAT, maxILAT

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

stableIMF=0S ;Set to a time (in minutes) over which IMF stability is required
includeNoConsecData=0 ;Setting this to 1 includes Chaston data for which  
                      ;there's no way to calculate IMF stability
                      ;Only valid for stableIMF GE 1
checkBothWays=0 ;

Bx_over_ByBz_Lim=0 ;Set this to the max ratio of Bx / SQRT(By*By + Bz*Bz)


;********************************************
;Variables for histos
;Bin sizes for 2d histos

;Want medians instead of averages?
medPlot=1

ePlots = 1 ;electron flux plots?
  eFluxPlotType="Integ" ;options are "Integ" and "Max"
pPlots = 1 ;Poynting flux [estimate] plots?
iPlots = 1 ;ion Plots?
orbPlot=1 ;Contributing orbits plot?
orbTotPlot=1 ;"Total orbits considered" plot?
orbFreqPlot=1 ;Contributing/total orbits plot?

;Do total orbs plot for frequency thing?
totalOrbsPlot=1

;######ELECTRONS
;Eflux max abs. value in interval, or integrated flux?
;NOTE: max value has negative values, which can mess with
;color bars

logEfPlot=0 ;Want log plots of e- flux?
absEFlux=0 ;Make E Flux plots absolute value?
;For linear or log EFlux plotrange
IF logEfPlot EQ 0 THEN customERange=[0,5000] ELSE customERange=[1,5.5]

;######Poynting flux
logPfPlot=1  ;Want log plots of Poynting flux?
absPFlux=0 ;Make Poynting flux plots absolute value?
;For linear or log PFlux plotrange
IF logPfPlot EQ 0 THEN customPRange=[0,3500] ELSE customPRange=[-1,1]

;######Ion flux (up)
logIonFluxPlot=0
absIonFlux=0
;For linear or log ion flux plotrange
IF logIonFluxPlot EQ 0 THEN customIonRange=[0,1.5e8] ELSE customIonRange=[1,8.5]

;######Oxy flux
logOFluxPlot=0
absOFlux=0
;For linear or log ion flux plotrange
;IF logOFluxPlot EQ 0 THEN customORange=[0,1e4] ELSE customRange=ALOG10([0,1e4]

;Which IMF clock angle are we doing?
;options are 'duskward', 'dawnward', 'bzNorth', 'bzSouth'
IF batchMode EQ !NULL THEN clockStr='duskward'

;How to set angles? Note, clock angle is measured with
;Bz North at zero deg, ranging from -180<clock_angle<180
;Setting angle limits 45 and 135, for example, gives a 90-deg
;window for dawnward and duskward plots
angleLim1=45 ;in degrees
angleLim2=135;in degrees

;Bin sizes for 2D histos
binMLT=0.5
binILAT=1

;Set minimum allowable number of events for a histo bin to be displayed
maskMin=1

;********************************************
;Stuff for output
hoyDia= "_" + STRMID(SYSTIME(0), 4, 3) + "_" + $
       STRMID(SYSTIME(0), 8,2) + "_" + STRMID(SYSTIME(0), 22, 2)
plotDir='plots/test/'
IF medPlot GT 0 THEN plotSuff = "_med" ELSE plotSuff = "_avg"
plotType='Eflux_' +eFluxPlotType
plotType=(logEfPlot EQ 0) ? plotType : 'log' + plotType
plotType=(logPfPlot EQ 0) ? plotType : 'logPf_' + plotType
plotDir=plotDir + plotType + '/'
;Want to make plots in plotDir?
savePlots=0
;Write output file with data params? Only possible if savePlots=1...
IF savePlots NE 0 THEN outputPlotSummary=1 $ ;Change to zero if not wanted
   ELSE outputPlotSummary=0

;Write plot data output for Bin?
writeHDF5=0
writeASCII=1

;********************************************
;Figure out both hemisphere and plot indices, 
;tap DBs, and setup output
IF minILAT GT 0 THEN hemStr='North' ELSE IF maxILAT LT 0 THEN hemStr='South' $
   ELSE BEGIN & printf,lun,"Which hemisphere?" & hemStr = '??' & ENDELSE

;Open file for text summary, if desired
IF (outputPlotSummary) THEN $
   OPENW,lun,plotDir+'fluxplots_'+hemStr+'_'+clockStr+plotSuff+"_"+strtrim(stableIMF,2)+"stable"+hoyDia+'.txt',/GET_LUN $
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


POYNT_EST=maximus.DELTA_B * maximus.DELTA_E * 1.0e-9 / mu_0 

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


;########Flux_N and Mask########
;First, histo to show where events are
h2dFluxN=hist_2d(maximus.mlt(plot_i),$
	maximus.ilat(plot_i),$
        BIN1=binMLT,BIN2=binILAT,$
	MIN1=MINMLT,MIN2=MINILAT,$
	MAX1=MAXMLT,MAX2=MAXILAT)

h2dFluxNTitle="Number of events"
IF (writeASCII) OR (writeHDF5) THEN dataName="nEvents_"
h2dStr={h2dStr, data: DOUBLE(h2dFluxN), $
        title : "Number of events", $
        lim : DOUBLE([MIN(h2dFluxN),MAX(h2dFluxN)]) }

;Make a mask for plots so that we can show where no data exists
h2dMaskStr={h2dStr}
h2dMaskStr.data=h2dStr.data
h2dMaskStr.data(where(h2dStr.data LT maskMin))=255
h2dMaskStr.data(where(h2dStr.data GE maskMin))=0
h2dMaskStr.title="Histogram mask"
IF (writeASCII) OR (writeHDF5) THEN dataName=[dataName,"histoMask_"]
h2dStr=[h2dStr,TEMPORARY(h2dMaskStr)]

;h2dStr={h2dStr, data : DBLARR(N_ELEMENTS(h2dFluxN(*,0)),N_ELEMENTS(h2dFluxN(0,*))), title : "", lim : DBLARR(2) }


;########Medians?########
;IF medPlot GT 0 THEN $
;medHist=median_hist(maximus.mlt(plot_i),maximus.ILAT(plot_i),$
;                           plot_i,MIN1=MINMLT,MIN2=MINILAT,$
;                           MAX1=MAXMLT,MAX2=MAXILAT,$
;                           BINSIZE1=binMLT,BINSIZE2=binILAT,$
;                           OBIN1=h2d_ef_bins1,OBIN2=h2d_ef_bins2)


;########ELECTRON FLUX########

h2dEStr={h2dStr}

IF eFluxPlotType EQ "Integ" THEN elecData=maximus.integ_elec_energy_flux(plot_i) $
ELSE IF eFluxPlotType EQ "Max" THEN elecData=maximus.elec_energy_flux(plot_i) $

IF (medPlot) THEN BEGIN & $
   IF eFluxPlotType EQ "Integ" THEN BEGIN & $
      h2dEstr.data=median_hist(maximus.mlt(plot_i),maximus.ILAT(plot_i),$
                               maximus.integ_elec_energy_flux(plot_i),$
                               MIN1=MINMLT,MIN2=MINILAT,$
                               MAX1=MAXMLT,MAX2=MAXILAT,$
                               BINSIZE1=binMLT,BINSIZE2=binILAT,$
                               OBIN1=h2d_ef_bins1,OBIN2=h2d_ef_bins2,$
                               ABSMED=absEFlux) & $
   ENDIF ELSE IF eFluxPlotType EQ "Max" THEN BEGIN & $
      h2dEstr.data=median_hist(maximus.mlt(plot_i),maximus.ILAT(plot_i),$
                               maximus.elec_energy_flux(plot_i),$
                               MIN1=MINMLT,MIN2=MINILAT,$
                               MAX1=MAXMLT,MAX2=MAXILAT,$
                               BINSIZE1=binMLT,BINSIZE2=binILAT,$
                               OBIN1=h2d_ef_bins1,OBIN2=h2d_ef_bins2,$
                               ABSMED=absEFlux) & $
   ENDIF & $
ENDIF ELSE BEGIN & $
   IF eFluxPlotType EQ "Integ" THEN BEGIN & $
      h2dEStr.data=hist2d(maximus.mlt(plot_i), $
                      maximus.ilat(plot_i),$
                      maximus.integ_elec_energy_flux(plot_i),$
                      MIN1=MINMLT,MIN2=MINILAT,$
                      MAX1=MAXMLT,MAX2=MAXILAT,$
                      BINSIZE1=binMLT,BINSIZE2=binILAT,$
                      OBIN1=h2d_ef_bins1,OBIN2=h2d_ef_bins2) & $
   ENDIF ELSE IF eFluxPlotType EQ "Max" THEN BEGIN & $
      h2dEStr.data=hist2d(maximus.mlt(plot_i), $
                      maximus.ilat(plot_i),$
                      maximus.elec_energy_flux(plot_i),$
                      MIN1=MINMLT,MIN2=MINILAT,$
                      MAX1=MAXMLT,MAX2=MAXILAT,$
                      BINSIZE1=binMLT,BINSIZE2=binILAT,$
                      OBIN1=h2d_ef_bins1,OBIN2=h2d_ef_bins2) & $
   ENDIF & $
   h2dEStr.data(where(h2dFluxN NE 0))=h2dEStr.data(where(h2dFluxN NE 0))/h2dFluxN(where(h2dFluxN NE 0)) & $
ENDELSE 

                               
IF (writeHDF5) OR (writeASCII) THEN BEGIN & $
  IF
  dataRawPtr=PTR_NEW(maximus.integ_elec_energy_flux(plot_i)) & $
    

;Log plots desired?
logEstr=""
absEstr=""
IF absEFlux EQ 1 THEN BEGIN & $
   h2dEStr.data = ABS(h2dEStr.data) & $
   absEstr= "ABS" & $
ENDIF
IF logEfPlot EQ 1 THEN BEGIN & $
   logEstr="Log " & $
   h2dEStr.data(where(h2dEStr.data GT 0))=ALOG10(h2dEStr.data(where(h2dEStr.data GT 0))) & $
ENDIF
abslogEstr=absEstr + logEstr

;Do custom range for Eflux plots, if requested
IF customERange NE !NULL THEN h2dEStr.lim=TEMPORARY(customERange)$
   ELSE h2dEStr.lim = [MIN(h2dEstr.data),MAX(h2dEstr.data)]

h2dEStr.title= abslogEstr + "Electron Flux (ergs/cm!U2!N-s)"
IF (ePlots) THEN BEGIN & h2dStr=[h2dStr,TEMPORARY(h2dEStr)] & $
  IF (writeASCII) OR (writeHDF5) THEN dataName=[dataName,STRTRIM(abslogEstr,2)+"eFlux"+eFluxPlotType+"_"] & $
ENDIF
delvar,h2dEStr

;########Poynting Flux########

h2dPStr={h2dStr}

IF medPlot GT 0 THEN BEGIN & $
   h2dPstr.data=median_hist(maximus.mlt(plot_i),maximus.ILAT(plot_i),$
                            poynt_est(plot_i),$
                            MIN1=MINMLT,MIN2=MINILAT,$
                            MAX1=MAXMLT,MAX2=MAXILAT,$
                            BINSIZE1=binMLT,BINSIZE2=binILAT,$
                            OBIN1=h2d_ef_bins1,OBIN2=h2d_ef_bins2,$
                            ABSMED=absPFlux) & $
ENDIF ELSE BEGIN & $
   h2dPStr.data=hist2d(maximus.mlt(plot_i),$
                       maximus.ilat(plot_i),$
                       poynt_est(plot_i),$
                       MIN1=MINMLT,MIN2=MINILAT,$
                       MAX1=MAXMLT,MAX2=MAXILAT,$
                       BINSIZE1=binMLT,BINSIZE2=binILAT) & $
   h2dPStr.data(where(h2dFluxN NE 0))=h2dPStr.data(where(h2dFluxN NE 0))/h2dFluxN(where(h2dFluxN NE 0)) & $
ENDELSE


;Log plots desired?
logPstr=""
absPstr=""
IF absPflux EQ 1 THEN BEGIN & $
   h2dPStr.data = ABS(h2dPStr.data) & $
   absPstr= "ABS" & $
ENDIF

IF logPfPlot EQ 1 THEN BEGIN & $
   logPstr="Log " & $
   h2dPStr.data(where(h2dPStr.data GT 0))=ALOG10(h2dPStr.data(where(h2dPStr.data GT 0))) & $
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
  IF (writeASCII) OR (writeHDF5) THEN dataName=[dataName,STRTRIM(abslogPstr,2)+"pFlux_"] & $
ENDIF
delvar,h2dPStr

;if iPlots NE 0 THEN @interp_plots_ions.pro

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
   temp_ii=WHERE(maximus.orbit(plot_i) EQ tempOrb) & $
   h2dOrbTemp=hist_2d(maximus.mlt(plot_i(temp_ii)),$
                      maximus.ilat(plot_i(temp_ii)),$
                      BIN1=binMLT,BIN2=binILAT,$
                      MIN1=MINMLT,MIN2=MINILAT,$
                      MAX1=MAXMLT,MAX2=MAXILAT) & $
   orbARR[j,*,*]=h2dOrbTemp & $
   h2dOrbTemp(WHERE(h2dOrbTemp GT 0)) = 1 & $
   h2dOrbStr.data += h2dOrbTemp & $
ENDFOR

h2dOrbStr.title="Num Contributing Orbits"

h2dOrbStr.lim=[MIN(h2dOrbStr.data),MAX(h2dOrbStr.data)]

IF (orbPlot) THEN BEGIN & h2dStr=[h2dStr,h2dOrbStr] & $
  IF (writeASCII) OR (writeHDF5) THEN dataName=[dataName,"orbsContributing_"] & $
ENDIF

;########TOTAL Orbits########

uniqueOrbs_ii=UNIQ(maximus.orbit(ind_region_magc_geabs10_acestart),SORT(maximus.orbit(ind_region_magc_geabs10_acestart)))
h2dTotOrbStr={h2dStr}

h2dOrbN=INTARR(N_ELEMENTS(h2dStr[0].data(*,0)),N_ELEMENTS(h2dStr[0].data(0,*)))
orbArr=INTARR(N_ELEMENTS(uniqueorbs_ii),N_ELEMENTS(h2dFluxN(*,0)),N_ELEMENTS(h2dFluxN(0,*)))

FOR j=0, N_ELEMENTS(uniqueorbs_ii)-1 DO BEGIN & $
   tempOrb=maximus.orbit(ind_region_magc_geabs10_acestart(uniqueOrbs_ii(j))) & $
   temp_ii=WHERE(maximus.orbit(ind_region_magc_geabs10_acestart) EQ tempOrb) & $
   h2dOrbTemp=hist_2d(maximus.mlt(ind_region_magc_geabs10_acestart(temp_ii)),$
                      maximus.ilat(ind_region_magc_geabs10_acestart(temp_ii)),$
                      BIN1=binMLT,BIN2=binILAT,$
                      MIN1=MINMLT,MIN2=MINILAT,$
                      MAX1=MAXMLT,MAX2=MAXILAT) & $
   orbARR[j,*,*]=h2dOrbTemp & $
   h2dOrbTemp(WHERE(h2dOrbTemp GT 0)) = 1 & $
   h2dTotOrbStr.data += h2dOrbTemp & $
ENDFOR

h2dTotOrbStr.title="Total Contributing Orbits"
h2dTotOrbStr.lim=[MIN(h2dTotOrbStr.data),MAX(h2dTotOrbStr.data)]

IF (orbTotPlot) THEN BEGIN & h2dStr=[h2dStr,h2dTotOrbStr] & $
  IF (writeASCII) OR (writeHDF5) THEN dataName=[dataName,"orbTot_"] & $
ENDIF
;########Orbit FREQUENCY########
h2dFreqOrbStr={h2dStr}
h2dFreqOrbStr.data=h2dOrbStr.data
h2dFreqOrbStr.data(WHERE(h2dTotOrbStr.data NE 0))=h2dOrbStr.data(WHERE(h2dTotOrbStr.data NE 0))/h2dTotOrbStr.data(WHERE(h2dTotOrbStr.data NE 0))
h2dFreqOrbStr.title="Orbit Frequency"
h2dFreqOrbStr.lim=[MIN(h2dFreqOrbStr.data),MAX(h2dFreqOrbStr.data)]

IF (orbFreqPlot) THEN BEGIN & h2dStr=[h2dStr,TEMPORARY(h2dFreqOrbStr)] & $
  IF (writeASCII) OR (writeHDF5) THEN dataName=[dataName,"orbFreq_"] & $
ENDIF

IF (writeHDF5) or (writeASCII) THEN BEGIN & $
  
ENDIF

delvar,h2dTotOrbStr
delvar,h2dOrbStr
delvar,h2dFreqOrbStr

;********************************************************
;If something screwy goes on, better take stock of it and alert user

FOR i = 2, N_ELEMENTS(h2dStr)-1 DO BEGIN & $
   IF n_elements(where(h2dStr[i].data EQ 0)) NE $
   n_elements(where(h2dStr[0].data EQ 0)) THEN BEGIN & $
     printf,lun,"h2dStr["+strtrim(i,2)+"] has", n_elements(where(h2dStr[i].data EQ 0))," elements that are zero, whereas FluxN has", n_elements(where(h2dStr[0].data EQ 0)),"." & $
printf,lun,"Sorry, can't plot anything meaningful." & ENDIF


;********************************************************
;Handle Plots all at once

;!!Make sure mask and FluxN are ultimate and penultimate arrays, respectively

h2dStr=SHIFT(h2dStr,-2)
dataName=SHIFT(dataName,-2)

IF savePlots EQ 0 THEN BEGIN & $
   cgWindow, 'interp_contplotmulti_str', h2dStr, Background='White', $
             WTitle='Flux plots for '+hemStr+'ern Hemisphere, '+clockStr+ $
                    ' IMF, ' + strmid(plotSuff,1) & $
ENDIF ELSE BEGIN & $
   CD, CURRENT=c & PRINTF,LUN, "Current directory is " + c + "/" + plotDir & $
   PRINTF,LUN, "Creating output files..." & $
   ;Create a PostScript file.
   cgPS_Open, plotDir + 'fluxplots_'+hemStr+'_'+clockStr+plotsuff+"_"+strtrim(stableIMF,2)+"stable"+hoyDia+'.ps' & $
   interp_contplotmulti_str,h2dStr & $
   cgPS_Close & $
   ;Create a PNG file with a width of 800 pixels.
   cgPS2Raster, plotDir + 'fluxplots_'+hemStr+'_'+clockStr+plotsuff+"_"+strtrim(stableIMF,2)+"stable"+hoyDia+'.ps', /PNG, Width=1000 & $
ENDELSE

;For altitude histograms
;cgWindow,"cgHistoPlot",maximus.alt(plot_i),title="Current events for predom. " +clockStr+" IMF, 15Min stability",fill="red"

IF (outputPlotSummary) THEN BEGIN & CLOSE,lun & FREE_LUN,lun & ENDIF

;Thanks, IDL Coyote

IF (writeHDF5) THEN BEGIN & $
  FOR j=0, N_ELEMENTS(h2dStr)-2 DO BEGIN & $
    fname=plotDir+dataName[j]+hemStr+'_'+clockStr+plotsuff+"_"+strtrim(stableIMF,2)+"stable"+hoyDia+'.h5' & $
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
;            hemStr+'_'+clockStr+plotsuff+"_"+strtrim(stableIMF,2)+"stable"+hoyDia+'.h5' & $
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
  FOR j=0, N_ELEMENTS(h2dStr)-2 DO BEGIN & $
    fname=plotDir+dataName[j]+hemStr+'_'+clockStr+plotsuff+"_"+strtrim(stableIMF,2)+"stable"+hoyDia+'.h5' & $
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

   
ENDIF

;IF writeASCII NE 0 THEN BEGIN & $
;  fname=plotDir+'fluxplots_'+hemStr+'_'+clockStr+plotsuff+"_"+strtrim(stableIMF,2)+"stable"+hoyDia+'.ascii' & $
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
  FOR j = 0, n_elements(h2dStr)-2 DO BEGIN & $
    fname=plotDir+dataName[j]+hemStr+'_'+clockStr+plotsuff+"_"+strtrim(stableIMF,2)+"stable"+hoyDia+'.ascii' & $
    PRINT,"Writing ASCII file: " + fname & $
    OPENW,lun2, fname, /get_lun & $
    FOR i = 0, N_ELEMENTS(plot_i) - 1 DO BEGIN & $
      PRINTF,lun2,(maximus.ILAT(plot_i))[i],(maximus.MLT(plot_i))[i],$
                  (maximus.INTEG_ELEC_ENERGY_FLUX(plot_i))[i],$
                  FORMAT='(F7.2,1X,F7.2,1X,F7.2)' & $
    ENDFOR & $
  ENDFOR & $
  CLOSE, lun2 & $  
  FREE_LUN, lun2 & $
ENDIF

IF (writeHDF5) OR (writeASCII) THEN HEAP_GC

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
