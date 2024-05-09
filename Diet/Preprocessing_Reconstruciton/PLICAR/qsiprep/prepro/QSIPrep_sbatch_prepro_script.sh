#!/bin/bash
#SBATCH -J qsiprep
#SBATCH --time=24:00:00
#SBATCH -n 1
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=24G
#SBATCH --gres=gpu					# request GPU access, can specify number of GPUs with --gres=gpu:2 (https://supercomputing.swin.edu.au/docs/2-ozstar/oz-partition.html#requesting-gpus)
#SBATCH --tmp=50GB					# Scratch for working dir (accessed via $JOBFS). Testing seems to show ~5.5GB for one visit qsiprep.
#SBATCH --mail-type=ALL 			# Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=larnoldy@swin.edu.au	# email address
#SBATCH -e /fred/oz251/Arla/derivatives/LA/qsiprep/log/error_%x_%A_%a.log			# Standard error
#SBATCH -o /fred/oz251/Arla/derivatives/LA/qsiprep/log/output_%x_%A_%a.log			# Standard output

#################################################################################
#
#
# Subject_Pre-processing QSIprep pipeline
#-----------------------------------------
#
# A batch script to pre-process the ARLA dataset
#
################################################################################
#
# Usage             : QSIPrep_sbatch_prepro_script.sh
# QSIPrep Website   : https://qsiprep.readthedocs.io/en/latest/index.html  
#
# Author            : Lizanne Arnoldy
# Version           : 1.00
# Date              : 11/01/2022
#
################################################################################

source /dagg/public/neuro/fix_bash.sh
subj=$1

bids_root_dir="/fred/oz251/Arla/conversion_LA"
container_dir="/fred/oz251/containers/qsiprep-0.16.1.sif"
derivs_dir="/fred/oz251/Arla/derivatives/LA/qsiprep"
	
#module load gcc/9.2.0 openmpi/4.0.2 python/3.7.4 #need openmpi??? 
module load apptainer/latest  

source /dagg/public/neuro/fix_bash.sh	
#to unpack containers?
TMPDIR=$JOBFS

# Make sure FS_LICENSE is defined in the container.
export FS_LICENSE=/home/larnoldy/private/fs_license_linux.txt	

apptainer run --cleanenv `#  host environment variables to pass into the container you`\
--nv `# setup the containers environment to use an NVIDIA GPU and the basic CUDA libraries`\
-B /fred/oz251/Arla:/data `#b data directory`\
-B $derivs_dir:/output $container_dir `#b output and container directory`\
/data/conversion_LA /output participant `# call bids_directory output_derectory and participants`\
--participant-label $subj `# Participant identifier`\
--fs-license-file $FS_LICENSE `# Path to FreeSurfer license key file. Get it (for free) by registering at`\
--eddy-config /data/conversion_LA/code/LA/qsiprep/eddy_params.json `# path to a json file with settings for the call to eddy.The current default json can be found here: https://github.com/PennBBL/qsiprep/blob/master/qsiprep/data/eddy_params.json`\
--nthreads 2 `# maximum number of threads across all processes - Dave`\
--mem_mb 24000 `# upper bound memory limit for qsiprep processes -Dave `\
--output-resolution 2 `# same as native resolution -Rob`\
--denoise-method dwidenoise `# Image-based denoising method choose_dwidenoise_(MRtrix) as there is currently no option to run patch2self after the other denoising steps (motion correction, unringing, etc) in qsiprep`\
--unringing-method mrdegibbs `# enabled Gibbs undinging -default:none - I choose to include Gibbs unringing to include all the denoising steps`\
--resource-monitor `# enable Nipype s resource monitoring to keep track of memory and CPU usage - from qsiprep site`\
-w /data/derivatives/LA/qsiprep/work >& /fred/oz251/Arla/derivatives/LA/qsiprep/log/qsiprep_${subj}_$(date -Iseconds).log

#--do_reconall `# this command is not included as freesurfer was removed from the QSIPrep container due to the required space see:https://github.com/PennLINC/qsiprep/issues/384`\
#--unringing-method #default: none
 