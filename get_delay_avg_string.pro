FUNCTION GET_DELAY_AVG_STRING,avgType,delayArr,delayDeltaSec

  avgString = STRING(FORMAT='("__",A0,"_over_",F0.2,"-",F0.2,"minDelays--delay_delta_",I0,"sec")',avgType, $
                     delayArr[0]/60.,delayArr[-1]/60.,delayDeltaSec)

  RETURN,avgString

END