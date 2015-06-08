c
c TAUEST-IBM adaption
c
c March 2008, Manfred Mudelsee
c
c
cc$debug
c
c ======================================================================
c
c     TAUEST:
c
c     a computer program for estimating persistence
c     in unevenly spaced weather/climate time series
c
c ======================================================================
c
c     FORTRAN 77
c
c ======================================================================
c
c     developed: 1998--2000
c
c     by:
c     Manfred Mudelsee
c     Institute of Meteorology
c     University of Leipzig
c     Stephanstr. 3
c     D-04103 Leipzig
c     FRG
c
c     E-Mail: Mudelsee@rz.uni-leipzig.de
c     URL:    http://www.uni-leipzig.de/~meteo/MUDELSEE/
c
c ======================================================================
c
c     Reference:
c
c     Mudelsee M. TAUEST: a computer program for estimating persistence
c                 in unevenly spaced weather/climate time series.
c                 Computers & Geosciences 28:69-72.
c
c ======================================================================
c
c     TAUEST.BAT:
c
c     tauest1.exe               :  initialization
c     gnuplot tauest1.plt       :  plot time series
c     tauest2.exe               :  estimation
c     gnuplot tauest2a.plt      :  plot estimation result and LS function
c     gnuplot tauest2b.plt      :  scatterplot
c     tauest3.exe               :  simulation
c     gnuplot tauest3b          :  plot simulation result
c     tauest4.exe               :  bias correction and final result
c
c ======================================================================
c
c     tauest3.for
c
c ======================================================================
c
c     Main variables
c
c     Read from file tauest2.tmp:
c
c       t       :       time (scaled)
c       n       :       number of points
c   scalt       :       scaling factor (time) (tauest2.exe)
c    amin       :       estimated value of a = exp(-scalt/tau)
c
c     Other:
c
c       x       :       simulated time series value
c       r       :       residual
c  delta2       :       average spacing
c  rhonon       :       = amin**delta2, in the case of equidistance,
c                       rhonon = autocorrelation coefficient
c  rhopre       :       prescribed 'autocorrelation' (bias correction)
c    nsim       :       number of simulations
c       s       :       LS function
c   brent       :       Brent's method, minimum s-value
c     tol       :       Brent's method, precision
c    tol2       :       multiple solutions, precision
c   nmult       :       number of multiple solutions
c    nneg       :       number of solutions on left boundary
c    npos       :       number of solutions on right boundary
c    einv       :       1/e
c  tausim       :       tau of simulated time series
c  medtau       :       median(tausim)
c    ci05       :       5-% percentile(tausim)
c    ci95       :       95-% percentile(tausim)
c     nft       :       density estimation: number of positions
c      ft       :       density estimation: Fourier transform
c  dextau       :       density estimation: tau value
c  deytau       :       density estimation: density value
c
c ======================================================================

      character*1 flag,cbias,cbias2
      character*10 file2
      character*11 file3,file4
      character*12 file1,file5,file6,file7
      character*24 detr,detrm,detrl
      character*60 name
      parameter (file1='tauest2b.tmp',file2='tausim.dat',
     +           file3='density.dat',file4='tauest3.plt',
     +           file5='tauest3a.tmp',file6='tauest3b.tmp',
     +           file7='tauest3c.tmp',
     +           detrm='Detrending:         mean',
     +           detrl='Detrending:       linear')
      integer i,isim,
     +        n,nmax,
     +        nsim,nsimx,
     +        iseed7,
     +        mult,nmult,
     +        nneg,npos,
     +        nft
      parameter (nmax=30000,nsimx=5000,nft=1024)
      double precision t(1:nmax),x(1:nmax),
     +                 tausim(1:nsimx),
     +                 dumd1(1:nsimx)
      real ft(1:nft),dextau(1:nft),deytau(1:nft)
      double precision delta2,amin,scalt,
     +                 rhonon,rhopre,apre,einv,
     +                 seed7,
     +                 b1fit,b2fit,
     +                 tol,tol2,
     +                 mintau,maxtau,avetau,vartau,medtau,madtau,
     +                 ci95,ci05
      parameter (einv=0.3678794d0,tol=3.0d-8,tol2=1.0d-6)
      real deymax,deymin
      common /ran7no/ seed7
c
c 1.  Welcome, read results file
c     ==========================
c
      print *,'========================================================'
      print *,'                                                        '
      print *,'    TAUEST:                                             '
      print *,'                                                        '
      print *,'    Simulation                                          '
      print *,'                                                        '
      print *,'========================================================'
      open (unit=1, file=file1, form='formatted',
     +      access='sequential', status='unknown')
      read (unit=1,fmt='(a60)') name
      read (unit=1,fmt='(i6)') n
      do 100 i=1,n
         read (unit=1,fmt='(e20.10e4)') t(i)
100   continue
      delta2=(t(n)-t(1))/(n-1)
      read (unit=1,fmt='(a24)') detr
      read (unit=1,fmt='(e20.10e4)') scalt
      read (unit=1,fmt='(e20.10e4)') amin
      close (unit=1, status='keep')
