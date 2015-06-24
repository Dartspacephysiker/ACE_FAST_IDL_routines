;+
;2015/06/22 at U Washington
;This simply runs the other journal file, but sets up the output for pretty postscript
;-

PRO JOURNAL__20150622__OVERLAY_FOUR_STORMS__NICE_OUTPUT__CEDAR2015

  
  JOURNAL__20150620__OVERLAY_STORM_PLOTS__CEDAR2015

  device, /close
  set_plot, 'x'
  !p.font=-1

END