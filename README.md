## Benchmarks of BLAST and PLAST

This project provides a script framework originally used to run benchmarks of [BLAST](https://blast.ncbi.nlm.nih.gov/Blast.cgi?CMD=Web&PAGE_TYPE=BlastDocs) and [PLAST](https://plast.inria.fr) on a supercomputer infrastructure.

Provided scripts were originally designed to run comparison softwares on [IFREMER](www.ifremer.fr)'s [DATARMOR](https://www.top500.org/system/178981) computer providing the PBS job scheduler system. However, it would be easy to adapt theses scripts to run with other kind of job schedulers.

## Requirements

Our scripts were designed to work with:

* PBS pro 14.2.4
* NCBI [BLAST](https://blast.ncbi.nlm.nih.gov/Blast.cgi?CMD=Web&PAGE_TYPE=BlastDocs) 2.2.31 and 2.6.0
* INRIA [PLAST](https://plast.inria.fr) 2.3.2

In addition, you need some data sets to run sequence comparisons:

* FASTA files containing BLAST/PLAST queries
* BLAST databanks to be used as subjects for BLAST/PLAST comparison jobs

It is up to you to install all that material.

## Use

First of all, you will have to edit scripts to meet YOUR requirements:

* edit "blast_template.txt": this is the script that is scheduled by PBS on the computing system. Among others, it contains queries and subjet banks to use, as well as BLAST and PLAST commands to run.
* edit "01-generate-scripts.sh": this is the script that defines PBS constraints (number of cores, memory and walltime).

Then, simply execute scripts by sequential order:

* first, run [01-generate-scripts.sh](scripts/01-generate-scripts.sh): takes "blast_template.txt" and generate as many job submission scripts as PBS constraints (cores and comparison types)
* then, run[ 02-submit-scripts.sh](scripts/ 02-submit-scripts.sh): automatically submits to PBS all the scripts generated by previous step
* optionally, run [03-alter-wtime.sh](scripts/03-alter-wtime.sh): alters walltime of all submitted jobs (in case your jobs take a long time to finish)
* finally, run [04-analyse-resources.sh](scripts/04-analyse-resources.sh): compiles usefull data from jobs stats; for instance, this is the script used to generate content of sub-folder [results](results)

## Test case on IFREMER's DATARMOR supercomputer

We used scripts above presented to evaluate the optimal configuration (cores, RAM and walltime) to run sequence comparison jobs (aka BLAST) on the [DATARMOR](https://www.top500.org/system/178981) supercomputer available at IFREMER for bioinformatics computational intensive works.

For that purpose, we ran jobs using the following constraints:

* use 8, 16, 32 and 56 cores; HPC part of DATARMOR provides several hundreds 56-core computing nodes;
* use 32 Go RAM;
* queries: bacterium *Yersinia pestis* protein sequences (blastp and blastx) or gene sequences (blastn and megablast), i.e. 3979 sequences;
* subject banks: one of Swissprot (555,594 sequences), Genbank Bacteria division (1,604,589 sequences) or TrEmbl (90,050,708 sequences); banks content as available on September 2017.
* softwares: BLAST 2.2.31 & 2.6.0 and PLAST 2.3.2.

Below, we use the following identifiers to target each kind of queries:

* P: bacterium *Yersinia pestis* protein sequences
* N: bacterium *Yersinia pestis* gene sequences

Same for subject banks:

* P: SwissProt
* PL: TrEmbl
* N: Genbank Bacteria division (to be used to run blastn)
* M: Genbank Bacteria division (to be used to run megablast)

For instance, using these identifiers, we identify a protein/protein comparison against SwissProt and TrEmbl with id "P-P" and "P-PL".

Raw results (running times, CPU & memory use on 8, 16 ,32  and 56 cores) are as follows:

* [BLAST 2.2.31](results/results-blast-2.2.31.tsv)
* [BLAST 2.6.0](results/results-blast-2.6.0.tsv)
* [PLAST 2.3.2](results/results-blast-2.3.2.tsv)

Note: content of the above files is described [here](results/README.md)

Since we were interested in running time, here are some graphical outputs (generated using material from sub-folder [gnuplot](gnuplot)):

* y-axis: running time (seconds)
* x-axis: nb cores
* B2, B6 and P stands for BLAST 2.2.31, BLAST 2.6.0 and PLAST 2.3.2, respectively

* ![P-P: blastp](gnuplot/pp-time.png)
* ![P-PL: blastp](gnuplot/ppl-time.png)
* ![N-P: blastx](gnuplot/np-time.png)
* ![N-N: blastn and megablast](gnuplot/nn-time.png)
* ![M-N: focus on megablast](gnuplot/mn-time.png)

Note: N-N and M-N comparisons not done using PLAST since it is not optimal with regards to BLAST performance.
