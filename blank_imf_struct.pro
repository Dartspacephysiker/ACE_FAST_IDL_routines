;;12/02/16
FUNCTION BLANK_IMF_STRUCT

  COMPILE_OPT IDL2

     IMF_struct = { $
                  clockStr                   : ''      , $
                  angleLim1                  : 0.      , $
                  angleLim2                  : 0.      , $
                  clock_i                    : 0       , $
                  dont_consider_clockAngles  : 0B      , $
                  ;; byMin                   : 0.      , $
                  ;; byMax                   : 0.      , $
                  ;; bzMin                   : 0.      , $
                  ;; bzMax                   : 0.      , $
                  ;; btMin                   : 0.      , $
                  ;; btMax                   : 0.      , $
                  ;; bxMin                   : 0.      , $
                  ;; bxMax                   : 0.      , $
                  abs_byMin                  : 0B      , $
                  abs_byMax                  : 0B      , $
                  abs_bzMin                  : 0B      , $
                  abs_bzMax                  : 0B      , $
                  abs_btMin                  : 0B      , $
                  abs_btMax                  : 0B      , $
                  abs_bxMin                  : 0B      , $
                  abs_bxMax                  : 0B      , $
                  do_not_consider_IMF        : 0B      , $
                  satellite                  : 'OMNI'  , $
                  omni_Coords                : 'GSM'   , $
                  delay                      : 900     , $
                  ;; multiple_delays            : 0B      , $
                  ;; multiples               : 0       , $
                  ;; multiString             : ''      , $
                  delay_res                  : 120.    , $
                  binOffset_delay            : 0.      , $
                  ;; stableIMF               : 0.      , $
                  ;; smoothWindow            : 0.      , $
                  includeNoConsecData        : 0B      , $
                  earliest_UTC               : 0.D     , $
                  latest_UTC                 : 0.D     , $
                  use_julDay_not_UTC         : 0B      , $
                  earliest_julDay            : 0.D     , $
                  latest_julDay              : 0.D}

  RETURN,IMF_struct
END
