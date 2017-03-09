;;02/14/17
PRO JOURNAL__20170214__ZHANG2014__LOOKIT_OVERALL_B_VARIABILITY

  COMPILE_OPT IDL2,STRICTARRSUBS

  RESTORE,'/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/saves_output_etc/20170210/OMNI_stats--Alfvens_dodat_20170210.sav'

  sigmaIMF = SQRT(stats.stddev.bx*stats.stddev.bx+$
                  stats.stddev.by*stats.stddev.by+$
                  stats.stddev.bz*stats.stddev.bz)

  sC_i = SORT(stats.clockStr) 
  oi   = [sC_i[0],sC_i[2],sC_i[4],sC_i[3],sC_i[1],sC_i[6],sC_i[7],sC_i[5]]
  amp  = ' &'
  endL = ' \\'
  FOR k=0,7 DO BEGIN
     PRINT,FORMAT='(I1,A2,T5,A10,A2,T19,F6.2,A2,T30,F6.2,A2,T40,F6.2,A2,T53,F6.2,A2,T63,F6.2,A2,T73,F6.2,A2,T83,F6.2,A2,T94,F6.2,A2,T104,F6.2,A2,T114,F6.2,A2,T124,F6.2,A2,T134,F6.2,A3)', $
           k+1,amp,stats.prettyClock[k],amp,stats.nPoints[oi[k]]/60./24.,amp,stats.npoints[oi[k]]/FLOAT(stats.nTime[oi[k]])*100.,amp, $
           stats.avg.bx[oi[k]],amp,stats.avg.by[oi[k]],amp,stats.avg.bz[oi[k]],amp,stats.avg.swSpeed[oi[k]]/1000.,amp,stats.avg.dpTilt[oi[k]],amp, $
           stats.stdDev.bx[oi[k]],amp,stats.stdDev.by[oi[k]],amp,stats.stdDev.bz[oi[k]],amp,stats.stdDev.swSpeed[oi[k]]/1000.,amp,stats.stdDev.dpTilt[oi[k]],endL
  ENDFOR

  PRINT,''
  FOR k=0,7 DO BEGIN
     PRINT,FORMAT='(I1,A2,T5,A10,A2,T19,F6.2,A2,T83,F6.2,A2,T94,F6.2,A2,T104,F6.2,A2,T114,F6.2)', $
           k+1,amp,stats.prettyClock[k],amp,stats.nPoints[oi[k]]/60./24.,amp,stats.stdDev.bx[oi[k]],amp,stats.stdDev.by[oi[k]],amp,stats.stdDev.bz[oi[k]],amp,sigmaIMF[oi[k]]

     ;; PRINT,FORMAT='(I1,A2,T5,A10,A2,T19,F6.2,A2,T30,F6.2,A2,T40,F6.2,A2,T53,F6.2,A2,T63,F6.2,A2,T73,F6.2,A2,T83,F6.2,A2,T94,F6.2,A2,T104,F6.2,A2,T114,F6.2,A2,T124,F6.2,A2,T134,F6.2,A3)', $
     ;;       k+1,amp,stats.prettyClock[k],amp,stats.nPoints[oi[k]]/60./24.,amp,stats.npoints[oi[k]]/FLOAT(stats.nTime[oi[k]])*100.,amp, $
     ;;       stats.avg.bx[oi[k]],amp,stats.avg.by[oi[k]],amp,stats.avg.bz[oi[k]],amp,stats.avg.swSpeed[oi[k]]/1000.,amp,stats.avg.dpTilt[oi[k]],amp, $
     ;;       stats.stdDev.bx[oi[k]],amp,stats.stdDev.by[oi[k]],amp,stats.stdDev.bz[oi[k]],amp,stats.stdDev.swSpeed[oi[k]]/1000.,amp,stats.stdDev.dpTilt[oi[k]],endL
  ENDFOR

END