c
c 2.  Simulation parameters, bias correction
c     ======================================
c
      print *
      write (unit=6,fmt='(a,a)')        ' Data file:        ',name
      write (unit=6,fmt='(a,i6)')       ' Number of points: ',n
      write (unit=6,fmt='(1x,a24)')  detr
      print *
      write (unit=6,fmt='(a,7x,1p,d15.4)') ' tau:              ',
     +       -1.0d0/(scalt*dlog(amin))
      rhonon=amin**delta2
      write (unit=6,fmt='(a,f15.4)') ' rho_non:             ',rhonon
200   print *
      write (6,'(1x,a,i6)')
     +        'Number of Simulations:        [INT] <=            ',nsimx
      read (5,*) nsim
      if (nsim.gt.nsimx) go to 200
      print *
      write (6,'(1x,a)')
     +        'Random generator seed:    1 < [INT] <         2147483646'
      read (5,*) iseed7
      seed7=1.d0*iseed7
220   print *
      write (6,'(1x,a)')
     +        'Bias correction ?             [y/n]'
      read (5,'(a1)') cbias
      if (cbias.ne.'y'.and.cbias.ne.'n') go to 220
      if (cbias.eq.'y') then
         if (detr .ne. 'Detrending:           no') then
230         write (6,'(1x,a)')
     +      'Automatic (Kendall 1954 Biometrika 41:403-404)       [a]'
            write (6,'(1x,a)')
     +      'Per hand                                             [h]'
            read (5,'(a1)') cbias2
            if (cbias2.ne.'a'.and.cbias2.ne.'h') go to 230
         else
            write (6,'(1x,a)')
     +      'Per hand                                                '
            cbias2='h'
         end if
         if (cbias2.eq.'a') then
            rhopre=(n-1.0)*rhonon/(n-4.0)+1.0/(n-4.0)
         else if (cbias2.eq.'h') then
210         print *,'Prescribe rho_pre (between 0 and 1):'
            read (5,*) rhopre
            rhopre=rhopre*1.0d0
            if (rhopre.le.0.0d0.or.rhopre.ge.1.0d0) go to 210
         end if
         apre=1.0d0*rhopre**(1.0d0/delta2)
      else if (cbias.eq.'n') then
         rhopre=rhonon
         apre=amin
      end if
c
c 3.  Initialization
c     ==============
c
      nmult=0
      nneg=0
      npos=0
c
c 4.  Start simulations
c     =================
c
      do 400 isim=1,nsim
c
c 5.  Generation of data
c     ==================
c
      call gendat(apre,n,t,x)
c
c 6.  Detrending
c     ==========
c
      if (detr.eq.detrm) then
         call avevar(x,n,b1fit,b2fit)
         do 600 i=1,n
            x(i)=x(i)-b1fit
600      continue
      else if (detr.eq.detrl) then
         call fit(t,x,n,b1fit,b2fit)
         do 620 i=1,n
            x(i)=x(i)-b1fit-b2fit*t(i)
620      continue
      end if
c
c 7.  Estimation
c     ==========
c
      call minls(einv,n,tol,tol2,t,x,tausim(isim),mult)
      nmult=nmult+mult
      if (tausim(isim).le.0.0d0) then
         nneg=nneg+1
         tausim(isim)=0.0d0
      else if (tausim(isim).ge.1.0d0) then
         npos=npos+1
         tausim(isim)=9.9d9
      else
         tausim(isim)=-1.0d0/(scalt*dlog(tausim(isim)))
      end if
c
c 8.  End simulations
c     ===============
c
      if (mod(isim,100).eq.0.or.isim.eq.1)
     +   print *, 'Simulation ', isim,' / ',nsim
400   continue
c
c 9.  Report simulation problems
c     ==========================
c
      flag='-'
      if (nmult.gt.0) then
         flag='+'
         print *
         write (6,'(a,i6,a,i6)')
     +   ' Number of multiple solutions:          ',nmult,' / ',nsim
      end if
      if (nneg.gt.0) then
         flag='+'
         print *
         write (6,'(a,i6,a,i6)')
     +   ' Number of solutions on left boundary:  ',nneg,' / ',nsim
      end if
      if (npos.gt.0) then
         flag='+'
         print *
         write (6,'(a,i6,a,i6)')
     +   ' Number of solutions on right boundary: ',npos,' / ',nsim
         write (6,'(a)')
     +   ' Note: For the kernel density plot, such solutions are'
         write (6,'(a)')
     +   '       set to the maximum of the other solutions.'
      end if
      if (flag.eq.'+') then
         print *, 'Continue with Enter'
         read (*,'()')
      end if
c
c 10. Solutions on right boundary
c     ===========================
c
      maxtau=0.0d0
      do 1000 i=1,nsim
         if (tausim(i).ne.9.9d9) maxtau=max(maxtau,tausim(i))
1000  continue
      do 1010 i=1,nsim
         if (tausim(i).eq.9.9d9) tausim(i)=maxtau
