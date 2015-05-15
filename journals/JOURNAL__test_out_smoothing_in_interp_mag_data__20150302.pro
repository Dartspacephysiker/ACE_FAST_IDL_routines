;

bxorig=bx(smoothrange)
byorig=by(smoothrange)
bzorig=bz(smoothrange)

bx(smoothRange)=smooth(bx(smoothRange),smoothWindow)
by(smoothRange)=smooth(by(smoothRange),smoothWindow)
bz(smoothRange)=smooth(bz(smoothRange),smoothWindow)

bxsmooth=bx(smoothrange)
bysmooth=by(smoothrange)
bzsmooth=bz(smoothrange)

cgplot,byorig(0:30),/window,color="blue"
cgplot,bysmooth(0:30),/addcmd,/overplot,color="red"