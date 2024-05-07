#!/bin/bash
#SBATCH --mail-type=ALL 			# Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=larnoldy@swin.edu.au	# email address
#SBATCH -e /fred/oz251/Mast/derivatives/LA/mrtrix/log/error_%x_%A_%a.log			# Standard error
#SBATCH -o /fred/oz251/Mast/derivatives/LA/mrtrix/log/output_%x_%A_%a.log			# Standard output
#
#################################################################################
#
#
# Subject_mrtrix_connectome script
#-----------------------------------------
#
# A batch that uses files generated from QSIPrep_rec_5tt_rf_Final.sh 
# and the calculated mean responsfunctions to create the connectome (mrtrix).
# This batch is used to analyse the ARLA dataset. 
#
################################################################################
#
# Usage             : mrtrix_recon_script_connectome.sh
# mrtrix Website    : https://mrtrix.readthedocs.io/en/dev/index.html
#
# Author            : Lizanne Arnoldy
# Version           : 1.00
# Date              : 19/09/2023
#
################################################################################

source /dagg/public/neuro/fix_bash.sh
source /dagg/public/neuro/startup_20230111.sh
#export INFO=1

subj=$1
derivdir='/fred/oz251/Mast/derivatives/LA/mrtrix/connectome/'${subj}'/'

#create derivetives directory
if [ ! -d ${derivdir} ]
then
echo 'derividir is: '${derivdir}
mkdir -p ${derivdir}
fi

#estimation of FiberOrientation Distributions:for every voxel, estimate the orientation of every fiber that cross the voxel
#with responsmean mrtrix: dwi2fod [ options ]  algorithm dwi response odf [response odf] (from QSIPREP Commentlines:/fred/oz251/Mast/derivatives/LA/qsiprep/${subj}/rec/rec_5tt_rf/work/qsirecon_wf/sub-${subj}_mrtrix_5tt_rf/sub_${subj}_ses_V1_space_T1w_desc_preproc_recon_wf/msmt_csd/estimate_fod)
dwi2fod \
-mask /fred/oz251/Mast/derivatives/LA/qsiprep/work/qsirecon_wf/sub-${subj}_mrtrix_5tt_rf/sub_${subj}_ses_V1_space_T1w_desc_preproc_recon_wf/qsirecon_anat_wf/resample_mask/sub-${subj}_desc-brain_mask_resample.nii.gz `#Path/to_mask (Orientation ACPC)`\
-lmax 8,8,8 `#from QSIPREP commentline`\
-nthreads 1 `#from QSIPREP commentline`\
-force \
msmt_csd `# algorith` \
/fred/oz251/Mast/derivatives/LA/qsiprep/work/qsirecon_wf/sub-${subj}_mrtrix_5tt_rf/sub_${subj}_ses_V1_space_T1w_desc_preproc_recon_wf/msmt_csd/create_mif/sub-${subj}_ses-V1_space-T1w_desc-preproc_dwi.mif `#input diffusion-weighted image`\
/fred/oz251/Mast/derivatives/LA/mrtrix/connectome/responsemean_wm.txt `# input meanRF` \
/fred/oz251/Mast/derivatives/LA/mrtrix/connectome/${subj}/sub-${subj}_ses-1_run-1_space-T1w_desc-preproc_dwi_meanwmfod.mif `#odfoutput`\
/fred/oz251/Mast/derivatives/LA/mrtrix/connectome/responsemean_gm.txt `# input meanRF`\
/fred/oz251/Mast/derivatives/LA/mrtrix/connectome/${subj}/sub-${subj}_ses-1_run-1_space-T1w_desc-preproc_dwi_meangmfod.mif `#odfoutput`\
/fred/oz251/Mast/derivatives/LA/mrtrix/connectome/responsemean_csf.txt `# input meanRF`\
/fred/oz251/Mast/derivatives/LA/mrtrix/connectome/${subj}/sub-${subj}_ses-1_run-1_space-T1w_desc-preproc_dwi_meancsffod.mif `#odfoutput`\
|& tee /fred/oz251/Mast/derivatives/LA/mrtrix/log/${subj}_FOD_log.txt

