;2017/12/15
; Going to use these orbits for fun
; 1731      106        89        17
; 1817      224       124       100     1997-02-05/11:27:50      1997-02-05/11:30:07
; 1848       59        17        42     1997-02-08/08:14:04      1997-02-08/08:16:15
; 2742      125        74        51     1997-05-01/23:59:26      1997-05-02/00:00:10
; 2880      162        21       141     1997-05-14/18:09:27      1997-05-14/18:10:34
; 2893      216       158        58     1997-05-15/23:00:49      1997-05-15/23:04:36
; 3008      364        54       310     1997-05-26/14:09:32      1997-05-26/14:10:13
; 3131      177        33       144     1997-06-06/23:03:36      1997-06-06/23:04:27
; 3908      162        82        80     1997-08-17/19:19:26      1997-08-17/19:22:21
PRO JOURNAL__20171216__PICKOUT_SOME_DIFFUSE_ALFVENS_IN_THE_CUSP

  COMPILE_OPT IDL2,STRICTARRSUBS

  @common__maximus_vars.pro
  @common__newell_espec.pro

  good_i_date   = '20170817'
  good_i_dir    = '/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/saves_output_etc/' + $
                  good_i_date + '/'
  good_i_file   = 'maximus_good_i__NORTH-' + good_i_date + '.sav'

  RESTORE,good_i_dir+good_i_file

  pasApresMidi  = 0

  CASE 1 OF
     KEYWORD_SET(pasApresMidi): BEGIN
        niceString = 'notCusp'
     END
     ELSE: BEGIN
        niceString = 'cusp'
     END
  ENDCASE

  outFile       = 'NewellInterp_for_' + $
                  (niceString) + $
                  '_Alfs-' + '20171215' + $
                  '.sav'

  LOAD_MAXIMUS_AND_CDBTIME
  ;; LOAD_NEWELL_ESPEC_DB;,/GIGANTE
  
  RESTORE,good_i_dir+outFile

  highCE_i  = WHERE(justGood.charE GE 80, $
                    nHighCE, $
                        COMPLEMENT=lowCE_i, $
                        NCOMPLEMENT=nLowCE)

  PRINT,niceString + ' orbs'
  orbs = justgood.orbit[UNIQ(justgood.orbit,SORT(justgood.orbit))]
  nOrbs = N_ELEMENTS(orbs)
  PRINT,FORMAT='(A8,T10,A8,T20,A8,T30,A8)',"Orbit","N event","N high","N low"
  FOR k=0,nOrbs-1 DO BEGIN
     inds = WHERE(justgood.orbit EQ orbs[k],nHere)
     ;; IF inds[0] EQ -1 THEN CONTINUE
     highCE_inds = WHERE(justGood.charE[inds] GE 80,nHighCE, $
                         COMPLEMENT=lowCE_inds, $
                         NCOMPLEMENT=nLowCE)
     PRINT,FORMAT='(I5,T10,I5,T20,I5,T30,I5,T40,A0,T65,A0)',orbs[k],nHere,nHighCE,nLowCE, $
           T2S(justGood.x[inds[0]]), $
           T2S(justGood.x[inds[-1]])
     IF orbs[k] EQ 1817 THEN BEGIN
        PRINT, "diffuse"
        FOR kk=0,nLowCE-1 DO BEGIN
           PRINT,T2S(justGood.x[inds[lowCE_inds[kk]]],/MS)
        ENDFOR
        PRINT, "accel"
        FOR kk=0,nHighCE-1 DO BEGIN
           PRINT,T2S(justGood.x[inds[highCE_inds[kk]]],/MS)
        ENDFOR
     ENDIF
  ENDFOR
  
  STOP



END
