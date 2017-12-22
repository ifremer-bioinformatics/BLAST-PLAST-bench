For each "tsv" file we have the following columns:

* QUERY: type of query (see below)
* SUBJECT: type of subject
* CPUS(c): nb CPUs requested in PBS submission script
* MEM(Gb): RAM requested in PBS submission script
* CPUPCT: CPU percent used during job execution
* CPUTIME: CPU time of job execution
* MEM(Mb): max memory (RAM) used during job execution
* NCPUS: nb CPUs assigned by PBS to the job
* VMEM(Mb): virtual memory (RAM) used during job execution
* WALLTIME(s): job running time (seconds)
* QTIME(s): time stamp (epoch) when job has been queued
* STIME(s): time stamp (epoch) when job has started execution
* DELTA(s): on hold time (STIME-QTIME) in seconds
* JOBID: job ID

Above, we use the following identifiers to target each kind of queries:

* P: bacterium *Yersinia pestis* protein sequences
* N: bacterium *Yersinia pestis* gene sequences

Same for subject banks:

* P: SwissProt
* PL: TrEmbl
* N: Genbank Bacteria division (to be used to run blastn)
* M: Genbank Bacteria division (to be used to run megablast)

For instance, using these identifiers, we identify a protein/protein comparison against SwissProt and TrEmbl with id "P-P" and "P-PL".

Here are some details about the files we used:

* queries: bacterium *Yersinia pestis* protein sequences (blastp and blastx) or gene sequences (blastn and megablast), i.e. 3979 sequences;
* subject banks: one of Swissprot (555,594 sequences), Genbank Bacteria division (1,604,589 sequences) or TrEmbl (90,050,708 sequences); banks content as available on September 2017.
* softwares: BLAST 2.2.31 & 2.6.0 and PLAST 2.3.2.

