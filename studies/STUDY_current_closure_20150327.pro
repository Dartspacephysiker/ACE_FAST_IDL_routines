;**************************************************
; These commands were primarily generated during a meeting with Professor LaBelle and Iver Cairns, in which we were trying to understand 
;  Chris' advice in an email to me, which was as follows: 

;"With regard to the asymmetry in the number of up/down currents – Perhaps see what it looks like if you evaluate Jpara*dx for each event
;and total it for each orbit where dx is the distance along the s/c trajectory mapped to a common altitude. I think this is perhaps a
;better measure of current closure than counting the filaments. A comparison of this with the average value of |jpara*dx| would perhaps
;be meaningful. If not then it could be the current sheet geometry  that screws things up which is perhaps embedded in the database
;somehow from the correlation (or lack thereof) in dbx vs dby - Seem to remember something in there on this. "

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


; Here's a totally NEW thang

restore, 'scripts_for_processing_Dartmouth_data/Dartdb_02112015--500-14999--maximus.sav'

1. map width_x to a common altitude
currentEst=Jpara*mapped_width_x

uniqueOrbs_ii=UNIQ(maximus.orbit(plot_i),SORT(maximus.orbit(plot_i)))
nOrbs=n_elements(uniqueOrbs_ii)
printf,lun,"There are " + strtrim(nOrbs,2) + " unique orbits in the dataset"



initialOrb = 1000
lastOrb = 15000
FOR i=initialOrb,lastOrb DO BEGIN

   orbIndices=WHERE(maximus.orbit EQ i)
   IF orbIndices[0] NE -1 THEN BEGIN
      
   ENDIF

ENDFOR


currentClosureEst = TOTAL(currentEst(orbit[blah]_indices))