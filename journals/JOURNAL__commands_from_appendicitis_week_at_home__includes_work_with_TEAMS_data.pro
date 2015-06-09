;**************************************************
restore,"scripts_for_processing_Dartmouth_data/Dartdb_02042015--first11465--maximus.sav"
cghistoplot,maximus.width_time
cghistoplot,maximus.width_time,maxinput=5
cghistoplot,maximus.width_time,maxinput=1
cghistoplot,maximus.width_time,maxinput=5,binsize=0.5
cghistoplot,maximus.width_time,maxinput=5,binsize=0.25
cghistoplot,maximus.width_time,maxinput=5,binsize=0.1,mininput=0.1
cghistoplot,maximus.width_time,maxinput=5,binsize=0.01,mininput=0.1
cghistoplot,maximus.width_time,binsize=0.01,maxinput=0.1

cghistoplot,maximus.width_time,binsize=0.01,maxinput=0.5
maximus.width_time(uniq(maximus.width_time(sort(maximus.width_time))))
cghistoplot,maximus.width_time,maxinput=5
cghistoplot,maximus.width_time,maxinput=5,xtitle="Time (s)"
cghistoplot,maximus.width_time,maxinput=5,xtitle="Time (s)",filename="current_event_histo.png"
cghistoplot,maximus.db,maxinput=5,xtitle="dB (nT)"
cghistoplot,maximus.delta_b,maxinput=5,xtitle="dB (nT)"
cghistoplot,maximus.delta_b,xtitle="dB (nT)"
cghistoplot,maximus.delta_b,maxinput=1e4,xtitle="dB (nT)"
print,n_elements(where(maximus.delta_b GT 1e4))
cghistoplot,maximus.delta_b,maxinput=1e2,xtitle="dB (nT)"
cghistoplot,maximus.delta_b,maxinput=10,xtitle="dB (nT)"
print,maximus.delta_b(where(maximus.delta_b LE 5))
print,maximus.orbit(where(maximus.delta_b LE 5))
print,maximus.delta_b(where(maximus.mag_current GE 10))
cghistoplot,maximus.delta_b(where(maximus.mag_current GE 10))
cghistoplot,maximus.delta_b(where(maximus.mag_current GE 10)),maxinput=1e2
cghistoplot,maximus.delta_b(where(maximus.mag_current GE 10)),maxinput=15
cghistoplot,maximus.delta_b(where(maximus.mag_current GE 10)),maxinput=6,binsize=0.2
cghistoplot,maximus.delta_b(where(maximus.mag_current GE 10)),maxinput=9,binsize=0.2
cghistoplot,maximus.delta_b(where(maximus.mag_current GE 10)),maxinput=12,binsize=0.2,
cghistoplot,maximus.delta_b(where(maximus.mag_current GE 10)),maxinput=12,binsize=0.2
cghistoplot,maximus.delta_b(where(maximus.mag_current GE 10)),maxinput=12,binsize=0.2,mininput=4
cghistoplot,maximus.delta_b(where(maximus.mag_current GE 10)),maxinput=16,binsize=0.2,mininput=4
cghistoplot,maximus.delta_b(where(maximus.mag_current GE 20)),maxinput=16,binsize=0.2,mininput=4
cghistoplot,maximus.delta_b(where(maximus.mag_current GE 20)),maxinput=40,binsize=0.2,mininput=4
cghistoplot,maximus.delta_b(where(maximus.mag_current GE 30)),maxinput=40,binsize=0.2,mininput=4
cghistoplot,maximus.delta_b(where(maximus.mag_current GE 3)),maxinput=40,binsize=0.2,mininput=4
cghistoplot,maximus.delta_b(where(maximus.mag_current GE 3)),maxinput=16,binsize=0.2,mininput=4
cghistoplot,maximus.delta_b(where(maximus.mag_current GE 10)),maxinput=16,binsize=0.2,mininput=4
cghistoplot,maximus.delta_b(where(maximus.mag_current GE 20)),maxinput=16,binsize=0.2,mininput=4
cghistoplot,maximus.delta_b(where(maximus.mag_current GE 15)),maxinput=16,binsize=0.2,mininput=4
cghistoplot,maximus.delta_b(where(maximus.mag_current GE 10)),maxinput=16,binsize=0.2,mininput=4
cghistoplot,maximus.delta_b(where(maximus.mag_current GE 15)),maxinput=16,binsize=0.2,mininput=4
cghistoplot,maximus.delta_b(where(maximus.mag_current GE 10)),maxinput=16,binsize=0.2,mininput=4
cghistoplot,maximus.delta_b(where(maximus.alt GE 1000 AND maximus.mag_current GE 10)),maxinput=16,binsize=0.2,mininput=4
cghistoplot,maximus.delta_b(where(maximus.alt GE 1000 AND maximus.mag_current GE 20)),maxinput=16,binsize=0.2,mininput=4
cghistoplot,maximus.delta_e(where(maximus.mag_current GE 10)),maxinput=16,binsize=0.2,mininput=4
cghistoplot,maximus.delta_e(where(maximus.mag_current GE 10)),maxinput=16,binsize=0.2,mininput=8
cghistoplot,maximus.delta_e(where(maximus.mag_current GE 20)),maxinput=16,binsize=0.2,mininput=8
cghistoplot,maximus.delta_e(where(maximus.mag_current GE 30)),maxinput=16,binsize=0.2,mininput=8
cghistoplot,maximus.delta_e(where(maximus.mag_current GE 30)),maxinput=30,binsize=0.2,mininput=8
cghistoplot,maximus.delta_e(where(maximus.mag_current GE 20)),maxinput=30,binsize=0.2,mininput=8
cghistoplot,maximus.delta_e(where(maximus.mag_current GE 10)),maxinput=30,binsize=0.2,mininput=8
cghistoplot,maximus.delta_e(where(maximus.mag_current GE 5)),maxinput=30,binsize=0.2,mininput=8
cghistoplot,maximus.delta_e(where(maximus.mag_current GE 3)),maxinput=30,binsize=0.2,mininput=8
cghistoplot,maximus.delta_e(where(maximus.mag_current GE 5)),maxinput=30,binsize=0.2,mininput=8


