# COG&Pfam-join
Note: to use these joining scripts, you need to have installed in your computer the RStudio or something similar to deal with R.
Get amino-acid FASTA
1) Upload genome on RAST.
2) In RAST, for each genome, go to Job Details and download the annotated amino-acid FASTA file.
WebMGA
3) Upload the amino-acid FASTA file in WebMGA, and run it for:
	COG: http://weizhong-lab.ucsd.edu/webMGA/server/cog/
Pfam: http://weizhong-lab.ucsd.edu/webMGA/server/pfam/
The job processing can take a while. So, I advise you to copy  the JobID to a document to be able to retrieve the results latter, in case you accidentally close the browser.
4) When it’s finished, download the results. These will consist in several different files (normally 3). For each genome you’ll only need the .txt file with a simple name. The other 2 will say “cog-class” or “cog-raw”- these you can discard. 
Note: it is really important that your .txt file has a simple name like: aquimarina.txt (any different characters won’t work on these script)s.
5) Create a new folder and, inside, put the .txt files from all the genomes that you want to have a joint table. Open each file and remove the # symbol that appears next to Accession (R doesn’t read anything that goes after #).
Script to join files
7) Copy the script to inside the folder. Run the script by executing it in RStudio. The output will be a table (tsv) with all the genomes and cog entries grouped.
8) Repeat from step 4, now for the Pfam annotation.

I hope it’s helpful.

Sandra Godinho Silva
sandragodinhosilva@gmail.com

Last update: Last update: 14/02/2020
