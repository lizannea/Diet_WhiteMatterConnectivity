#include \ at the end of Response Function file
cd /fred/oz251/Arla/derivatives/LA/mrtrix/connectome

#include a \ at the end of the line - wm
sed -i 's/$/ \\/' RF_list_wm.sh

#include a \ at the end of the line - gm
sed -i 's/$/ \\/' RF_list_gm.sh

#include a \ at the end of the line - csf
sed -i 's/$/ \\/' RF_list_csf.sh