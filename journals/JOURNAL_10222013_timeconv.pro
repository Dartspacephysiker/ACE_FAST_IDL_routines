; IDL Version 8.2.1 (linux x86_64 m64)
; Journal File for spencerh@Meriadoc
; Working directory: /home/spencerh/Research/Chastondb/idl_datafiles/ACE_FAST
; Date: Wed Oct 23 15:24:34 2013
 
restore,"~/Research/Chastondb/idl_datafiles/maximus.dat"
CD, '/home/spencerh/Research/Chastondb/idl_datafiles/ACE_FAST'
;verification that the conversion to time doesn't screw up precision and stuff:
print,maximus.time[0]
;1996-11-21/21:25:25.562
print,str_to_time(maximus.time[0]),format='(F20.10)'
;848611525.5620000362
;See? It's OK
CD, '/home/spencerh/Research/ACE_indices_data/idl'
restore,"acedata_idl.dat"
this=where(mag_prop.BX_GSE GE 1.00e+33)
print,N_ELEMENTS(this)/n_elements(mag_prop.bx_gse)
;           0
print,n_elements(mag_prop.bx_gse)
;     1548713
