; IDL Version 8.2.1 (linux x86_64 m64)
; Journal File for spencerh@Meriadoc
; Working directory: /home/spencerh/Research/ACE_indices_data/idl
; Date: Mon Nov  4 11:34:57 2013
 
restore,dataDir + "/processed/idl_acedata.dat"

;where to save data
culledDataStr=dataDir + "/processed/culled_ACE_magdata.dat"

;Cull IMF data
mag_good=cgSetIntersection(where(mag_prop.bx_gse lt 1.0e33),where(mag_prop.by_gse lt 1.0e33))
print,n_elements(mag_good)
;     1486677
mag_good=cgSetIntersection(where(mag_prop.bz_gse lt 1.0e33),mag_good)
print,n_elements(mag_good)
;     1486677
bx=mag_prop.bx_gse(mag_good)
by=mag_prop.by_gse(mag_good)
bz=mag_prop.bz_gse(mag_good)
mag_day=mag_prop.DAY(mag_good)
mag_hour=mag_prop.hour(mag_good)
mag_minute=mag_prop.MINUTE(mag_good)
mag_month=mag_prop.month(mag_good)
mag_sec=mag_prop.sec(mag_good)
mag_x=mag_prop.x_gse(mag_good)
mag_y=mag_prop.y_gse(mag_good)
mag_z=mag_prop.z_gse(mag_good)
mag_year=mag_prop.year(mag_good)

;conv time to Unix time, so compatible with Chastondb
mag_jultime=julday(mag_month,mag_day,mag_year,mag_hour,mag_minute,mag_SEC)
mag_utc=LONG((mag_jultime-2440587.5)*86400.0)

;don't need extra time stuff now
delvar,mag_month,mag_day,mag_year,mag_hour,mag_minute,mag_SEC,mag_jultime

;don't need mag_prop
delvar,mag_prop

;some derived stuff
phiClock=ATAN(by,bz)
thetaCone=ACOS(abs(bx)/SQRT(bx*bx+by*by+bz*bz))
bxy_over_bz=sqrt(bx*bx+by*by)/abs(bz)
cone_overClock=thetaCone/phiClock

;histos
;cghistoplot,bxy_over_bz,maxinput=70,mininput=-70,xtitle="Sqrt(Bx^2+By^2)/Bz",title="Histogram of Bxy over Bz for ACE data, 1998-2000",output="bxy_over_bz.png"
;cgHistoplot,cone_overClock,title="Distr. of cone angle over clock angle, 1998-2000",xtitle="cone over clock ratio",reverse_indices=ri,mininput=-1e2,maxinput=1e2,output="cone_overClock_zoomout.png"
;cgHistoplot,180/!PI*phiClock,title="Distr. of IMF clock angles, 1998-2000",xtitle="IMF clock angle, degrees",output="IMFclockangle_histo.png"
;cgHistoplot,180/!PI*thetaCone,title="Distr. of IMF cone angles, 1998-2000",xtitle="IMF cone angle, degrees",output="IMFconeangle_histo.png"


;save that garbage
;OBS:save,filename="culled_ACE_magdata.dat",bx,by,bz,mag_day,mag_good,mag_hour,mag_minute,mag_month,mag_sec,mag_x,mag_y,mag_z,mag_year,phiClock,thetaCone,cone_overClock,bxy_over_bz
;OBS01032014:save,filename="culled_ACE_magdata.dat",bx,by,bz,mag_good,mag_x,mag_y,mag_z,phiClock,thetaCone,cone_overClock,bxy_over_bz,mag_utc
save,filename=culledDataStr,bx,by,bz,phiClock,thetaCone,cone_overClock,bxy_over_bz,mag_utc


;Cull SW param data
plasma_good=cgSetIntersection(where(plasma_prop.vx_gse LT 1.0e30),where(plasma_prop.vy_gse lt 1.0e30))
print,n_elements(plasma_good)
plasma_good=cgSetIntersection(where(plasma_prop.vz_gse lt 1.0e30),plasma_good)
print,n_elements(plasma_good)
plasma_good=cgSetIntersection(where(plasma_prop.density lt 1.0e30),plasma_good)
print,n_elements(plasma_good)
plasma_good=cgSetIntersection(where(plasma_prop.temp lt 1.0e30),plasma_good)
print,n_elements(plasma_good)
vx=plasma_prop.vx_gse(plasma_good)
vy=plasma_prop.vy_gse(plasma_good)
vz=plasma_prop.vz_gse(plasma_good)
plasma_density=plasma_prop.density(plasma_good)
plasma_temp=plasma_prop.temp(plasma_good)
plasma_day=plasma_prop.DAY(plasma_good)
plasma_hour=plasma_prop.hour(plasma_good)
plasma_minute=plasma_prop.MINUTE(plasma_good)
plasma_month=plasma_prop.month(plasma_good)
plasma_sec=plasma_prop.sec(plasma_good)
plasma_x=plasma_prop.x_gse(plasma_good)
plasma_y=plasma_prop.y_gse(plasma_good)
plasma_z=plasma_prop.z_gse(plasma_good)
plasma_year=plasma_prop.year(plasma_good)
delvar,plasma_prop

;Cull TAP data
;plasma_good=cgSetIntersection(where(plasma_prop.vx_gse LT 1.0e30),where(plasma_prop.vy_gse lt 1.0e30))
;print,n_elements(plasma_good)
;plasma_good=cgSetIntersection(where(plasma_prop.vz_gse lt 1.0e30),plasma_good)
;print,n_elements(plasma_good)
;plasma_good=cgSetIntersection(where(plasma_prop.density lt 1.0e30),plasma_good)
;print,n_elements(plasma_good)
;plasma_good=cgSetIntersection(where(plasma_prop.temp lt 1.0e30),plasma_good)
;print,n_elements(plasma_good)
;vx=plasma_prop.vx_gse(plasma_good)
;vy=plasma_prop.vy_gse(plasma_good)
;vz=plasma_prop.vz_gse(plasma_good)
;plasma_density=plasma_prop.density(plasma_good)
;plasma_temp=plasma_prop.temp(plasma_good)
;plasma_day=plasma_prop.DAY(plasma_good)
;plasma_hour=plasma_prop.hour(plasma_good)
;plasma_minute=plasma_prop.MINUTE(plasma_good)
;plasma_month=plasma_prop.month(plasma_good)
;plasma_sec=plasma_prop.sec(plasma_good)
;plasma_x=plasma_prop.x_gse(plasma_good)
;plasma_y=plasma_prop.y_gse(plasma_good)
;plasma_z=plasma_prop.z_gse(plasma_good)
;plasma_year=plasma_prop.year(plasma_good)
;delvar,tap_prop
