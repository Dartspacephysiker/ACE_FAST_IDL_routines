;20150513
;Post-thesis proposal
;   The big idea is to figure out if there is a bias in the identification of Alfvén events that corresponds to a certain
;"angle of attack" (as described by Kristina Lynch). The idea is that auroral arcs are very usually elongated in the
;east-west direction, and the change in the B-field as a function of distance that a satellite would measure, cutting
;directly across an arc, vs. that it would measure if it cut obliquely across an arc, would result in (possibly very)
;different calculations in the associated current. 
;   This journal is going to explore how one might calculate such an angle of attack. One naïve estimate is the rate of
;change in MLT relative to {time? ilat? altitude? speed? some combo?}.

;load the DB
dataDir = '/SPENCEdata/Research/Cusp/ACE_FAST/scripts_for_processing_Dartmouth_data/'
dbFile = 'Dartdb_02282015--500-14999--maximus--cleaned.sav'
restore,dataDir+dbFile

curThresh=10 ;only those events with sufficiently large current
curThresh_i=where(abs(maximus.mag_current) GE curThresh)

;find an orbit that has lots of events
minOrb=9901
maxOrb=10000
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

;sort 'em
;; orbSortI = reverse(sort(orbArr[*,1]))
orbSortI = sort(orbArr[*,1])
orbArr[*,0]=orbArr[orbSortI,0]
orbArr[*,1]=orbArr[orbSortI,1]

FOR i=0,n_elements(orbSortI)-1 DO BEGIN
   print,format='("Orbit:",T10,I0,T20,"N events:",T32,I0)',orbArr[i,0],orbArr[i,1]
ENDFOR




;; here are some good ones
;later DB
;; Orbit:   9986      N events:   494
;; Orbit:   9987      N events:   523

;mid-DB
;; Orbit:   4958      N events:   221
;; Orbit:   4793      N events:   411

;;early DB
;; Orbit:   1118      N events:   50
;; Orbit:   1035      N events:   24


orb=9987
orb_i = where(maximus.orbit eq orb)
key_scatterplots_polarproj,just_plot_i=orb_i,outfile='scatterplot--northHemi--orb'+strcompress(orb,/remove_all)+'.png',strans=80, $
                           plotTitle='Orbit '+strcompress(orb,/remove_all)

orb=4793
orb_i = where(maximus.orbit eq orb)
key_scatterplots_polarproj,just_plot_i=orb_i,outfile='scatterplot--northHemi--orb'+strcompress(orb,/remove_all)+'.png',strans=80, $
                           plotTitle='Orbit '+strcompress(orb,/remove_all)

orb=6692
orb_i = where(maximus.orbit eq orb)
key_scatterplots_polarproj,just_plot_i=orb_i,outfile='scatterplot--northHemi--orb'+strcompress(orb,/remove_all)+'.png',strans=80, $
                           plotTitle='Orbit '+strcompress(orb,/remove_all)


;what about orbs with big events?
bigNEvent_i=where(orbArr[*,1] GT 400)
nBigEvOrbs=n_elements(bigNEvent_i)
;; print,format='("[",19(I0, :, ", "),"]")',orbArr[bigNEvent_i,0]
;; bigNEvorbs=[3354, 4019, 4288, 5583, 6465, 6605, 6606, 6692, 6693, 6694, 6720, 8758, 8759, 8760, 9589, 9792, 9797, 9987, 11739]
bigNEvOrbs=orbArr[bigNEvent_i,0]
bigNEvOrbs_i=make_array(150000,/L64)

evCount=0
FOR I=0,NBIGEVORBS-1 DO BEGIN
   curEv_i = where(maximus.orbit EQ bigNEvOrbs[i])
   curEvCount = n_elements(curEv_i)
   bigNEvOrbs_i(evCount:evCount+curEvCount-1)=curEv_i
   evCount += curEvCount
   ;; print,evCount
   ;; print,curEvCount
ENDFOR

min_bigevorbs_i=min(where(bigNEvOrbs_i EQ 0))
bigNevOrbs_i=bigNEvOrbs_i[0:min_bigevorbs_i-1]

bigNEvOrbs_and_current_i = cgsetintersection(bigNEvOrbs_i,curThresh_i)
key_scatterplots_polarproj,just_plot_i=bigNEvOrbs_and_current_i, $
                           outfile='scatterplot--northHemi--orbs_with_more_than_400_events_above_10microAcurthresh.png',strans=95

;these should be equal
;; print,evCount
;; print,min_bigevorbs_i

;just a spot check
;; print,maximus.orbit(bignevorbs_i[6000])
;; print,maximus.orbit(bignevorbs_i[-1])