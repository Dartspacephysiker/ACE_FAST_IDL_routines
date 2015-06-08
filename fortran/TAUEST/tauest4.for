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
c     tauest4.for
c
c ======================================================================
c
c     Main variables
c
c     Read from file tauest3c.tmp:
c
c       n       :       number of points
c   scalt       :       scaling factor (time) (tauest2.exe)
c    amin       :       estimated  value of a = exp(-scalt/tau)
c    apre       :       prescribed value of a (bias correction)
c   cbias       :       whether bias correction is performed
c    ci05       :       5-% percentile(tausim)
c    ci95       :       95-% percentile(tausim)
c
c    Other:
c
c  biasok       :       whether bias correction is OK
c
c ======================================================================

      character*1 cbias,biasok
      character*12 file1
      character*24 detr
      character*60 name
      parameter (file1='tauest3c.tmp')
      integer n,nsim
      double precision amin,apre,scalt,rhonon,rhopre,tau,
     +                 ci95,ci05
c
c 1.  Read simulations results file
c     =============================
c
      open (unit=1, file=file1, form='formatted',
     +      access='sequential', status='unknown')
      read (unit=1,fmt='(a60)') name
      read (unit=1,fmt='(i6)') n
      read (unit=1,fmt='(a24)') detr
      read (unit=1,fmt='(a1)') cbias
      read (unit=1,fmt='(e20.10e4)') scalt
      read (unit=1,fmt='(e20.10e4)') amin
      read (unit=1,fmt='(e20.10e4)') apre
      read (unit=1,fmt='(e20.10e4)') rhonon
      read (unit=1,fmt='(e20.10e4)') rhopre
      read (unit=1,fmt='(i6)') nsim
      read (unit=1,fmt='(e20.10e4)') ci05
      read (unit=1,fmt='(e20.10e4)') ci95
      close (unit=1, status='keep')
c
c 2.  Bias correction OK?
c     ===================
c
      if (cbias.eq.'y') then
200      print *
         write (unit=6,fmt='(1x,4a)')
     +   'Is your bias correction OK',',',' that means',','
         print *
         write (unit=6,fmt='(1x,a)')
     +   'is med(tausim) close enough to tau ?'
         print *
         write (unit=6,fmt='(1x,3a)')
     +   'If ''yes''',',',' proceed with              [y]'
         print *
         write (unit=6,fmt='(1x,3a)')
     +   'If '' no''',',',' exit with                 [n]'
         print *
         write (unit=6,fmt='(1x,a)')
     +  '          and run TAUEST new with another value for rho_pre.'
         read (5,'(a1)') biasok
         if (biasok.ne.'y'.and.biasok.ne.'n') go to 200
         if (biasok.eq.'n') then
            print *
            write (unit=6,fmt='(1x,a)')
     +      'Good bye.'
            go to 500
         end if
      end if
c
c 3.  Bias correction
c     ===============
c
      tau=-1.0d0/(scalt*dlog(amin))
      if (cbias.eq.'y') then
         ci05=ci05-1.0d0/(scalt*dlog(apre))-tau
         ci95=ci95-1.0d0/(scalt*dlog(apre))-tau
         tau=-1.0d0/(scalt*dlog(apre))
      end if
c
c 4.  Final result
c     ============
c
      print *
      print *
      print *,'========================================================'
      print *,'                                                        '
      print *,'    TAUEST:                                             '
      print *,'                                                        '
      print *,'    Final result                                        '
      print *,'                                                        '
      print *,'========================================================'
      print *
      write (unit=6,fmt='(a,a)')        ' Data file:        ',name
      write (unit=6,fmt='(a,i6)')       ' Number of points: ',n
      write (unit=6,fmt='(1x,a24)')  detr
      print *
      write (unit=6,fmt='(a,7x,1p,d15.4)') ' tau:              ',
     +       -1.0d0/(scalt*dlog(amin))
      write (unit=6,fmt='(a,f15.4)') ' rho_non:             ',rhonon
      print *
      if (cbias.eq.'y') then
         write (6,'(a)') ' Bias correction: yes'
         write (unit=6,fmt='(a,f15.4)') ' rho_pre:             ',rhopre
      else if (cbias.eq.'n') then
         write (6,'(a)') ' Bias correction:  no'
      end if
      print *
      write (unit=6,fmt='(a,i6)')       ' nsim:             ',nsim
      print *
      write (unit=6,fmt='(a,1x,1p,d15.4)')
     +' Estimated persistence time [in original time units]:   ',tau
      write (unit=6,fmt='(a,1x,1p,d15.4)')
     +' equi-tailed 90-% confidence interval, lower boundary:  ',ci05
      write (unit=6,fmt='(a,1x,1p,d15.4)')
     +' equi-tailed 90-% confidence interval, upper boundary:  ',ci95
      print *
      print *, 'Proceed with Enter to view output file names'
      read (*,'()')
      print *
      print *,'Output files:'
      print *
      print *,'scatter.dat :    scatterplot data'
      print *,' tausim.dat :    simulated persistence times'
      print *,'density.dat :    kernel density'
      print *
c
c 5.  Exit
c     ====
c
500   stop 'TAUEST terminated '
      end

