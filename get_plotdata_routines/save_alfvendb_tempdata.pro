PRO SAVE_ALFVENDB_TEMPDATA,TEMPFILE=tempFile,H2DSTRARR=h2dStrArr,DATANAMEARR=dataNameArr,$
                           MAXM=maxM,MINM=minM,MAXI=maxI,MINI=minI,BINM=binM,BINI=binI,DO_LSHELL=do_lShell,$
                           MINL=minL,MAXL=maxL,BINL=binL,$
                           RAWDIR=rawDir,PARAMSTR=paramStr,$
                           CLOCKSTR=clockStr,PLOTMEDORAVG=plotMedOrAvg,STABLEIMF=stableIMF,HOYDIA=hoyDia,HEMI=hemi

  defTempDir='/SPENCEdata/Research/Cusp/ACE_FAST/temp/'

  tempFile = defTempDir + 'polarplots_'+paramStr+".dat"
  save,h2dStrArr,dataNameArr,maxM,minM,maxI,minI,binM,binI,do_lShell,minL,maxL,binL,$
       rawDir,clockStr,plotMedOrAvg,stableIMF,hoyDia,hemi,$
       filename=tempFile
  

END