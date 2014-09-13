restore,datadir+'processed/maximus.dat'
thesens=where(ABS(maximus.MAG_CURRENT) LT 10))
thesens=where(ABS(maximus.MAG_CURRENT) LT 10)
cghistoplot,maximus.ALT(thesens)
thosens=where(ABS(maximus.MAG_CURRENT) GE 10)
cghistoplot,maximus.ALT(thosens)
hosens=where(maximus.MLT GE 6 AND maximus.MLT LE 18 AND maximus.ILAT GE 65 AND maximus.ILAT LE 85)
cghistoplot,maximus.alt(hosens),FILL="RED",TITLE="Hist of events by altitude for 6<MLT<18,65<ILAT<85",output="png",outfilename="alt_histo_northhemi"
cghistoplot,maximus.alt(hosens)cghistoplot,maximus.alt(cgSetIntersection(hosens,thesens))
cghistoplot,maximus.alt(cgSetIntersection(hosens,thesens))
cghistoplot,maximus.alt(cgSetIntersection(hosens,thosens))
cghistoplot,maximus.alt(cgSetIntersection(hosens,thosens)),FILL="RED",TITLE="Histo of events by altitude where |mag_c| GE 10 in North Hemi",outfilename="alt_histo_magc_ge_10_northhemi.png",output="PNG"
cghistoplot,maximus.alt(cgSetIntersection(hosens,thesens)),FILL="RED",TITLE="Histo of events by altitude where |mag_c| LT 10 in North Hemi",outfilename="alt_histo_magc_LT_10_northhemi.png",output="PNG"
