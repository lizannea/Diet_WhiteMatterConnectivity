
# Change before runnign this script!!
cd /fred/oz251/Arla/derivatives/LA/mrtrix/TFNBS/DH/woc_super_5000

#without covariates
connectomestats \
-tfce_dh 0.1 \
-tfce_e 0.5 \
-tfce_h 2.5 \
-nshuffles 5000 \
-debug \
-force \
/fred/oz251/Arla/derivatives/LA/mrtrix/TFNBS/DH/Thresholded_80_biderectional_connectome/file_list.txt \
tfnbs \
/fred/oz251/Arla/derivatives/LA/mrtrix/TFNBS/DH/design_matrix/Design_without_covariates.txt \
/fred/oz251/Arla/derivatives/LA/mrtrix/TFNBS/DH/design_matrix/Contrast_without_covariates.txt \
/fred/oz251/Arla/derivatives/LA/mrtrix/TFNBS/DH/woc_super_5000/tfnbs_woc_
