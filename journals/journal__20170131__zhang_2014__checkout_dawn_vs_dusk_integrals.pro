;;01/31/17
PRO JOURNAL__20170131__ZHANG2014__CHECKOUT_DAWN_VS_DUSK_INTEGRALS

  COMPILE_OPT IDL2

  dir           = '/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/saves_output_etc/20170129/'
  statsFile     = 'OMNI_stats--Alfvens_dodat_20170127.sav'

  integPrecis   = 'F0.2'
  integPrecis   = 'F0.4'

  hemi          = 'NORTH'
  ;; hemi          = 'SOUTH'

  especs        = 1

  rel_to_bzNorth = 1
  up_to_90       = 1

  evryStr     = ''
  IF KEYWORD_SET(rel_to_bzNorth) THEN BEGIN
     evryStr += 'rel to BzNorth' 
  ENDIF

  fDir          = '/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/temp/'
  CASE 1 OF
     KEYWORD_SET(eSpecs): BEGIN
        fPref  = 'polarplots_NWO-'
        IF KEYWORD_SET(up_to_90) THEN BEGIN
           fPref += '-upto90-'
           evryStr += (evryStr EQ '' ? '' : '-' ) + 'up to 90 ILAT'
        ENDIF
        fPref += 'Dst_-50750-4300_km--orbs_500-12670-' + hemi + '-0sampT-avgnStorm_9stable_0.0Del_30.0Res_0.0Ofst_btMin1.0-Ring_tAvgd_'
        fSuffs = ['NoN-eNumFl-all_fluxes_eSpec-2009_' + ['diff','mono','broad'], $
                  'eFlux-all_fluxes_eSpec-2009_'      + ['diff','mono','broad']] + '.dat'
     END
     ELSE: BEGIN
        ;; fPref = 'polarplots_Dst_-50750-4300km-orb_500-12670-' + hemi + '-avgnStorm_9stable_0.0Del_30.0Res_0.0Ofst_btMin1.0-Ring_'
        fPref  = 'polarplots_Dst_-50'
        IF KEYWORD_SET(up_to_90) THEN BEGIN
           fPref += '--upto90ILAT'
           evryStr += (evryStr EQ '' ? '' : '-' ) + 'up to 90 ILAT'
        ENDIF
        fPref += '750-4300km-orb_500-12670-' + hemi + '-cur_-1-1-avgnStorm_9stable_0.0Del_30.0Res_0.0Ofst_btMin1.0-Ring_'

        fSuffs = ['tAvgd_pF_pF','tAvgd_sptAvg_NoN-iflux_IntgUp','tAvgd_NoN-eNumFl','tAvgd_sptAvg_NoN-eNumFl_eF_LC_intg','tAvgd_eFlux_Max'] + '.dat'
     END
  ENDCASE


  RESTORE,dir+statsFile

  FOR jj=0,N_ELEMENTS(fSuffs)-1 DO BEGIN

     H2DStrArr = !NULL
     RESTORE,fDir+fPref+fSuffs[jj]

     IF KEYWORD_SET(rel_to_bzNorth) THEN BEGIN
        dawnBzNorthI      = H2DStrArr[0].grossIntegrals.custom[0]/H2DStrArr[0].grossFAC
        duskBzNorthI      = H2DStrArr[0].grossIntegrals.custom[1]/H2DStrArr[0].grossFAC
        dawnDuskBzNorthI  = dawnBzNorthI+duskBzNorthI
        ratioBzNorth      = dawnBzNorthI/duskBzNorthI
     ENDIF

     PRINT,''
     PRINT,evryStr
     PRINT,H2DStrArr[jj].title
     PRINT,FORMAT='(A0,T15,A0,T30,A0,T45,A0,T60,A0,T75,A0)',"ClockStr","Dawn Integ","Dusk Integ","Dawn/Dusk","Dawn+Dusk","Dawn wins"
     FOR k=0,N_ELEMENTS(H2DStrArr)-1 DO BEGIN
        
        dawnI             = H2DStrArr[k].grossIntegrals.custom[0]/H2DStrArr[k].grossFAC
        duskI             = H2DStrArr[k].grossIntegrals.custom[1]/H2DStrArr[k].grossFAC
        dawnDuskI         = dawnI+duskI
        ratio             = dawnI/duskI

        CASE 1 OF
           KEYWORD_SET(rel_to_bzNorth): BEGIN
              dawnI       = dawnI/dawnBzNorthI
              duskI       = duskI/duskBzNorthI
              dawnDuskI   = dawnDuskI/dawnDuskBzNorthI
              ratio       = ratio/ratioBzNorth

              winnah      = 0
           END
           ELSE: BEGIN
              winnah            = (H2DStrArr[k].grossIntegrals.custom[0] - H2DStrArr[k].grossIntegrals.custom[1])
              IF winnah GT 0 THEN BEGIN
                 IF ABS(winnah / H2DStrArr[k].grossIntegrals.custom[0]) GE 0.1 THEN BEGIN
                    winnah      = 1
                 ENDIF ELSE BEGIN
                    winnah      = 0
                 ENDELSE
              ENDIF ELSE BEGIN
                 IF ABS(winnah / H2DStrArr[k].grossIntegrals.custom[1]) GE 0.1 THEN BEGIN
                    winnah      = -1
                 ENDIF ELSE BEGIN
                    winnah      = 0
                 ENDELSE
              ENDELSE
           END
        ENDCASE
        PRINT,FORMAT='(A0,T15,'+integPrecis+',T30,'+integPrecis+',T45,'+integPrecis+',T60,'+integPrecis+',T75,I0)', $
              stats.clockStr[k], $
              dawnI, $
              duskI, $
              ratio, $
              dawnDuskI, $
              winnah

     ENDFOR

  ENDFOR
  
END
