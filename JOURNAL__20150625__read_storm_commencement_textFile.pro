;2015/06/26 This file gets used in the routine JOURNAL__20150625__use_arreglado_storm_commencement

PRO JOURNAL__20150625__read_storm_commencement_textFile

  ;; commencement_tmpltFile='storm_commencement_IDL_template.sav'
  ;; txtFile='storm_commencement_relative_to_DST_min_for_77_large_storms_identified_during_FAST_mission_Oct1996-Oct2000.txt'
  ;; datFile='20150625__stuff_for_identifying_sudden_commencement.sav'

  ;; stormCom_template=ASCII_TEMPLATE(txtFile)
  ;; save,stormCom_template,filename='storm_commencement_IDL_template.sav'

  ;; restore,datFile
  ;; restore,commencement_tmpltFile
  ;; largeStorm_commencement=READ_ASCII(txtFile,TEMPLATE=stormCom_template)
  ;; lrg_commencement={ind:largeStorm_commencement.largeStorm_ind,dst_min:largeStorm_commencement.dst_min,offset:largeStorm_commencement.commencement,offset_dst:largeStorm_commencement.commencement_dst}

  ;The above is not as awesome. Use my slightly better file:
  commencementFile='commencement_offsets_for_largestorms--20150625.sav'
  restore,commencementFile

END