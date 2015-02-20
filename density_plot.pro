PRO Density_Plot,x,y,xrange=xrange,yrange=yrange
 
   ; Set up variables for the plot. Normally, these values would be 
   ; passed into the program as positional and keyword parameters.
   x = cgScaleVector(Randomn(-3L, 100000)*2, -10, 10)
   y = cgScaleVector(Randomn(-5L, 100000)*5, 0, 100)
   IF NOT KEYWORD_SET(xrange) then xrange = [Min(x), Max(x)]
   IF NOT KEYWORD_SET(yrange) then yrange  = [Min(y), Max(y)]
   xbinsize = 0.25
   ybinsize = 3.00
   
   ; Open a display window.
   cgDisplay
   
   ; Create the density plot by binning the data into a 2D histogram.
   density = Hist_2D(x, y, Min1=xrange[0], Max1=xrange[1], Bin1=xbinsize, $
                           Min2=yrange[0], Max2=yrange[1], Bin2=ybinsize)   
                           
   maxDensity = Ceil(Max(density)/1e2) * 1e2
   scaledDensity = BytScl(density, Min=0, Max=maxDensity)
                           
   ; Load the color table for the display. All zero values will be gray.
   cgLoadCT, 33
   TVLCT, cgColor('gray', /Triple), 0
   TVLCT, r, g, b, /Get
   palette = [ [r], [g], [b] ]
   
   ; Display the density plot.
   cgImage, scaledDensity, XRange=xrange, YRange=yrange, /Axes, Palette=palette, $
      XTitle='Concentration of X', YTitle='Concentration of Y', $
      Position=[0.125, 0.125, 0.9, 0.8]
      
   thick = (!D.Name EQ 'PS') ? 6 : 2
   cgContour, density, LEVELS=maxDensity*[0.25, 0.5, 0.75], /OnImage, $
       C_Colors=['Tan','Tan', 'Brown'], C_Annotation=['Low', 'Avg', 'High'], $
       C_Thick=thick, C_CharThick=thick
      
   ; Display a color bar.
   cgColorbar, Position=[0.125, 0.875, 0.9, 0.925], Title='Density', $
       Range=[0, maxDensity], NColors=254, Bottom=1, OOB_Low='gray', $
       TLocation='Top'
END ;*****************************************************************