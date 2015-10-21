;2015/10/21
;Maybe this makes life a little easier

  wholecap = 1

  charSize = cgDefCharSize()*((N_ELEMENTS(wholeCap) EQ 0) ? 1.0 : 0.7 )
  charsize_grid=2.0

  ;;color tables
  ctIndex_allPosData       = 39 ;This, I believe, is the color table that Chris Chaston likes
  ctBrewer_allPosData      = 0
  ctReverse_allPosData     = 0
  ;; ctIndex_allPosData       = 16         ;This is the one I usually use
  ;; ctBrewer_allPosData      = 1

  ctIndex                  = 22
  ctBrewer                 = 1
  ctReverse                = 0
  
  defLabelFormat           = '(E0.4)'
  latLabelFormat           = '(I0)'
  lonLabelFormat           = '(I0)'
  integralLabelFormat      = '(D0.3)'