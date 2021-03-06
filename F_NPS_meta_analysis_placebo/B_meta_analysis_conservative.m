function B_meta_analysis_conservative(datapath,pubpath)
%% Meta-Analysis & Forest Plot ? Full Sample (MAIN RESULTS)
% Path to add Forest Plots to:
% Add folder with Generic Inverse Variance Methods Functions
df_name='data_frame.mat';
load(fullfile(datapath,df_name));
 
        
% Labels extended version, w description for placebo / pain conditions 
% df.study_citations_conservative={
%             'Atlas et al. 2012: Hidden vs open remifentanil drip infusion (expectation period)| heat';...
% 			'Bingel et al. 2006: Control vs placebo cream | laser';...
% 			'Bingel et al. 2011: No vs positive expectations | heat';...
% 			'Choi et al. 2011: No vs low & high effective placebo drip infusion (Exp1 and 2) | electrical';...
% 			'Eippert et al. 2009: Control vs placebo cream (saline & naloxone group) | heat (early & late)';...
% 			'Ellingsen et al. 2013: Pre vs post placebo nasal spray | heat';...
%             'Elsenbruch et al. 2012: No vs certain placebo drip infusion | distension';...
%             'Freeman et al. 2015: Control vs placebo cream | heat';...
%             'Geuter et al. 2013: Control vs weak & strong placebo cream | heat (early & late)';...
%             'Kessner et al. 2014: Negative vs positive treatment expectation group | heat';...
%             'Kong et al. 2006: Control vs placebo acupuncture | heat (high & low)';...
%             'Kong et al. 2009: Control vs placebo sham acupuncture | heat';...
%             'Lui et al. 2010: Red vs green cue signifying sham TENS off vs on | laser';...
%             'Ruetgen et al. 2015: No treatment vs placebo pill group  | electrical'
%             'Schenk et al. 2015:  Control vs placebo (saline & lidocain) | heat'
%             'Theysohn et al. 2009: No vs certain placebo drip infusion | distension';...
%             'Wager et al. 2004, Study 1: Control vs placebo cream | heat*';...
%             'Wager et al. 2004, Study 2: Control vs placebo cream | electrical*';...
%             'Wrobel et al. 2014: Control vs placebo cream (saline & haldol group) | heat(early & late)'
%             'Zeidan et al. 2015: Control vs placebo cream (placebo group) | heat*';...
%             };
        
% Same as full meta-analysis, but without high risk-of-bias studies
%% One Forest plot per variable
varnames={'rating'
          'NPS'};
nicevarnames={'Pain ratings',...
              'NPS response'};
summary=[];

for i = 1:numel(varnames)
    GIV_stats=df.(['GIV_stats_',varnames{i}]);
    for j=1:size(GIV_stats,1)
        if df.excluded_conservative_sample(j)
        GIV_stats(j).mu=NaN;    
        GIV_stats(j).g=NaN;
        end
    end
    summary.(varnames{i})=forest_plotter(GIV_stats,...
                  'studyIDtexts',df.study_citations_conservative,... 
                  'outcomelabel',[nicevarnames{i},' (Hedges'' g)'],...
                  'type','random',...
                  'summarystat','g',...
                  'withoutlier',0,...
                  'WIsubdata',0,...
                  'boxscaling',1,...
                  'textoffset',0);
    hgexport(gcf, fullfile(pubpath,['B2_Meta_Conserv_',varnames{i},'.svg']), hgexport('factorystyle'), 'Format', 'svg');
    hgexport(gcf, fullfile(pubpath,['B2_Meta_Conserv_',varnames{i},'.png']), hgexport('factorystyle'), 'Format', 'png'); 
    crop(fullfile(pubpath,['B2_Meta_Conserv_',varnames{i},'.png']));
end
close all;
%% Additional forest plot for pain ratings standardized to 101pt VAS
varnames={'rating101'};
nicevarnames={'Pain ratings'};
for i = 1:numel(varnames)
    GIV_stats=df.(['GIV_stats_',varnames{i}]);
    for j=1:size(GIV_stats,1)
        if df.excluded_conservative_sample(j)
        GIV_stats(j).mu=NaN;    
        GIV_stats(j).g=NaN;
        end
    end
    summary.(varnames{i})=forest_plotter(GIV_stats,...
                  'studyIDtexts',df.study_citations_conservative,... 
                  'outcomelabel',[nicevarnames{i},' (VAS_1_0_1)'],...
                  'type','random',...
                  'summarystat','mu',...
                  'withoutlier',0,...
                  'WIsubdata',0,...
                  'boxscaling',1,...
                  'textoffset',0);
    hgexport(gcf, fullfile(pubpath,['B2_Meta_Conserv_',varnames{i},'.svg']), hgexport('factorystyle'), 'Format', 'svg'); 
    hgexport(gcf, fullfile(pubpath,['B2_Meta_Conserv_',varnames{i},'.png']), hgexport('factorystyle'), 'Format', 'png'); 
    crop(fullfile(pubpath,['B2_Meta_Conserv_',varnames{i},'.png']));
end

close all
%% Obtain Bayes Factors
disp('BAYES FACTORS RATINGS')
effect=abs(summary.rating.g.random.summary)
SEeffect=summary.rating.g.random.SEsummary
bayes_factor(effect,SEeffect,0,[0,0.5,2])

disp('BAYES FACTORS NPS')
effect=abs(summary.NPS.g.random.summary)
SEeffect=summary.NPS.g.random.SEsummary

bayes_factor(effect,SEeffect,0,[0,0.5,2]) % Bayes factor for normal (two-tailed) null prior placing 95% probability for the mean effect being between -1 and 1
bayes_factor(effect,SEeffect,0,[0,0.5,1]) % "Enthusiast" Bayes factor for normal (one-tailed) null prior placing 95% probability for the mean effect being between -1 and 0
bayes_factor(effect,SEeffect,0,[abs(summary.rating.g.random.summary),...
                               summary.rating.g.random.SEsummary,2]) % Bayes factor for normal null prior identical with overall behavioral effect
end