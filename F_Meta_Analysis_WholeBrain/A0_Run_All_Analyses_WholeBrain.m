%% Script running all analyses of the placebo-meta-analysis,
% printing out all numerical results for the paper.

%% Import required functions
cd /Users/matthiaszunhammer/Dropbox/Boulder_Essen/Analysis
% SPM required
addpath(genpath('/Users/matthiaszunhammer/Documents/MATLAB/spm12/'))
% All custom meta-analysis functions required
addpath(genpath('/Users/matthiaszunhammer/Dropbox/Boulder_Essen/'))

run('./A1_Select_All_and_Conservative.m');
run('./A2_mask_missing_voxels.m');

run('./B1_MetaAnalysis_All.m');
run('./B1_MetaAnalysis_All_Permutation_Test_Pain.m');
run('./B1_MetaAnalysis_All_Permutation_Test_Placebo.m');

run('./B1_MetaAnalysis_Conservative.m');
run('./B1_MetaAnalysis_Conservative_Permutation_Test_Pain.m');
run('./B1_MetaAnalysis_Conservative_Permutation_Test_Placebo.m');

run('./B2_create_results_images_pain.m');
run('./B2_create_results_images_placebo.m');

run('./B2_create_results_images_pain_conservative.m');
run('./B2_create_results_images_placebo_conservative.m');

run('./B2_create_results_tables_pain.m');
run('./B2_create_results_tables_placebo.m');

run('./B2_create_results_tables_pain_conservative.m');
run('./B2_create_results_tables_placebo_conservative.m');