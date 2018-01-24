set terminal pngcairo  transparent enhanced font "arial,10" fontscale 1.0 size 600, 400 
set output 'mem-time.png'
set boxwidth 0.9 absolute
set style fill   solid 1.00 border lt -1
set style histogram clustered gap 1 title textcolor lt -1
set datafile missing '-'
set style data histograms
set xtics border in scale 0,0 nomirror rotate by -45  autojustify
set xtics  norangelimit 
set xtics   ()
set title "Memory comparison. Walltime time (s)." 
set yrange [ 1 : 1000000 ] noreverse nowriteback
set logscale y
plot for [i=2:3] '/dev/stdin' using i:xtic(1) title col

