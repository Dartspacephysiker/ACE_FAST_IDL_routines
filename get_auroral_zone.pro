
FUNCTION get_auroral_zone,nMLTs,minMLT,maxMLT,BNDRY_POLEWARD=bndry_poleward,ACTIVITY_LEVEL=activity_level

  def_activity_level = 7; default used by Chaston
  defMinMLT = 0
  defMaxMLT = 24
  defNMLTs = 48

  ;set up keywords
  IF activity_level EQ !NULL THEN activity_level = def_activity_level
  IF minMLT EQ !NULL THEN minMLT = defMinMLT
  IF maxMLT EQ !NULL THEN maxMLT = defMaxMLT
  IF nMLTs EQ !NULL THEN nMLTs = defNMLTs

  ;Array of MLT values 
  MLTs=indgen(nMLTs,/FLOAT)*(maxMLT-minMLT)/nMLTs+minMLT
  bndry_eqWard=auroral_zone(MLTs,def_activity_level,/lat)/(!DPI)*180.0
  bndry_poleWard=auroral_zone(MLTs,def_activity_level,/lat,/poleward)/(!DPI)*180.0
  
  RETURN, bndry_eqWard

END