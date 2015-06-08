c
c TAUEST
c
c ======================================================================
c
c     Change log:
c
c     Date         Version    Changes
c
c     May 2011     2.0        More details on TAUEST reference
c                             [tauest1.for, Point 1]
c
c                             Made ready for compilation under gfortran:
c                             o 'pause' statements via read (*,'()')
c                             o non-integer do loop variable replaced
c                               by integer [tauest2.for, Point 7]
c
c                             Bias correction formula (Kendall 1954)
c                             explicitly solved
c                             [tauest3.for, Point 2]
c
c                             Title of density plot changes
c                             [tauest3.for, Point 13]
c
c     March 2002     1.0      (Original version)
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
c     tauest1.for
c
c ======================================================================
c
      SUBROUTINE tauest1_edit(argc, argv)
      character*60 name
      character*11 file1,file2
      parameter (file1='tauest1.tmp',file2='tauest1.plt')
c
c ======================================================================
c
c 1.  Welcome, data file name and path
c     ================================
c
      print *,'========================================================'
      print *,'                                                        '
      print *,'    TAUEST:                                             '
      print *,'                                                        '
      print *,'    a computer program for estimating persistence       '
      print *,'    in unevenly spaced weather/climate time series      '
      print *,'                                                        '
      print *,'    Mudelsee M (2002) Computers and Geosciences         '
      print *,'                      28:69-72                          '
      print *,'                                                        '
      print *,'    www.mudelsee.com                                    '
      print *,'                                                        '
      print *,'                                                        '
      print *,'                                                        '
      print *,'    TAUEST Version 2.0 (May 2011)                       '
      print *,'                                                        '
      print *,'========================================================'
      print *
      print *,'x vs t: [path + filename] '
      read (unit=5,fmt='(a)') name
      open (unit=1, file=file1, form='formatted',
     +      access='sequential', status='unknown')
      write (unit=1,fmt='(a60)') name
      close (unit=1,status='keep')
c
c 2.  Plotting data
c     =============
c
      open (unit=1, file=file2, form='formatted',
     +      access='sequential', status='unknown')
      write (unit=1,fmt='(a)') ' set grid'
      write (unit=1,fmt='(a)') ' set key'
      write (unit=1,fmt='(5(a))')
     +      ' plot ''',name,''' title ''',name,'''w l 8'
      write (unit=1,fmt='(a)') ' pause mouse key'
      close (unit=1, status='keep')
      stop ' '
      end
      
