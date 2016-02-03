;2016/02/03 Professor Lotko rightly questioned by 11 min seemed like the right number.
;    I think I have some confusion based on a long-time-ago conversation with Binzheng about
; the delay between ACE and the ionosphere. However, if the data are already propagated to the
; magnetopause …
;    So just where are these little guys propagated to?
PRO JOURNAL__20160203__WHY_THE_11MIN_DELAY

  LOAD_OMNI_DB,sw_data,/LOAD_CULLED_OMNI_DB

  good_i = sw_data.goodmag_goodtimes_i

  LOAD_OMNI_DB,sw_data,/FORCE_LOAD_DB

  ;;location of the bow shock nose
  cghistoplot,sw_data.bsn_x[good_i[0:100000]]
  bsn_stat             = MOMENT(sw_data.bsn_x[good_i])
END