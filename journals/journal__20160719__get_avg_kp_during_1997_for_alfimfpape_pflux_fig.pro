;;07/19/16
;;See, what we need is the average Kp so that we can compare with Keiling et al. [2003] and Zhang's thesis
PRO JOURNAL__20160719__GET_AVG_KP_DURING_1997_FOR_ALFIMFPAPE_PFLUX_FIG

  COMPILE_OPT IDL2,STRICTARRSUBS

  ;; ;;Don't use these lines. We hate them.
  ;; KpDir   = '/SPENCEdata/Research/database/OMNI/'
  ;; KpFile  = 'Kp__1994-2006.sav'

  LOAD_KP_DB,kp,DBFILE=dbFile,DBDIR=dbDir

  ;; Kpfile1 = 'omni2_h0_mrg1hr_19970101_v01.cdf'
  ;; Kpfile2 = 'omni2_h0_mrg1hr_19970701_v01.cdf'

  ;; dat1    = CDF_OPEN(Kpdir+Kpfile1)
  ;; dat2    = CDF_OPEN(Kpdir+Kpfile2)
  
  
  ;;Way better
  @restore_spdfcdas
  ;; Kp = SPDFGETDATA('OMNI2_H0_MRG1HR', 'KP1800', $
  ;; ['1994-01-01T00:00:00.000Z', '2006-12-31T23:59:59.000Z'])
  
  ;; kpTimeUTC = !NULL
  ;; kpVals    = !NULL
  yearAvgs  = !NULL
  year      = !NULL

  startYear = 1980
  stopYear  = 2010
  Kp = SPDFGETDATA('OMNI2_H0_MRG1HR', 'KP1800', $
                   [STRCOMPRESS(startYear,/REMOVE_ALL)+'-01-01T00:00:00.000Z', $
                    STRCOMPRESS(stopYear,/REMOVE_ALL)+'-12-31T23:59:59.000Z'])

  kpTimeUTC = CDF_EPOCH_TO_UTC(kp.epoch.dat)
  kpVals    = kp.kp.dat


  FOR i=startYear,stopYear DO BEGIN
     PRINT,i
     yearStr = STRCOMPRESS(i,/REMOVE_ALL)
     ;; Kp = SPDFGETDATA('OMNI2_H0_MRG1HR', 'KP1800', $
     ;;                  [yearStr+'-01-01T00:00:00.000Z', $
     ;;                   yearStr+'-12-31T23:59:59.000Z'])
     
     startUTC  = STR_TO_TIME(yearStr+'-01-01/00:00:00.000')
     stopUTC   = STR_TO_TIME(yearStr+'-12-31/23:59:59.999')

     min       = MIN(ABS(kpTimeUTC-startUTC),start_i)
     max       = MIN(ABS(kpTimeUTC-stopUTC),stop_i)

     PRINT,'Start (time,i)   : ' + TIME_TO_STR(startUTC,/MS) + ', ' + STRCOMPRESS(start_i,/REMOVE_ALL)
     PRINT,'Stop (time,i)    : ' + TIME_TO_STR(stopUTC ,/MS) + ', ' + STRCOMPRESS(stop_i ,/REMOVE_ALL)

     yearAvgs  = [yearAvgs,MEAN(kpVals[start_i:stop_i])/10.]
     year      = [year,yearStr]
  ENDFOR

  Kp        = {time:kpTimeUTC,kp:kpVals, $
               avgs:yearAvgs, $
               avg_year:year}
  ;; Bartels = SPDFGETDATA('OMNI2_H0_MRG1HR', 'Rot1800', $
  ;;                       ['1997-01-01T00:00:00.000Z', '1997-12-31T23:59:59.000Z'])

  ;; PRINT,'Saving ' + KpFile + ' ...'
  ;; SAVE,Kp,FILENAME=KpDir+KpFile

  STOP
END
