;2016/02/18 Only purpose is to set a clock angle
PRO SET_IMF_CLOCK_ANGLE,CLOCKSTR=clockStr,IN_ANGLE1=angleLim1,IN_ANGLE2=AngleLim2, $
                        DONT_CONSIDER_CLOCKANGLES=dont_consider_clockAngles

  COMMON OMNI_STABILITY

  ;;In any case, if we've made it here then ZERO this thing
  C_OMNI__treat_angles_like_bz_south              = 0


  IF KEYWORD_SET(dont_consider_clockAngles) THEN BEGIN
     C_OMNI__clockStr                             = ''
     C_OMNI__noClockAngles                        = 1
     C_OMNI__negAngle                             = 0
     C_OMNI__posAngle                             = 0
  ENDIF ELSE BEGIN

     C_OMNI__clockStr                             = clockStr

     ;;Set up to check correct region: negAngle<phi<posAngle
     CASE STRUPCASE(C_OMNI__clockStr) OF 
        STRUPCASE('duskward'): BEGIN 
           ;;   ctrAngle                          = 90 
           C_OMNI__negAngle                       = angleLim1 
           C_OMNI__posAngle                       = angleLim2 
        END
        STRUPCASE('dawnward'): BEGIN  
           ;;   ctrAngle                          = -90 
           C_OMNI__negAngle                       = -angleLim2 
           C_OMNI__posAngle                       = -angleLim1 
        END
        STRUPCASE('bzNorth'): BEGIN 
           ;;   ctrAngle                          = 0 
           C_OMNI__negAngle                       = -angleLim1 
           C_OMNI__posAngle                       = angleLim1 
        END
        STRUPCASE('bzSouth'): BEGIN  
           ;;   ctrAngle                          = 180 
           C_OMNI__negAngle                       = angleLim2 
           C_OMNI__posAngle                       = -angleLim2 
        END
        STRUPCASE('all_IMF'): BEGIN 
           C_OMNI__negAngle                       = -angleLim1 
           C_OMNI__posAngle                       = angleLim2 
        END
        STRUPCASE('dawn-north'): BEGIN
           ;;   ctrAngle                          = -45
           ;; C_OMNI__negAngle                       = -90.0
           ;; C_OMNI__posAngle                       = -angleLim1
           C_OMNI__negAngle                       = -angleLim2+45.
           C_OMNI__posAngle                       = -angleLim1+45.
        END
        STRUPCASE('dawn-south'): BEGIN
           ;; ctrAngle                            = -135
           ;; C_OMNI__negAngle                       = -angleLim2
           ;; C_OMNI__posAngle                       = -90.0
           C_OMNI__negAngle                       = -angleLim2-45.
           C_OMNI__posAngle                       = -angleLim1+45.
        END
        STRUPCASE('dusk-north'): BEGIN
           ;; ctrAngle                            = 45
           ;; C_OMNI__negAngle                       = angleLim1
           ;; C_OMNI__posAngle                       = 90.0
           C_OMNI__negAngle                       = angleLim1-45.
           C_OMNI__posAngle                       = angleLim2-45.
        END
        STRUPCASE('dusk-south'): BEGIN
           ;; ctrAngle                            = 135
           ;; C_OMNI__negAngle                       = 90.0
           ;; C_OMNI__posAngle                       = angleLim2
           C_OMNI__negAngle                       = angleLim1+45.
           C_OMNI__posAngle                       = angleLim2+45.
        END
        ELSE: BEGIN
           PRINTF,lun, "Only nine options, brother."
           STOP
        END
     ENDCASE

     IF C_OMNI__negAngle LT -180 THEN BEGIN
        PRINTF,lun,"Whoa! you've set some strange limits for IMF clock angle. Treating your range like it's Bz south..."
        C_OMNI__treat_angles_like_bz_south        = 1
        C_OMNI__negAngle                          = C_OMNI_negAngle + 360.
     ENDIF
     IF C_OMNI__posAngle GT 180 THEN BEGIN
        PRINTF,lun,"Whoa! you've set some strange limits for IMF clock angle. Treating your range like it's Bz south..."
        C_OMNI__treat_angles_like_bz_south        = 1
        C_OMNI__posAngle                          = C_OMNI_negAngle - 360.
     ENDIF
  ENDELSE
END