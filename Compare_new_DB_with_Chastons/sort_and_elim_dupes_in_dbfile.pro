PRO sort_and_elim_dupes_in_dbfile,dbfile
  
  restore,dbfile

  times=str_to_time(dat.time)
  sorted_times=times(sort(times))
  uniq_times_i=uniq(times,sort(times))
  uniq_times=times(uniq_times_i)

  print,"Original number of elements : " + strcompress(n_elements(dat.time),/REMOVE_ALL)
  print,"Number of duplicate elements: " + strcompress(n_elements(dat.time)-n_elements(uniq_times),/REMOVE_ALL)
  RETURN

END