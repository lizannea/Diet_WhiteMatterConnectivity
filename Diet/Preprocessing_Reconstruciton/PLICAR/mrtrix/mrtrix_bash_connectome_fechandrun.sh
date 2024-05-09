#!/bin/bash
#SBATCH --time=20:00:00
#SBATCH -n 1
#SBATCH --cpus-per-task=2
#SBATCH --mem-per-cpu=12G
#SBATCH --gres=gpu					# request GPU access, can specify number of GPUs with --gres=gpu:2 (https://supercomputing.swin.edu.au/docs/2-ozstar/oz-partition.html#requesting-gpus)
#SBATCH --tmp=50GB					# Scratch for working dir (accessed via $JOBFS). Testing seems to show ~5.5GB for one visit qsiprep.
#SBATCH --mail-type=ALL 			# Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=larnoldy@swin.edu.au	# email address
#SBATCH -e /fred/oz251/Arla/derivatives/LA/mrtrix/log/error_%x_%A_%a.log			# Standard error
#SBATCH -o /fred/oz251/Arla/derivatives/LA/mrtrix/log/output_%x_%A_%a.log			# Standard output

source /dagg/public/neuro/fix_bash.sh
source /dagg/public/neuro/startup_20230111.sh
#export INFO=1

#fetch and run mrtrix container on ozstar
bidsdir="/fred/oz251/Arla/conversion_LA"
codedir="${bidsdir}/code/LA/mrtrix"
container="/fred/dagg/public/neuro"

subj=$1

apptainer exec /dagg/public/neuro/neurodesk_20230111/neurocommand/local/containers/mrtrix3_3.0.3_20210917/mrtrix3_3.0.3_20210917.simg bash ${codedir}/mrtrix_sbatch_script_connectome.sh ${subj} |& tee mrtrix_2_$(date -Iseconds).log
