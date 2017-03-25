%% Meta-Analysis & Forest Plot
clear
% Add folder with Generic Inverse Variance Methods Functions first
addpath('/Users/matthiaszunhammer/Dropbox/Boulder_Essen/Analysis/A_Analysis_GIV_Functions/')
datapath='../../Datasets';

load(fullfile(datapath,'AllData.mat'))

% !!!!! These must be in the same order as listed under "studies" !!!!
studies={  'atlas'
           'ellingsen_warm'
           'ellingsen_brush'
           'freeman'
           'kessner'
           'kong06'
           'kong09'
           'ruetgen'
           'wager04a_princeton'}; % Duplicate Ellingsen
% studyIDtexts={
%             'Atlas et al. 2012: High (VAS 100%, ?47.1?C) vs low (VAS 25%, 41.2?C) heat';...
%             'Ellingsen et al. 2013: Painful hot (VAS 50%, ?47.1?C) vs warm touch (VAS 0%, ~42.5?C)';...
%             'Ellingsen et al. 2013: Painful hot (VAS 50%, ?47.1?C) vs brushstroke (VAS 0%)';...
%             'Freeman et al. 2015: High (VAS 55%) vs low (???) heat (post placebo)';...
%             'Kong et al. 2006: High (VAS ???) vs low (???) heat (post placebo)';...
%             'Kong et al. 2009: High (VAS ???) vs low (???) heat (post placebo)';...
%             'Ruetgen et al. 2015: High (VAS 83%, 0.74mA) vs non-painful (VAS 0%, 0.16 mA), electrical shocks'
%             'Wager et al. 2004, Study 1: Stong (3.75 mA) vs mild (1.44 mA) electrical shock';...
%             };
studyIDtexts={
            'Atlas et al. 2012: High vs low noxious heat';...
            'Ellingsen et al. 2013: Noxious heat vs non-noxious warm touch';...
            'Ellingsen et al. 2013: Noxious heat vs non-noxious brushstroke';...
            'Freeman et al. 2015: High vs low noxious heat';...
            'Kessner et al. 2006: High vs moderate noxious heat';...
            'Kong et al. 2006: High vs low noxious heat';...
            'Kong et al. 2009: High vs low noxious heat';...
            'Ruetgen et al. 2015: High vs mild noxious electrical shocks'
            'Wager et al. 2004, Study 1: High vs mild noxious electrical shocks';...
            };
