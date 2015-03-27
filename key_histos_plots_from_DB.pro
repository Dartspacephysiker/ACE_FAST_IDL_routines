;+
; NAME: KEY_HISTOS_PLOTS_FROM_DB
;
;
;
; PURPOSE: Get a sense for what's happening in a given database. Specifically, the key data products I'm picking here are
;          -> alt                  (altitude)
;          -> mag_current          (Yep, current derived from magnetometer)
;          -> elec_energy_flux     (electron energy flux)
;          -> delta_b              (peak-to-peak of the max magnetic field fluctuation)
;          -> delta_e              (peak-to-peak of the max electric field fluctuation)
;          -> max_chare_losscone   (Max characteristic energy in the losscone)
;          -> pfluxEst             (Poynting flux estimate)
;            
;          Could also mess around with
;          -> width_x              (width of filament along spacecraft trajectory)
;          -> width_time           (temporal width)
;
; CATEGORY: Are you serious? Everyone knows the answer to this.
;
;
;
; INPUTS:
;
; OPTIONAL INPUTS:
;
; KEYWORD PARAMETERS:
;
; OUTPUTS:
;
; OPTIONAL OUTPUTS:
;
; PROCEDURE:
;
; EXAMPLE:
;
; MODIFICATION HISTORY: 2015/03/27
;                       Birth
;-

PRO KEY_HISTOS_PLOTS_FROM_DB,dbFile

  default_DBFile = "scripts_for_processing_Dartmouth_data/Dartdb_02282015--500-14999--maximus--cleaned.sav"

  IF NOT KEYWORD_SET(dbFile) THEN restore,default_DBFile ELSE restore,dbFile
  

  ;;names of the POSSIBILITIES
  maxTags=tag_names(maximus)

  ;"Key" data products (I guess they're key)
  ;; print,maxTags(3)      ;alt
  ;; print,maxTags(6)      ;mag_current
  ;; print,maxTags(8)      ;elec_energy_flux
  ;; print,maxTags(12)     ;max_chare_losscone
  ;; print,maxTags(22)     ;delta_b
  ;; print,maxTags(23)     ;delta_e
  ;; print,maxTags(48)     ;pfluxEst

  ;; optional
  ;; print,maxTags(21)     ;width_x
  ;; print,maxTags(20)     ;width.time
  
  maxStructInd = [3,6,8,12,22,23,48]
  n_dataz = n_elements(maxStructInd)

  maxStructLims=make_array(n_elements(maxStructInd),2)

  ;; Here's a winning strategy to plot everything versus everything
  ;; This will loop over every unique pair in maxStructInd

  FOR i=1,n_dataz DO BEGIN

     tempStructInd = shift(maxStructInd,-i+1)

     FOR j=1,n_dataz-i DO BEGIN

        mS_i = maxStructInd(i-1)
        mS_j = tempStructInd(j)
;;        print,format='(A0,T20,A0)',maxTags(maxStructInd(i)),maxTags(tempStructInd(j))
        print,format='(I0,T5,I0)',mS_i,mS_j

        ;; Now if we just create a [n_dataz-1]x2 matrix of limits for each data product, we can plot everything versus everything with ease!
        ;; Something like this
        cgscatter2d,maximus.(mS_i),maximus.(mS_j), $
                    XRANGE=maxStructLims(mS_i,*),YRANGE=maxStructLims(mS_j,*), $
                    XTITLE=maxTags(mS_i),YTITLE=maxTags(mS_j), $
                    OUTFILENAME=maxTags(mS_i)+"_vs_"+maxTags(mS_j)+".png"
     ENDFOR

     cghistoplot,maximus.(mS_i),MININPUT=maxStructLims(mS_i,0),MAXINPUT=maxStructLims(mS_i,1),outfilename=maxTags(mS_i)+"_histogram.png"

  ENDFOR

END