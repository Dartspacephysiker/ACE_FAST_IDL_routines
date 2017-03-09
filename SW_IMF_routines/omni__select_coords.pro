PRO OMNI__SELECT_COORDS,Bx, $
                        By_GSE,Bz_GSE,Bt_GSE, $
                        thetaCone_GSE,phiClock_GSE,cone_overClock_GSE,Bxy_over_Bz_GSE, $
                        By_GSM,Bz_GSM,Bt_GSM, $
                        thetaCone_GSM,phiClock_GSM,cone_overClock_GSM,Bxy_over_Bz_GSM, $
                        OMNI_COORDS=OMNI_coords, $
                        LUN=lun

  COMPILE_OPT idl2,strictarrsubs

  @common__omni_stability.pro

  IF KEYWORD_SET(OMNI_coords) THEN BEGIN
     C_OMNI__magCoords           = OMNI_coords 
  ENDIF ELSE BEGIN
     PRINTF,lun,'No OMNI coordinate type selected! Defaulting to GSE ...'
     C_OMNI__magCoords           = 'GSE'
  ENDELSE

  ;;No need to pick up Bx with magcoords, since it's the same either way
  C_OMNI__Bx                     = TEMPORARY(Bx)
  CASE C_OMNI__magCoords OF 
     "GSE": BEGIN
        C_OMNI__By               = TEMPORARY(By_GSE)
        C_OMNI__Bz               = TEMPORARY(Bz_GSE)
        C_OMNI__Bt               = TEMPORARY(Bt_GSE)
        C_OMNI__thetaCone        = TEMPORARY(thetaCone_GSE)
        C_OMNI__phiClock         = TEMPORARY(phiClock_GSE)
        C_OMNI__cone_overClock   = TEMPORARY(cone_overClock_GSE)
        C_OMNI__Bxy_over_Bz      = TEMPORARY(Bxy_over_Bz_GSE)

        By_GSM                   = !NULL
        Bz_GSM                   = !NULL
        Bt_GSM                   = !NULL
        thetaCone_GSM            = !NULL
        phiClock_GSM             = !NULL
        cone_overClock_GSM       = !NULL
        Bxy_over_Bz_GSM          = !NULL
     END
     "GSM": BEGIN
        C_OMNI__By               = TEMPORARY(By_GSM)
        C_OMNI__Bz               = TEMPORARY(Bz_GSM)
        C_OMNI__Bt               = TEMPORARY(Bt_GSM)
        C_OMNI__thetaCone        = TEMPORARY(thetaCone_GSM)
        C_OMNI__phiClock         = TEMPORARY(phiClock_GSM)
        C_OMNI__cone_overClock   = TEMPORARY(cone_overClock_GSM)
        C_OMNI__Bxy_over_Bz      = TEMPORARY(Bxy_over_Bz_GSM)

        By_GSE                   = !NULL
        Bz_GSE                   = !NULL
        Bt_GSE                   = !NULL
        thetaCone_GSE            = !NULL
        phiClock_GSE             = !NULL
        cone_overClock_GSE       = !NULL
        Bxy_over_Bz_GSE          = !NULL
     END
     ELSE: BEGIN
        print,"Invalid/no coordinates chosen for OMNI data! Defaulting to GSM..."
        WAIT,1.0
        C_OMNI__By               = TEMPORARY(By_GSM)
        C_OMNI__Bz               = TEMPORARY(Bz_GSM)
        C_OMNI__Bt               = TEMPORARY(Bt_GSM)
        C_OMNI__thetaCone        = TEMPORARY(thetaCone_GSM)
        C_OMNI__phiClock         = TEMPORARY(phiClock_GSM)
        C_OMNI__cone_overClock   = TEMPORARY(cone_overClock_GSM)
        C_OMNI__Bxy_over_Bz      = TEMPORARY(Bxy_over_Bz_GSM)

        By_GSE                   = !NULL
        Bz_GSE                   = !NULL
        Bt_GSE                   = !NULL
        thetaCone_GSE            = !NULL
        phiClock_GSE             = !NULL
        cone_overClock_GSE       = !NULL
        Bxy_over_Bz_GSE          = !NULL
     END
  ENDCASE
  C_OMNI__thetaCone              = C_OMNI__thetaCone*180/!PI
  C_OMNI__phiClock               = C_OMNI__phiClock*180/!PI

END