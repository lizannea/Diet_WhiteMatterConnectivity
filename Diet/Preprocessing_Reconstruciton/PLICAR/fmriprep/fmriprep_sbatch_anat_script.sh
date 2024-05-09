#!/bin/bash
#SBATCH -J fmriprep_anat
#SBATCH --time=24:00:00
#SBATCH -n 1
#SBATCH --cpus-per-task=4
#SBATCH --mem=24G
#SBATCH --tmp=40GB					# Scratch for working dir (accessed via $JOBFS)
#SBATCH --mail-type=ALL 			# Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=larnoldy@swin.edu.au	# email address
#SBATCH -e /fred/oz251/Arla/derivatives/LA/fmriprep2/log/error_%A_%a.log			# Standard error
#SBATCH -o /fred/oz251/Arla/derivatives/LA/fmriprep2/log/output_%A_%a.log		# Standard output

source /dagg/public/neuro/fix_bash.sh

subj=$1
bids_root_dir="/fred/oz251/Arla/conversion_LA"
container="/fred/oz251/containers/fmriprep-22.0.2.sif"
derivs_dir="/fred/oz251/Arla/derivatives/LA/fmriprep2"

#module load gcc/9.2.0 openmpi/4.0.2 python/3.7.4 #need openmpi??? 
module load apptainer/latest 

#to unpack containers?
TMPDIR=$JOBFS

#Make fmriprep_anat directory in derivatives folder
if [ ! -d ${derivs_dir} ]; then
mkdir -p ${derivs_dir}
fi

# Make sure FS_LICENSE is defined in the container.
export FS_LICENSE=/home/larnoldy/private/fs_license_linux.txt

# Designate a templateflow bind-mount point
TEMPLATEFLOW_HOST_HOME=/home/larnoldy/.cache/templateflow
export APPTAINERENV_TEMPLATEFLOW_HOME="/templateflow"

apptainer run --cleanenv \
-B /fred/oz251/Arla/conversion_LA:/data \
-B $derivs_dir:/output \
-B ${TEMPLATEFLOW_HOST_HOME}:${APPTAINERENV_TEMPLATEFLOW_HOME} \
-B $JOBFS:/work $container \
/data /output participant \
--participant-label ${subj} \
--skip_bids_validation \
--fs-license-file $FS_LICENSE \
--output-spaces MNI152NLin6Asym:res-2 \
--anat-only \
--nthreads 4 \
--mem_mb 24000 \
--stop-on-first-crash \
--verbose \
--write-graph \
-w /work >& /fred/oz251/Arla/derivatives/LA/fmriprep2/log/fmriprep_${subj}_$(date -Iseconds).log

#--anat-only #run anatomical workflows only