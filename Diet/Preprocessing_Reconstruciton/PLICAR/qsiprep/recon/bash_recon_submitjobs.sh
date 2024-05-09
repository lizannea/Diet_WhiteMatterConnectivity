#!/bin/bash
#SBATCH --mail-type=ALL 			# Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=larnoldy@swin.edu.au	# email address

source /dagg/public/neuro/fix_bash.sh
source /dagg/public/neuro/startup_20230111.sh

#Simple loop to send off sqiprep job for all subjs in a list

bidsdir="/fred/oz251/Arla/conversion_LA"
codedir="/fred/oz251/Arla/conversion_LA/code/LA/qsiprep/recon"
logdir="/fred/oz251/Arla/derivatives/LA/qsiprep/log/"

#make deriv/log dir for analysis
if [ ! -d ${logdir} ]; then
mkdir -p ${logdir}
fi

cd ${bidsdir}
ls -d sub-* > ${logdir}/pptlist.txt


for subj in `cat ${logdir}/pptlist.txt` 
do

subj_id=${subj:4}
echo "sending jobs for ${subj_id}" 
sbatch ${codedir}/QSIPrep_sbatch_recon_script.sh ${subj_id}
done