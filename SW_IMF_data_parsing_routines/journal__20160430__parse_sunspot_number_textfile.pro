PRO JOURNAL__20160430__PARSE_SUNSPOT_NUMBER_TEXTFILE

  sn_dir             = '/SPENCEdata/Research/Cusp/database/sw_omnidata/'
  sn_file            = 'Sunspot_Number--20160430--V2.txt'
  out_sn_file        = 'SSN--20160430--V2.dat'

  ;; sn_ascii_tmplt     = ASCII_TEMPLATE(sn_dir+sn_file)

  sn_ascii_tmplt     = {VERSION: 1.0000000, $
                        DATASTART: 0, $
                        DELIMITER: ' ', $
                        MISSINGVALUE: -1, $
                        COMMENTSYMBOL: "", $
                        FIELDCOUNT: 8, $
                        FIELDTYPES: [3, 3, 3, 4, 3, 4, 3, 7], $
                        FIELDNAMES: ["Y", "M", "D", "Y_FRAC", "SSN", "SSN_STDEV", "N_OBS", "Provisional"], $
                        FIELDLOCATIONS: [0, 5, 8, 11, 21, 25, 32, 36], $
                        FIELDGROUPS: [0, 1, 2, 3, 4, 5, 6, 7]}
  
  ssn                = READ_ASCII(sn_dir+sn_file,TEMPLATE=sn_ascii_tmplt)

  julDay             = JULDAY(ssn.m,ssn.d,ssn.y,0,0,0)
  time_utc           = JULDAY_TO_UTC(julDay)

  tStamp             = TIMESTAMP(DAY=ssn.d, $
                                         ;; HOUR=MAKE_ARRAY(N_ELEMENTS(ssn.d),VALUE=12), $
                                         ;; MINUTE=MAKE_ARRAY(N_ELEMENTS(ssn.d),VALUE=0), $
                                         MONTH=ssn.m, $
                                         ;; SECOND=MAKE_ARRAY(N_ELEMENTS(ssn.d),VALUE=0), $
                                         YEAR=ssn.y) + "/00:00:00"

  ssn                = { $ ;; Y: ssn.y, $
                       ;; M: ssn.m, $
                       ;; D: ssn.d, $
                       TIME: time_utc, $
                       SSN: ssn.ssn, $
                       SSN_STDEV: ssn.ssn_stdev, $
                       N_OBS: ssn.n_obs, $
                       PROVISIONAL: ssn.provisional, $
                       TSTAMP: tStamp, $
                       JULDAY: julday, $
                       Y_FRAC: ssn.y_frac}
  
  PRINT,'saving ' + sn_dir+out_sn_file + '...'
  save,ssn,FILENAME=sn_dir+out_sn_file

END