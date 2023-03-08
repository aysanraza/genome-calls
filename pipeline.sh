echo ""
echo "================= Welcome to the genome-calls pipeling =================" 
echo ""

echo ""
echo "Kindly make sure about the specified guidlines:"
echo ""

echo "1- Project envirnment is installed and activated
2- You are present in a project folder
3- Project folder contains the fastq.gz format of read file, .fa format reference sequence, 
4- Rename the read file as reads.fastq.gz (single end) and reference file as ref.fa
5- Reads are clean.
6- Paths are set according to your system"
echo ""

echo ""
echo "Choice of Variant Caller:"
echo ""

echo "1- Alignment based variant calling
2- Bayesian based variant calling
3- Exit Program"

echo ""
read -p "Enter Choice (1 or 2 or 3):" choice
echo ""

if [ "$choice" == 1 ]; then
  bowtie2-build project_folder/ref.fa indexfiles
  bowtie2 -x project_folder/indexfiles -U project_folder/reads.fastq.gz -S project_folder/map.sam
  head map.sam
  samtools view -bS project_folder/map.sam > project_folder/map.bam
  samtools sort project_folder/map.bam -o project_folder/map.sorted.bam
  bcftools mpileup -f project_folder/ref.fa project_folder/map.sorted.bam | bcftools view -Ov - > project_folder/map.raw.bcf
  bcftools view project_folder/map.raw.bcf
  bcftools view -i '%QUAL>=20' map.raw.bcf
  
elif [ "$choice" == 2 ]; then
  bowtie2-build project_folder/ref.fa indexfiles
  bowtie2 -x project_folder/indexfiles -U project_folder/reads.fastq.gz -S project_folder/ngs_practice/map.sam
  head map.sam
  samtools view -bS /project_folder/map.sam > project_folder/map.bam
  freebayes -f ref.fa map.bam > variants.vcf
  
elif [ "$choice" == 3 ]; then
  echo ""
  echo "Program Terminated"
  echo ""
  exit
  
else
  echo ""
  echo "Program Terminated due to invalid option selection"
  echo ""
fi


