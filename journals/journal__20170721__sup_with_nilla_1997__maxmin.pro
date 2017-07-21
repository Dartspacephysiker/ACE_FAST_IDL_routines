RESTORE,'../temp/polarplots_just_1997--300-4300-NORTH_AACGM-cur_-1-1-avg.dat'

  GET_H2D_BIN_AREAS,h2dAreas, $
                    CENTERS1=centersMLT, $
                    CENTERS2=centersILAT, $
                    BINSIZE1=0.75*15, $
                    BINSIZE2=2, $
                    MAX1=24*15, $
                    MAX2=90, $
                    MIN1=0, $
                    MIN2=60, $
                    SHIFT1=0, $
                    SHIFT2=shiftI
  centersMLT /= 15.

  dayInds     = WHERE(centersMLT GE 6  AND centersMLT LT 18, $
                      nDayInds, $
                      COMPLEMENT=nightInds,NCOMPLEMENT=nNightInds)
  dayRegion   = WHERE(centersMLT GE 11  AND centersMLT LT 14, $
                      nDayRegion)
  nightRegion = WHERE(centersMLT GE 21 OR centersMLT LE 1, $
                      nNightRegion)
  HELP,H2DStrArr[-3].name

  HELP,MAX(H2DStrArr[-3].data[dayRegion])
  HELP,MIN(H2DStrArr[-3].data[dayRegion])

  HELP,'bro'
  HELP,''
  HELP,MAX(H2DStrArr[-3].data[nightRegion])

