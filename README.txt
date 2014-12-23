ROCKETSHIP v1.1,  2014
Last updated 12/20/2014

Copyright (c) 2014, Thomas Ng, Samuel Barnes
All rights reserved.

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

Contains program and associated files to process and analyze parametric MRI and DCE-MRI files. Developed at the Biological Imaging Center at the California Institute of Technology. 

Please see Barnes, Ng et al BMC Bioinformatics (2015) for more information.

Thomas Ng 	thomasn@caltech.edu
Samuel Barnes 	srbarnes@caltech.edu

1. Installation:
- Copy or unzip all the files form github package, keeping the directory tree intact
- There should be three directories
i) 	dce 			contains ROCKETSHIP DCE module and associated files
ii) 	parametric_scripts 	contains the ROCKETSHIP fitting module to generate T2/T2*, T1, ADC and other parametric maps
iii) 	external_programs 	contains external files, partially modified, and used under the respective BSD licenses as part of the 				ROCKETSHIP software suite.

- Files can be run in MATLAB (tested for R2014a and above). Please add all the directories and their subdirectories to the path prior to running the programs.
- dce and parametric_scripts can be run independently, but requires files from external_programs to varying extents

2. Running the program
i) dce
The DCE module is initiated by running "dce.m"

ii) parametric_scripts
The fitting module is initiated by running "fitting_gui.m"

3. Listing of files and brief descriptor

README.txt				- This file

i) dce: ROCKETSHIP DCE module  (94 files)

'ADDLUT.m'				- File parsing helper file		
'AIFbiexpcon.m'				- Fits AIF to biexponential model
'AIFbiexpfithelp.m'			- Helping file for AIF fitting
'A_make_R1maps_func.m'			- Submodule A for processing DCE-MRI files
'B_AIF_fitting_func.m'			- Submodule B for processing AIF/Reference regions
'D_fit_voxels_batch_func.m'		- Submodule D for curve fitting batch program
'D_fit_voxels_func.m'			- Submodule D for curve fitting
'FXLfit_generic.m'			- Model fitting file
'REMOVELUT.m'				- File parsing helper file 
'RUNA.fig'				- GUI for submodule A
'RUNA.m'				- GUI for submodule A
'RUNB.fig'				- GUI for submodule B
'RUNB.m'				- GUI for submodule B
'RUND.fig'				- GUI for submodule D
'RUND.m'				- GUI for submodule D
'allnumeric.m'				- File parsing helper file 
'appendLISTS.m'				- File parsing helper file 
'auc_helper.m'				- File for area-under curve calculation
'average_aifs.fig'			- GUI for submodule B: generate population AIF
'average_aifs.m'			- GUI for submodule B: generate population AIF
'cleanAB.m'				- Helper file for submodule A
'cleanR1t.m'				- Helper file for submodule A
'compare_fits.m'			- Helper file for submodule E
'compare_gui.fig'			- Helper file for submodule E
'compare_gui.m'				- Helper file for submodule E
'consistencyCHECKRUNA.m'		- Helper file for submodule A
'dce.fig'				- MAIN File for ROCKETSHIP module GUI
'dce.m'					- MAIN File for ROCKETSHIP module GUI
'dce_auto_aif.m'			- Helper file for submodule A
'dce_last_state.mat'			- Data file storing previous GUI states
'dce_preferences.txt'			- Preference file containing parameters for fitting. Edit as necessary
'disp_error.m'				- Helper file to display error messages in GUIs
'double2uint16Scale.m'			- Helper file to parse DICOM images
'findLUTPLACE.m'			- File parsing helper file 
'findRod.m'				- Helper file for submodule A
'findrootname.m'			- File parsing helper file 
'findsubjectID.m'			- File parsing helper file
'finduniqueID.m'			- File parsing helper file
'finduniqueID_B.m'			- File parsing helper file
'finduniqueID_B_helper.m'		- File parsing helper file
'finduniqueIDhelper.m'			- File parsing helper file
'finduniqueIDhelperB.m'			- File parsing helper file
'fitting_analysis.fig'			- GUI for submodule E
'fitting_analysis.m'			- GUI for submodule E
'generatefullpath.m'			- File parsing helper file
'isDICOM.m'				- File parsing helper file
'isDICOMhdr.m'				- File parsing helper file
'isNIFTI.m'				- File parsing helper file
'license.txt'				- License file
'loadIMGVOL.m'				- File parsing helper file
'longestfilename.m'			- File parsing helper file
'matchindex.m'				- File parsing helper file
'model_0.m'				- Helper file for submodule D: model fitting
'model_2cxm.m'				- Helper file for submodule D: model fitting
'model_2cxm_cfit.m'			- Helper file for submodule D: model fitting
'model_extended_tofts.m'		- Helper file for submodule D: model fitting
'model_extended_tofts_cfit.m'		- Helper file for submodule D: model fitting
'model_fxr.m'				- Helper file for submodule D: model fitting
'model_fxr_cfit.m'			- Helper file for submodule D: model fitting
'model_patlak.m'			- Helper file for submodule D: model fitting
'model_patlak_cfit.m'			- Helper file for submodule D: model fitting
'model_patlak_linear.m'			- Helper file for submodule D: model fitting
'model_patlak_linear_fit.m'		- Helper file for submodule D: model fitting
'model_tissue_uptake.m'			- Helper file for submodule D: model fitting
'model_tissue_uptake_cfit.m'		- Helper file for submodule D: model fitting
'model_tofts.m'				- Helper file for submodule D: model fitting
'model_tofts_cfit.m'			- Helper file for submodule D: model fitting
'model_vp.m'				- Helper file for submodule D: model fitting
'model_vp_cfit.m'			- Helper file for submodule D: model fitting
'myginput.m'				- Helper file for submodule D: model fitting
'natORDER.m'				- File parsing helper file: sorts lists in natural order
'natORDERhelper.m'			- File parsing helper file: sorts lists in natural order
'nested_fit_helper.m'			- Helper file for submodule D: model fitting
'niftipathfind.m'			- File parsing helper file: sorts lists in natural order
'parse_cfit.m'				- Helper file for submodule D
'parse_cfit_helper.m'			- Helper file for submodule D
'parse_preference_file.m'		- Parses preference text file as needed.
'plot_curve.m'				- Plot time activity curves
'plot_dce_curve.m'			- Plot time activity curves
'reorderLUT.m'				- File parsing helper file
'rescaleDICOM.m'			- Helper file to parse DICOM images
'run_neuroecon_job.m'			- Legacy file to enable batch job on external server
'sortIMGVOL.m'				- Image parsing helper file
'sort_parse_2Dvol.m'			- Image parsing helper file
'sort_parse_2Dvol_helper.m'		- Image parsing helper file
'sort_parse_3Dvol.m'			- Image parsing helper file
'sort_parse_3Dvol_helper.m'		- Image parsing helper file
'sort_parse_INPUTS.m'			- Image parsing helper file
'split2subsets.m'			- Image parsing helper file
'updateLUT.m'				- File parsing helper file
'update_segmentlist.m'			- File parsing helper file
'visualize_list.m'			- File parsing helper file
'visualize_list_dce.m'			- File parsing helper file
'visualize_runD.m'			- File parsing helper file

