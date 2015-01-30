PRO new_entire_cap_plot

  datFile='temp/whole_cap_all_IMF_practice_data.dat' ;This one's an orb file

  restore,datFile

  nEvDat=h2dstr[2].data                              ;number of events data

  nXlines=(maxMLT-minMLT)/binMLT + 1
  nYlines=(maxILAT-minILAT)/binILAT + 1

  mlts=indgen(nXlines)*binMLT+minMLT
  ilats=indgen(nYlines)*binILAT+minILAT


  greenland_map = MAP('STEREOGRAPHIC', $
                      CENTER_LATITUDE=90, $
                      CENTER_LONGITUDE=0, $
                      FILL_COLOR='Light Blue')
  

END