#Intensity Normalization (from QSIPREP COMMENTLINES: path/fred/oz251/Mast/derivatives/LA/qsiprep/${subj}/rec/rec_5tt_rf/work/qsirecon_wf/sub-${subj}_mrtrix_5tt_rf/sub_${subj}_ses_V1_space_T1w_desc_preproc_recon_wf/msmt_csd/intensity_norm)
#mtnormalise wmfod.mif wmfod_norm.mif gmfod.mif gmfod_norm.mif csffod.mif csffod_norm.mif -mask path/to_mask
mtnormalise \
/fred/oz251/Mast/derivatives/LA/mrtrix/connectome/${subj}/sub-${subj}_ses-1_run-1_space-T1w_desc-preproc_dwi_meanwmfod.mif `#path to input odf image`\
/fred/oz251/Mast/derivatives/LA/mrtrix/connectome/${subj}/sub-${subj}_ses-1_run-1_space-T1w_desc-preproc_dwi_wm_mtnorm.mif `#output image` \
/fred/oz251/Mast/derivatives/LA/mrtrix/connectome/${subj}/sub-${subj}_ses-1_run-1_space-T1w_desc-preproc_dwi_meangmfod.mif `#path to input image`\
/fred/oz251/Mast/derivatives/LA/mrtrix/connectome/${subj}/sub-${subj}_ses-1_run-1_space-T1w_desc-preproc_dwi_gm_mtnorm.mif `#output image`\
/fred/oz251/Mast/derivatives/LA/mrtrix/connectome/${subj}/sub-${subj}_ses-1_run-1_space-T1w_desc-preproc_dwi_meancsffod.mif `#path to input odf image`\
/fred/oz251/Mast/derivatives/LA/mrtrix/connectome/${subj}/sub-${subj}_ses-1_run-1_space-T1w_desc-preproc_dwi_csf_mtnorm.mif `#output image`\
-check_mask /fred/oz251/Mast/derivatives/LA/mrtrix/connectome/${subj}/inliers.nii.gz `# output the final mask used to compute the normalisation. This mask excludes regions identified as outliers by the optimisation process` \
-mask /fred/oz251/Mast/derivatives/LA/qsiprep/work/qsirecon_wf/sub-${subj}_mrtrix_5tt_rf/sub_${subj}_ses_V1_space_T1w_desc_preproc_recon_wf/qsirecon_anat_wf/resample_mask/sub-${subj}_desc-brain_mask_resample.nii.gz `#path to mask`\
-check_norm /fred/oz251/Mast/derivatives/LA/mrtrix/connectome/${subj}/norm.nii.gz `# from qsiprep comment`\
-force `#overwrite`\
-nthreads 1 `# from qsiprep comment`\
|& tee /fred/oz251/Mast/derivatives/LA/mrtrix/log/${subj}_mtnormalization_log.txt

#Preparing Anatomically Constrained Tractography (ACT)->streamline termination -> already done in qsiprep
#Path to 5TT image:
#streamline seeding mask from 5ttimages have already been created by QSIPrep: path /fred/oz251/Mast/derivatives/LA/qsiprep/${subj}/rec/rec_5tt_rf/work/qsirecon_wf/sub-${subj}_mrtrix_5tt_rf/anat_ingress_wf/apply_header_to_5tt/sub-${subj}_5tt_hdrxform.nii.gz 

#Creat streamlines (from QSIPREP path to comment:/fred/oz251/Mast/derivatives/LA/qsiprep/sub-{subj}/rec_mrtixworkflow6/work/qsirecon_wf/sub-096_mrtrix_multishell_msmt_hsvs/sub_096ses_V1_space_T1w_desc_preproc_recon_wf/track_ifod2/tractography)
# tckgen [ options ]  source tracks
tckgen \
-force \
-act /fred/oz251/Mast/derivatives/LA/qsiprep/work/qsirecon_wf/sub-${subj}_mrtrix_5tt_rf/anat_ingress_wf/apply_header_to_5tt/sub-${subj}_5tt_hdrxform.nii.gz `#header applied to 5tt`\
-algorithm iFOD2 `#from qsiprep / Oren`\
-backtrack `#from qsiprep -allow tracks to be truncated and re-tracked if a poor structural termination is encountered`\
-crop_at_gmwmi `#from qsiprep`\
-cutoff 0.06 `#from Oren -set the FOD amplitude cutoff for terminating tracks`\
-maxlength 300.000000 `#from Oren`\
-minlength 5.000000 `#from Oren`\
-samples 4 `#from qsiprep`\
-nthreads 3 `#from qsiprep`\
-output_seeds /fred/oz251/Mast/derivatives/LA/mrtrix/connectome/${subj}/out_seeds.nii.gz `#from qsiprep commentline`\
-power 0.330000 `#from qsiprep`\
-max_attempts_per_seed 1000 `#from Oren`\
-seed_dynamic /fred/oz251/Mast/derivatives/LA/mrtrix/connectome/${subj}/sub-${subj}_ses-1_run-1_space-T1w_desc-preproc_dwi_wm_mtnorm.mif `#from qsiprep commentline`\
-select 10000000 `#from qsiprep`\
/fred/oz251/Mast/derivatives/LA/mrtrix/connectome/${subj}/sub-${subj}_ses-1_run-1_space-T1w_desc-preproc_dwi_wm_mtnorm.mif \
/fred/oz251/Mast/derivatives/LA/mrtrix/connectome/${subj}/${subj}_tracked.tck `#output: tracs`\
|& tee /fred/oz251/Mast/derivatives/LA/mrtrix/log/${subj}_tracked_log.txt