;**************************************************
restore, '/SPENCEdata/Research/Cusp/database/dartdb/saves/Dartdb_02112015--500-14999--maximus.sav'
print,n_elements(where(maximus.mag_current LT 0))
print,n_elements(where(maximus.mag_current GT 0))
print,n_elements(where(maximus.mag_current GT 10))
print,n_elements(where(maximus.mag_current LT -10))
cghistoplot,maximus.mag_current(where(maximus.mag_current LT -10))
cghistoplot,maximus.mag_current(where(maximus.mag_current LT -10 AND maximus.mag_current GT -1e3))
cghistoplot,maximus.mag_current(where(maximus.mag_current LT -10 AND maximus.mag_current GT -200))
cghistoplot,maximus.mag_current(where(maximus.mag_current LT -10 AND maximus.mag_current GT -500))
cghistoplot,maximus.mag_current(where(maximus.mag_current LT -10 AND maximus.mag_current GT -500)),binsize=0.2,mininput=-20
cghistoplot,maximus.mag_current(where(maximus.mag_current GT 10 AND maximus.mag_current LT 500)),binsize=0.2,maxinput=20
cghistoplot,maximus.mag_current(where(maximus.mag_current GT 10 AND maximus.mag_current LT 500)),binsize=0.2,maxinput=100
cghistoplot,maximus.mag_current(where(maximus.mag_current GT 5 AND maximus.mag_current LT 500)),binsize=0.2,maxinput=100
cghistoplot,maximus.mag_current(where(maximus.mag_current GT 5 AND maximus.mag_current LT 500)),binsize=0.2,maxinput=15
sqrt(4000)
cghistoplot,maximus.mag_current(where(maximus.mag_current LT -5 AND maximus.mag_current GT -500)),binsize=0.2,mininput=-15
cghistoplot,maximus.delta_b(where(maximus.mag_current LT -5 AND maximus.mag_current GT -500)),binsize=0.2,mininput=-15
cghistoplot,maximus.delta_b(where(maximus.mag_current LT -5 AND maximus.mag_current GT -500)),binsize=0.2,mininput=-15,maxinput=200
cghistoplot,maximus.delta_b(where(maximus.mag_current LT -5 AND maximus.mag_current GT -500)),binsize=0.2,mininput=-15,maxinput=20
cghistoplot,maximus.width_x(where(maximus.mag_current LT -5 AND maximus.mag_current GT -500)),binsize=0.2,mininput=-15,maxinput=20
cghistoplot,maximus.width_x(where(maximus.mag_current LT -5 AND maximus.mag_current GT -500))
cghistoplot,maximus.width_x(where(maximus.mag_current LT -5 AND maximus.mag_current GT -500)),maxinput=5e4
cghistoplot,maximus.width_x(where(maximus.mag_current LT -5 AND maximus.mag_current GT -500)),maxinput=1e4
cghistoplot,maximus.width_x(where(maximus.mag_current LT -1 AND maximus.mag_current GT -500)),maxinput=1e4
cghistoplot,maximus.width_x(where(maximus.mag_current LT -10 AND maximus.mag_current GT -500)),maxinput=1e4
cghistoplot,maximus.width_x(where(maximus.mag_current LT -1 AND maximus.mag_current GT -500)),maxinput=1e4
cghistoplot,maximus.width_x(where(maximus.mag_current LT -10 AND maximus.mag_current GT -500)),maxinput=1e4
cghistoplot,maximus.width_x(where(maximus.mag_current LT -1 AND maximus.mag_current GT -500)),maxinput=1e4
cghistoplot,maximus.width_x(where(maximus.mag_current LT -10 AND maximus.mag_current GT -500)),maxinput=1e4,/overplot
cghistoplot,maximus.width_x(where(maximus.mag_current LT -10 AND maximus.mag_current GT -500)),maxinput=1e4
cghistoplot,maximus.width_x(where(maximus.mag_current LT -1 AND maximus.mag_current GT -500)),maxinput=1e4
cghistoplot,maximus.width_x(where(maximus.mag_current LT -10 AND maximus.mag_current GT -500)),maxinput=1e4
cghistoplot,maximus.width_x(where(maximus.mag_current LT -1 AND maximus.mag_current GT -500)),maxinput=1e4
cghistoplot,maximus.width_x(where(maximus.mag_current LT -7 AND maximus.mag_current GT -500)),maxinput=1e4
cgscatter2dupthresh=500
lowthresh=10
lims=where(maximus.mag_current GE lowthresh and maximus.mag_current LE upthresh)
neglims=where(maximus.mag_current LE -lowthresh and maximus.mag_current GE -upthresh)

