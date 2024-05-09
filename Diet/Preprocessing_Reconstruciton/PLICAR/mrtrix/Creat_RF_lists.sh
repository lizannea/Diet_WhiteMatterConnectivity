#Creat list of response functions

# list for wm RF
ls -ld /fred/oz251/Arla/derivatives/LA/qsiprep/work/qsirecon_wf/sub-***_mrtrix_5tt_rf/sub_***_ses_1_run_1_space_T1w_desc_preproc_recon_wf/msmt_csd/estimate_response/*_wm.txt | awk '{$1=$2=$3=$4=$5=$6=$7=$8=""; print $0}' > /fred/oz251/Arla/derivatives/LA/mrtrix/connectome/RF_list_wm.sh

# list for gm RF
ls -ld /fred/oz251/Arla/derivatives/LA/qsiprep/work/qsirecon_wf/sub-***_mrtrix_5tt_rf/sub_***_ses_1_run_1_space_T1w_desc_preproc_recon_wf/msmt_csd/estimate_response/*_gm.txt | awk '{$1=$2=$3=$4=$5=$6=$7=$8=""; print $0}' > /fred/oz251/Arla/derivatives/LA/mrtrix/connectome/RF_list_gm.sh

# list for csf RF
ls -ld /fred/oz251/Arla/derivatives/LA/qsiprep/work/qsirecon_wf/sub-***_mrtrix_5tt_rf/sub_***_ses_1_run_1_space_T1w_desc_preproc_recon_wf/msmt_csd/estimate_response/*_csf.txt | awk '{$1=$2=$3=$4=$5=$6=$7=$8=""; print $0}' > /fred/oz251/Arla/derivatives/LA/mrtrix/connectome/RF_list_csf.sh



##list of filenames for NBS TFNBS analysis
ls -ld /fred/oz251/Mast/derivatives/LA/mrtrix/TFNBS/DH/DASH/LOW_HIGH/100%/*.csv | awk -F/ '{print $NF}' > /fred/oz251/Mast/derivatives/LA/mrtrix/TFNBS/DH/DASH/LOW_HIGH/100%/file_list.txt
