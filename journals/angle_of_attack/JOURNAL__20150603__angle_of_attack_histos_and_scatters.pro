;; ;2015/06/03
; The big idear is see if the strange drop-off in angles of attack above ~160 degrees could have anything to do with MLT
;or ILAT. Let's take a look, shall we?

PRO JOURNAL__20150603__angle_of_attack_histos_and_scatters

  dataDir='/SPENCEdata/Research/Cusp/ACE_FAST/'
  aOa_fLFile='angle_of_attack__fastLocDB_20150409--20150601.sav'
  fastLocFile='time_histo_stuff/fastLoc_intervals2--20150409.sav'

  restore,dataDir+aOa_fLFile
  restore,dataDir+fastLocFile

  symTransp=99

  angleLim=20
  bigaOaInds=WHERE(aOa_fastLoc GE 180-angleLim)
  smallaOaInds=WHERE(aOa_fastLoc LE angleLim)

  dpLim=0.05
  bigdPInds=WHERE(dotProds_fastLoc GE 1.0-dpLim)
  smalldPInds=WHERE(dotProds_fastLoc LE -1.0+dpLim)


  ;plot stuff
  w = WINDOW(WINDOW_TITLE="Angle of attack histos", $
             DIMENSIONS=[1000,500])
  bigaOaScatter = SCATTERPLOT(fastLoc.MLT(bigaOaInds),aOa_fastLoc(bigaOaInds), $
                           TITLE='Angle of attack vs. MLT for Angles $ \geq '+STRCOMPRESS(180-angleLim,/REMOVE_ALL)+'\deg$', $
                           SYM_TRANSPARENCY=symTransp,LAYOUT=[2,1,1],/CURRENT)
  smallaOaScatter = SCATTERPLOT(fastLoc.MLT(smallaOaInds),aOa_fastLoc(smallaOaInds), $
                             TITLE='Angle of attack vs. MLT for Angles  $\leq ' + STRCOMPRESS(angleLim,/REMOVE_ALL)+' \deg$', $
                             SYM_TRANSPARENCY=symTransp,LAYOUT=[2,1,2],/CURRENT)

  w2 = WINDOW(WINDOW_TITLE="Dot-product histos", $
             DIMENSIONS=[1000,500])
  bigdPScatter = SCATTERPLOT(fastLoc.MLT(bigdPInds),dotProds_fastLoc(bigdPInds), $
                           TITLE='Dot product vs. MLT for dotprods $ \geq '+STRCOMPRESS(1.0-dpLim,/REMOVE_ALL)+'$', $
                           SYM_TRANSPARENCY=symTransp,LAYOUT=[2,1,1],/CURRENT)
  smalldPScatter = SCATTERPLOT(fastLoc.MLT(smalldPInds),dotProds_fastLoc(smalldPInds), $
                             TITLE='Dot product vs. MLT for dotprods $\leq ' + STRCOMPRESS(-1.0+dpLim,/REMOVE_ALL)+'$', $
                             SYM_TRANSPARENCY=symTransp,LAYOUT=[2,1,2],/CURRENT)


END