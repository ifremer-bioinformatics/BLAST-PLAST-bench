set terminal pngcairo  transparent enhanced font "arial,10" fontscale 1.0 size 600, 400 
set output 'nn-time.png'
set boxwidth 0.9 absolute
set style fill solid 1.00 border lt -1
#set key fixed right top vertical Right noreverse noenhanced autotitle nobox
set style histogram clustered gap 1 title textcolor lt -1
set style data histograms
set xtics border in scale 0,0 nomirror rotate by -45  autojustify
set xtics norangelimit 
set xtics ()
set title "Nucleic-Nucleic comparison. Running time." 
set yrange [ 0 : 10000 ] noreverse nowriteback
plot for [i=2:5] '/dev/stdin' using i:xtic(1) title col

