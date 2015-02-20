cgscatter2d,maximus.elec_energy_flux,maximus.mag_current,xrange=[-50,50],yrange=[-50,50] 


;next batch
ind=where(maximus.mag_current LE -10 OR maximus.mag_current GE 10)

cgscatter2d,maximus.total_eflux_integ(ind),maximus.mag_current(ind),xrange=[-4e4,4e4],yrange=[-50,50]


;how about 
cgscatter2d,maximus.mag_current(ind),maximus.esa_current(ind),yrange=[-100,100],xrange=[-50,50]



;same thing for Chaston database
restore,'../database/processed/maximus.dat'
ind=where(maximus.mag_current LE -10 OR maximus.mag_current GE 10)
cgscatter2d,maximus.mag_current(ind),maximus.esa_current(ind),yrange=[-100,100],xrange=[-50,50]


;poynting flux with current
restore,'scripts_for_processing_Dartmouth_data/Dartdb_02112015--500-14999--maximus.sav'
mu_0 = 4.0e-7 * !PI
POYNT_EST=maximus.DELTA_B * maximus.DELTA_E * 1.0e-9 / mu_0 
cgscatter2d,poynt_est(ind),maximus.mag_current(ind),yrange=[-100,100],xrange=[-50,50]


;Now screening by altitude on flux vs. current
restore,'scripts_for_processing_Dartmouth_data/Dartdb_02112015--500-14999--maximus.sav'
ind=where((maximus.mag_current LE -10 OR maximus.mag_current GE 10) AND maximus.alt GE 3000)
cgscatter2d,maximus.total_eflux_integ(ind),maximus.mag_current(ind),xrange=[-4e4,4e4],yrange=[-50,50]

;Now screening by altitude on flux vs. current
restore,'scripts_for_processing_Dartmouth_data/Dartdb_02112015--500-14999--maximus.sav'
ind=where(maximus.mag_current GE 10 AND maximus.alt GE 3000)
cghistoplot,maximus.total_eflux_integ(ind),mininput=-1e4,maxinput=1e4
n_pos_for_posmagc=n_elements(where(maximus.total_eflux_integ(ind) GT 0))
n_neg_for_posmagc=n_elements(where(maximus.total_eflux_integ(ind) LT 0))
print,'n_pos_for_posmagc: ' + str(n_pos_for_posmagc)
print,'n_neg_for_posmagc: ' + str(n_neg_for_posmagc)
nind=double(n_elements(ind))
print,'%_pos_for_posmagc: ' + str(n_pos_for_posmagc/nind*100.0) + '%'
print,'%_neg_for_posmagc: ' + str(n_neg_for_posmagc/nind*100.0) + '%'


ind=where(maximus.mag_current LE -10 AND maximus.alt GE 3000)
cghistoplot,maximus.total_eflux_integ(ind),mininput=-1e4,maxinput=1e4
n_pos_for_negmagc=n_elements(where(maximus.total_eflux_integ(ind) GT 0))
n_neg_for_negmagc=n_elements(where(maximus.total_eflux_integ(ind) LT 0))
print,'n_pos_for_negmagc: ' + str(n_pos_for_negmagc)
print,'n_neg_for_negmagc: ' + str(n_neg_for_negmagc)
nind=double(n_elements(ind))
print,'%_pos_for_negmagc: ' + str(n_pos_for_negmagc/nind*100.0) + '%'
print,'%_neg_for_negmagc: ' + str(n_neg_for_negmagc/nind*100.0) + '%'