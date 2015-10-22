;2015/10/21
;Maybe this makes life a little easier

  wholecap = 1

  charSize                    = cgDefCharSize()*((N_ELEMENTS(wholeCap) EQ 0) ? 1.0 : 0.7 )
  charSize = cgDefCharSize()*((N_ELEMENTS(wholeCap) EQ 0) ? 1.3 : 0.7 )

  ;;******************************
  ;;Color tables
  ;;******************************

  ;;Number of colors in the colorbar
  nLevels=12

  ;;color table options when all values are positive or logged
  chrisPosScheme              = 1

  IF chrisPosScheme THEN BEGIN
     ctIndex_allPosData       = 39 ;This, I believe, is the color table that Chris Chaston likes
     ctBrewer_allPosData      = 0
     ctReverse_allPosData     = 0
     maskColor                = "black"
     defGridColor             = "white"
     defGridTextColor         = "dark gray"
  ENDIF ELSE BEGIN
     ctIndex_allPosData       = 16 ;This is the one I usually use
     ctBrewer_allPosData      = 1
     ctReverse_allPosData     = 0
     maskColor                = "gray"
     defGridColor             = 'black'
     defGridTextColor         = "black"
  ENDELSE

  ;;color table options when values are positive or negative
  ctIndex                  = 22
  ctBrewer                 = 1
  ctReverse                = 0
  
  defLabelFormat           = '(E0.4)'
  latLabelFormat           = '(I0)'
  lonLabelFormat           = '(I0)'
  integralLabelFormat      = '(D0.3)'

  ;;********************
  ;;GRID DEFAULTS
  ;;********************
  defGridLineThick               = 1.7
  defGridLineThick_PS            = 1.7

  defGridBoldLineThick           = 6
  defGridBoldLineThick_PS        = 7

  defcharSize_grid               = 2.0

  ;;lat/lon/lshell grid defaults
  defGridLats                 = [50,60,70,80]
  defGridLshells              = [2,6,10,14,16,20]

  ;;the bold part
  ;; defBoldGridColor            = 'black'
  defBoldGridLinestyle        = 0
  defBoldLonDelta             = 90
  defBoldLshellDelta          = 10
  defBoldLatDelta             = 10

  ;;**********************************
  ;;Wholecap vs. not-wholecap defaults
  ;;**********************************
  IF N_ELEMENTS(wholeCap) EQ 0 THEN BEGIN
     cbPosition       = [0.25, 0.89, 0.75, 0.91]
     cbTLocation      = "TOP"
     cbVertical       = 0
     cbTCharsize      = cgDefCharsize()*1.0
     cbTextThick      = 1.5

     lTexPos1         = 0.11
     lTexPos2         = 0.68
     bTexPos1         = 0.78
     bTexPos2         = 0.74
     clockStrOffset   = -0.7
  ENDIF ELSE BEGIN
     cbPosition       = [0.86, 0.10, 0.89, 0.90]
     cbTLocation      = "RIGHT"                     ;;"RIGHT" only works if cbVertical == 1
     cbVertical       = 1
     cbTCharsize      = defCharsize_grid
     cbTextThick      = 1.5

     lTexPos1         = 0.09
     lTexPos2         = 0.63
     bTexPos1         = 0.88
     bTexPos2         = 0.84
     clockStrOffset   = -0.8
  ENDELSE

