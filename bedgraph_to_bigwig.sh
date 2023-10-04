# Convert bedGraph to bigWig file
# ucsc-bedgraphtobigwig converts a bigWig file to ASCII bedGraph format.
# Reference page > (https://genome.ucsc.edu/goldenPath/help/bigWig.html)

# To execute the contents of the .bashrc file in the current shell session (necessary to start conda)
    source ~/.bashrc

# install the bedtools
    cd anaconda3/envs/                  # go to your anaconda3 directory
    conda create --name ucsc-bedgraphtobigwig        # create your ucsc-bedgraphtobigwig environment
    
    cd anaconda3/envs/ucsc-bedgraphtobigwig/         #go to your working directory
    
    conda activate ucsc-bedgraphtobigwig             #activate conda environment
    
    conda install -c bioconda ucsc-bedgraphtobigwig  #install ucsc-bedgraphtobigwig
    
# create your working directory for your ucsc-bedgraphtobigwig environment
    mkdir ucsc-bedgraphtobigwig_mm10                # working directory should be outside the anaconda3 directory
    cd ucsc-bedgraphtobigwig_mm10                   # go to your ucsc-bedgraphtobigwig working directory

# To copy a file from one location to another in a Unix-based system,
    cp /directory/path/file_name.bed /directory/path/ucsc-bedgraphtobigwig_mm10/

# activate the bedtools environment in your working directory
    conda activate ucsc-bedgraphtobigwig            #activate conda environment

# upload your bed file file_name.bed and 'reference genome chr sizes file > mm10.chrom.sizes.txt' into conda environment
    to  /directory/path/ucsc-bedgraphtobigwig_mm10/

# open bed file in the terminal to decide which columns will be printed
    less file_name.bed

# bed file should contain just 4 columns; chrom  chromStart  chromEnd  dataValue
# this is the command to modify and print your desired file
    awk -v FS='\t' -v OFS='\t' '{print $1, $2, $2+1, $11}' file_name.bed | head

# create your output file including your desired columns 
    awk -v FS='\t' -v OFS='\t' '{print $1, $2, $2+1, $11}' file_name.bed > file_name_methylation_CG.bed

# check the file constitution > bedGraph should be without header
    less file_name_methylation_CG.bed

# delete headers in HEK293T_WGBS_CG.txt by anno function  
    awk 'NR!=1' file_name_methylation_CG.bed > file_name_methylation_CG_without_header.bed

# check the file constitution  
    less file_name_methylation_CG_without_header.bed

# bedGraph should be sorted
    sort -k1,1 -k2,2n file_name_methylation_CG_without_header.bed > sorted_file_name_methylation_CG_without_header.bed

# download appropriate chromosome sizes file from https://hgdownload.soe.ucsc.edu/downloads.html and rename/upload to the directory
# hg38.chrom.sizes hg19.chrom.sizes mm10.chrom.sizes

# You can check whether a file is tab-delimited or not in Unix by examining its contents

result=$(file file_name_methylation_CG_without_header.bed | grep -o "tab")
if [ "$result" = "tab" ]; then
    echo "File is tab-delimited."
else
    echo "File is not tab-delimited."
fi

# chrM should be deleted in bed files
# $1 represents the first column of each line. The condition $1 != "chrM" checks if the value of the first column is not equal to "chrM". 
# If the condition is true, the line is printed. 
# If the condition is false (i.e., the first column is "chrM"), the line is skipped.
    awk '$1 != "chrM"' file_name_methylation_CG_without_header.bed > file_name_methylation_CG_without_header_without_chrM.bed

# script worked and ready to generate .bw (BigWig file)
    bedGraphToBigWig file_name_methylation_CG_without_header_without_chrM.bed mm10.chrom.sizes.bed file_name_methylation_CG.bw

# It worked > put .bw file to appropriate folder in remote drive to upload UCSC
    /directory/path/folder_name/

# cp /directory/path/file_name_methylation_CG.bw /directory/path/folder_name/
# go to UCSC account > Custom Tracks > Add custom track
    track type=bigWig name=Sample_name color=0,255,0 bigDataUrl=https://url_name.com/directory/path/file_name_methylation_CG.bw



