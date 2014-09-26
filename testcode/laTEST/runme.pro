
batchme=1

IMF=['duskward','dawnward','bzSouth','bzNorth']

FOR j=0, (batchme) ? 3 : 0 DO BEGIN & $ 

  allData="fluxplots_North_"+IMF[j]+"_avg_0stable_Jan_28_14.dat"  & $ 
  
  restore,allData  & $ 
  
  ;Subtract one since last array is the mask
  nPlots=N_ELEMENTS(h2dStr)-1  & $ 

  FOR i=0, nPlots-1 DO BEGIN & $
    ; Create a PostScript file.
    cgPS_Open, dataname[i]+hemStr+'_'+clockStr+plotsuff+"_"+strtrim(stableIMF,2)+"stable"+hoyDia+".ps" & $
    saveme1,h2dStr[i],dataName[i],allData & $
    cgPS_Close & $
  
    ; Create a PNG file with a width of 600 pixels.
    cgPS2Raster, dataname[i]+hemStr+'_'+clockStr+plotsuff+"_"+strtrim(stableIMF,2)+"stable"+hoyDia+".ps", $
    /PNG, Width=1000 & $
  
  ENDFOR  & $ 
  
ENDFOR