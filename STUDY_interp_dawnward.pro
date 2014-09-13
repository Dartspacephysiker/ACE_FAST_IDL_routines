;This is for the northern hemisphere, with IMF predom. dawnward 

;****************************************************
;For super high electron energy fluxes

print,where(h2dEflux gt 5)
;         248
print,h2dEflux(248)
;      13.0022
print,h2dEflux_n(248)
;      2
print,where(h2dEflux gt 2.5)
;         248


print,where(maximus.ELEC_ENERGY_FLUX(cdb_interp_i(phi_le_0_ii)) GE 5)
;        3626        3638

this=cdb_interp_i(phi_le_0_ii(3626))
that=cdb_interp_i(phi_le_0_ii(3638))
shPrintStructVals,maximus,this

;****************************************************
;Now very LOW values (EVIDENTLY -15 isn't enough)

print,where(h2dEflux_av LT -15)
;         170         179

print,h2deflux_av(where(h2deflux_av LT -15))
;     -16.6073     -18.8297
print,h2deflux_n(where(h2deflux_av LT -15))
;           5           2

print,where(maximus.ELEC_ENERGY_FLUX(cdb_interp_i(phi_le_0_ii)) LT -15)
this = where(maximus.ELEC_ENERGY_FLUX(cdb_interp_i(phi_le_0_ii)) LT -15)
print,n_elements(this)

shPrintStructVals,maximus,this
