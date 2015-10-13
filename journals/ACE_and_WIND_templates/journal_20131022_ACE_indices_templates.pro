; IDL Version 8.2.1 (linux x86_64 m64)
; Journal File for spencerh@Meriadoc
; Working directory: /home/spencerh/Research/ACE_data/idltemplates
; Date: Wed Oct 23 11:49:45 2013
 
;ACE_magdata_tmplt= ascii_template()
;ACE_plasmadata_tmplt= ascii_template()
;ACE_tapdata_tmplt= ascii_template()
;AT COMMANDLINE: cat aceplasmaP199802.dat aceplasmaP199803.dat aceplasmaP199804.dat aceplasmaP199805.dat aceplasmaP199806.dat aceplasmaP199807.dat aceplasmaP199808.dat aceplasmaP199809.dat aceplasmaP199810.dat aceplasmaP199811.dat aceplasmaP199812.dat aceplasmaP199901.dat aceplasmaP199902.dat aceplasmaP199903.dat aceplasmaP199904.dat aceplasmaP199905.dat aceplasmaP199906.dat aceplasmaP199907.dat aceplasmaP199908.dat aceplasmaP199909.dat aceplasmaP199910.dat aceplasmaP199911.dat aceplasmaP199912.dat aceplasmaP200001.dat aceplasmaP200002.dat aceplasmaP200003.dat aceplasmaP200004.dat aceplasmaP200005.dat aceplasmaP200006.dat aceplasmaP200007.dat aceplasmaP200008.dat aceplasmaP200009.dat aceplasmaP200010.dat aceplasmaP200011.dat aceplasmaP200012.dat > aceplasmaP_1999802-200012.dat
;plasma_prop=read_ascii("../plasmadata/aceplasmaP_199802-200012.dat",template=ACE_plasmadata_tmplt)
;mag_prop=read_ascii("../magdata/acemagP_199802-200012.dat",template=ACE_magdata_tmplt)
;tap_prop=read_ascii("../tapdata/aceTAP_199802-200012.dat",template=ACE_tapdata_tmplt)
;save,/variables,filename="idl_ACEdata.dat"
;restore,"../../glob_ind_1999-2009/dst_ae_ascii_tmplts_IAGA.dat"
;dst=read_ascii("../ind_1999-2009/DST_1996-2009_IAGA2002.dat",template=tmplt_dst)
;ae=read_ascii("../ind_1999-2009/AE_1996-2009_IAGA2002.dat",template=tmplt_ae)
;save,ae,dst,filename="idl_ae_dst.dat"

