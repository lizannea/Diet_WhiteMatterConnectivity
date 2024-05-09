
# Change befo runnign this script!!
cd /fred/oz251/Arla/derivatives/LA/mrtrix/TFNBS/DH/wc_super_5000

#with covariates
connectomestats \
-tfce_dh 0.1 \
-tfce_e 0.5 \
-tfce_h 2.5 \
-nshuffles 5000 \
-debug \
-force \
/fred/oz251/Arla/derivatives/LA/mrtrix/TFNBS/DH/Thresholded_80_biderectional_connectome/file_list.txt \
tfnbs \
/fred/oz251/Arla/derivatives/LA/mrtrix/TFNBS/DH/design_matrix/DesignMatrix_with_covariates_N.txt \
/fred/oz251/Arla/derivatives/LA/mrtrix/TFNBS/DH/design_matrix/Contrast_with_covariates_N.txt \
/fred/oz251/Arla/derivatives/LA/mrtrix/TFNBS/DH/wc_super_5000/tfnbs_wc_