1010  continue
      call analys(nsim,dumd1,nft,ft,tausim,
     +     mintau,maxtau,avetau,vartau,medtau,madtau,dextau,deytau,
     +     deymax,deymin,ci95,ci05)
c
c 11. Write individual simulation results to file
c     ===========================================
c
      open (unit=1, file=file2, form='formatted',
     +      access='sequential', status='unknown')
      write (1,'(a)')
     +'#__output__from__tauest3.exe:__individual__simulation__results'
      do 1100 i=1,nsim
         write (unit=1,fmt='(1x,1p,e20.10e4)') tausim(i)
1100  continue
      close (unit=1, status='keep')
c
c 12. Write kernel density to file
c     ============================
c
c Note: Boundary solutions (left/right) have been set to zero/maximum
c       of non-boundary solutions.
      open (unit=1, file=file3, form='formatted',
     +      access='sequential', status='unknown')
      write (1,'(a)')
     +'#__output__from__tauest3.exe:__kernel__density'
      do 1200 i=1,nft
         write (unit=1,fmt='(2(1x,e20.10e4))') dextau(i),deytau(i)
1200  continue
      close (unit=1, status='keep')
      open (unit=1, file=file5, form='formatted',
     +      access='sequential', status='unknown')
      write (unit=1,fmt='(4(1x,e20.10e4))')
     +       ci05,deymin,ci95,deymin
      write (unit=1,fmt='(4(1x,e20.10e4))')
     +       ci05,deymax,ci95,deymax
      close (unit=1, status='keep')
      open (unit=1, file=file6, form='formatted',
     +      access='sequential', status='unknown')
      write (unit=1,fmt='(4(1x,e20.10e4))')
     +       medtau,deymin,-1.0d0/(scalt*dlog(amin)),deymin
      write (unit=1,fmt='(4(1x,e20.10e4))')
     +       medtau,deymax,-1.0d0/(scalt*dlog(amin)),deymax
      close (unit=1, status='keep')
c
c 13. Plot file (density)
c     ===================
c
      open (unit=1, file=file4, form='formatted',
     +      access='sequential', status='unknown')
      write (unit=1,fmt='(a)') ' set grid'
      write (unit=1,fmt='(a)') ' set key'
      write (unit=1,fmt='(a,i6,30x,a,1p,d12.4,a,f8.4,
     +                    4x,a,f8.4,6x,a,1p,d12.4,a)')
     +      ' set title "Density plot"'
      if (cbias.eq.'y')
     +   write (unit=1,fmt='(a)')   'set xlabel "CHECK  WHETHER  med  IS
     +  CLOSE  ENOUGH  TO  tau"'
      write (unit=1, fmt='(26(a))')
     +' plot ''',file3,''' title ''',name, '''  w d 8',',',
     +      '''',file3,''' title  '' density ''   w l 8',',',
     +      '''',file6,''' u 3:4 title '' tau '' w l 6',',',
     +      '''',file6,''' u 1:2 title '' med '' w l 7',',',
     +      '''',file5,''' u 1:2 title '' ci05 '' w l 7',',',
     +      '''',file5,''' u 3:4 title '' ci95 '' w l 7'
      write (unit=1,fmt='(a)') ' pause mouse key'
      close (unit=1, status='keep')
c
c 14. Temporary file (bias correction and final result)
c     =================================================
c
      open (unit=1, file=file7, form='formatted',
     +      access='sequential', status='unknown')
      write (unit=1,fmt='(a60)') name
      write (unit=1,fmt='(i6)') n
      write (unit=1,fmt='(a24)') detr
      write (unit=1,fmt='(a1)') cbias
      write (unit=1,fmt='(e20.10e4)') scalt
      write (unit=1,fmt='(e20.10e4)') amin
      write (unit=1,fmt='(e20.10e4)') apre
      write (unit=1,fmt='(e20.10e4)') rhonon
      write (unit=1,fmt='(e20.10e4)') rhopre
      write (unit=1,fmt='(i6)') nsim
      write (unit=1,fmt='(e20.10e4)') ci05
      write (unit=1,fmt='(e20.10e4)') ci95
      close (unit=1, status='keep')
c
c 15. Exit
c     ====
c
      stop ' '
      end
c
c ======================================================================
c
      subroutine analys(n,maddum,nft,ft,tau,
     +          min_,max_,ave_,var_,med_,mad_,dex_,dey_,
     +          deymax,deymin,ci95,ci05)
