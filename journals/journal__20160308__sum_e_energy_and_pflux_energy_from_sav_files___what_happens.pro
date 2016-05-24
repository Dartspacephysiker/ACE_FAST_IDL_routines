PRO JOURNAL__20160308__SUM_E_ENERGY_AND_PFLUX_ENERGY_FROM_SAV_FILES___WHAT_HAPPENS

  h2dFileDir                = '/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/temp/'
  h2dFilePref               = 'polarplots_Mar_5_16--NORTH--despun--logAvg--maskMin5--OMNI--GSM--'
  h2dFileClockStr           = ['dawnward','duskward']

  delayArr                  = [-1500, -1440, -1380, -1320, -1260, $
                               -1200, -1140, -1080, -1020,  -960, $
                                -900,  -840,  -780,  -720,  -660, $
                                -600,  -540,  -480,  -420,  -360, $
                                -300,  -240,  -180,  -120,  -60,  $
                                   0,    60,   120,   180,   240, $
                                 300,   360,   420,   480,   540, $
                                 600,   660,   720,   780,   840, $
                                 900,   960,  1020,  1080,  1140, $
                                1200,  1260,  1320,  1380,  1440, $
                                1500]

  delayStr                  = STRING(FORMAT='("__",F0.2,"mindelay")',delayArr/60.) 

  h2dFileSuffs              = '__0stable__'+delayStr+'__byMin5.0__bzMin-9.0.dat'


  FOR clock_i=0,1 DO BEGIN
     clockStr               = h2dFileClockStr[clock_i]

     FOR delay_i=0,N_ELEMENTS(delayArr)-1 DO BEGIN
        curFile             = h2dFileDir+h2dFilePref+clockStr+h2dFileSuffs[delay_i]
        IF FILE_TEST(curFile) THEN BEGIN
        ENDIF ELSE BEGIN
           PRINT,"Couldn't find " + curFile + "!!!"
        ENDELSE
     ENDFOR

  dawnFiles                 = h2dFilePref+h2dFileClockStr

END