;;01/31/17
PRO JOURNAL__20170131__ZHANG2014__CHECKOUT_DAWN_VS_DUSK_INTEGRALS

  COMPILE_OPT IDL2

  dir           = '/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/saves_output_etc/20170129/'
  statsFile     = 'OMNI_stats--Alfvens_dodat_20170127.sav'

  especs        = 1

  hemi          = 'NORTH'
  hemi          = 'SOUTH'

  fDir          = '/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/temp/'
  CASE 1 OF
     KEYWORD_SET(eSpecs): BEGIN
        fPref  = 'polarplots_NWO-Dst_-50750-4300_km--orbs_500-12670-' + hemi + '-0sampT-avgnStorm_9stable_0.0Del_30.0Res_0.0Ofst_btMin1.0-Ring_tAvgd_'
        fSuffs = ['NoN-eNumFl-all_fluxes_eSpec-2009_' + ['diff','mono','broad'], $
                  'eFlux-all_fluxes_eSpec-2009_'      + ['diff','mono','broad']] + '.dat'
     END
     ELSE: BEGIN
        ;; fPref = 'polarplots_Dst_-50750-4300km-orb_500-12670-' + hemi + '-avgnStorm_9stable_0.0Del_30.0Res_0.0Ofst_btMin1.0-Ring_'
        fPref  = 'polarplots_Dst_-50750-4300km-orb_500-12670-' + hemi + '-cur_-1-1-avgnStorm_9stable_0.0Del_30.0Res_0.0Ofst_btMin1.0-Ring_'

        fSuffs = ['tAvgd_pF_pF','tAvgd_sptAvg_NoN-iflux_IntgUp','tAvgd_NoN-eNumFl','tAvgd_sptAvg_NoN-eNumFl_eF_LC_intg','tAvgd_eFlux_Max'] + '.dat'
     END
  ENDCASE


  RESTORE,dir+statsFile

  FOR jj=0,N_ELEMENTS(fSuffs)-1 DO BEGIN

     H2DStrArr = !NULL
     RESTORE,fDir+fPref+fSuffs[jj]

     PRINT,''
     PRINT,H2DStrArr[jj].title
     PRINT,FORMAT='(A0,T15,A0,T30,A0,T45,A0,T60,A0)',"ClockStr","Dawn Integ","Dusk Integ","Dawn/Dusk","Dawn wins"
     FOR k=0,N_ELEMENTS(H2DStrArr)-1 DO BEGIN
        
        winnah = (H2DStrArr[k].grossIntegrals.custom[0] - H2DStrArr[k].grossIntegrals.custom[1])
        IF winnah GT 0 THEN BEGIN
           IF ABS(winnah / H2DStrArr[k].grossIntegrals.custom[0]) GE 0.1 THEN BEGIN
              winnah = 1
           ENDIF ELSE BEGIN
              winnah = 0
           ENDELSE
        ENDIF ELSE BEGIN
           IF ABS(winnah / H2DStrArr[k].grossIntegrals.custom[1]) GE 0.1 THEN BEGIN
              winnah = -1
           ENDIF ELSE BEGIN
              winnah = 0
           ENDELSE
        ENDELSE

        PRINT,FORMAT='(A0,T15,F0.2,T30,F0.2,T45,F0.2,T60,I0)', $
              stats.clockStr[k], $
              H2DStrArr[k].grossIntegrals.custom[0]/H2DStrArr[k].grossFAC, $
              H2DStrArr[k].grossIntegrals.custom[1]/H2DStrArr[k].grossFAC, $
              H2DStrArr[k].grossIntegrals.custom[0]/H2DStrArr[k].grossIntegrals.custom[1], $
              winnah

     ENDFOR

  ENDFOR
  
  STOP

END