c Analyses simulation result (tausim): minimum, maximum, average,
c variance, median, MAD, confidence interval (90 %) and
c kernel density.
c The window width for the density estimation is after
c Silverman (1986): Density Estimation for Statistics and Data
c                   Analysis. Chapman and Hall, London.
c The program for kernel density estimation via the FFT is
c from:
c Silverman (1982): Appl. Statist. 31:93-99,
c using the enhancement of:
c Jones and Lotwick (1984): Appl. Statist. 33:120-122.
      integer n,nft
      double precision tau(1:n),maddum(1:n)
      real dex_(1:nft),dey_(1:nft)
      double precision min_,max_,ave_,var_,med_,mad_,ci95,ci05
      real deymax,deymin
      real ft(1:nft),window
      integer i,ifault
      external sort,avevar,robust,denest
      call sort (n,tau)
      min_=tau(1)
      max_=tau(n)
      ci95=tau(int(0.95d0*n))
      ci05=tau(int(0.05d0*n))
      call avevar(tau,n,ave_,var_)
      call robust(n,tau,med_,mad_,maddum)
      window=real(1.059d0*dsqrt(var_)*n**(-0.2d0))
      call denest(tau,n,
     +            real(min_-(max_-min_)*3.0d0/nft),
     +            real(max_+(max_-min_)*3.0d0/nft),
     +            window,ft,dex_,dey_,nft,0,ifault)
      if (ifault.ne.0) then
         print *, ' ERROR ',ifault, ' in density estimation!'
         read (*,'()')
      end if
      deymin=1.0e+30
      deymax=-1.0e+30
      do 100 i=1,nft
         deymin=min(deymin,dey_(i))
         deymax=max(deymax,dey_(i))
100   continue
      return
      end
c
c ======================================================================
c
      SUBROUTINE avevar(data,n,ave,var)
c Numerical Recipes.
      INTEGER n
      DOUBLE PRECISION ave,var,data(n)
      INTEGER j
      DOUBLE PRECISION s,ep
      ave=0.0d0
      do 11 j=1,n
        ave=ave+data(j)
11    continue
      ave=ave/n
      var=0.0d0
      ep=0.0d0
      do 12 j=1,n
        s=data(j)-ave
        ep=ep+s
        var=var+s*s
12    continue
      var=(var-ep**2/n)/(n-1)
      return
      END
c
c ======================================================================
c
      FUNCTION brent(ax,bx,cx,f,tol,xmin,xfunc,yfunc,nfunc)
c Numerical Recipes (modified): Brent's method in one dimension.
      integer nfunc
      double precision xfunc(1:nfunc),yfunc(1:nfunc)
      INTEGER ITMAX
      DOUBLE PRECISION brent,ax,bx,cx,tol,xmin,f,CGOLD,ZEPS
      EXTERNAL f
      PARAMETER (ITMAX=100,CGOLD=.3819660d0,ZEPS=1.d-18)
      INTEGER iter
      DOUBLE PRECISION a,b,d,e,etemp,fu,fv,fw,fx,p,q,r,tol1,tol2,u,v,w,x
     *,xm
      a=min(ax,cx)
      b=max(ax,cx)
      v=bx
      w=v
      x=v
      e=0.d0
      fx=f(x,xfunc,yfunc,nfunc)
      fv=fx
      fw=fx
      do 11 iter=1,ITMAX
        xm=0.5d0*(a+b)
        tol1=tol*abs(x)+ZEPS
        tol2=2.d0*tol1
        if(abs(x-xm).le.(tol2-.5d0*(b-a))) goto 3
        if(abs(e).gt.tol1) then
          r=(x-w)*(fx-fv)
          q=(x-v)*(fx-fw)
          p=(x-v)*q-(x-w)*r
          q=2.d0*(q-r)
          if(q.gt.0.d0) p=-p
          q=abs(q)
          etemp=e
          e=d
          if(abs(p).ge.abs(.5d0*q*etemp).or.p.le.q*(a-x).or.p.ge.q*(b-x)
     *)
     *goto 1
          d=p/q
          u=x+d
          if(u-a.lt.tol2 .or. b-u.lt.tol2) d=sign(tol1,xm-x)
          goto 2
        endif
1       if(x.ge.xm) then
          e=a-x
        else
          e=b-x
        endif
        d=CGOLD*e
2       if(abs(d).ge.tol1) then
          u=x+d
        else
          u=x+sign(tol1,d)
        endif
        fu=f(u,xfunc,yfunc,nfunc)
        if(fu.le.fx) then
          if(u.ge.x) then
            a=x
          else
            b=x
          endif
          v=w
          fv=fw
          w=x
          fw=fx
          x=u
          fx=fu
        else
          if(u.lt.x) then
            a=u
          else
            b=u
          endif
          if(fu.le.fw .or. w.eq.x) then
            v=w
            fv=fw
            w=u
            fw=fu
          else if(fu.le.fv .or. v.eq.x .or. v.eq.w) then
            v=u
            fv=fu
          endif
        endif
11    continue
      print *, 'brent exceed maximum iterations'
      read (*,'()')
3     xmin=x
      brent=fx
      return
      END
c
c ======================================================================
c
      subroutine denest(dt,ndt,dlo,dhi,window,ft,
     +                  xsmth,smooth,nft,ical,ifault)
c Density estimation, cf. subroutine analys.
      real dlo,dhi,window,ft,smooth,zero,one,six,thir2,big,step,ainc,
     +hw,fac1,dlo1,rj,fac,wt,winc,bc,rjfac,xsmth
      integer ndt,nft,kftlo,kfthi,ical,ifault,ii,i,jj,jhi,jmax,nft2,j1,
     +j2,j2lo,k,j,kk
      double precision dt(1:ndt)
      external forrt,revrt
      dimension ft(1:nft),xsmth(1:nft),smooth(1:nft)
      data zero,one,six,thir2 /0.0e0,1.0e0,6.0e0,32.0e0/
      data big,kftlo,kfthi /30.0e0,5,11/
      data half /0.5e0/
      do 100 k=1,nft
         xsmth(k)=dlo+(k-1)*(dhi-dlo)/nft
