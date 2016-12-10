PRO JOURNAL__20160505__MLT_OF_THE_BIGGEST_PFLUX_EVENTS

  do_despun                = 1
  ;; hemi                     = 'NORTH'
  hemi                     = 'SOUTH'
  
  ;; altitudeRange                 = [3680,4180]
  ;; altitudeRange                 = [3000,4180]
  altitudeRange                 = [2000,3000]
  ;; altitudeRange                 = [1000,2000]
  ;; altitudeRange                 = [340,1000]
 
  altitudeRange            = [[0,4175], $
                              [0340,0680], $
                              [0680,1180], $
                              [1180,1680], $
                              [1680,2180], $
                              [2180,2680], $
                              [2680,3180], $
                              [3180,3680], $
                              [3680,4180]]

  pFluxMin                 = 1
  binSize                  = 0.5

  SET_PLOT_DIR,plotDir,/FOR_SW_IMF,/ADD_TODAY,ADD_SUFF='--big_pFlux_MLT_dists'

  LOAD_MAXIMUS_AND_CDBTIME,maximus,DESPUNDB=despun

  good_i        = GET_CHASTON_IND(maximus,HEMI=hemi)

  nAltRanges    = N_ELEMENTS(altitudeRange[0,*])
  FOR i=0,nAltRanges-1 DO BEGIN
     
     altRange                 = altitudeRange[*,i]

     altStr                   = KEYWORD_SET(altRange) ? STRING(FORMAT='("--altRange_",I0,"-",I0)',altRange[0],altRange[1]) : ''
     altNiceStr               = KEYWORD_SET(altRange) ? STRING(FORMAT='(", altRange ",I0,"-",I0)',altRange[0],altRange[1]) : ''
     
     output                   = plotDir+'MLT_dist_for_pFlux_GE_' + STRCOMPRESS(pFluxMin,/REMOVE_ALL) + altStr + '--' + hemi + '.png'
     title                    = 'MLT distribution for pFlux GE ' + STRCOMPRESS(pFluxMin,/REMOVE_ALL) + altNiceStr + '(' + hemi + ')'


     inds          = WHERE(maximus.pFluxEst GE pFluxMin AND maximus.alt GE altRange[0] AND maximus.alt LE altRange[1])
     inds          = CGSETINTERSECTION(good_i,inds)


     CGHISTOPLOT,maximus.mlt[inds], $
                 MININPUT=0, $
                 MAXINPUT=24, $
                 BINSIZE=binsize, $
                 XTICKS=5, $
                 XTICKVALUES=[0,6,12,18,24], $
                 XTICKNAMES=['0','6','12','18','24'], $
                 OUTPUT=output, $
                 TITLE=title

  ENDFOR

END