ii) parametric_scripts 
ROCKETSHIP fitting module to generate T2/T2*, T1, ADC and other parametric maps (31 files)

'calculateMap.m'			- Helper file for fitting
'calculateMap_batch.m'			- Helper file for fitting
'check_TRfit.m'				- Helper file to check TR fitting
'disp_error.m'				- Helper file to display error messages in GUI
'double2uint16Scale.m'			- Image parsing helper file 
'fitParameter.m'			- Helper file for fitting
'fitting_gui.fig'			- MAIN file for ROCKETSHIP fitting module
'fitting_gui.m'				- MAIN file for ROCKETSHIP fitting module
'fitting_script.m'			- Helper file for fitting
'generatefullpath.m'			- File parsing helper file
'instantiate_dataset.m'			- File parsing helper file
'isDICOM.m'				- File parsing helper file
'license.txt'				- License file
'load_batch.m'				- File parsing helper file
'load_image_files.m'			- File parsing helper file
'makeNewbatch.m'			- File parsing helper file
'miscellaneous_aux_files'		- Directory containing miscellaneous auxilary files, likely unnecessary, but kept for legacy purposes.
'parallelFit.m'				- Helper file for fitting
'parseDICOM.m'				- File parsing helper file
'prepareFit.m'				- Helper file for fitting
'preprocessIMGvol.m'			- Image parsing helper file
'quick_check.m'				- Check for error prior to fitting
'rescaleDICOM.m'			- Image parsing helper file
'setup_file_list.m'			- File parsing helper file
'setup_job.m'				- Helper file for fitting
'sortIMGVOL.m'				- Image parsing helper file
'update_handles.m'			- Helper file for fitting
'update_parameters.m'			- Helper file for fitting
'visualize_R2.m'			- Helper file for GUI, visualize R2 maps
'visualize_list.m'			- Image parsing helper file

iii) external_programs

Listing of various programs incoporated under BSD license as part of ROCKETSHIP. Please go to the relevant page on MATLABCentral for details for each particular app.

'DataHash'
'ProgressBar'
'ReadImageJROI'
'TimedProgressBar'
'dirr'
'ftest'
'imshow3d'
'niftitools'
'uirecall'


