;from IDL docs for MAPGRID
;; If you want more control over the grid labels, then you can set the LABEL_FORMAT property to an IDL function name. 
;; The callback function is called with four parameters: Orientation, Location, Fractional, and DefaultLabel, where:
;; --> Orientation is 0 for a line of longitude (e.g. 120°E) and 1 for a line of latitude (e.g. 45°S)
;; --> Location is the location value (e.g. 120 for 120°E, or -45 for 45°S)
;; --> Fractional is 0 if all of the grid lines are integers, and 1 if any of the grid lines are floating-point numbers (non-integers)
;; --> DefaultLabel is a string giving the default label as computed by MAPGRID

function polar_maplabels, orientation, location, fractional, defaultlabel
  
  if ((ABS(location) eq 0 OR abs(location) eq 180) AND orientation EQ 0) THEN BEGIN
     RETURN, STRTRIM(ROUND(location/15),2) + ' MLT'
  ENDIF

  ;;degree = '!M' + STRING(176b)  ; Use the Math symbol
  IF (orientation EQ 0) THEN BEGIN
     location = (location lt 0) ? LONG(ROUND((location+360)/15)) : LONG(ROUND(location/15)) 
  ENDIF 

  label = STRTRIM(ROUND(location),2)
  suffix = orientation ? ((ABS(location) EQ 70) ? ' ILAT' : '') : $
           ((ABS(location) EQ 0 OR ABS(location) EQ 12) ? ' MLT' : '')
  
  return, label + suffix
end