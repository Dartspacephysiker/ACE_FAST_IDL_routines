;2015/06/12 This pro just reads the storm files that Brett gifted me

;PRO read_storm_files,STORMFILENAME=stormFileName

stormDir='/SPENCEdata/Research/Cusp/ACE_FAST/storm_finding_from_Brett/'
largeStormFile='Large_storms_from_20150513_list.txt'
smallStormFile='Small_storms_from_20150513_list.txt'

stormOutDir='/SPENCEdata/Research/Cusp/database/sw_omnidata/'
stormOutFile='large_and_small_storms--1985-2011--Anderson.sav'
  
;; stormTemplate=ascii_template(stormDir+largeStormFile)
;Template for the storm files that Brett provided (many thanks to him)
fieldtypes=[3,3,3,3,3,3,4,4]
fieldnames=["STORM","YEAR", "MONTH", "DAY", "HOUR", "MINUTE", "DST", "DROP_IN_DST"]
fieldlocations=[0,9,22,33,45,57,64,76]
fieldgroups=[0,1,2,3,4,5,6,7]
stormTemplate={version:1.0,$
               datastart:2,$
               delimiter:' ',$
               missingvalue:!values.f_nan,$
               commentsymbol:';',$
               fieldcount:[8],$
               fieldtypes:fieldtypes,$
               fieldnames:fieldnames,$
               fieldlocations:fieldlocations,$
               fieldgroups:fieldgroups}

stormDat=read_ascii(stormDir+largeStormFile,template=stormTemplate)
largeStormDat={is_largeStorm:MAKE_ARRAY(n_elements(stormDat.storm),VALUE=1), $
          storm:stormDat.storm, $
          year:stormDat.year, $
          month:stormDat.month, $
          day:stormDat.day, $
          hour:stormDat.hour, $
          minute:stormDat.minute, $
          dst:stormDat.dst, $
          drop_in_dst:stormDat.drop_in_dst}

stormDat=read_ascii(stormDir+smallStormFile,template=stormTemplate)
smallStormDat={is_largeStorm:MAKE_ARRAY(n_elements(stormDat.storm),VALUE=0), $
          storm:stormDat.storm, $
          year:stormDat.year, $
          month:stormDat.month, $
          day:stormDat.day, $
          hour:stormDat.hour, $
          minute:stormDat.minute, $
          dst:stormDat.dst, $
          drop_in_dst:stormDat.drop_in_dst}

;times?
jultime = (JulDay([largeStormDat.month,smallStormDat.month], $
                 [largeStormDat.day,smallStormDat.day], $
                 [largeStormDat.year,smallStormDat.year], $
                 [largeStormDat.hour,smallStormDat.hour], $
                 [largeStormDat.minute,smallStormDat.minute], $
                 0) - JulDay(1,1,1970,0,0,0) ) * 24. * 60 * 60

stormStruct={stormStruct,is_largeStorm:[largeStormDat.is_largeStorm,smallStormDat.is_largeStorm], $
             storm:[largeStormDat.storm,smallStormDat.storm], $
             time:julTime, $
             tStamp:TIMESTAMP(YEAR = [largeStormDat.year,smallStormDat.year], $
                              MONTH = [largeStormDat.month,smallStormDat.month], $
                              DAY = [largeStormDat.day,smallStormDat.day], $
                              HOUR = [largeStormDat.hour,smallStormDat.hour], $
                              MINUTE = [largeStormDat.minute,smallStormDat.minute], $
                              SECOND = 0), $
             year:[largeStormDat.year,smallStormDat.year], $
             month:[largeStormDat.month,smallStormDat.month], $
             day:[largeStormDat.day,smallStormDat.day], $
             hour:[largeStormDat.hour,smallStormDat.hour], $
             minute:[largeStormDat.minute,smallStormDat.minute], $
             dst:[largeStormDat.dst,smallStormDat.dst], $
             drop_in_dst:[largeStormDat.drop_in_dst,smallStormDat.drop_in_dst]}

save,stormStruct,filename=stormOutDir+stormOutFile