100   continue
      if (window.le.zero) goto 92
      if (dlo.ge.dhi) goto 93
      ii=2**kftlo
      do 1 k=kftlo,kfthi
         if (ii.eq.nft) goto 2
      ii=ii+ii
1     continue
      ifault=1
      return
2     step=(dhi-dlo)/float(nft)
      ainc=one/(float(ndt)*step)
      nft2=nft/2
      hw=window/step
      fac1=thir2*(atan(one)*hw/float(nft))**2
      if (ical.ne.0) goto 10
c      dlo1=dlo-step
      dlo1=dlo-step*half
      do 3 j=1,nft
         ft(j)=zero
3     continue
      do 4 i=1,ndt
         wt=(real(dt(i))-dlo1)/step
         jj=int(wt)
         if (jj.lt.1.or.jj.gt.nft) goto 4
         wt=wt-float(jj)
         winc=wt*ainc
         kk=jj+1
         if (jj.eq.nft) kk=1
         ft(jj)=ft(jj)+ainc-winc
         ft(kk)=ft(kk)+winc
4     continue
      call forrt(ft,nft)
10    jhi=sqrt(big/fac1)
      jmax=min0(nft2-1,jhi)
      smooth(1)=ft(1)
      rj=zero
      do 11 j=1,jmax
         rj=rj+one
         rjfac=rj*rj*fac1
         bc=one-rjfac/(hw*hw*six)
         fac=exp(-rjfac)/bc
         j1=j+1
         j2=j1+nft2
         smooth(j1)=fac*ft(j1)
         smooth(j2)=fac*ft(j2)
11    continue
      if (jhi+1-nft2) 21,23,20
20    smooth(nft2+1)=exp(-fac1*float(nft2)**2)*ft(nft2+1)
      goto 24
21    j2lo=jhi+2
      do 22 j1=j2lo,nft2
         j2=j1+nft2
         smooth(j1)=zero
         smooth(j2)=zero
22    continue
23    smooth(nft2+1)=zero
24    call revrt(smooth,nft)
      do 25 j=1,nft
         if (smooth(j).lt.zero) smooth(j)=zero
25    continue
      ifault=0
      return
92    ifault=2
      return
93    ifault=3
      return
      end
c
c ======================================================================
c
      subroutine fastg(xreal,ximag,n,itype)
c Density estimation, cf. subroutine analys.
      integer n
      real xreal(1:n),ximag(1:n)
      real zero,half,one,one5,two,four,pie,z,bcos,bsin,
     +     xs0,xs1,xs2,xs3,ys0,ys1,ys2,ys3,cw1,cw2,cw3,sw1,sw2,sw3,tempr
      real x1,y1,x2,y2,x3,y3
      integer itype,ifaca,k,ifcab,litla,i0,i1,i2,i3
      data zero,half,one,one5,two,four /0.0,0.5,1.0,1.5,2.0,4.0/
      pie=four*atan(one)
      ifaca=n/4
      if (itype) 3,19,5
3     do 4 k=1,n
         ximag(k)=-ximag(k)
4     continue
5     ifcab=ifaca*4
      z=pie/float(ifcab)
      bcos=-two*sin(z)**2
      bsin=sin(two*z)
      cw1=one
      sw1=zero
      do 10 litla=1,ifaca
         do 8 i0=litla,n,ifcab
            i1=i0+ifaca
            i2=i1+ifaca
            i3=i2+ifaca
            xs0=xreal(i0)+xreal(i2)
            xs1=xreal(i0)-xreal(i2)
            ys0=ximag(i0)+ximag(i2)
            ys1=ximag(i0)-ximag(i2)
            xs2=xreal(i1)+xreal(i3)
            xs3=xreal(i1)-xreal(i3)
            ys2=ximag(i1)+ximag(i3)
            ys3=ximag(i1)-ximag(i3)
            xreal(i0)=xs0+xs2
            ximag(i0)=ys0+ys2
            x1=xs1+ys3
            y1=ys1-xs3
            x2=xs0-xs2
            y2=ys0-ys2
            x3=xs1-ys3
            y3=ys1+xs3
            if (litla-1) 19,6,7
6           xreal(i2)=x1
            ximag(i2)=y1
            xreal(i1)=x2
            ximag(i1)=y2
            xreal(i3)=x3
            ximag(i3)=y3
            goto 8
7           xreal(i2)=x1*cw1+y1*sw1
            ximag(i2)=y1*cw1-x1*sw1
            xreal(i1)=x2*cw2+y2*sw2
            ximag(i1)=y2*cw2-x2*sw2
            xreal(i3)=x3*cw3+y3*sw3
            ximag(i3)=y3*cw3-x3*sw3
8        continue
         if (litla-ifaca) 9,10,19
