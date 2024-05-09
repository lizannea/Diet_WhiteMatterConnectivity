#!/bin/bash
#SBATCH -J qsiprep
#SBATCH --time=12:00:00
#SBATCH -n 1
#SBATCH --cpus-per-task=2
#SBATCH --mem-per-cpu=12G
#SBATCH --gres=gpu					# request GPU access, can specify number of GPUs with --gres=gpu:2 (https://supercomputing.swin.edu.au/docs/2-ozstar/oz-partition.html#requesting-gpus)
#SBATCH --tmp=50GB					# Scratch for working dir (accessed via $JOBFS). Testing seems to show ~5.5GB for one visit qsiprep.
#SBATCH --mail-type=ALL 			# Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=larnoldy@swin.edu.au	# email address
#SBATCH -e /fred/oz251/Arla/derivatives/LA/qsiprep/log/error_%x_%A_%a.log			# Standard error
#SBATCH -o /fred/oz251/Arla/derivatives/LA/qsiprep/log/output_%x_%A_%a.log			# Standard output
#
#####################################################################################################################################################################
#
#
# Subject_reconstruction pipeline from QSIPrep
#---------------------------------------------
#
# A batch that goes through a part of the the "mrtrix_multishell_msmt_hsvs" 
# workflow (see jason file).
#(the folling page provided the full workfol https://github.com/PennLINC/qsiprep/blob/master/qsiprep/data/pipelines/mrtrix_multishell_msmt_ACT-hsvs.json)
#
#####################################################################################################################################################################
#
# Usage             : QSIPrep_sbatch_96_rec_5tt_rf.sh
# QSIPrep Website   : https://qsiprep.readthedocs.io/en/latest/index.html  
#
# Author            : Lizanne Arnoldy
# Version           : 1.00
# Date              : 11/01/2022
#
#####################################################################################################################################################################

source /dagg/public/neuro/fix_bash.sh
source /dagg/public/neuro/startup_20230111.sh

subj=$1
bids_root_dir="/fred/oz251/Arla/conversion_LA"
container_dir="/fred/oz251/containers/qsiprep-0.16.1.sif"
derivs_dir="/fred/oz251/Arla/derivatives/LA/qsiprep"
	
#module load gcc/9.2.0 openmpi/4.0.2 python/3.7.4 #need openmpi??? 
ml apptainer/latest  
	
#to unpack containers?
TMPDIR=$JOBFS

# Make sure FS_LICENSE is defined in the container.
export FS_LICENSE=/home/larnoldy/private/fs_license_linux.txt
	  
apptainer run --cleanenv `# Enables host environment variables to pass into the container environmet you use`\
--nv  `# sets up the containers environment to use an NVIDIA GPU and the basic CUDA libraries`\
-B /fred/oz251/Arla:/data \
-B /fred/oz251/Arla/derivatives/LA/qsiprep/work:/work \
-B $derivs_dir:/output $container_dir `# bind multiple directories`\
/data/derivatives/LA/qsiprep/qsiprep /output participant `# derivatives/qsiprep derivatives participant`\
--participant_label $subj `# Participant identifier`\
--nthreads 2 `# maximum number of threads across all processes - Dav`\
--mem_mb 24000 `# upper bound memory limit for qsiprep processes -Dave`\
--output-resolution 2 `# same as native resolution -Rob`\
--recon-only `# run only reconstruction, assumes preprocessing has already completed`\
--stop-on-first-crash `# Force stopping on first crash, even if a work directory was specified`\
--recon_input /data/derivatives/LA/qsiprep/qsiprep `# use preprocessed directory as inputs to qsirecon`\
--recon_spec /fred/oz251/Arla/conversion_LA/code/LA/qsiprep/recon/mrtrix_5tt_rf.json `# json file specifying a reconstruction pipeline to be run after preprocessing -Matt`\
--freesurfer-input /data/derivatives/LA/fmriprep/sourcedata/freesurfer `#specify the directory containing freesurfer outputs`\
--fs-license-file $FS_LICENSE `# Path to FreeSurfer license key file`\
-w /work >& /fred/oz251/Arla/derivatives/LA/qsiprep/log/qsiprep_rec_${subj}_$(date -Iseconds).log
