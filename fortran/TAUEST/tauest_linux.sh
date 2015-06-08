echo off
cls
tauest1
gnuplot tauest1.plt
tauest2
gnuplot tauest2a.plt
gnuplot tauest2b.plt
tauest3
gnuplot tauest3.plt
tauest4
rm *.tmp
rm *.plt
