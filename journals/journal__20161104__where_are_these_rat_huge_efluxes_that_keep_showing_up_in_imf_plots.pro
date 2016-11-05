;;11/04/16
PRO JOURNAL__20161104__WHERE_ARE_THESE_RAT_HUGE_EFLUXES_THAT_KEEP_SHOWING_UP_IN_IMF_PLOTS

  COMPILE_OPT IDL2

  orbRange = [7750,10000]
  altRange = [1000,4300]
  hemi     = 'NORTH'
  mltBounds = [22,24]
  ilatBounds = [63,72]

  LOAD_MAXIMUS_AND_CDBTIME,maximus

  these_i = GET_CHASTON_IND(maximus, $
                            ORBRANGE=orbRange, $
                            ALTITUDERANGE=altRange, $
                            MINMLT=mltBounds[0], $
                            MAXMLT=mltBounds[1], $
                            MINILAT=ilatBounds[0], $
                            MAXILAT=ilatBounds[1])
                            

  plotQ      = 'ELEC_ENERGY_FLUX'
  maxDB_i    = (WHERE(STRUPCASE(TAG_NAMES(maximus)) EQ STRUPCASE(plotQ)))[0]

  IF maxDB_i EQ -1 THEN STOP

  columns   = 2
  rows      = 1
  !P.MULTI  = [0, columns, rows, 0, 0]

  CGHISTOPLOT,ABS(maximus.(maxDB_i)[these_i])
                    


END
