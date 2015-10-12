FUNCTION GET_RESTRICTED_AND_INTERPED_DB_INDICES,dbStruct,satellite,delay,LUN=lun, $
   DBTIMES=dbTimes,dbfile=dbfile,DO_CHASTDB=do_chastdb, HEMI=hemi, $
   ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, $
   MINMLT=minM,MAXMLT=maxM,BINM=binM,MINILAT=minI,MAXILAT=maxI,BINI=binI, $
   BYMIN=byMin,BZMIN=bzMin,BYMAX=byMax,BZMAX=bzMax,CLOCKSTR=clockStr,BX_OVER_BYBZ=Bx_over_ByBz_Lim, $
   STABLEIMF=stableIMF,OMNI_COORDS=omni_Coords,ANGLELIM1=angleLim1,ANGLELIM2=angleLim2, $
   HWMAUROVAL=HwMAurOval, HWMKPIND=HwMKpInd,NO_BURSTDATA=no_burstData, $
   GET_TIME_I_NOT_ALFVENDB_I=get_time_i_not_alfvendb_i
  
  COMPILE_OPT idl2

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1 ;stdout


  final_i = get_chaston_ind(dbStruct,satellite,lun, $
                            DBTIMES=dbTimes,dbfile=dbfile,CHASTDB=do_chastdb, HEMI=hemi, $
                            ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, $
                            MINMLT=minM,MAXMLT=maxM,BINM=binM,MINILAT=minI,MAXILAT=maxI,BINI=binI, $
                            HWMAUROVAL=HwMAurOval, HWMKPIND=HwMKpInd,NO_BURSTDATA=no_burstData,GET_TIME_I_NOT_ALFVENDB_I=get_time_i_not_alfvendb_i)
  phiChast = interp_mag_data(final_i,satellite,delay,lun,DBTIMES=dbTimes, $
                             FASTDBINTERP_I=FASTDBInterp_i,FASTDBSATPROPPEDINTERPED_I=cdbSatProppedInterped_i,MAG_UTC=mag_utc,PHICLOCK=phiClock, $
                             DATADIR=dataDir,SMOOTHWINDOW=smoothWindow, $
                             BYMIN=byMin,BZMIN=bzMin,BYMAX=byMax,BZMAX=bzMax, $
                             OMNI_COORDS=omni_Coords)
  phiImf_ii = check_imf_stability(clockStr,angleLim1,angleLim2,phiChast,cdbSatProppedInterped_i,stableIMF,mag_utc,phiClock,$
                                 LUN=lun,bx_over_bybz=Bx_over_ByBz_Lim)
  
  restricted_and_interped_i=FASTDBInterp_i[phiImf_ii]

  RETURN,restricted_and_interped_i

END