;***********************************************
;Batch mode to get all IMF orientation plots?
batchMode=1

;clockList=LIST('duskward','dawnward','bzNorth','bzSouth')

;FOR i = 0, N_ELEMENTS(clockList)-1 DO BEGIN & $
;   clockStr=clockList[i] & $
;   @interp_plots_str & $
;ENDFOR

clockStr='duskward'
@interp_plots_str
;.RESET_SESSION

clockStr='dawnward'
@interp_plots_str
;.RESET_SESSION

clockStr='bzNorth'
@interp_plots_str
;.RESET_SESSION

clockStr='bzSouth'
@interp_plots_str
;.RESET_SESSION
