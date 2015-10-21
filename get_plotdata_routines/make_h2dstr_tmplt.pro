;;2015/10/14
FUNCTION MAKE_H2DSTR_TMPLT,MIN1 = min1in, MIN2 = min2in, $
                      MAX1 = max1in, MAX2 = max2in, $
                      BIN1 = b1in, BIN2 = b2in


    ;Supply default values for keywords.
    min1 = (N_ELEMENTS(min1in) gt 0) ? min1in : (0 < im1min)
    max1 = (N_ELEMENTS(max1in) gt 0) ? max1in : im1max
    min2 = (N_ELEMENTS(min2in) gt 0) ? min2in : (0 < im2min)
    max2 = (N_ELEMENTS(max2in) gt 0) ? max2in : im2max
    b1 = (N_ELEMENTS(b1in) gt 0) ? b1in : 1L
    b2 = (N_ELEMENTS(b2in) gt 0) ? b2in : 1L

    ;Get # of bins for each
    im1bins = FLOOR((max1-min1) / b1) + 1L
    im2bins = FLOOR((max2-min2) / b2) + 1L

    if (im1bins le 0) then MESSAGE, 'Illegal bin size for V1.'
    if (im2bins le 0) then MESSAGE, 'Illegal bin size for V2.'


    h2dStr_tmplt={tmplt_h2dStr, data: DBLARR(im1bins,im2bins), $
                  title : "Template for 2D hist structure", $
                  lim : DBLARR(2), $
                  is_logged : 0}

    RETURN,h2dStr_tmplt

END