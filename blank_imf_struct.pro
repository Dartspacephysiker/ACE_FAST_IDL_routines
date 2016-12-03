;;12/02/16
FUNCTION BLANK_IMF_STRUCT

  COMPILE_OPT IDL2

     IMF_struct = { $
                  clockStr                   : ''      , $
                  angleLim1                  : 0.      , $
                  angleLim2                  : 0.      , $
                  multiple_IMF_clockAngles   : 0B      , $
                  clock_i                    : 0       , $
                  dont_consider_clockAngles  : 0B      , $
                  ;; orbRange                   : [0L,0L] , $
                  ;; altitudeRange              : [0L,0L] , $
                  ;; charERange                 : [0.,0.] , $
                  ;; byMin                   : 0.      , $
                  ;; byMax                   : 0.      , $
                  ;; bzMin                   : 0.      , $
                  ;; bzMax                   : 0.      , $
                  ;; btMin                   : 0.      , $
                  ;; btMax                   : 0.      , $
                  ;; bxMin                   : 0.      , $
                  ;; bxMax                   : 0.      , $
                  abs_byMin               : 0B      , $
                  abs_byMax               : 0B      , $
                  abs_bzMin               : 0B      , $
                  abs_bzMax               : 0B      , $
                  abs_btMin               : 0B      , $
                  abs_btMax               : 0B      , $
                  abs_bxMin               : 0B      , $
                  abs_bxMax               : 0B      , $
                  ;; bx_over_by_ratio_max    : 0.      , $
                  ;; bx_over_by_ratio_min    : 0.      , $
                  ;; Bx_over_ByBz_Lim        : 0.      , $
                  do_not_consider_IMF        : 0B      , $
                  paramString                : ''      , $
                  paramString_list           : LIST()  , $
                  satellite                  : 'OMNI'  , $
                  omni_Coords                : 'GSM'   , $
                  delay                      : 900     , $
                  multiple_delays            : 0B      , $
                  executing_multiples        : 0B      , $
                  ;; multiples                  : 0       , $
                  ;; multiString                : ''      , $
                  delay_res                  : 0.      , $
                  binOffset_delay            : 0.      , $
                  ;; stableIMF                  : 0.      , $
                  ;; smoothWindow               : 0.      , $
                  includeNoConsecData        : 0B      , $
                  earliest_UTC               : 0.D     , $
                  latest_UTC                 : 0.D     , $
                  earliest_julDay            : 0.D     , $
                  latest_julDay              : 0.D}

  RETURN,IMF_struct
END
