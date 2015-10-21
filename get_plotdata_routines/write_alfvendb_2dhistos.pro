;;2015/10/21 maximus and plot_i are only needed for ascii
PRO WRITE_ALFVENDB_2DHISTOS,MAXIMUS=maximus,PLOT_I=plot_i, $
                            WRITEHDF5=writeHDF5,WRITEPROCESSEDH2D=WRITEPROCESSEDH2D,WRITEASCII=writeASCII, $
                            H2DSTRARR=h2dStrArr,DATARAWPTRARR=dataRawPtrArr,DATANAMEARR=dataNameArr, $
                            PARAMSTR=paramStr,PLOTDIR=plotDir

   ;;********************************************************
   ;;Thanks, IDL Coyote--time to write out lots of data
   IF KEYWORD_SET(writeHDF5) THEN BEGIN 
      ;;write out raw data here
      FOR j=0, N_ELEMENTS(h2dStrArr)-2 DO BEGIN 
         fname=plotDir + dataNameArr[j]+paramStr+'.h5' 
         PRINT,"Writing HDF5 file: " + fname 
         fileID=H5F_CREATE(fname) 
         datatypeID=H5T_IDL_CREATE(h2dStrArr[j].data) 
         dataspaceID=H5S_CREATE_SIMPLE(SIZE(h2dStrArr[j].data,/DIMENSIONS)) 
         datasetID = H5D_CREATE(fileID,dataNameArr[j], datatypeID, dataspaceID) 
         H5D_WRITE,datasetID, h2dStrArr[j].data 
         H5F_CLOSE,fileID 
      ENDFOR 

      ;;To read your newly produced HDF5 file, do this:
      ;;s = H5_PARSE(fname, /READ_DATA)
      ;;HELP, s.mydata._DATA, /STRUCTURE  
      IF KEYWORD_SET(writeProcessedH2d) THEN BEGIN 
         FOR j=0, N_ELEMENTS(h2dStrArr)-2 DO BEGIN 
            fname=plotDir + dataNameArr[j]+paramStr+'.h5' 
            PRINT,"Writing HDF5 file: " + fname 
            fileID=H5F_CREATE(fname) 
            
            ;;    datatypeID=H5T_IDL_CREATE() 
            dataspaceID=H5S_CREATE_SIMPLE(SIZE(h2dStrArr[j].data,/DIMENSIONS)) 
            datasetID = H5D_CREATE(fileID,dataNameArr[j], datatypeID, dataspaceID) 
            H5D_WRITE,datasetID, h2dStrArr[j].data 
            
            datatypeID=H5T_IDL_CREATE(h2dStrArr[j].data) 
            dataspaceID=H5S_CREATE_SIMPLE(SIZE(h2dStrArr[j].data,/DIMENSIONS)) 
            datasetID = H5D_CREATE(fileID,dataNameArr[j], datatypeID, dataspaceID) 
            H5D_WRITE,datasetID, h2dStrArr[j].data     
            
            
            datatypeID=H5T_IDL_CREATE(h2dStrArr[j].data) 
            dataspaceID=H5S_CREATE_SIMPLE(SIZE(h2dStrArr[j].data,/DIMENSIONS)) 
            datasetID = H5D_CREATE(fileID,dataNameArr[j], datatypeID, dataspaceID) 
            H5D_WRITE,datasetID, h2dStrArr[j].data 
            H5F_CLOSE,fileID 
         ENDFOR 
      ENDIF 
   ENDIF

   IF KEYWORD_SET(writeASCII) THEN BEGIN 
      ;;These are the "raw" data, just as we got them from Chris
      FOR j = 0, n_elements(dataRawPtrArr)-3 DO BEGIN 
         fname=plotDir + dataNameArr[j]+paramStr+'.ascii' 
         PRINT,"Writing ASCII file: " + fname 
         OPENW,lun2, fname, /get_lun 

         FOR i = 0, N_ELEMENTS(plot_i) - 1 DO BEGIN 
            PRINTF,lun2,(maximus.ILAT[plot_i])[i],(maximus.MLT[plot_i])[i],$
                   (*dataRawPtrArr[j])[i],$
                   FORMAT='(F7.2,1X,F7.2,1X,F7.2)' 
         ENDFOR 
         CLOSE, lun2   
         FREE_LUN, lun2 
      ENDFOR 
      
      ;;NOW DO PROCESSED H2D DATA 
      IF KEYWORD_SET(writeProcessedH2d) THEN BEGIN 
         FOR i = 0, n_elements(h2dStrArr)-1 DO BEGIN 
            fname=plotDir + "h2d_"+dataNameArr[i]+paramStr+'.ascii' 
            PRINT,"Writing ASCII file: " + fname 
            OPENW,lun2, fname, /get_lun 
            FOR j = 0, N_ELEMENTS(outH2DBinsMLT) - 1 DO BEGIN 
               FOR k = 0, N_ELEMENTS(outH2DBinsILAT) -1 DO BEGIN 
                  PRINTF,lun2,outH2DBinsILAT[k],$
                         outH2DBinsMLT[j],$
                         (h2dStrArr[i].data)[j,k],$
                         FORMAT='(F7.2,1X,F7.2,1X,F7.2)' 
               ENDFOR 
            ENDFOR 
            CLOSE, lun2   
            FREE_LUN, lun2 
         ENDFOR 
      ENDIF 
   ENDIF

END