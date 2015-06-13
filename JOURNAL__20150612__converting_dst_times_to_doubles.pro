

;dst file
restore,'../database/processed/idl_ae_dst_data.dat'

year = Fix(StrMid(dst.date,0,4))
mon =  Fix(StrMid(dst.date,5,2))
day =  Fix(StrMid(dst.date,8,2))
hour = Fix(StrMid(dst.time,0,2))
min =  Fix(StrMid(dst.time,3,2))
sec =  Fix(StrMid(dst.time,6,6),TYPE=4)
julTime=(JulDay(mon,day,year,hour,min,sec) - JulDay(1,1,1970,0,0,0))*24.*60*60

dst={date:STRING(dst.date+"T"+dst.time), $
     time:jultime, $
     doy:dst.doy, $
     dst:dst.dst}

;now ae
year = Fix(StrMid(ae.date,0,4))
mon =  Fix(StrMid(ae.date,5,2))
day =  Fix(StrMid(ae.date,8,2))
hour = Fix(StrMid(ae.time,0,2))
min =  Fix(StrMid(ae.time,3,2))
sec =  Fix(StrMid(ae.time,6,6),TYPE=4)
julTime=(JulDay(mon,day,year,hour,min,sec) - JulDay(1,1,1970,0,0,0))*24.*60*60

ae={date:STRING(ae.date+"T"+ae.time), $
    time:jultime, $
    doy:ae.doy, $
    ae:ae.ae, $
    au:ae.au, $
    al:ae.al, $
    ao:ae.ao}

;now save these little fellers
save,dst,ae,filename='../database/processed/idl_ae_dst_data.dat'