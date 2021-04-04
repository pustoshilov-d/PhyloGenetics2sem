#!/bin/bash
ulimit -n 100000
export PATH=~/miniconda3/bin:$PATH
export PATH=~/anaconda_ete/bin:$PATH

conda update conda
conda config --add channels defaults
conda config --add channels bioconda
conda config --add channels conda-forge

conda create -n phylo_new python=3.6
conda activate phylo_new
source activate phylo_new

conda install -c etetoolkit ete3 ete_toolchain
pip3 install -I ete3
ete3 upgrade-external-tools

ete3 build check
ete3 build workflows genetree 
SUPERMATRIX_WORKFLOW

data_dir="/mnt/Data10tb/student6/phylogen"
work_dir="/home/student6/02.BioinfFilogenetika"

# # 1 2 5 9 орто-групп
num=9
cur_fasta=$data_dir/$num"prot.fasta"
cur_cog=$data_dir/"COG_"$num"prot.txt"
cur_work_dir=$work_dir/$num/


xvfb-run ete3 build \
-w clustalo_default-trimal_gappyout-none-none \
-m cog_95-alg_concat_default-treebest_ensembl \
--cogs $cur_cog \
-a $cur_fasta \
-o $cur_work_dir \
--clearall
--cpu 5

# -w clustalo_default-trimal01-none-none \
# -m cog_100-alg_concat_default-fasttree_default \
#sptree_fasttree_100 

ref=$data_dir/"reference.nwk"
cur_tree_1=$cur_work_dir/clustalo_default-trimal01-none-fasttree_default/$num"prot.fasta.final_tree.nw"
cur_tree_2=$cur_work_dir/cog_100-alg_concat_default-fasttree_default/$num"prot.fasta.final_tree.nw"
cur_tree_3=$cur_work_dir/cog_100-alg_concat_default-fasttree_full/$num"prot.fasta.final_tree.nw"
cur_tree_4=$cur_work_dir/cog_95-alg_concat_default-treebest_ensembl/$num"prot.fasta.final_tree.nw"

echo number gene groups $num
echo $cur_tree_4

xvfb-run ete3 compare \
-t $cur_tree_4 \
-r $ref \
--unrooted

xvfb-run ete3 view -t $cur_tree_1

## R https://ms609.github.io/TreeDist/reference/TreeDistance.html 
## Information-based generalized Robinson–Foulds distances
## 