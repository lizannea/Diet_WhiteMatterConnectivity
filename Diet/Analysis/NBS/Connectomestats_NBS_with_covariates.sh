
# Change befo runnign this script!!
cd /fred/oz251/Arla/derivatives/LA/mrtrix/NBS/Thresholded_mask_80/WC

#with covariates
connectomestats \
-threshold 2.39 \
-nshuffles 5000 \
-debug \
-force \
/fred/oz251/Arla/derivatives/LA/mrtrix/TFNBS/DH/Thresholded_80_biderectional_connectome/file_list.txt \
nbs \
/fred/oz251/Arla/derivatives/LA/mrtrix/TFNBS/DH/design_matrix/DesignMatrix_with_covariates_N.txt \
/fred/oz251/Arla/derivatives/LA/mrtrix/TFNBS/DH/design_matrix/Contrast_with_covariates_N.txt \
/fred/oz251/Arla/derivatives/LA/mrtrix/NBS/Thresholded_mask_80/WC/nbs_wc_
