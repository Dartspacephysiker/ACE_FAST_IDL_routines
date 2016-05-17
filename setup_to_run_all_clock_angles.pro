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
                                  AND_TILING_OPTIONS=and_tiling_options, $
                                  GROUP_LIKE_PLOTS_FOR_TILING=group_like_plots_for_tiling, $
                                  TILE_IMAGES=tile_images, $
                                  TILING_ORDER=tiling_order, $
                                  N_TILE_COLUMNS=n_tile_columns, $
                                  N_TILE_ROWS=n_tile_rows, $
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


  IF KEYWORD_SET(and_tiling_options) THEN BEGIN
     tile_images                 = 1
     IF KEYWORD_SET(group_like_plots_for_tiling) THEN BEGIN
        tiling_order             = [7,0,1,6,-9,2,5,4,3]
        n_tile_columns           = 3
        n_tile_rows              = 3
     ENDIF
     tilePlotSuff                = "--a_la_Zhang_2014"
  ENDIF

END