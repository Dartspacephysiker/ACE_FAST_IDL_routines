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