;20150513
;This should be interesting
;do orbit number vs number of events

;dbstuff
dataDir = '/SPENCEdata/Research/Cusp/ACE_FAST/scripts_for_processing_Dartmouth_data/'
dbFile = 'Dartdb_02282015--500-14999--maximus--cleaned.sav'
restore,dataDir+dbFile

outFile='n_orbits_vs_n_events_observed.png'

;only those events with sufficiently large current
curThresh=10 
curThresh_i=where(abs(maximus.mag_current) GE curThresh)

;find an orbit that has lots of events
minOrb=1000
maxOrb=14999
;; minOrb=4700
;; maxOrb=5000

orbArr = make_array(maxOrb-minOrb+1,2)

i = 0
FOR orbI=minOrb,maxOrb DO BEGIN
   
   orbArr[i,0]=orbI
   temp_i=where(maximus.orbit EQ orbI)
   IF temp_i[0] NE -1 THEN BEGIN
      temp_i = cgsetintersection(curThresh_i,temp_i)
      IF temp_i[0] NE -1 THEN orbArr[i,1]=n_elements(temp_i)
   ENDIF
   i++
ENDFOR

;save,orbarr,filename='num_events_per_orb_array_20150513.sav'

numvorbplot = SCATTERPLOT(orbArr[*,0], orbArr[*,1], $
                          sym_size=0.8, $
                          SYMBOL='o',SYM_TRANSPARENCY=87,$
                          XTITLE='Orbit number', $
                          YTITLE='Number of events with |J_par| GT 10 microA/m^2', $
                          TITLE='Correlation between number of Alfvén events observed and orbit number?')

numvorbplot.save,outFile,resolution=600
