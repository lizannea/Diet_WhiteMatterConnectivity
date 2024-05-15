**README: Connectome Analysis with QSIPrep and MRtrix3**

**Overview**
This repository contains scripts and tools to create connectomes using QSIPrep (v0.16.1), Fmriprep and MRtrix3 (v3.0.3_20210917) operated from the Neurodesk platform. Additonally, it contains scripts to calculate graph theory measures such as global efficiency, local efficiency, modularity, assortativity, and more calculated through MATLAB and it includes methods to assess connectivity differences through Network-Based Statistic (NBS) and Threshold-Free Network-Based Statistic (TFNBS).

**Prerequisites**
Before running the scripts, organize your data according to the Brain Imaging Data Structure (BIDS) format. This project analyzes data from two clinical trials, therefore specific scripts are provided for each trial dataset (PLICAR and Diabetes).

**Directory Structure and Scripts
Preprocessing and Reconstruction (PLICAR)**
1.	QSIPrep Preprocessing:
-	bash_prepro_submitjobs.sh: Loops through all subjects to send off QSIPrep preprocessing jobs.
-	QSIPrep_sbatch_prepro_script.sh: Runs the preprocessing script within the QSIPrep container.
-	Eddy_params.json: Parameter file for the QSIPrep preprocessing script.
2.	fMRIPrep Script:
-	fmriprep_submitjobs.sh: Loops through all subjects to send off fMRIPrep jobs.
-	fmriprep_sbatch_anat.sh: Runs anatomy-only fMRIPrep script. Output is used in the QSIPrep reconstruction pathway.
3.	QSIPrep Reconstruction:
-	mrtrix_5tt_rf.json: Needed for the first part of the QSIPrep reconstruction ("mrtrix_5tt_hsvs"). 
o	This was done due to the need to calculate the mean response function outside of the QSIPrep container. The rest of the workflow ran through MRtrix3 (also using a containerised solution)
-	bash_recon_submitjobs.sh: Loops through all subjects to send off QSIPrep reconstruction jobs.
-	QSIPrep_sbatch_recon_script.sh: Runs the QSIPrep reconstruction script within the QSIPrep container.
4.	MRtrix Scripts:
-	Within mrtrix/ run the followin:
o	Creat_RF_list.sh: Creates a list of all the respons funtions generated through the QSIPrep reconstruction workflow.
o	clean_RF_list.sh: cleans the list
o	Calucalte_meanRF.sh: this script calculates the mean response function for white matter, grey matter, and cerebrospinal fluid
o	bash_submitjobs.sh: Loops through all subjects to send off to run the MRtrix job.
o	mrtrix_bash_connectome_fechandrun.sh: runs the container 
o	mrtrix_sbatch_script_connectome.sh: Runs all the Mrtrix script, which includes dwi2fod msmt_csd, mtnormalise, tckgen, tcksift2, mrtransform, labelconvert, tck2connectome.
- FreeSurferColorLUT.txt and fs_default.txt: these text files are needed for the Desikan-Killiany atlas within the labelconvert command.
- This script closely models the QSIPrep containers reconstruction workflow, incorporating minor modifications in the tckgen command sourced from Civier et al (2019)

**Connectome Analysis**
1.	Graph Theory Measures (GTM):
-	GTM/ directiory inclues the following scipts that were calculated using the Brain Connectivity Toolbox
•	Scripts to calculate global efficiency, average local efficiency, modularity, and assortativity
	Global_efficiency.m
	Local_efficiency.m
	Modularity
	Assortativity.m
•	Scripts to calculate clustering coefficient, characteristic path length, normalized clustering coefficient, normalized characteristic path length, small-worldness, and vulnerability were calcualated using using the methods established by Yeh et al. (2016). To calculate these metrics for all each generated connectiom following Matlab script will utilise the scripts in: GTM/Script_Zhang
	CC_Zhang.m
	Zhang_path_lenght.m
	Zhang_Random_path_lenght.m
	Zhang_SmallWorldness_gamma_lambda.m
	Zhang_vulnerablity.m
•	Connectome_conversions provide the scripts to convert connectomes to the needed connectomes:
	Distance_wei_create_connectome.m
	Lengths_creat_connectome_converions.m
	Random_Distance_wei_create_connectome.m
	Random_wei_normalised
	Weight_norm_connectome_beforeCC.m
2.	Network-Based Statistics (NBS)
-	Example scripts and files for running NBS analyses, including design matrices and contrast files.
-	Connectomestats_NBS_without_covariates.sh: Runs NBS analysis without covariates with specified density masks and thresholds (density mask:80% and on three t-thresholds: 2.39with 5000 permutations).
-	Connectomestats_NBS_with_covariates.sh: Runs NBS analysis wit covariates with specified density masks and thresholds (density mask:80% and on three t-thresholds: 2.39with 5000 permutations).
3.	Threshold-Free NBS (TFNBS):
-	Includes example scripts and files for running TFNBS analyses, including design matrices and contrast files.
- 	Connectomestats_without_covariates.sh: Runs TFNBS analysis with 5000 permutations and specified parameters.


  
Usage
Follow the directory-specific instructions to run preprocessing, reconstruction, and analysis scripts. Ensure all prerequisite software and data structures are correctly set up before beginning processing.
