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
c     tauest2.for
c
c ======================================================================
c
c       Main variables
c
c       t       :       time
c       x       :       time series value
c       r       :       residual
c       n       :       number of points (<= nmax)
c   delta       :       average spacing
c   scalt       :       scaling factor (time)
c     rho       :       in the case of equidistance,
c                       rho = autocorrelation coefficient
c       s       :       LS function
c   brent       :       Brent's method, minimum s-value
c     tol       :       Brent's method, precision
c    tol2       :       multiple solutions, precision
c    mult       :       flag (multiple solution)
c    amin       :       estimated value of a = exp(-scalt/tau)
c    einv       :       1/e
c
c ======================================================================
c
      SUBROUTINE TAUEST2(T, TIME_OR_AGE, X, N, DETREND, 
     +     OrbStr, ORBSTRL, INTERVAL)
      character*1 TIME_OR_AGE             !SPENCE addition
      character*5 OrbStr                  !SPENCE addition
      character*1 itrvlStr                !SPENCE addition
      character*11 file1,file5
      character*12 file2,file3,file4,file6
      character*24 detrn,detrm,detrl
      character*1 DETREND                 !SPENCE addition
      character*60 name
c      parameter (file1='tauest1.tmp',file2='tauest2a.tmp',
      parameter (file2='tauest2a',    !SPENCE edit; we pass data directly
     +           file3='tauest2a',file4='tauest2b',
     +           file5='scatter',file6='tauest2b',
     +           detrn='Detrending:           no',
     +           detrm='Detrending:         mean',
     +           detrl='Detrending:       linear')
      integer i,
     +        idumd1,
     +        n,nmax,
     +        mult
     +        ORBSTRL
     +        INTERVALL
      parameter (nmax=30000)
      double precision t(1:nmax),x(1:nmax),r(1:nmax)
c      REAL t(1:nmax),x(1:nmax),r(1:nmax)  !SPENCE change
      double precision b1fit,b2fit,
     +                 delta,rho,scalt,
     +                 amin,einv,
     +                 dumd1,
     +                 brent,s,
     +                 tol,tol2
      parameter (einv=0.3678794d0,tol=3.0d-8,tol2=1.0d-6)
      external avevar,brent,fit,s,minls,rhoest
c
c ======================================================================
c
c 1.  Welcome, number of points
c     =========================
c
      print *,'========================================================'
      print *,'                                                        '
      print *,'    TAUEST2:                                            '
      print *,'                                                        '
      print *,'    Estimation                                          '
      print *,'                                                        '
      print *,'========================================================'
      WRITE(*,010)OrbStr
010   FORMAT(10X,'Orbit :',T50,A)
      WRITE(*,020)IntervalStr
020   FORMAT(10X,'Interval :',T50,A)
      WRITE(name,030)orbStr
030   FORMAT(10X,'Autocorr data for orb ',A)
c      write (OrbStr,'(I
c     open (unit=1, file=file1, form='formatted',
c    +      access='sequential', status='unknown')
c     read (unit=1,fmt='(a60)') name
c     close (unit=1,status='keep')
c     print *
c     write (6,'(1x,a)') name
c     print *
c     write (6,'(1x,a,i6)')
c    +        'Number of points:        [INT] <=                 ',nmax
c     read (5,*) n
c
c 2.  Correct time direction
c     ======================
c
c$$$200   print *
c$$$      write (6,'(1x,a)')
c$$$     +        't:                  time [t]'
c$$$      print *,'                     age [a]'
c$$$      read (5,'(a)') TIME_OR_AGE
      if (TIME_OR_AGE.ne.'t'.and.TIME_OR_AGE.ne.'a') then
         TIME_OR_AGE = 't'
         print *,'Incorrect TIME_OR_AGE; assuming ''t'' '
      end if
c$$$      open (unit=1, file=name, form='formatted',
c$$$     +      access='sequential', status='old')
c$$$      if (TIME_OR_AGE.eq.'t') then
c$$$         do 210 i=1,n
c$$$            read (1,*) t(i), x(i)
c$$$            t(i)=t(i)*1.0d0
c$$$            x(i)=x(i)*1.0d0
c$$$210      continue
c$$$      else if (TIME_OR_AGE.eq.'a') then
c$$$         do 220 i=1,n
c$$$            read (1,*) t(n+1-i),x(n+1-i)
c$$$            t(n+1-i)=-1.0d0*t(n+1-i)
c$$$            x(n+1-i)=1.0d0*x(n+1-i)
c$$$220      continue
c$$$      end if
c$$$      close (unit=1,status='keep')
c
c 3.  Detrending
c     ==========
c
300   print *
      print *,'Have the data been detrended/should they be detrended  ?'
      print *
      write (6,'(1x,a24,a4)') detrn,' [n]'
      write (6,'(1x,a24,a4)') detrm,' [m]'
      write (6,'(1x,a24,a4)') detrl,' [l]'
      WRITE(*,305)DETREND
305   FORMAT(10X,'Passed detrend:',T50,I4)
      if (DETREND.ne.'n'.and.DETREND.ne.'m'.and.DETREND.ne.'l') then
         DETREND = 'l'
         print *,'Incorrect DETREND; assuming ''l'' '
      end if
      if (DETREND.eq.'m') then
         call avevar(x,n,b1fit,b2fit)
         do 310 i=1,n
            x(i)=x(i)-b1fit
310      continue
      else if (DETREND.eq.'l') then
         call fit(t,x,n,b1fit,b2fit)
         do 320 i=1,n
            x(i)=x(i)-b1fit-b2fit*t(i)
320      continue
      end if
c
c 4.  Scaling of x
c     ============
c
      call avevar(x,n,b1fit,b2fit)
      do 400 i=1,n
         x(i)=x(i)/dsqrt(b2fit)
400   continue
c
c 5.  Scaling of t (=> start value of a = 1/e)
c     ============
c
      delta=(t(n)-t(1))/(n-1)
      call rhoest(n,x,rho)
      if (rho.le.0.0d0) then
         rho=0.05d0
         print *
         print *, 'rho estimation: < 0'
         read (*,'()')
      else if (rho.gt.1.0d0) then
         rho=0.95d0
         print *
         print *, 'rho estimation: > 1'
         read (*,'()')
      end if
      scalt=-1.0d0*dlog(rho)/delta
      do 500 i=1,n
         t(i)=t(i)*scalt
500   continue
c
c 6.  Estimation
c     ==========
c
      call minls(einv,n,tol,tol2,t,x,amin,mult)
      if (mult.eq.1) then
         print *
         print *, 'Estimation problem: LS function has > 1 minima'
         read (*,'()')
      end if
      if (amin.le.0.0d0) then
         print *
         print *, 'Estimation problem: a_min =< 0'
         read (*,'()')
      else if (amin.ge.1.0d0) then
         print *
         print *, 'Estimation problem: a_min >= 1'
         read (*,'()')
      end if
c
c 7.  Plot file (estimation result and LS function)
c     =============================================
c
c     NOTE: S(a) uses as a the t-scaled (scalt factor) transformed
c           values. The results from correctly using
c           tau = -1.0d0/(scalt*dlog(amin) therefore may deviate.
c           That means, this plot is only for judging S(a) visually),
c           no inference of minimum value should be performed.
c
c
      open (unit=1, 
     +      file=file2//'_'//trim(orbStr)//'_'//trim(itrvlStr)//'.tmp', 
     +      form='formatted',
     +      access='sequential', status='unknown')
      do 700 idumd1=0,200
         dumd1=idumd1*0.005d0
         write (unit=1,fmt='(e20.10e4,1x,e20.10e4)')
     +         dumd1,s(dumd1,t,x,n)
700   continue
      close (unit=1, status='keep')
      open (unit=1,
     +      file=file3//'_'//trim(orbStr)//'_'//trim(itrvlStr)//'.plt',
     +      form='formatted',
     +      access='sequential', status='unknown')
      write (unit=1,fmt='(a)') ' set grid'
      write (unit=1,fmt='(a)') ' set key'
      write (unit=1,fmt='(1p,a,i6,31x,a,d15.4,a)')
     +      ' set title "n = ',n,
     +      ' tau = ',-1.0d0/(scalt*dlog(amin)),'    "'
      write (unit=1, fmt='(9(a))')
     +' plot ''',file2,''' title ''',name, '''  w d 8',',',
     +      '''',file2,''' title  '' S(a) ''   w l 8'
      write (unit=1,fmt='(a)') ' pause mouse key'
      close (unit=1, status='keep')
c
c 8.  Temporary file (simulation)
c     ===========================
c
      open (unit=1, 
     +      file=file4//'_'//trim(orbStr)//'_'//trim(itrvlStr)//'.tmp', 
     +      form='formatted',
     +      access='sequential', status='unknown')
      write (unit=1,fmt='(a60)') name
      write (unit=1,fmt='(i6)') n
      do 800 i=1,n
         write (unit=1,fmt='(e20.10e4)') t(i)
800   continue
      if (DETREND.eq.'n') then
         write (unit=1,fmt='(a24)') detrn
      else if (DETREND.eq.'m') then
         write (unit=1,fmt='(a24)') detrm
      else if (DETREND.eq.'l') then
         write (unit=1,fmt='(a24)') detrl
      end if
      write (unit=1,fmt='(e20.10e4)') scalt
      write (unit=1,fmt='(e20.10e4)') amin
      close (unit=1, status='keep')
c
c 9.  Residuals
c     =========
c
      do 900 i=2,n
         r(i)=x(i)-x(i-1)*dabs(amin)**(t(i)-t(i-1))
900   continue
      open (unit=1, 
     +      file=file5//'_'//trim(orbStr)//'_'//trim(itrvlStr)//'.dat',
     +      form='formatted',
     +      access='sequential', status='unknown')
      write (unit=1, fmt='(a)')
     +'#__t(i)__x(i)__x(i-1)__r(i)__r(i-1)'
      do 920 i=2,n
         write (unit=1, fmt='(5(1x,e20.10e4))')
     +         t(i),x(i),x(i-1),r(i),r(i-1)
920   continue
      close (unit=1, status='keep')
c
c 10. Scatterplot file
c     ================
c
      open (unit=1, 
     +      file=file6//'_'//trim(orbStr)//'_'//trim(itrvlStr)//'.plt', 
     +      form='formatted',
     +      access='sequential', status='unknown')
      write (unit=1,fmt='(a)') ' set grid'
      write (unit=1,fmt='(a)') ' set key'
      write (unit=1,fmt='(a)') ' set pointsize 2.8'
      write (unit=1,fmt='(1p,a,i6,31x,a,d15.4,a)')
     +      ' set title "n = ',n,
     +      ' tau = ',-1.0d0/(scalt*dlog(amin)),'    "'
      write (unit=1,fmt='(a)') ' set xlabel ''r(i)  /  x(i)'' '
      write (unit=1,fmt='(a)') ' set ylabel ''r(i-1)  /  x(i-1)'' '
      write (unit=1, fmt='(15(a))')
     +' plot ''',file5,''' u 2:3 title ''',name, '''  w d 8',',',
     +      '''',file5,'''',
     +' u 2:3 title '' x ''  w p pt 9',',',
     +      '''',file5,'''',
     +' u 4:5 title '' r ''  w p 6'
      write (unit=1,fmt='(a)') ' pause mouse key'
      close (unit= 1,status='keep')
c
c 11. Exit
c     ====
c
      stop ' '
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
      subroutine rhoest(n,x,rho)
c Autocorrelation coefficient estimation (equidistant data).
      integer n
      double precision x(1:n)
      double precision rho
      integer i
      double precision sum1,sum2
      sum1=0.0d0
      sum2=0.0d0
      do 100 i=2,n
         sum1=sum1+x(i)*x(i-1)
         sum2=sum2+x(i)**2.0d0
100   continue
      rho=sum1/sum2
      return
      end
c
c ======================================================================
c
      double precision function s(a,t,x,n)
c LS function.
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

