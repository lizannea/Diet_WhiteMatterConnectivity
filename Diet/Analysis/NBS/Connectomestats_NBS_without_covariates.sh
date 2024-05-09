
# Change before runnign this script!!
cd /fred/oz251/Arla/derivatives/LA/mrtrix/NBS/Thresholded_mask_80/WOC

#without covariates
connectomestats \
-threshold 2.39 \
-nshuffles 5000 \
-debug \
-force \
/fred/oz251/Arla/derivatives/LA/mrtrix/TFNBS/DH/Thresholded_80_biderectional_connectome/file_list.txt \
nbs \
/fred/oz251/Arla/derivatives/LA/mrtrix/TFNBS/DH/design_matrix/Design_without_covariates.txt \
/fred/oz251/Arla/derivatives/LA/mrtrix/TFNBS/DH/design_matrix/Contrast_without_covariates.txt \
/fred/oz251/Arla/derivatives/LA/mrtrix/NBS/Thresholded_mask_80/WOC/tfnbs_woc_
