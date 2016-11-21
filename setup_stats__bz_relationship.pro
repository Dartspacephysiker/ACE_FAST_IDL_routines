;;11/21/16
FUNCTION SETUP_STATS__BZ_RELATIONSHIP, $
   FILESDIR=filesDir, $
   OMNI_FILE=OMNI_file, $
   INTEG_FILE=integ_file, $
   NH_INDS=NH_inds, $
   SH_INDS=SH_inds

  COMPILE_OPT IDL2

  RESTORE,(KEYWORD_SET(filesDir) ? filesDir : '') + OMNI_file
  RESTORE,(KEYWORD_SET(filesDir) ? filesDir : '') + integ_file

  BzStats = {bz:{avg:stats.avg.bz, $
                 stddev:stats.stddev.bz}, $
             KL:{avg:stats.avg.kl_efield, $
                 stddev:stats.stddev.kl_efield}, $
             integs:hemiintegs.integrals, $
             areas:hemiintegs.area}

  RETURN,BzStats
END
