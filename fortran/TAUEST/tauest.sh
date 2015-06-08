#! /bin/bash

if [ $1 ] 
then if [ $1 -le 4 ]
    then NCHAN=${1} 
    else echo "$0 <NUM CHANS (MAX 4)> <d|f|t (\"digitizer\"|\"fileplayer\"|\"tcp\")> "
	exit
    fi
fi

if [ $2 ];
then if [ `expr match ${2} "f"` -eq 1 ]; then 
	RTDF="rtd_${2}.data"; OPREFIX=${2}
    elif [ `expr match ${2} "t"` -eq 1 ]; then
	RTDF="rtd_${2}.data"; OPREFIX=${2}
    elif [ `expr match ${2} "d"` -eq 1 ]; then
	RTDF="rtd_${2}.data"; OPREFIX=${2}
    else echo "$0 <NUM CHANS (MAX 4)> <d|f|t (\"digitizer\"|\"fileplayer\"|\"tcp\")> "
	exit
    fi
fi

echo "Gnuplotting ${RTDFILE}.."
echo "(Gnuplot) Number of channels in ${RTDFILE}: ${NCHAN}"

gnuplot -persist plot_opts.gnu -e "${PLOTSTR}" rtd_loop.gnu

tauest1 <<EOF
idl_tauest.tmp
EOF
gnuplot tauest1.plt
tauest2
gnuplot tauest2a.plt
gnuplot tauest2b.plt
tauest3
gnuplot tauest3.plt
tauest4
rm *.tmp
rm *.plt