upthresh=500
lowthresh=10
lims=where(maximus.mag_current GE lowthresh and maximus.mag_current LE upthresh)
neglims=where(maximus.mag_current LE -lowthresh and maximus.mag_current GE -upthresh)

cghistoplot,maximus.width_x(where(maximus.mag_current LT -10 AND maximus.mag_current GT -500)),maxinput=1e4
cghistoplot,maximus.width_x(where(maximus.mag_current LT -1 AND maximus.mag_current GT -500)),maxinput=1e4
cgscatter2d,maximus.alt,maximus.mag_current
cgscatter2d,maximus.alt,maximus.mag_current,yrange=[-100 100]
cgscatter2d,maximus.alt,maximus.mag_current,yrange=[-100, 100]
cgscatter2d,maximus.alt,maximus.mag_current,yrange=[-200, 200]


;**************************************************
commands_for_dusk_dawn_plots
commands_for_dusk_dawn_plots__chare_3e2_to_5e3


;**************************************************
  t1str = STRING("1997-01-10/11:11:14.910")
  t1str = STRING('1997-01-10/11:11:14.910')
load_fa_k0_tms,trange=[t1str,t2str]
exit
help,hm_t1
print,hm_t1.denergy
print,hm_t1.denergy(*,0)
print,hm_t1.denergy(0,*)
print,hm_t1.denergy(*,0)
cgplot,hm_t1.denergy(*,0)
help,hm_t1
print,dtheta
print,hm_t1.dtheta
print,hm_t1.dphi
cgplot,hm_t1.mass(0,*)
cgplot,hm_t1.mass(*,0)
cgplot,hm_t1.mass(*,*)
print,hm_t1.mass(*,*)
help,hm_t1
print,hm_t1.spin_fract
help,hm_t1
print,hm_t1.data[*,*,0]
cgcontour,hm_t1.data[*,*,0]
cgcontour,hm_t1.data[*,*,1]
cgcontour,hm_t1.data[*,*,2]
cgcontour,hm_t1.data[*,*,3]
print,t1str
help,hm_t1
print,time_to_str(tm_h1.time,/ms)
print,time_to_str(hm_t1.time,/ms)
print,time_to_str(hm_t1.end_time,/ms)
exit
print,time_to_str(hm_t1.end_time,/ms)
help,hm_t1
print,tm_h1.data(*,*,0)
print,hm_11.data(*,*,0)
print,hm_t1.data(*,*,0)
print,max(hm_t1.data)
help,hm_t1
print,max(hm_t1.mass)
get_en_spec, 'fa_th_3d', units = 'eflux', gap_time = 60
get_en_spec, 'fa_th_3d', units = 'eflux', gap_time = 60,name=biz
help,biz
print,t1
get_en_spec, 'fa_th_3d', units = 'eflux', gap_time = 60,t1=t1,t2=t2
help,tmp
help
get_en_spec, 'fa_th_3d', units = 'eflux', gap_time = 60,t1=t1,t2=t2,name="chris"
help,chris


