; IDL Version 8.2.1 (linux x86_64 m64)
; Journal File for spencerh@Meriadoc
; Working directory: /home/spencerh/Research/Chastondb/idl_datafiles/ACE_FAST
; Date: Wed Oct 23 09:42:48 2013
 
restore,"../maximus.dat"
help,/str,maximus
print, str_to_time(maximus.time[0])
;   8.4861153e+08
print, maximus.time[0]
;1996-11-21/21:25:25.562
print, maximus.time[134924]
;1999-03-02/18:13:54.120
;Zhang & Co. use a delay of 22 min based on cross-correlation analysis(Zhang et al. 2010; Journal Atm. Sol-Terr. Phys.)
print, "Chaston's db spans from", maximus.time[0], " to ", maximus.time[134924]
;Chaston's db spans from1996-11-21/21:25:25.562 to 1999-03-02/18:13:54.120
;Not very much--what's worse is that ACE propagated data begins in Feb 1998