% studyIDtexts={
%             'Atlas et al. 2012:';...
%             'Ellingsen et al. 2013: (warmth)';...
%             'Ellingsen et al. 2013: (brushstroke)';...
%             'Freeman et al. 2015:';...
%             'Kong et al. 2006:';...
%             'Kong et al. 2009:';...
%             'Ruetgen et al. 2015:'
%             'Wager et al. 2004, Study 1:';...
%             };
			
        % The asteriks "*" indicates that for these data-sets only rating
        % contrasts were available. Therefore standardized effect sizes (d
        % and hedges g) were imputed using the mean average within-subject
        % correlation for ratings in all other studies, which was: 0.5143
        % (obtained by running the code below with replacing all imputed r's with NaN for all withinMetastats functions, then nanmean([stats.r]))
%% Study-level data
varselect={'NPSraw','MHEraw','rating','stimInt'};
df_hilo.variables=varselect;
df_hilo.studies=studies;

iNPS=find(strcmp(df_hilo.variables,'NPSraw'));
iR=find(strcmp(df_hilo.variables,'rating'));

%'Atlas'
i=find(strcmp(studies,'atlas'));
df_hilo.hi{i}=mean(...
        cat(3,...
        df{(strcmp(df.studyID,'atlas')&~cellfun(@isempty,regexp(df.cond,'StimHiPain_Open_Stimulation'))),varselect},...
        df{(strcmp(df.studyID,'atlas')&~cellfun(@isempty,regexp(df.cond,'StimHiPain_Hidden_Stimulation'))),varselect}),...
        3);
df_hilo.lo{i}=mean(...
        cat(3,...
        df{(strcmp(df.studyID,'atlas')&~cellfun(@isempty,regexp(df.cond,'StimLoPain_Open_Stimulation'))),varselect},...
        df{(strcmp(df.studyID,'atlas')&~cellfun(@isempty,regexp(df.cond,'StimLoPain_Hidden_Stimulation'))),varselect}),...
        3);

stats(i).NPS=withinMetastats(df_hilo.hi{i}(:,iNPS),df_hilo.lo{i}(:,iNPS));
stats(i).rating=withinMetastats(df_hilo.hi{i}(:,iR),df_hilo.lo{i}(:,iR));

    
%'Ellingsen Heat vs Warm'
i=find(strcmp(studies,'ellingsen_warm'));
df_hilo.hi{i}=mean(...
        cat(3,...
        df{(strcmp(df.studyID,'ellingsen')&strcmp(df.cond,'Painful_touch_placebo')),varselect},...
         df{(strcmp(df.studyID,'ellingsen')&strcmp(df.cond,'Painful_touch_control')),varselect}),...
        3);
df_hilo.lo{i}=mean(...
        cat(3,...
        df{(strcmp(df.studyID,'ellingsen')&strcmp(df.cond,'Warm_touch_placebo')),varselect},...
         df{(strcmp(df.studyID,'ellingsen')&strcmp(df.cond,'Warm_touch_control')),varselect}),...
        3);
stats(i).NPS=withinMetastats(df_hilo.hi{i}(:,iNPS),df_hilo.lo{i}(:,iNPS));
stats(i).rating=withinMetastats(df_hilo.hi{i}(:,iR),df_hilo.lo{i}(:,iR));

%'Ellingsen Heat vs Brushstroke'
i=find(strcmp(studies,'ellingsen_brush'));
df_hilo.hi{i}=mean(...
        cat(3,...
        df{(strcmp(df.studyID,'ellingsen')&strcmp(df.cond,'Painful_touch_placebo')),varselect},...
         df{(strcmp(df.studyID,'ellingsen')&strcmp(df.cond,'Painful_touch_control')),varselect}),...
        3);
df_hilo.lo{i}=mean(...
        cat(3,...
        df{(strcmp(df.studyID,'ellingsen')&strcmp(df.cond,'Brushstroke_placebo')),varselect},...
         df{(strcmp(df.studyID,'ellingsen')&strcmp(df.cond,'Brushstroke_control')),varselect}),...
        3);
stats(i).NPS=withinMetastats(df_hilo.hi{i}(:,iNPS),df_hilo.lo{i}(:,iNPS));
stats(i).rating=withinMetastats(df_hilo.hi{i}(:,iR),df_hilo.lo{i}(:,iR));

%'Freeman High vs Lowpain'
i=find(strcmp(studies,'freeman'));
df_hilo.hi{i}= df{(strcmp(df.studyID,'freeman')&strcmp(df.cond,'post-HighpainVsLowpain')),varselect};
stats(i).NPS=withinMetastats(df_hilo.hi{i}(:,iNPS),0);
stats(i).rating=withinMetastats(df_hilo.hi{i}(:,iR),0);

% 'Kessner Hi (VAS 80) vs Lo (VAS 50) stimulation'
% Since Kessner et al simulated a treatment effect witnin participants,
% Hi pain stimulation coincides with control treatment and
% Lo pain stimulation coincides with placebo treatment
i=find(strcmp(studies,'kessner'));
df_hilo.hi{i}=[df{(strcmp(df.studyID,'kessner')&strcmp(df.cond,'pain_control_neg')),varselect};...
        df{(strcmp(df.studyID,'kessner')&strcmp(df.cond,'pain_control_pos')),varselect}];
df_hilo.lo{i}=[df{(strcmp(df.studyID,'kessner')&strcmp(df.cond,'pain_placebo_neg')),varselect};...
         df{(strcmp(df.studyID,'kessner')&strcmp(df.cond,'pain_placebo_pos')),varselect}];
stats(i).NPS=withinMetastats(df_hilo.hi{i}(:,iNPS),df_hilo.lo{i}(:,iNPS));
stats(i).rating=withinMetastats(df_hilo.hi{i}(:,iR),df_hilo.lo{i}(:,iR));

%'Kong06 Heat vs Warm'
i=find(strcmp(studies,'kong06'));
df_hilo.hi{i}=mean(...
        cat(3,...
        df{(strcmp(df.studyID,'kong06')&strcmp(df.cond,'pain_pre_control_high_pain')),varselect},...
         df{(strcmp(df.studyID,'kong06')&strcmp(df.cond,'pain_pre_placebo_high_pain')),varselect},...
         df{(strcmp(df.studyID,'kong06')&strcmp(df.cond,'pain_post_control_high_pain')),varselect},...
         df{(strcmp(df.studyID,'kong06')&strcmp(df.cond,'pain_post_placebo_high_pain')),varselect}),...
        3);
df_hilo.lo{i}=mean(...
        cat(3,...
        df{(strcmp(df.studyID,'kong06')&strcmp(df.cond,'pain_pre_control_low_pain')),varselect},...
         df{(strcmp(df.studyID,'kong06')&strcmp(df.cond,'pain_pre_placebo_low_pain')),varselect},...
         df{(strcmp(df.studyID,'kong06')&strcmp(df.cond,'pain_post_control_low_pain')),varselect},...
         df{(strcmp(df.studyID,'kong06')&strcmp(df.cond,'pain_post_placebo_low_pain')),varselect}),...
        3);
stats(i).NPS=withinMetastats(df_hilo.hi{i}(:,iNPS),df_hilo.lo{i}(:,iNPS));
stats(i).rating=withinMetastats(df_hilo.hi{i}(:,iR),df_hilo.lo{i}(:,iR));

%'Kong09 High vs Lowpain'
i=find(strcmp(studies,'kong09'));
df_hilo.hi{i}= df{(strcmp(df.studyID,'kong09')&strcmp(df.cond,'allHighpainVSLowPain')),varselect};
stats(i).NPS=withinMetastats(df_hilo.hi{i}(:,iNPS),0);
stats(i).rating=withinMetastats(df_hilo.hi{i}(:,iR),0);

%'R?tgen Hi vs Low shock'
i=find(strcmp(studies,'ruetgen'));
df_hilo.hi{i}=[df{(strcmp(df.studyID,'ruetgen')&strcmp(df.cond,'Self_Pain_Control_Group')),varselect};...
         df{(strcmp(df.studyID,'ruetgen')&strcmp(df.cond,'Self_Pain_Placebo_Group')),varselect}];
df_hilo.lo{i}=[df{(strcmp(df.studyID,'ruetgen')&strcmp(df.cond,'Self_NoPain_Control_Group')),varselect};...
         df{(strcmp(df.studyID,'ruetgen')&strcmp(df.cond,'Self_NoPain_Placebo_Group')),varselect}];

stats(i).NPS=withinMetastats(df_hilo.hi{i}(:,iNPS),df_hilo.lo{i}(:,iNPS));
stats(i).rating=withinMetastats(df_hilo.hi{i}(:,iR),df_hilo.lo{i}(:,iR));

%'wager_princeton High vs Lowpain'
i=find(strcmp(studies,'wager04a_princeton'));
df_hilo.hi{i}= df{(strcmp(df.studyID,'wager04a_princeton')&strcmp(df.cond,'intense-mild')),varselect};
stats(i).NPS=withinMetastats(df_hilo.hi{i}(:,iNPS),0);
stats(i).rating=withinMetastats(df_hilo.hi{i}(:,iR),0);

%% Summarize all studies, weigh by SE
% Summary analysis+ Forest Plot
statsNPS=[stats.NPS];
ForestPlotter(statsNPS,...
              'studyIDtexts',studyIDtexts,...
              'outcomelabel','NPS-Response (Hedge''s g)',...
              'type','random',...
              'summarystat','g',...
              'textoffset',0.1,...
              'withoutlier',0,...
              'WIsubdata',1,...
              'boxscaling',1);
          
hgexport(gcf, 'C1_NPS_hi_vs_lo_pain_all.svg', hgexport('factorystyle'), 'Format', 'svg'); 
hgexport(gcf, '../../Protocol_and_Manuscript/NPS_validation/Figures/Figure4', hgexport('factorystyle'), 'Format', 'svg');

NPS_pos_imgs=vertcat(statsNPS.delta)>0;
perc_pos_NPS=sum(NPS_pos_imgs)/sum(~isnan(NPS_pos_imgs));

disp([num2str(perc_pos_NPS*100),'% of participants showed a positive NPS response.'])

%% Plot Standardized NPS vs Standardized Rating response
statsRating=[stats.rating];
figure
% First plot effects of changes in stimulus intensity on NPS/ratings in red
hold on
x=[statsRating.g];
y=[statsNPS.g];
yneg=([statsNPS.se_g].*1.96);
ypos=([statsNPS.se_g].*1.96);
xneg=([statsRating.se_g].*1.96);
xpos=([statsRating.se_g].*1.96);
errorbar(x,y,yneg,ypos,xneg,xpos,'ro')
plot(x,y,'.')
lsline

%Then plot effects of placebos
PlaceboStats=load('/Users/matthiaszunhammer/Dropbox/Boulder_Essen/Analysis/E_NPS_Meta_Analysis_Placebo/Full_Sample_Study_Level_Results_Placebo.mat');
pla_studies={'atlas'
             'ellingsen'
             'freeman'
             'kessner'
             'kong06'
             'kong09'
             'ruetgen'
             'wager04a_princeton'};
ipla_studies=ismember(PlaceboStats.stats.studies,pla_studies);
statsRating_pla=[PlaceboStats.stats.rating(ipla_studies)];
statsNPS_pla=[PlaceboStats.stats.NPS(ipla_studies)];
x=abs([statsRating_pla.g]);
y=abs([statsNPS_pla.g]);
yneg=([statsNPS_pla.se_g].*1.96);
ypos=([statsNPS_pla.se_g].*1.96);
xneg=([statsRating_pla.se_g].*1.96);
xpos=([statsRating_pla.se_g].*1.96);
errorbar(x,y,yneg,ypos,xneg,xpos,'bo')
plot(x,y,'.')

% Overall results
% x_pla=0.65;
% y_pla=0.08;
% yneg_pla=0.08;
% ypos_pla=0.08;
% xneg_pla=0.13;
% xpos_pla=0.13;
%errorbar(x_pla,y_pla,yneg_pla,ypos_pla,xneg_pla,xpos_pla,'o')
hold off
ylabel('Absolute effect on NPS response (Hedges''g)')
xlabel('Absolute effect on pain ratings (Hedges''g)')