;+
; NAME: BATCH_GET_INDS_FROM_DB
;
; PURPOSE: Run GET_INDS_FROM_DB in batches
;
; INPUTS: Anything that can be passed to get_inds_from_db can also be passed to the batch
;            version by way of inheritance of keywords.
;
; MODIFICATION HISTORY:
;      
;      03/29/2014 Born in Wilder 315
;
;-
PRO BATCH_GET_INDS_FROM_DB,INDPREFIX=indPrefix,INDSUFFIX=indSuffix, $
                                          MASKMIN=maskMin,DIRECTIONS=directions, ALL=all, $
                                          _EXTRA=e

  IF KEYWORD_SET(all) AND NOT KEYWORD_SET(directions) THEN BEGIN
     directions=['dawnward', 'duskward', 'all_IMF', 'bzNorth', 'bzSouth']
  ENDIF

  IF NOT KEYWORD_SET(directions) THEN BEGIN
     directions=['dawnward', 'duskward'] ;default
  ENDIF
  PRINT,FORMAT='("IMF ORIENTATIONS: ",T30,(5(A10)))',directions

  ;mask min
  ;; IF N_ELEMENTS(maskMin) EQ 0 THEN maskMin = 4
  ;; PRINT,"Mask min: " + strcompress(maskMin,/REMOVE_ALL)

  ;;loop over IMF orientations
  FOR i=0,N_ELEMENTS(directions)-1 DO BEGIN

     get_inds_from_db, clockstr=directions[i],INDPREFIX=indPrefix,INDSUFFIX=indSuffix, $
                                         maskmin=maskMin, _extra=e

  ENDFOR

END