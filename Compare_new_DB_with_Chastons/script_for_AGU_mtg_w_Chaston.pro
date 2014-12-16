;;Here are the data I'll be taking to Chaston


;orbs=[2030,2057,6065,6065,9000,10000,2587,2587]
;intervals=[0,0,0,1,0,0,0,1]

pro biz,dat
dat=1
;*******************
;for time comparison
thresh=[0,5,10]
;thresh=[5,10]
;orbs=[2030,2057,6065,6065,9000,10000]
;intervals=[0,0,0,1,0,0]
orbs=[2030,2057,6535,9000,10000]
intervals=[0,0,0,0,0]

for j=0,n_elements(thresh)-1 do begin & $
   for i=0,n_elements(orbs)-1 do begin & $
       compare_chastondbfile_dartdbfile_3,orbs[i],interval=intervals[i],out_suffix="--AGU_mtg_w_Chaston",max_tdiff=0.016,check_current_thresh=thresh[j],/only_alfvenic,/check_sorted & $
   endfor & $
endfor

;*******************
;for width_t comparison
thresh=[0,5,10]
;thresh=[5,10]
;orbs=[2030,2057,6065,6065,9000,10000]
;intervals=[0,0,0,1,0,0]
orbs=[2030,2057,6535,9000,10000]
intervals=[0,0,0,0,0]

for j=0,n_elements(thresh)-1 do begin & $
   for i=0,n_elements(orbs)-1 do begin & $
       compare_chastondbfile_dartdbfile_3,orbs[i],interval=intervals[i],out_suffix="--AGU_mtg_w_Chaston",max_tdiff=0.016,check_current_thresh=thresh[j],arr_elem=20,/only_alfvenic,/check_sorted & $
   endfor & $
endfor

end
;*******************