#RECOMENDED: Reduce the amount of streamlines (reduces overestimated long tracks compaired to shorttracks: CSD-bias)
#From QSIprep path to example commentline:(/fred/oz251/Mast/derivatives/LA/qsiprep/96/rec_mrtixworkflow6/work/qsirecon_wf/sub-096_mrtrix_multishell_msmt_hsvs/sub_096ses_V1_space_T1w_desc_preproc_recon_wf/track_ifod2/tck_sift2)  
# tcksift2 [ options ]  in_tracks in_fod out_weights
tcksift2 \
-act /fred/oz251/Mast/derivatives/LA/qsiprep/work/qsirecon_wf/sub-${subj}_mrtrix_5tt_rf/anat_ingress_wf/apply_header_to_5tt/sub-${subj}_5tt_hdrxform.nii.gz `#header applied to 5tt`\
-nthreads 3 `# maximum number of threads across all processes -qsiprep`\
-out_mu /fred/oz251/Mast/derivatives/LA/mrtrix/connectome/${subj}/sub-${subj}_ses-1_run-1_space-T1w_desc-preproc_dwi_wm_mtnorm_mu.txt `# output the final value of SIFT proportionality coefficient mu to a text file`\
/fred/oz251/Mast/derivatives/LA/mrtrix/connectome/${subj}/${subj}_tracked.tck `# path/to_input_tracks`\
/fred/oz251/Mast/derivatives/LA/mrtrix/connectome/${subj}/sub-${subj}_ses-1_run-1_space-T1w_desc-preproc_dwi_wm_mtnorm.mif `# path/to_input_mtnorm_fod`\
/fred/oz251/Mast/derivatives/LA/mrtrix/connectome/${subj}/sub-${subj}_ses-1_run-1_space-T1w_desc-preproc_dwi_wm_mtnorm_weights.csv `#output_weights `\
|& tee /fred/oz251/Mast/derivatives/LA/mrtrix/log/${subj}_sift_log.txt

#QC:modifi the file to see a subset of the tracts (from BATMAN)
#tckedit /fred/oz251/Mast/derivatives/LA/mrtrix/connectome/${subj}/${subj}_tracked.tck -number 200k /fred/oz251/Mast/derivatives/LA/mrtrix/connectome/${subj}/${subj}_smallerTracks_200k.tck
#QC: mrview
#mrview /fred/oz251/Mast/derivatives/LA/qsiprep/work/qsirecon_wf/sub-${subj}_mrtrix_5tt_rf/sub_${subj}_ses_V1_space_T1w_desc_preproc_recon_wf/msmt_csd/create_mif/sub-${subj}_ses-1_run-1_space-T1w_desc-preproc_dwi.mif -tractography.load /fred/oz251/Mast/derivatives/LA/mrtrix/connectome/${subj}/${subj}_smallerTracks_200k.tck -capture.folder /fred/oz251/Mast/derivatives/LA/mrtrix/connectome/images -capture.prefix tracked -capture.grab -exit

#Preparing a parcellation image for structural connectivity analysis
#aligne freesurfer file aparc_aseg.mgz to qsiprep images (QSIprep comment line: path:/fred/oz251/Mast/derivatives/LA/qsiprep/work/qsirecon_wf/sub-DEA077_mrtrix_5tt_rf/anat_ingress_wf/register_fs_to_qsiprep_wf/register_to_qsiprep)
mrtransform \
-strides -1,-2,3 \
-linear /fred/oz251/Mast/derivatives/LA/qsiprep/work/qsirecon_wf/sub-${subj}_mrtrix_5tt_rf/anat_ingress_wf/register_fs_to_qsiprep_wf/convert_ants_to_mrtrix_transform/transform0GenericAffine.txt \
/fred/oz251/Mast/derivatives/LA/fmriprep/sourcedata/freesurfer/sub-${subj}/mri/aparc+aseg.mgz \
/fred/oz251/Mast/derivatives/LA/fmriprep/sourcedata/freesurfer/sub-${subj}/mri/aparc+aseg.nii.gz

