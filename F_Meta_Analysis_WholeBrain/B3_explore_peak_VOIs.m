% Explore peak activations with Forrest Plots
 addpath('~/Documents/MATLAB/crop')
%% Create results tables
clear
load('B1_Full_Sample_Summary_Pain.mat')
load('B1_Full_Sample_Summary_Placebo.mat')

studyIDtexts={ % !!!!! These must be in the same order as listed under "studies" !!!!
            'Atlas et al. 2012:';...
			'Bingel et al. 2006:';...
			'Bingel et al. 2011:';...
			'Choi et al. 2011:';...
			'Eippert et al. 2009:';...
			'Ellingsen et al. 2013:';...
            'Elsenbruch et al. 2012:';...
            'Freeman et al. 2015:';...
            'Geuter et al. 2013:';...
            'Kessner et al. 2014:';...
            'Kong et al. 2006:';...
            'Kong et al. 2009:';...
            'Lui et al. 2010:';...
            'Ruetgen et al. 2015:'
            'Schenk et al. 2015:'
            'Theysohn et al. 2009:';...
            'Wager et al. 2004, Study 1:';...
            'Wager et al. 2004, Study 2:';...
            'Wrobel et al. 2014:'
            'Zeidan et al. 2015:';...
            };

%% Explore VOI PAIN
% Best peak around left hippocampus

maskpath='./nii_results/Full_Sample_10_percent_mask.nii';
% VOIs of interest

MNI_pla_g={[36,8,0],... %51616
           [-40,-64,-24],...
           [12,-8,68],...
           [-44,-62,-26],...
           [-2,-36,6],...
           [-6,-32,12]}; %

for i=1:length(MNI_pla_g)
    [~,~,masked_i]=mni2mat(MNI_pla_g{i},maskpath);
    VOI_stats=stat_reduce(placebo_stats,masked_i);
    VOI_summary=ForestPlotter(VOI_stats,...
                      'studyIDtexts',studyIDtexts,...
                      'outcomelabel',sprintf('Hedges'' g at MNI [%d, %d, %d]',MNI_pla_g{i}),...
                      'type','random',...
                      'summarystat','g',...
                      'withoutlier',0,...
                      'WIsubdata',0,...
                      'boxscaling',1,...
                      'textoffset',0);
                  
  hgexport(gcf, sprintf('./figure_results/VOI_Full_pla_g_%d_%d_%d.svg',MNI_pla_g{i}), hgexport('factorystyle'), 'Format', 'svg'); 
  hgexport(gcf, sprintf('./figure_results/VOI_Full_pla_g_%d_%d_%d.png',MNI_pla_g{i}), hgexport('factorystyle'), 'Format', 'png'); 
  %crop(sprintf('./figure_results/VOI_Full_pla_g_%d_%d_%d.svg',MNI_pla_g{i}));
  crop(sprintf('./figure_results/VOI_Full_pla_g_%d_%d_%d.png',MNI_pla_g{i}));
end