;**************************************************
restore, '/SPENCEdata/Research/Cusp/database/dartdb/saves/Dartdb_02112015--500-14999--maximus.sav'
ls
help,maximus
newcurrent=maximus.width_x*maximus.mag_current
cghistoplot,newcurrent
print,where(maximus.delta_x LT 0)
print,where(maximus.width_x LT 0)
cghistoplot,newcurrent,mininput=-1e7,maxinput=1e7
cghistoplot,newcurrent,mininput=-1e6,maxinput=1e6
cghistoplot,newcurrent,mininput=-1e6,maxinput=1e5
cghistoplot,newcurrent,mininput=-1e5,maxinput=1e5
print,n_elements(where(newcurrent LT 0))
print,n_elements(where(newcurrent GT 0))
inds=where(ABS(maximus.mag_current) GT 10)
newcurrent=maximus.width_x(inds)*maximus.mag_current(inds)
cghistoplot,newcurrent,mininput=-1e5,maxinput=1e5
print,n_elements(where(newcurrent LT 0))
print,n_elements(where(newcurrent GT 0))
newcurrent=maximus.width_x(inds)*maximus.mag_current(inds)*maximus.mag_current(inds)
cghistoplot,newcurrent,mininput=-1e5,maxinput=1e5
newcurrent=maximus.width_x(inds)*maximus.mag_current(inds)*maximus.width_x(inds)
cghistoplot,newcurrent,mininput=-1e5,maxinput=1e5
newcurrent=maximus.width_x(inds)*maximus.mag_current(inds)
inds=where(ABS(maximus.mag_current) GT 10)
newcurrent=maximus.width_x(inds)*maximus.mag_current(inds)
cghistoplot,newcurrent,mininput=-1e7,maxinput=1e7
cghistoplot,newcurrent,mininput=-1e5,maxinput=1e5
newcurrent=maximus.width_x(inds)*maximus.mag_current(inds)
cghistoplot,newcurrent,mininput=-1e5,maxinput=1e5
cghistoplot,maximus.width_x(inds),mininput=-1e7,maxinput=1e7
cghistoplot,maximus.width_x(inds)
cghistoplot,maximus.width_x(inds),maxinput=1e4