#Desikan-Killiany atlas (84 nodes)
labelconvert \
/fred/oz251/Mast/derivatives/LA/fmriprep/sourcedata/freesurfer/sub-${subj}/mri/aparc+aseg.nii.gz \
/fred/oz251/Arla/conversion_LA/code/LA/mrtrix/FreeSurferColorLUT.txt \
/fred/oz251/Arla/conversion_LA/code/LA/mrtrix/fs_default.txt \
/fred/oz251/Mast/derivatives/LA/mrtrix/connectome/${subj}/sub_${subj}_parcels.mif `# output`

#Creating the Connectome
#wheight.csv file is not included
tck2connectome \
-assignment_radial_search 2 `# perform a radial search from each streamline endpoint to locate the nearest node`\
-force \
-tck_weights_in /fred/oz251/Mast/derivatives/LA/mrtrix/connectome/${subj}/sub-${subj}_ses-1_run-1_space-T1w_desc-preproc_dwi_wm_mtnorm_weights.csv `#specifies a txt file containing the streamline weights`\
-out_assignment /fred/oz251/Mast/derivatives/LA/mrtrix/connectome/${subj}_assignments.txt \
/fred/oz251/Mast/derivatives/LA/mrtrix/connectome/${subj}/${subj}_tracked.tck \
/fred/oz251/Mast/derivatives/LA/mrtrix/connectome/${subj}/sub_${subj}_parcels.mif \
/fred/oz251/Mast/derivatives/LA/mrtrix/connectome/${subj}/sub_${subj}_parcels.csv \
|& tee /fred/oz251/Mast/derivatives/LA/mrtrix/log/${subj}_tck2connectome_log.txt

#QC:Connectome visualization tool
#mrview *parcels.mif -connectome.init *parcels.mif -connectome.load *parcels.csv -capture.folder /fred/oz251/Mast/derivatives/LA/mrtrix/connectome/images -capture.prefix connectome -capture.grab -exit
#mrview *parcels.mif -connectome.init *parcels.mif -connectome.load *parcels.csv 

# QC: Extract streamlines from a tractogram based on their assignment to parcellated nodes
#connectome2tck /fred/oz251/Mast/derivatives/LA/mrtrix/connectome/122/122_tracked.tck /fred/oz251/Mast/derivatives/LA/mrtrix/connectome/122_assignments.txt /fred/oz251/Mast/derivatives/LA/mrtrix/connectome/tracks_28_73.tck -nodes 28,73 -exclusive -files single
#the mvriew of this file there you delete the head image and jusl look at the stream lines

#QC: GIVES THE OUTLINE OF WHITE MATER OVERLAY ON DWI image to see if the alignment was correct
#5tt2vis -cgm 0 -sgm 0 -wm 1 -csf 0 -path 0 /fred/oz251/Mast/derivatives/LA/qsiprep/work/qsirecon_wf/sub-122_mrtrix_5tt_rf/anat_ingress_wf/apply_header_to_5tt/sub-122_5tt_hdrxform.nii.gz /fred/oz251/Mast/derivatives/LA/mrtrix/BCT/wm.nii.gz
#mrcalc wm.nii.gz 0 -gt wm_bin.nii.gz
#maskfilter wm_bin.nii.gz erode -npass 1 wm_bin_ero.nii.gz
#mrcalc wm_bin.nii.gz wm_bin_ero.nii.gz -sub wm_edge.nii.gz

#overlay DWI image of the wm_edhe.nii.gz
#mrview /fred/oz251/Mast/derivatives/LA/qsiprep/work/qsirecon_wf/sub-122_mrtrix_5tt_rf/sub_122ses_V1_space_T1w_desc_preproc_recon_wf/msmt_csd/create_mif/sub-122_ses-1_run-1_space-T1w_desc-preproc_dwi.mif 

#QC: look at the odfs -> meanofd
#sum the matrix!!!! without the diagonal of the matrix 

#get x y x for 
#for i in {1..84}; do mrcalc /fred/oz251/Arla/derivatives/LA/mrtrix/connectome/092/sub_092_parcels.mif $i -eq - -quiet | mrcenter - scanner; done