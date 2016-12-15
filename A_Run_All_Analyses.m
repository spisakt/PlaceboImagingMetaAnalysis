%% Script running all analyses of the placebo-meta-analysis,
% printing out all numerical results for the paper.

%% Run Imports
% will create one .mat file in ./Datasets for each study. Each .mat file
% contains a df (dataframe, table) with paths to images and the respective
% behavioral/demografic/imaging data

run('./A_Import/A_Run_All_Single_Imports.m')
%% Apply all Masks (NPS, MHE, Tissue Probability-Maps, Brain-Masks)
run('./B_Apply_NPS/A_Apply_NPS_Single_Study.m')
run('./B_Apply_NPS/A_Apply_MHE_Single_Study.m')
run('./B_Apply_NPS/A_Apply_NOTBRAIN_Single_Study.m')
run('./B_Apply_NPS/A_Apply_NOTBRAIN_Single_Study.m')

%% Outlier analysis

%% NPS based meta-analysis (also MHE)

%% Whole brain analysis
