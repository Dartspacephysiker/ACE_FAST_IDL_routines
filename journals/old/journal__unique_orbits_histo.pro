;This problem has shown itself to be nontrivial, unless I'm
;missing something obvious--quite possible, of course.
;The idea is to take all of the current events, bin them by MLT and
;ILAT as usual, and then so manipulate the histogram so that each
;orbit is only represented once in each bin, rather than multiple
;instances of the same orbit in each bin.
;So far, we have some fun things we've tried:

;***********************************************
;Try something totally different


h2dOrbN=INTARR(N_ELEMENTS(h2dFluxN(*,0)),N_ELEMENTS(h2dFluxN(0,*)))
orbArr=INTARR(N_ELEMENTS(uniqueorbs_ii),N_ELEMENTS(h2dFluxN(*,0)),N_ELEMENTS(h2dFluxN(0,*)))

FOR j=0, N_ELEMENTS(uniqueorbs_ii)-1 DO BEGIN & $
   tempOrb=maximus.orbit(plot_i(uniqueOrbs_ii(j))) & $
   temp_ii=WHERE(maximus.orbit(plot_i) EQ tempOrb) & $
   h2dOrbTemp=hist_2d(maximus.mlt(plot_i),$
                      maximus.ilat(plot_i),$
                      BIN1=binMLT,BIN2=binILAT,$
                      MIN1=MINMLT,MIN2=MINILAT,$
                      MAX1=MAXMLT,MAX2=MAXILAT) & $
   orbARR[j,*,*]=h2dOrbTemp & $
   h2dOrbTemp(WHERE(h2dOrbTemp GT 0)) = 1 & $
   h2dOrbN += h2dOrbTemp & $
ENDFOR

;***********************************************
;The following is all detritus from the study


;;This is how it really is
;cgHistoplot,maximus.ORBIT(plot_i),BINSIZE=1
;h1dOrb=histogram(maximus.orbit(plot_i),$
;                 OMIN=h1dOrbMin,OMAX=h1dOrbMax,REVERSE_INDICES=h1dOrbRI)
;
;;This becomes a "second degree" set of indices, just like uniqueOrbs_ii
;test=cgSetIntersection(phi_gt_0_ii,uniqueOrbs_ii)
;
;;First intersection between the two
;;print,test(0)
;;print,phi_gt_0_ii(0)
;;print,uniqueOrbs_ii(2)
;
;;The span of orbits
;h1dOrbSpan=h1dOrbMax-h1dOrbMin
;print,where(maximus.orbit(plot_i) EQ 5770)
;print,h1dorb(0)
;
;;How long, these orbit streaks?
;orbDur=comp_dur(maximus.orbit(plot_i),wherechange=orbChange)
;
;
;;The sum of all elements in orbDur is the 
;print,total(orbdur)
;print,9995-5770
;print,shift(maximus.ORBIT(plot_i(uniqueOrbs_ii)),-1)-maximus.ORBIT(plot_i(uniqueOrbs_ii))
;
;;This causes h1dOrb to give orbit# in the first column, and #events in
;;the second
;h1dOrb=TRANSPOSE([[(indgen(h1dOrbSpan+1)+h1dOrbMin)],[h1dOrb]])
;h1dOrb=h1dOrb[*,where(h1dOrb[1,*] GT 0)]
;
;;This orbInfos thing tells you the number of orbits who don't
;;show up in the orbDur matrix because they only correspond to a
;;single event
;orbInfos=shift(orbChange[0,*],-1)-orbChange[1,*]-1
;
;I give up, let's do it the old-fashioned way
;Might do something similar for median

;d1   = double(binMLT)
;d2   = double(binILAT)
;w1   = double(MaxMLT - MinMLT)
;w2   = double(MaxILAT - MinILAT)
;I1m  = floor(w1/d1)
;I2m  = floor(w2/d2)
;n1   = I1m + 1L
;n2   = I2m + 1L

;Carries number of contributing orbits to a given cell, auto set to zero
;h2dOrbN=INTARR(n1,n2)
;Carries which orbits those are, exactly
;h2dOrbNVals=PTRARR(n1,n2,/ALLOCATE_HEAP)
;Carries total value of each 
;orbArr=PTRARR(n1,n2,/ALLOCATE_HEAP)

;orbArr_i=0
;oldOrb=maximus.orbit(plot_i)

;FOR ii=0,n_elements(plot_i)-1 DO BEGIN & $
;   testOrb=maximus.orbit(plot_i(ii)) & $
;   testMLT=maximus.mlt(plot_i(ii)) & $
;   testILAT=
;   testMLTbin=FLOOR((maximus.mlt(plot_i(ii))-minMLT)/binMLT) & $
;   testILATbin=FLOOR((maximus.ilat(plot_i(ii))-minILAT)/binILAT) & $
;;   print,"ii = " + strtrim(ii) & $
;;   print, "testOrb = " + strtrim(testOrb) & $
;;   print, "testMLTbin = " + strtrim(testMLTbin) & $
;;   print, "testILATbin = " + strtrim(testILATbin) & $
;   testCond=WHERE(*h2dOrbNVals[testMLTbin,testILATbin] EQ testOrb $
;                 AND ) & $
;   ;Add orbit number to orbArr
;   IF testCond(0) EQ -1 THEN BEGIN & $
;      IF N_ELEMENTS(*h2dOrbNVals[testMLTbin,testILATbin]) EQ 0 THEN BEGIN & $
;         *h2dOrbNVals[testMLTbin,testILATbin]=testOrb & $
;         h2dOrbN[testMLTbin,testILATbin]=1 & $
;      ENDIF ELSE BEGIN & $
;         *h2dOrbNVals[testMLTbin,testILATbin]=[*h2dOrbNVals[testMLTbin,testILATbin],testOrb] & $ 
;         h2dOrbN[testMLTbin,testILATbin] += 1 & $
;      ENDELSE & $
;   ENDIF & $
;   IF N_ELEMENTS(*orbArr[testMLTbin,testILATbin]) EQ 0 THEN BEGIN & $
;      *orbArr[testMLTbin,testILATbin]=[[testOrb],[1]] & $ ;initialize row
;   ENDIF ELSE BEGIN & $
;      IF oldOrb NE testOrb THEN BEGIN & $
;         *orbArr[testMLTbin,testILATbin]=[*orbArr[testMLTbin,testILATbin],[[testOrb],[1]]] & $ ;New row for new orbit
;         ;orbArr_i += 1 & $
;      ENDIF ELSE BEGIN & $
;        (*orbArr[testMLTbin,testILATbin])[-1,1]+=1 & $
;      ENDELSE & $
;   ENDELSE & $
;   oldOrb=testOrb & $
;ENDFOR

;Store index in array 
;indexHisto=[[*,maximus.mlt(plot_i(ii))],[*,maximus.ilat(plot_i(ii))],[*,maximus.orbit(plot_i(ii))]]


;Delete all them variables
;delvar,testOrb,testMLTbin,testILATbin,oldOrb
