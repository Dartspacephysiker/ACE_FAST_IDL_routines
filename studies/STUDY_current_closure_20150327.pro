;**************************************************
; The commands at the end of this file were primarily generated during a meeting with Professor LaBelle and Iver Cairns, in
; which we were trying to understand Chris' advice in an email to me, which was as follows:  

;"With regard to the asymmetry in the number of up/down currents – Perhaps see what it looks like if you evaluate Jpara*dx for each event
;and total it for each orbit where dx is the distance along the s/c trajectory mapped to a common altitude. I think this is perhaps a
;better measure of current closure than counting the filaments. A comparison of this with the average value of |jpara*dx| would perhaps
;be meaningful. If not then it could be the current sheet geometry  that screws things up which is perhaps embedded in the database
;somehow from the correlation (or lack thereof) in dbx vs dby - Seem to remember something in there on this. "
;;;;;
; Log
;;;;;
; 2015/03/27
; Haven't finished. Still need to 
; a) get the proper factor for mapping altitudes, and
; b) finish designing the output. One possibility is sketched in the "Header for the output file" below, but it's not coded yet.

; The following is my attempt to actually implement what Chris was talking about

restore, 'scripts_for_processing_Dartmouth_data/Dartdb_02112015--500-14999--maximus.sav'

;output file
date = "20150327"
outFile = "STUDY_current_closure_" + date
openu,outf,outFile,/append,/get_lun 


                 ;; maximus={orbit:[maximus.orbit,dat.orbit],$
                 ;;          alfvenic:[maximus.alfvenic,dat.alfvenic]}

;;1. map width_x to a common altitude
mapAlt = 1000                   ;in km--use this altitude since we don't include data below it

mapped_width_x = maximus.width_x*func_to_map_altitude(maximus.altitude,mapAlt)
currentEst=Jpara*mapped_width_x

;only use good data
good_i = alfven_db_cleaner(maximus,LUN=-1)

;only include large-current events
minMagC = 10 ;10 microA/m^2
good_i = cgSetIntersection(good_i,where(ABS(maximus.mag_current) GT minMagC))

;Uniqueness of orbits in the data set?
uniqueOrbs_ii=UNIQ(maximus.orbit(plot_i),SORT(maximus.orbit(plot_i)))
nOrbs=n_elements(uniqueOrbs_ii)
printf,lun,"There are " + strtrim(nOrbs,2) + " unique orbits in the dataset"




;;Header for the output file
printf,outf,date
printf,outf, "      Orbit             Number of events     |Jpara*mapped_width_x|     stuff"

;;loop over all orbits
initialOrb = 1000
lastOrb = 15000
FOR i=initialOrb,lastOrb DO BEGIN

   orbIndices=WHERE(maximus.orbit EQ i)
   IF orbIndices[0] NE -1 THEN BEGIN
      orbIndices = cgSetIntersection(orbIndices,good_i)
      IF orbIndices[0] NE -1 THEN BEGIN
         ;; orbClosureEst=TOTAL(mapped_width_x(orbIndices)*maximus.mag_current(orbIndices))
         orbClosureEst=TOTAL(currentEst(orbIndices))
      ENDIF ELSE orbClosureEst = !NAN      
   ENDIF
   printf,outf, format= '(I-6,T32,A-0,T74,I-4)',i,str(dart_struct.(arr_elem)[keep_dart[i_dart]]),i_dart
      
ENDFOR


currentClosureEst = TOTAL(currentEst(orbit[blah]_indices))







;************************************************************
;Commands from meeting with Professors LaBelle and Cairns, 2015/03/26
;************************************************************

;; restore, 'scripts_for_processing_Dartmouth_data/Dartdb_02112015--500-14999--maximus.sav'

;; currentEst=maximus.width_x*maximus.mag_current
;; cghistoplot,currentEst

;; print,where(maximus.delta_x LT 0)
;; print,where(maximus.width_x LT 0)

;; cghistoplot,currentEst,mininput=-1e7,maxinput=1e7
;; cghistoplot,currentEst,mininput=-1e6,maxinput=1e6
;; cghistoplot,currentEst,mininput=-1e6,maxinput=1e5
;; cghistoplot,currentEst,mininput=-1e5,maxinput=1e5
;; print,n_elements(where(currentEst LT 0))
;; print,n_elements(where(currentEst GT 0))

restore, 'scripts_for_processing_Dartmouth_data/Dartdb_02112015--500-14999--maximus.sav'

inds=where(ABS(maximus.mag_current) GT 10)

currentEst=maximus.width_x(inds)*maximus.mag_current(inds)

cghistoplot,currentEst,mininput=-1e5,maxinput=1e5
print,n_elements(where(currentEst LT 0))
print,n_elements(where(currentEst GT 0))

cghistoplot,currentEst,mininput=-1e5,maxinput=1e5

;Now try to do width_x^2
currentEst=maximus.width_x(inds)*maximus.mag_current(inds)*maximus.width_x(inds)
cghistoplot,currentEst,mininput=-1e5,maxinput=1e5

cghistoplot,currentEst,mininput=-1e7,maxinput=1e7
cghistoplot,currentEst,mininput=-1e5,maxinput=1e5


;; cghistoplot,maximus.width_x(inds),mininput=-1e7,maxinput=1e7
;; cghistoplot,maximus.width_x(inds)
;; cghistoplot,maximus.width_x(inds),maxinput=1e4


