PRO winnow_chast_and_dart_data_array,cur_thresh=cur_thresh,chast_arr_elem=chast_arr_elem,arr_elem=arr_elem,chast_data=chast_data,dart_data=dart_data,chast_struct=chast_struct,dart_struct=dart_struct,as3=as3

  keep_chast=where(chast_struct.mag_current GT cur_thresh)
  keep_dart=where(dart_struct.mag_current GT cur_thresh)

  chast_data=dart_data(keep_chast)
  dart_data=dart_data(keep_dart)

END