9        z=cw1*bcos-sw1*bsin+cw1
         sw1=bcos*sw1+bsin*cw1+sw1
         tempr=one5-half*(z*z+sw1*sw1)
         cw1=z*tempr
         sw1=sw1*tempr
         cw2=cw1*cw1-sw1*sw1
         sw2=two*cw1*sw1
         cw3=cw1*cw2-sw1*sw2
         sw3=cw1*sw2+cw2*sw1
10    continue
      if (ifaca-1) 14,14,11
11    ifaca=ifaca/4
      if (ifaca) 19,12,5
12    do 13 k=1,n,2
         tempr=xreal(k)+xreal(k+1)
         xreal(k+1)=xreal(k)-xreal(k+1)
         xreal(k)=tempr
         tempr=ximag(k)+ximag(k+1)
         ximag(k+1)=ximag(k)-ximag(k+1)
         ximag(k)=tempr
13    continue
14    if (itype) 15,19,17
15    do 16 k=1,n
         ximag(k)=-ximag(k)
16    continue
      return
17    z=one/float(n)
      do 18 k=1,n
         xreal(k)=xreal(k)*z
         ximag(k)=ximag(k)*z
18    continue
19    return
      end
c
c ======================================================================
c
      SUBROUTINE fit(x,y,ndata,a,b)
c Numerical Recipes (modified): unweighted straight line fit.
      INTEGER ndata
      DOUBLE PRECISION a,b,x(ndata),y(ndata)
      INTEGER i
      DOUBLE PRECISION ss,st2,sx,sxoss,sy,t
      sx=0.d0
      sy=0.d0
      st2=0.d0
      b=0.d0
      do 12 i=1,ndata
        sx=sx+x(i)
        sy=sy+y(i)
12    continue
      ss= dble(ndata)
      sxoss=sx/ss
      do 14 i=1,ndata
        t=x(i)-sxoss
        st2=st2+t*t
        b=b+t*y(i)
14    continue
      b=b/st2
      a=(sy-sx*b)/ss
      return
      END
c
c ======================================================================
c
      subroutine forrt(x,m)
c Density estimation, cf. subroutine analys.
      integer m
      real x(1:m)
      real zero,quart,half,one,one5,two,four,pie
      real  z,bcos,bsin,un,vn,save1,an,bn,cn,dn
      real xn,yn
      integer ii,k,ipow,n,jpow,nn
      integer nn1,nn2,ki,l,li
      external scrag,fastg
      data zero,quart,half,one,one5,two,four /0.0,0.25,0.5,1.0,1.5,2.0,
     +4.0/
      ii=8
      do 2 k=3,21
         ipow=k
         if (ii-m) 1,3,1
1     ii=ii*2
2     continue
      return
3     pie=four*atan(one)
      call scrag(x,m,ipow)
      n=m/2
      jpow=ipow-1
      call scrag(x,n,jpow)
      call scrag(x(n+1),n,jpow)
      call fastg(x,x(n+1),n,1)
      call scrag(x,n,jpow)
      call scrag(x(n+1),n,jpow)
      nn=n/2
      z=half*(x(1)+x(n+1))
      x(n+1)=half*(x(1)-x(n+1))
      x(1)=z
      nn1=nn+1
      nn2=nn1+n
      x(nn1)=half*x(nn1)
      x(nn2)=-half*x(nn2)
      z=pie/float(n)
      bcos=-two*(sin(z/two)**2)
      bsin=sin(z)
      un=one
      vn=zero
      do 4 k=2,nn
         z=un*bcos+vn*bsin+un
         vn=vn*bcos-un*bsin+vn
         save1=one5-half*(z*z+vn*vn)
         un=z*save1
         vn=vn*save1
         ki=n+k
         l=n+2-k
         li=n+l
         an=quart*(x(k)+x(l))
         bn=quart*(x(ki)-x(li))
         cn=quart*(x(ki)+x(li))
         dn=quart*(x(l)-x(k))
         xn=un*cn-vn*dn
         yn=un*dn+vn*cn
         x(k)=an+xn
         x(ki)=bn+yn
         x(l)=an-xn
         x(li)=yn-bn
4     continue
      return
      end
c
c ======================================================================
c
      FUNCTION gasdev(idum)
c Numerical Recipes (modified: uses ran7), generates N(0,1).
      INTEGER idum
      DOUBLE PRECISION gasdev
C     USES ran7
      INTEGER iset
      DOUBLE PRECISION fac,gset,rsq,v1,v2,r7
      external ran7
      SAVE iset,gset
      DATA iset/0/
      if (iset.eq.0) then
1       CALL ran7(r7)
        v1=2.d0*r7-1.d0
        CALL ran7(r7)
        v2=2.d0*r7-1.d0
        rsq=v1**2+v2**2
        if(rsq.ge.1.d0.or.rsq.eq.0.d0)goto 1
        fac=sqrt(-2.d0*dlog(rsq)/rsq)
        gset=v1*fac
        gasdev=v2*fac
        iset=1
      else
        gasdev=gset
        iset=0
      endif
      return
      END
