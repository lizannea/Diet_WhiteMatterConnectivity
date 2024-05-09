#!/bin/bash
#SBATCH --mail-type=ALL 			# Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=larnoldy@swin.edu.au	# email address
#SBATCH -e /fred/oz251/Arla/derivatives/LA/mrtrix/log/error_%x_%A_%a.log			# Standard error
#SBATCH -o /fred/oz251/Arla/derivatives/LA/mrtrix/log/output_%x_%A_%a.log			# Standard output


source /dagg/public/neuro/fix_bash.sh
#source /dagg/public/neuro/startup_20230111.sh
#export INFO=1

#Simple loop to send off sqiprep job for all subjs in a list

bidsdir='/fred/oz251/Arla/conversion_LA'
codedir='/fred/oz251/Arla/conversion_LA/code/LA/mrtrix'
logdir='/fred/oz251/Arla/derivatives/LA/mrtrix/log/'

#make deriv/log dir for analysis
if [ ! -d ${logdir} ]
then
mkdir -p ${logdir}
fi

cd ${bidsdir}
ls -d sub-* > ${logdir}/pptlist.txt

for subj in `cat ${logdir}/pptlist.txt` 
do

subj_id=${subj:4}
echo "sending jobs for ${subj_id}" 
sbatch ${codedir}/mrtrix_bash_connectome_fechandrun.sh ${subj_id} |& tee mrtrix_1_$(date -Iseconds).log
done
