pro combine_Chaston_Dartmouth_maximus,maximus
;The idea is to combine everything we have with what Chaston already has
;Alfven_Stats_5 produces a few quantities that don't have corresponding products in Alfven_Stats_3. 
;See 'as5_as3_conversion_matrix.ods' to get the scoop.

  ;; Chaston db file
  Chaston_DBfile='/SPENCEdata2/Research/Cusp/database/processed/maximus.dat'
  
  ;; Dartmouth db file
  date='01122015'
  Dartmouth_DB='/SPENCEdata2//Research/Cusp/ACE_FAST/scripts_for_processing_Dartmouth_data/'
  Dart_DBfile=Dartmouth_DB + 'Dartdb_' + date + '_maximus.sav'

  ;; Output db file
  combined_DBfile='Chastdb_Dartdb_combined--' + date + '_maximus.sav'

  max_dart_orb=4099   ;; max dartmouth orbit to use

  ;; Restore these fellers
  restore,Chaston_DBfile
  chast_maximus=maximus

  restore,Dart_DBfile
  dart_maximus=maximus

  ;; don't use overlapping orbits
  chast_ind=where(chast_maximus.orbit GT max_dart_orb)
  dart_ind=where(dart_maximus.orbit LE max_dart_orb)

  ;; combine what quantities are possible to combine
  maximus={orbit:[dart_maximus.orbit(dart_ind),chast_maximus.orbit(chast_ind)],$
           TIME:[dart_maximus.time(dart_ind),chast_maximus.time(chast_ind)],$
           ALT:[dart_maximus.alt(dart_ind),chast_maximus.alt(chast_ind)],$
           MLT:[dart_maximus.mlt(dart_ind),chast_maximus.mlt(chast_ind)],$
           ILAT:[dart_maximus.ilat(dart_ind),chast_maximus.ilat(chast_ind)],$
           MAG_CURRENT:[dart_maximus.MAG_CURRENT(dart_ind),chast_maximus.MAG_CURRENT(chast_ind)],$
           ESA_CURRENT:[dart_maximus.ESA_CURRENT(dart_ind),chast_maximus.ESA_CURRENT(chast_ind)],$
           ELEC_ENERGY_FLUX:[dart_maximus.ELEC_ENERGY_FLUX(dart_ind),chast_maximus.ELEC_ENERGY_FLUX(chast_ind)],$
           INTEG_ELEC_ENERGY_FLUX:[dart_maximus.EFLUX_LOSSCONE_INTEG(dart_ind),chast_maximus.INTEG_ELEC_ENERGY_FLUX(chast_ind)],$
           CHAR_ELEC_ENERGY:[dart_maximus.MAX_CHARE_LOSSCONE(dart_ind),chast_maximus.CHAR_ELEC_ENERGY(chast_ind)],$
           ION_ENERGY_FLUX:[dart_maximus.ION_ENERGY_FLUX(dart_ind),chast_maximus.ION_ENERGY_FLUX(chast_ind)],$
           ION_FLUX:[dart_maximus.ION_FLUX(dart_ind),chast_maximus.ION_FLUX(chast_ind)],$
           ION_FLUX_UP:[dart_maximus.ION_FLUX_UP(dart_ind),chast_maximus.ION_FLUX_UP(chast_ind)],$
           INTEG_ION_FLUX:[dart_maximus.INTEG_ION_FLUX(dart_ind),chast_maximus.INTEG_ION_FLUX(chast_ind)],$
           INTEG_ION_FLUX_UP:[dart_maximus.INTEG_ION_FLUX_UP(dart_ind),chast_maximus.INTEG_ION_FLUX_UP(chast_ind)],$
           CHAR_ION_ENERGY:[dart_maximus.CHAR_ION_ENERGY(dart_ind),chast_maximus.CHAR_ION_ENERGY(chast_ind)],$
           WIDTH_TIME:[dart_maximus.WIDTH_TIME(dart_ind),chast_maximus.WIDTH_TIME(chast_ind)],$
           WIDTH_X:[dart_maximus.WIDTH_X(dart_ind),chast_maximus.WIDTH_X(chast_ind)],$
           DELTA_B:[dart_maximus.DELTA_B(dart_ind),chast_maximus.DELTA_B(chast_ind)],$
           DELTA_E:[dart_maximus.DELTA_E(dart_ind),chast_maximus.DELTA_E(chast_ind)],$
           MODE:[dart_maximus.MODE(dart_ind),chast_maximus.MODE(chast_ind)],$
           SAMPLE_T:[dart_maximus.SAMPLE_T(dart_ind),chast_maximus.SAMPLE_T(chast_ind)],$
           PROTON_FLUX_UP:[dart_maximus.PROTON_FLUX_UP(dart_ind),chast_maximus.PROTON_FLUX_UP(chast_ind)],$
           PROTON_ENERGY_FLUX_UP:[dart_maximus.PROTON_CHAR_ENERGY(dart_ind),chast_maximus.PROTON_ENERGY_FLUX_UP(chast_ind)],$
           OXY_FLUX_UP:[dart_maximus.OXY_FLUX_UP(dart_ind),chast_maximus.OXY_FLUX_UP(chast_ind)],$
           OXY_ENERGY_FLUX_UP:[dart_maximus.OXY_CHAR_ENERGY(dart_ind),chast_maximus.OXY_ENERGY_FLUX_UP(chast_ind)],$
           HELIUM_FLUX_UP:[dart_maximus.HELIUM_FLUX_UP(dart_ind),chast_maximus.HELIUM_FLUX_UP(chast_ind)],$
           HELIUM_ENERGY_FLUX_UP:[dart_maximus.HELIUM_CHAR_ENERGY(dart_ind),chast_maximus.HELIUM_ENERGY_FLUX_UP(chast_ind)],$
           SC_POT:[dart_maximus.SC_POT(dart_ind),chast_maximus.SC_POT(chast_ind)],$
           TOTAL_ELECTRON_ENERGY_DFLUX:[dart_maximus.TOTAL_ELECTRON_ENERGY_DFLUX_SINGLE(dart_ind),chast_maximus.TOTAL_ELECTRON_ENERGY_DFLUX(chast_ind)],$
           TOTAL_ALFVEN_ELECTRON_ENERGY_DFLUX:[dart_maximus.TOTAL_ALFVEN_ELECTRON_ENERGY_DFLUX(dart_ind),chast_maximus.TOTAL_ALFVEN_ELECTRON_ENERGY_DFLUX(chast_ind)],$
           TOTAL_ION_OUTFLOW:[dart_maximus.TOTAL_ION_OUTFLOW_SINGLE(dart_ind),chast_maximus.TOTAL_ION_OUTFLOW(chast_ind)],$
           TOTAL_ALFVEN_ION_OUTFLOW:[dart_maximus.TOTAL_ALFVEN_ION_OUTFLOW(dart_ind),chast_maximus.TOTAL_ALFVEN_ION_OUTFLOW(chast_ind)],$
           TOTAL_UPWARD_ION_OUTFLOW:[dart_maximus.TOTAL_UPWARD_ION_OUTFLOW_SINGLE(dart_ind),chast_maximus.TOTAL_UPWARD_ION_OUTFLOW(chast_ind)],$
           TOTAL_ALFVEN_UPWARD_ION_OUTFLOW:[dart_maximus.TOTAL_ALFVEN_UPWARD_ION_OUTFLOW(dart_ind),chast_maximus.TOTAL_ALFVEN_UPWARD_ION_OUTFLOW(chast_ind)]}


  print,"Saving combined Chaston/Dartmouth DB to " + combined_DBfile
  save,maximus,filename=combined_DBfile

  return

end