c
c ======================================================================
c
      subroutine gendat(a,n,t,x)
c Generates N(0, 1) random numbers x with autocorrelation
c decay time tau = -1/ln(a) on t grid.
      integer n
      double precision t(1:n),x(1:n)
      double precision a
      integer i
      double precision gasdev
      external gasdev
      x(1)=gasdev(1)*1.0d0
      do 100 i=2,n
         x(i)=x(i-1)*a**(t(i)-t(i-1))+
     +      dsqrt(1.0d0-a**(2.0d0*(t(i)-t(i-1))))*gasdev(i)
100   continue
      return
      end
c
c ======================================================================
c
      subroutine minls(a_ar1,n,tol,tol2,t,x,amin,nmu_)
c Minimization of LS function s.
      double precision a_ar1,tol,tol2
      integer n
      double precision t(1:n),x(1:n)
      double precision amin
      integer nmu_
      double precision dum1,dum2,dum3,dum4,a_ar11,a_ar12,a_ar13
      double precision s,brent
      external s,brent
      nmu_=0
      dum1=brent(-2.0d0,               a_ar1, +2.0d0, s, tol, a_ar11,
     +           t,x,n)
      dum2=brent( a_ar1, 0.5d0*(a_ar1+1.0d0), +2.0d0, s, tol, a_ar12,
     +           t,x,n)
      dum3=brent(-2.0d0, 0.5d0*(a_ar1-1.0d0),  a_ar1, s, tol, a_ar13,
     +           t,x,n)
      if  ((dabs(a_ar12-a_ar11).gt.tol2.and.dabs(a_ar12-a_ar1).gt.tol2)
     +.or.(dabs(a_ar13-a_ar11).gt.tol2.and.dabs(a_ar13-a_ar1).gt.tol2))
     +nmu_=1
      dum4=dmin1(dum1,dum2,dum3)
      if (dum4.eq.dum2) then
         amin=a_ar12
      else if (dum4.eq.dum3) then
         amin=a_ar13
      else
         amin=a_ar11
      end if
      return
      end
c
c ======================================================================
c
      subroutine ran7(z)
c Random number generator.
c Source: Park SK, Miller KW (1988) Comm ACM 31:1192-1201.
      double precision z,seed7,temp7,a7,m7
      parameter (a7=16807.D0, m7=2147483647.D0)
c      save seed7
      common /ran7no/ seed7
      temp7=a7*seed7
      seed7=temp7-m7*dint(temp7/m7)
      z=seed7/m7
      return
      end
c
c ======================================================================
c
      subroutine revrt(x,m)
c Density estimation, cf. subroutine analys.
      integer m
      real x(1:m)
      real zero,half,one,one5,two,four,pie
      real z,bcos,bsin,un,vn,save1,an,bn,cn,dn,pn,qn
      integer ii,k,ipow,n,nn
      integer nn1,nn2,ki,l,li
      external scrag,fastg
      data zero,half,one,one5,two,four /0.0,0.5,1.0,1.5,2.0,4.0/
      ii=8
      do 2 k=3,21
         ipow=k
         if (ii-m) 1,3,1
1     ii=ii*2
2     continue
      return
3     pie=four*atan(one)
      n=m/2
      nn=n/2
      z=x(1)+x(n+1)
      x(n+1)=x(1)-x(n+1)
      x(1)=z
      nn1=nn+1
      nn2=nn1+n
      x(nn1)=two*x(nn1)
      x(nn2)=-two*x(nn2)
      z=pie/float(n)
      bcos=-two*(sin(z/two)**2)
      bsin=sin(z)
      un=one
      vn=zero
      do 4 k=2,nn
         z=un*bcos+vn*bsin+un
         vn=vn*bcos-un*bsin+vn
         save1=one5-half*(z*z+vn*vn)
         un=z*save1
         vn=vn*save1
         ki=n+k
         l=n+2-k
         li=n+l
         an=x(k)+x(l)
         bn=x(ki)-x(li)
         pn=x(k)-x(l)
         qn=x(ki)+x(li)
         cn=un*pn+vn*qn
         dn=un*qn-vn*pn
         x(k)=an-dn
         x(ki)=bn+cn
         x(l)=an+dn
         x(li)=cn-bn
4     continue
      call fastg(x,x(n+1),n,-1)
      call scrag(x,m,ipow)
      return
      end
c
c ======================================================================
c
      subroutine robust(n,x,med,mad,z)
c Calculates median and MAD of x(1:n).
      integer n
      double precision x(1:n),z(1:n)
      double precision med,mad
      integer i
      external sort
      if (mod(n,2).eq.0) then
         med=0.5d0*(x(n/2)+x(n/2+1))
      else
         med=1.0d0*x((n+1)/2)
      end if
      do 100 i=1,n
         z(i)=dabs(x(i)-med)
100   continue
      call sort(n,z)
      if (mod(n,2).eq.0) then
         mad=0.5d0*(z(n/2)+z(n/2+1))
      else
         mad=1.0d0*z((n+1)/2)
      end if
      return
      end
c
c ======================================================================
c
      double precision function s(a,t,x,n)
