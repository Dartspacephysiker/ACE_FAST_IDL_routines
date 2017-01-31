PRO SETUP_TO_RUN_ALL_CLOCK_ANGLES,multiple_IMF_clockAngles,clockStrings, $
                                  angleLim1,angleLim2, $
                                  IMFStr,IMFTitle, $
                                  BYMIN=byMin, $
                                  BYMAX=byMax, $
                                  BZMIN=bzMin, $
                                  BZMAX=bzMax, $
                                  BTMIN=btMin, $
                                  BTMAX=btMax, $
                                  BXMIN=bxMin, $
                                  BXMAX=bxMax, $
                                  CUSTOM_INTEGRAL_STRUCT=custom_integral_struct, $
                                  CUSTOM_INTEG_MINM=minM_c, $
                                  CUSTOM_INTEG_MAXM=maxM_c, $
                                  CUSTOM_INTEG_MINI=minI_c, $
                                  CUSTOM_INTEG_MAXI=maxI_c, $
                                  AND_TILING_OPTIONS=and_tiling_options, $
                                  GROUP_LIKE_PLOTS_FOR_TILING=group_like_plots_for_tiling, $
                                  TILE_IMAGES=tile_images, $
                                  TILING_ORDER=tiling_order, $
                                  N_TILE_COLUMNS=n_tile_columns, $
                                  N_TILE_ROWS=n_tile_rows, $
                                  TILE__CB_IN_CENTER_PANEL=tile__cb_in_center_panel, $
                                  TILE__NO_COLORBAR_ARRAY=tile__no_colorbar_array, $
                                  TILEPLOTSUFF=tilePlotSuff

  multiple_IMF_clockAngles = 1
  clockStrings    = ['bzNorth','dusk-north','duskward','dusk-south','bzSouth','dawn-south','dawnward','dawn-north']
  angleLim1       = 67.5
  angleLim2       = 112.5  

  IMFStr        = ['1--bzNorth','2--dusk-north','3--duskward','4--dusk-south','5--bzSouth','6--dawn-south','7--dawnward','8--dawn-north']
  IMFTitle      = ['B!Dz!N North','Dusk-North','Duskward','Dusk-South','B!Dz!N South','Dawn-South','Dawnward','Dawn-north']

  IF N_ELEMENTS(byMax) GT 0 THEN BEGIN 
     IMFStr += '--byMax_' + STRCOMPRESS(byMax,/REMOVE_ALL)
     IMFTitle += ' B!Dy!N Max: ' + STRCOMPRESS(byMax,/REMOVE_ALL) + 'nT'
  ENDIF
  IF N_ELEMENTS(byMin) GT 0 THEN BEGIN
     IMFStr += '--byMin_' + STRCOMPRESS(byMin,/REMOVE_ALL)
     IMFTitle += ' B!Dy!N Min: ' + STRCOMPRESS(byMin,/REMOVE_ALL) + 'nT'
  ENDIF
  IF N_ELEMENTS(bzMax) GT 0 THEN BEGIN 
     IMFStr += '--bzMax_' + STRCOMPRESS(bzMax,/REMOVE_ALL)
     IMFTitle += ' B!Dz!N Max: ' + STRCOMPRESS(bzMax,/REMOVE_ALL) + 'nT'
  ENDIF
  IF N_ELEMENTS(bzMin) GT 0 THEN BEGIN
     IMFStr += '--bzMin_' + STRCOMPRESS(bzMin,/REMOVE_ALL)
     IMFTitle += ' B!Dz!N Min: ' + STRCOMPRESS(bzMin,/REMOVE_ALL) + 'nT'
  ENDIF
  IF N_ELEMENTS(btMax) GT 0 THEN BEGIN 
     IMFStr += '--btMax_' + STRCOMPRESS(btMax,/REMOVE_ALL)
     IMFTitle += ' B!Dt!N Max: ' + STRCOMPRESS(btMax,/REMOVE_ALL) + 'nT'
  ENDIF
  IF N_ELEMENTS(btMin) GT 0 THEN BEGIN
     IMFStr += '--btMin_' + STRCOMPRESS(btMin,/REMOVE_ALL)
     IMFTitle += ' B!Dt!N Min: ' + STRCOMPRESS(btMin,/REMOVE_ALL) + 'nT'
  ENDIF
  IF N_ELEMENTS(bxMax) GT 0 THEN BEGIN 
     IMFStr += '--bxMax_' + STRCOMPRESS(bxMax,/REMOVE_ALL)
     IMFTitle += ' B!Dt!N Max: ' + STRCOMPRESS(bxMax,/REMOVE_ALL) + 'nT'
  ENDIF
  IF N_ELEMENTS(bxMin) GT 0 THEN BEGIN
     IMFStr += '--bxMin_' + STRCOMPRESS(bxMin,/REMOVE_ALL)
     IMFTitle += ' B!Dt!N Min: ' + STRCOMPRESS(bxMin,/REMOVE_ALL) + 'nT'
  ENDIF

  clockStrings    = ['bzNorth','dusk-north','duskward','dusk-south','bzSouth','dawn-south','dawnward','dawn-north']

  ;;Do dawn integrals?
  ;; minM_c    = 7.5
  ;; maxM_c    = 10.5
  IF ~KEYWORD_SET(minM_c) THEN minM_c    = [ 6,12]
  IF ~KEYWORD_SET(maxM_c) THEN maxM_c    = [12,18]
  IF ~KEYWORD_SET(minI_c) THEN minI_c    = [70,70]
  IF ~KEYWORD_SET(maxI_c) THEN maxI_c    = [80,80]
  navn_c    = ['dawn','dusk']
  MLTRange  = !NULL
  ILATRange = !NULL
  CASE N_ELEMENTS(minM_c) OF
     0: 
     1: BEGIN

     END
     ELSE: BEGIN
        FOR k=0,N_ELEMENTS(minM_c)-1 DO BEGIN
           MLTRange  = [[[MLTRange]],[[TRANSPOSE(REFORM([REPLICATE(minM_c[k],8),REPLICATE(maxM_c[k],8)],8,2))]]]
           ILATRange = [[[ILATRange]],[[TRANSPOSE(REFORM([REPLICATE(minI_c[k],8),REPLICATE(maxI_c[k],8)],8,2))]]]
        ENDFOR
     END
  ENDCASE
  custom_integral_struct = {MLTRange:MLTRange,ILATRange:ILATRange}

  IF KEYWORD_SET(and_tiling_options) THEN BEGIN
     tile_images                 = 1
     IF KEYWORD_SET(group_like_plots_for_tiling) THEN BEGIN
        tiling_order             = [7,0,1, $
                                    6,-9,2, $
                                    5,4,3]
        n_tile_columns           = 3
        n_tile_rows              = 3
        IF KEYWORD_SET(tile__cb_in_center_panel) THEN BEGIN
           tile__no_colorbar_array = [1,1,1, $
                                      1,1,1, $
                                      1,1,1]
        ENDIF
        tilePlotSuff                = "--Zhang14"
     ENDIF
  ENDIF
END