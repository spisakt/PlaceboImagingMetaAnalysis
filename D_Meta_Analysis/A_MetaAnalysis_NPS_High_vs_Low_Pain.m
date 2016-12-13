%% Meta-Analysis & Forest Plot

clear
% Add folder with Generic Inverse Variance Methods Functions first
addpath('/Users/matthiaszunhammer/Dropbox/Boulder_Essen/Analysis/A_Analysis_GIV_Functions/')
basepath='/Users/matthiaszunhammer/Dropbox/Boulder_Essen/Analysis/D_Meta_Analysis';
cd(basepath)
datapath='/Users/matthiaszunhammer/Dropbox/Boulder_Essen/Datasets';

load(fullfile(datapath,'AllData_w_NPS_MHE.mat'))

studies=unique(df.studyID);   %Get all studies in df
% !!!!! These must be in the same order as listed under "studies" !!!!
studies=studies([1,6,8,12,13,14,18]);

studyIDtexts={
            'Atlas et al. 2012: High (VAS 100%, �47.1�C) vs low (VAS 25%, 41.2�C) heat';...
            'Ellingsen et al. 2013: Painful hot (VAS 50%, �47.1�C) vs warm touch (VAS 0%, ~42.5�C)';...
            'Freeman et al. 2015: High (VAS 55%) vs low (???) heat (post placebo)';...
            'Kong et al. 2006: High (VAS ???) vs low (???) heat (post placebo)';...
            'Kong et al. 2009: High (VAS ???) vs low (???) heat (post placebo)';...
            'Ruetgen et al. 2015: High (VAS 83%, 0.74mA) vs non-painful (VAS 0%, 0.16 mA), electrical shocks'
            'Wager et al. 2004a: Stong (3.75 mA) vs mild (1.44 mA) electrical shock';...
            };
			


        % The asteriks "*" indicates that for these data-sets only rating
        % contrasts were available. Therefore standardized effect sizes (d
        % and hedges g) were imputed using the mean average within-subject
        % correlation for ratings in all other studies, which was: 0.5143
        % (obtained by running the code below with replacing all imputed r's with NaN for all withinMetastats functions, then nanmean([stats.r]))
%% Select data STUDIES

%'Atlas'
hi_pain=mean(...
        [df{(strcmp(df.studyID,'atlas')&~cellfun(@isempty,regexp(df.cond,'StimHiPain_Open_Stimulation'))),'NPScorrected'},...
        df{(strcmp(df.studyID,'atlas')&~cellfun(@isempty,regexp(df.cond,'StimHiPain_Hidden_Stimulation'))),'NPScorrected'}],...
        2);
lo_pain=mean(...
        [df{(strcmp(df.studyID,'atlas')&~cellfun(@isempty,regexp(df.cond,'StimLoPain_Open_Stimulation'))),'NPScorrected'},...
        df{(strcmp(df.studyID,'atlas')&~cellfun(@isempty,regexp(df.cond,'StimLoPain_Hidden_Stimulation'))),'NPScorrected'}],...
        2);
i=find(strcmp(studies,'atlas'));
stats(i)=withinMetastats(hi_pain,lo_pain);

%'Ellingsen Heat vs Warm'
hi_pain=mean(...
        [df{(strcmp(df.studyID,'ellingsen')&strcmp(df.cond,'Painful_touch_placebo')),'NPScorrected'},...
         df{(strcmp(df.studyID,'ellingsen')&strcmp(df.cond,'Painful_touch_control')),'NPScorrected'}],...
        2);
lo_pain=mean(...
        [df{(strcmp(df.studyID,'ellingsen')&strcmp(df.cond,'Warm_touch_placebo')),'NPScorrected'},...
         df{(strcmp(df.studyID,'ellingsen')&strcmp(df.cond,'Warm_touch_control')),'NPScorrected'}],...
        2);

i=find(strcmp(studies,'ellingsen'));
stats(i)=withinMetastats(hi_pain,lo_pain);

%'Freeman High vs Lowpain'
hi_vs_lowPain= df{(strcmp(df.studyID,'freeman')&strcmp(df.cond,'post-HighpainVsLowpain')),'NPScorrected'};
i=find(strcmp(studies,'freeman'));
stats(i)=withinMetastats(hi_vs_lowPain*-1,0);

%'Kong06 Heat vs Warm'
hi_pain=mean(...
        [df{(strcmp(df.studyID,'kong06')&strcmp(df.cond,'pain_pre_control_high_pain')),'NPScorrected'},...
         df{(strcmp(df.studyID,'kong06')&strcmp(df.cond,'pain_pre_placebo_high_pain')),'NPScorrected'},...
         df{(strcmp(df.studyID,'kong06')&strcmp(df.cond,'pain_post_control_high_pain')),'NPScorrected'},...
         df{(strcmp(df.studyID,'kong06')&strcmp(df.cond,'pain_post_placebo_high_pain')),'NPScorrected'}],...
        2);
lo_pain=mean(...
        [df{(strcmp(df.studyID,'kong06')&strcmp(df.cond,'pain_pre_control_low_pain')),'NPScorrected'},...
         df{(strcmp(df.studyID,'kong06')&strcmp(df.cond,'pain_pre_placebo_low_pain')),'NPScorrected'},...
         df{(strcmp(df.studyID,'kong06')&strcmp(df.cond,'pain_post_control_low_pain')),'NPScorrected'},...
         df{(strcmp(df.studyID,'kong06')&strcmp(df.cond,'pain_post_placebo_low_pain')),'NPScorrected'}],...
        2);

i=find(strcmp(studies,'kong06'));
stats(i)=withinMetastats(hi_pain,lo_pain);

%'Kong09 High vs Lowpain'
hiPain_vs_lowPain= df{(strcmp(df.studyID,'kong09')&strcmp(df.cond,'allHighpainVSLowPain')),'NPScorrected'};
i=find(strcmp(studies,'kong09'));
stats(i)=withinMetastats(hiPain_vs_lowPain,0);

%'R�tgen Hi vs Low shock'
hi_pain=[df{(strcmp(df.studyID,'ruetgen')&strcmp(df.cond,'Self_Pain_Control_Group')),'NPScorrected'};...
         df{(strcmp(df.studyID,'ruetgen')&strcmp(df.cond,'Self_Pain_Placebo_Group')),'NPScorrected'}];
lo_pain=[df{(strcmp(df.studyID,'ruetgen')&strcmp(df.cond,'Self_NoPain_Control_Group')),'NPScorrected'};...
         df{(strcmp(df.studyID,'ruetgen')&strcmp(df.cond,'Self_NoPain_Placebo_Group')),'NPScorrected'}];

i=find(strcmp(studies,'ruetgen'));
stats(i)=withinMetastats(hi_pain,lo_pain);

%'wager_princeton High vs Lowpain'
hi_vs_lowPain= df{(strcmp(df.studyID,'wager_princeton')&strcmp(df.cond,'intense-mild')),'NPScorrected'};
i=find(strcmp(studies,'wager_princeton'));
stats(i)=withinMetastats(hi_vs_lowPain,0);


%% Summarize all studies, weigh by SE
% Summary analysis+ Forest Plot
ForestPlotter(stats,studyIDtexts,'NPS-Response (Hedge''s g)','random');

hgexport(gcf, 'NPS_Hi_lo_pain.eps', hgexport('factorystyle'), 'Format', 'eps'); 