c LS function. Note: s is defined also for a less than or equal to zero
c for numerical stability of minimization subroutine minls.
      integer n
      double precision t(1:n),x(1:n)
      double precision a
      integer i
      s=0.0d0
      do 100 i=2,n
         s=s+(x(i)-x(i-1)*dsign(1.0d0,a)*
     +     dabs(a)**(t(i)-t(i-1)))**2.0d0
100   continue
      return
      end
c
c ======================================================================
c
      subroutine scrag(xreal,n,ipow)
c Density estimation, cf. subroutine analys.
      integer n
      real xreal(1:n),tempr
      integer ipow,l(1:19)
      integer ii,itop,i,k,l0,j1,j2,j3,j4,j5,j6,j7,j8,j9,j10,j11,j12,
     +        j13,j14,j15,j16,j17,j18,j19,j20
      integer l1,l2,l3,l4,l5,l6,l7,l8,l9,
     +        l10,l11,l12,l13,l14,l15,l16,l17,l18,l19
      equivalence (l1,l(1)),(l2,l(2)),(l3,l(3)),(l4,l(4)),(l5,l(5)),
     +            (l6,l(6)),(l7,l(7)),(l8,l(8)),(l9,l(9)),(l10,l(10)),
     +  (l11,l(11)),(l12,l(12)),(l13,l(13)),(l14,l(14)),(l15,l(15)),
     +  (l16,l(16)),(l17,l(17)),(l18,l(18)),(l19,l(19))
      ii=1
      itop=2**(ipow-1)
      i=20-ipow
      do 5 k=1,i
         l(k)=ii
5     continue
      l0=ii
      i=i+1
      do 6 k=i,19
         ii=ii*2
         l(k)=ii
6     continue
      ii=0
      do 9 j1=1,l1,l0
      do 9 j2=j1,l2,l1
      do 9 j3=j2,l3,l2
      do 9 j4=j3,l4,l3
      do 9 j5=j4,l5,l4
      do 9 j6=j5,l6,l5
      do 9 j7=j6,l7,l6
      do 9 j8=j7,l8,l7
      do 9 j9=j8,l9,l8
      do 9 j10=j9,l10,l9
      do 9 j11=j10,l11,l10
      do 9 j12=j11,l12,l11
      do 9 j13=j12,l13,l12
      do 9 j14=j13,l14,l13
      do 9 j15=j14,l15,l14
      do 9 j16=j15,l16,l15
      do 9 j17=j16,l17,l16
      do 9 j18=j17,l18,l17
      do 9 j19=j18,l19,l18
      j20=j19
      do 9 i=1,2
      ii=ii+1
      if (ii-j20) 7,8,8
7     tempr=xreal(ii)
      xreal(ii)=xreal(j20)
      xreal(j20)=tempr
8     j20=j20+itop
9     continue
      return
      end
c
c ======================================================================
c
      SUBROUTINE sort(n,arr)
c Numerical Recipes.
      INTEGER n,M,NSTACK
      DOUBLE PRECISION arr(n)
      PARAMETER (M=7,NSTACK=50)
      INTEGER i,ir,j,jstack,k,l,istack(NSTACK)
      DOUBLE PRECISION a,temp
      jstack=0
      l=1
      ir=n
1     if(ir-l.lt.M)then
        do 12 j=l+1,ir
          a=arr(j)
          do 11 i=j-1,1,-1
            if(arr(i).le.a)goto 2
            arr(i+1)=arr(i)
11        continue
          i=0
2         arr(i+1)=a
12      continue
        if(jstack.eq.0)return
        ir=istack(jstack)
        l=istack(jstack-1)
        jstack=jstack-2
      else
        k=(l+ir)/2
        temp=arr(k)
        arr(k)=arr(l+1)
        arr(l+1)=temp
        if(arr(l+1).gt.arr(ir))then
          temp=arr(l+1)
          arr(l+1)=arr(ir)
          arr(ir)=temp
        endif
        if(arr(l).gt.arr(ir))then
          temp=arr(l)
          arr(l)=arr(ir)
          arr(ir)=temp
        endif
        if(arr(l+1).gt.arr(l))then
          temp=arr(l+1)
          arr(l+1)=arr(l)
          arr(l)=temp
        endif
        i=l+1
        j=ir
        a=arr(l)
3       continue
          i=i+1
        if(arr(i).lt.a)goto 3
4       continue
          j=j-1
        if(arr(j).gt.a)goto 4
        if(j.lt.i)goto 5
        temp=arr(i)
        arr(i)=arr(j)
        arr(j)=temp
        goto 3
5       arr(l)=arr(j)
        arr(j)=a
        jstack=jstack+2
        if (jstack.gt.NSTACK) then
           print *, 'NSTACK too small in sort'
           read (*,'()')
        end if
        if(ir-i+1.ge.j-l)then
          istack(jstack)=ir
          istack(jstack-1)=i
          ir=j-1
        else
          istack(jstack)=j-1
          istack(jstack-1)=l
          l=i
        endif
      endif
      goto 1
      END
      
      
