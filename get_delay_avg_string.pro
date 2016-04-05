FUNCTION GET_DELAY_AVG_STRING,avgType,delayArr,delayDeltaSec,delay_res,binOffset_delay

  avgString = STRING(FORMAT='("__",A0,"_over_",F0.2,"-",F0.2,"minDelays--delay_delta_",I0,"sec")',avgType, $
                     delayArr[0]/60.,delayArr[-1]/60.,delayDeltaSec)

  IF N_ELEMENTS(delay_res) GT 0 THEN delayResStr = STRING(FORMAT='("__",F0.2,"Res")',delay_res/60.) ELSE delayResStr = ""
  IF N_ELEMENTS(binOffset_delay) GT 0 THEN delBinOffStr = STRING(FORMAT='("__",F0.2,"binOffset")',binOffset_delay/60.) ELSE delBinOffStr = ""

  avgString = avgString + delayResStr + delBinOffStr

  RETURN,avgString

END