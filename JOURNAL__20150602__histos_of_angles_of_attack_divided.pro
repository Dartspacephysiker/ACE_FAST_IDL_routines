
dataDir='/SPENCEdata/Research/Cusp/ACE_FAST/'

aOaDBFile='angle_of_attack__DartDB_20150228_cleaned--20150601.sav'
aOaFastLocFile='angle_of_attack__fastLocDB_20150409--20150601.sav'

restore,dataDir+aOaDBFile
restore,dataDir+aOaFastLocFile

good_mC_i=cgsetintersection(WHERE(FINITE(dotProds_maxClean),/NULL),WHERE(FINITE(aOa_maxClean),/NULL))
good_fL_i=cgsetintersection(WHERE(FINITE(dotProds_fastLoc),/NULL),WHERE(FINITE(aOa_fastLoc),/NULL))

badBoth_mC_i=cgsetintersection(WHERE(~FINITE(dotProds_maxClean),/NULL),WHERE(~FINITE(aOa_maxClean),/NULL))
badBoth_fL_i=cgsetintersection(WHERE(~FINITE(dotProds_fastLoc),/NULL),WHERE(~FINITE(aOa_fastLoc),/NULL))

dotProds_maxClean=dotProds_maxClean(good_mC_i)
aOa_maxClean=aOa_maxClean(good_mC_i)
dotProds_fastLoc=dotProds_fastLoc(good_fL_i)
aOa_fastLoc=aOa_fastLoc(good_fL_i)

fLTags=TAG_NAMES(fastLoc)
bads=where(~FINITE(aOa_fastLoc))
FOR i=0,N_ELEMENTS(fLTags)-1 DO PRINT,fLTags(i),(fastLoc.(i))(bads(0:40))

dPMin=-1
dPMax=1
dPBinSize=0.02
cghistoplot,dotProds_maxClean,MININPUT=dPMin,MAXINPUT=dPMax,HISTDATA=dPHist_maxClean,BINSIZE=dPBinSize,/WINDOW
cghistoplot,dotProds_fastLoc,MININPUT=dPMin,MAXINPUT=dPMax,HISTDATA=dPHist_fastLoc,BINSIZE=dPBinSize,WINDOW=2,LOCATIONS=dotProdBins

dPBins=indgen(n_elements(dPHist_fastLoc))/(dPMax-dPMin)*dPBinSize+dPMin
dPHist_mC_div_fL=FLOAT(dPHist_maxClean)/FLOAT(dPHist_fastLoc)