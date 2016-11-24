FUNCTION GET_CLEAN_OMNI_I,Bx,By,Bz, $
                          LUN=lun

  COMPILE_OPT idl2

  clean_i                        = WHERE((ABS(Bx) LE 99.9) AND $
                                         (ABS(By) LE 99.9) AND $
                                         (ABS(Bz) LE 99.9),nClean, $
                                         NCOMPLEMENT=nNotClean)
  
  PRINTF,lun,"Losing " + STRCOMPRESS(nNotClean,/REMOVE_ALL) + $
         " OMNI entries because corresponding B{x,y,z} aren't within King/Papitashvili bounds"

  RETURN,clean_i
END