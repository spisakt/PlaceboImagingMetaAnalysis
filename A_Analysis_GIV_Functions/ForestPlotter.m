function ForestPlotter(MetaStats,studyIDtexts,outcomelabel,type,varargin)

%% Creates summary statistic and Forest Plot
%Inputs
%MetaStats: struct containing a within or between subject summary stat for each of the i studies.
%studyIDtexts: vector with i study labels.
%outcomelabel: string lableing the x-axis.
%Type: String indicating whether 'fixed' or 'random' analysis is desired.

%% Summarize all studies, weigh by n
% Summarize standardized means by using the generic inverse-variance method

if strcmp(varargin(1),'mu')
    summary_stat=[MetaStats.mu]';% Currently uses Hedge's g
    se_summary_stat=[MetaStats.se_mu]'; % Currently uses Hedge's g
    n=[MetaStats.n]';
elseif strcmp(varargin(1),'d')
    summary_stat=[MetaStats.d]';% Currently uses Hedge's g
    se_summary_stat=[MetaStats.se_d]'; % Currently uses Hedge's g
    n=[MetaStats.n]';
else
    summary_stat=[MetaStats.g]';% Currently uses Hedge's g
    se_summary_stat=[MetaStats.se_g]'; % Currently uses Hedge's g
    n=[MetaStats.n]';
end

[summary_total,se_summary_total,rel_weight,z,p,CI_lo,CI_hi,chisq,tausq,df,p_het,Isq]=GIVsummary(summary_stat,se_summary_stat,type);
ci=se_summary_stat.*1.96;
 %% Forest Plot for Standardized Effect Sizes:
%FIGURE WINDOW
h_px=3000;
fig=figure('Name','Forest Plot',...
        'Position', [0, 0, h_px*2, h_px/sqrt(2)]);% Position: left bottom width heigth;
hold on

%TEXT POSITION AND SIZE
font_size=16;
font_name='Arial';

%SIZE OF GRAPH AREA VS TEXT
x_graphW=0.5; %relative size of x-axis in normalized space (rel to the whole graph)
    
%AXIS SCALE
x_axis_size=max([double(ceil(max(abs(summary_stat)+ci))),3]); %x-Axis limit should be the smallest integer larger than the largest absolute stat+ci, but at least 3
y_axis_size=(length(studyIDtexts)+2);
ax=gca;
set(ax,'box','off',...
 'OuterPosition',[+0.4 0 x_graphW-0.1 1],...% Set outer figure borders to accomodate more text, Default: [left bottom width height], [0 0 1 1], in normalized units
 'Ylim',[0 y_axis_size],...
 'YTick',[],...
 'YTickLabel',[],...%
 'YColor','none',...
 'Xlim', [-x_axis_size x_axis_size],...
 'color','none',...
 'FontSize',font_size*0.90,...
 'FontName',font_name)
 xlabel([outcomelabel,' � 95% CI; IV, random']);
 yscale=diff(get(ax,'Ylim'));
 xscale=diff(get(ax,'Xlim'));
 xy_rel=(xscale+1)/(yscale+1); %get relative size of axis in axis space, adding one to each, since we are counting the steps on the scale, not the difference of maxima!

% LINE APPEARANCE
 line_width=1;
 % Plot y-Axis
 line([0 0],[0 y_axis_size],'LineWidth',line_width/2, 'Color',[0 0 0]);

% SINGLE SUBJECT DOT APPEARANCE
 dot_size=8;
 dot_color=[.5 .5 .5];
 
%STUDY BOXES
%Sizing of all boxes shold represent study weight
box_scaling=0.5;   % basic unit is y (height of a study-line)
studyIDweight=rel_weight; % get study weights from summary
 
% STUDY LABELS AND N'S
txt_position_study=(-x_axis_size)-x_axis_size*2.5; %In x-axis units, since MATLAB does not easily allow mixing figure-coordinates and axis coordinates
txt_position_n=x_axis_size+x_axis_size*0.85;
txt_position_eff=txt_position_n-0.5*x_axis_size;
txt_position_weight=txt_position_n+0.5*x_axis_size;

%axpos=get(gca,'Position'); %[left bottom width height]
%y_entries=linspace(axpos(2),(axpos(2)+axpos(4)),length(studyIDtexts)+2);

% Sort effects by...
% Alphabetic author name, just as in tables
[~,ids] = sort(studyIDtexts);
ids=fliplr(ids')';
% Effect size
%[~,ids] = sort(d);

% PLOT EFFECTS
for i=1:length(ids)
    % Get current study data
    ii=ids(i); % Select current studyID
    y=i+1;       % Arrange current studyID on y as sorted
    x=summary_stat(ii);  % Get current x yalue
    
    if ~isnan(x) % No plotting of stats for NaN Studies
        xsdleft=x-ci(ii);  % Set current x-error
        xsdright=x+ci(ii); % Set current x-error

        % Plot points representing standardized single-subject results
        ss_delta=MetaStats(ii).std_delta;
        if ~isempty(ss_delta)
            plot(ss_delta,... % X
                 random('unif',-.1,.1,length(ss_delta),1)+y,... %Y
                '.',...
                'MarkerSize',dot_size,...
                'Color',dot_color)
            % Additionally plot all outliers exceeding the axis
            n_out_lo=sum(ss_delta<(-x_axis_size));
            if n_out_lo>0
                   plot(-x_axis_size,...
                        y,...
                        '<',...
                        'MarkerSize',dot_size,...
                        'MarkerEdgeColor',dot_color,...
                        'MarkerFaceColor',dot_color)
                    text(-x_axis_size+0.02*x_axis_size, y, num2str(n_out_lo),...
                         'HorizontalAlignment','left',...
                         'VerticalAlignment','bottom',...
                         'FontSize',font_size*0.80,...
                         'FontName',font_name,...
                         'Interpreter','none');
            end
            n_out_hi=sum(ss_delta>x_axis_size);
            if n_out_hi>0
                   plot(x_axis_size,...
                        y,...
                        '>',...
                        'MarkerSize',dot_size,...
                        'MarkerEdgeColor',dot_color,...
                        'MarkerFaceColor',dot_color)
                    text(x_axis_size-0.02*x_axis_size, y, num2str(n_out_hi),...
                         'HorizontalAlignment','right',...
                         'VerticalAlignment','bottom',...
                         'FontSize',font_size*0.80,...
                         'FontName',font_name,...
                         'Interpreter','none'); 
            end
        end
        
        
        
        % Plot lines representing error-bars
        line([xsdleft xsdright],[y y],'LineWidth',line_width)

        % Create box symbolizing effect and study weights
        h_box=sqrt(studyIDweight(ii))*box_scaling;  %height of box is 1 unit of y (height of one full study row) times square root of weigth (to make area of box proportional to weight) times box_scaling (to flexibly make boxes larger and smaller)                                   
        w_box=sqrt(studyIDweight(ii))*xy_rel*box_scaling;  %same as with, but relative proportion of x to y has to be scaled
        %h_box=sqrt(studyIDweight(ii)*x_graphW)*xy_rel*box_scaling;    %same as with, but has to account for relative differences of y vs x axis scaling
        x_box=x-w_box/2; % Center box
        y_box=y-h_box/2; % Center box

        % Plot boxes symbolizing mean + sample weight
        rectangle('Position',[x_box y_box w_box h_box],'FaceColor',[0 0 0]); % Format: links, unten, w, h

    
        % Txt effect 
        formatSpec='%0.2f [%0.2f; %0.2f]';
        text(txt_position_eff, y, sprintf(formatSpec,x,xsdleft,xsdright),...
             'HorizontalAlignment','center',...
             'VerticalAlignment','middle',...
             'FontSize',font_size*0.90,...
             'FontName',font_name,...
             'Interpreter','none');
        % Txt n  
        text(txt_position_n, y, num2str(n(ii)),...
             'HorizontalAlignment','center',...
             'VerticalAlignment','middle',...
             'FontSize',font_size*0.90,...
             'FontName',font_name,...
             'Interpreter','none');
        % Txt weight
        formatSpec='%0.1f%%';
        text(txt_position_weight, y, sprintf(formatSpec,rel_weight(ii)*100),...
             'HorizontalAlignment','center',...
             'VerticalAlignment','middle',...
             'FontSize',font_size*0.90,...
             'FontName',font_name,...
             'Interpreter','none');
    end
        % Plot Study-Description, also for NaN studies
        text(txt_position_study, y, studyIDtexts(ii),...
             'HorizontalAlignment','left',...
             'VerticalAlignment','middle',...
             'FontSize',font_size*0.90,...
             'FontName',font_name,...
             'Interpreter','none');
end

% Plot Summary Results as rhombus:
rhoheight=1*box_scaling;

% left  upper  right lower 
x=[CI_lo summary_total CI_hi summary_total];
y=[1 1+rhoheight/2 1 1-rhoheight/2];
fill(x,y,[0.9 0.9 0.9])

ytitle=yscale+1; % Studies+1

 % Txt Study Title
    text(txt_position_study, ytitle, 'Study',...
         'HorizontalAlignment','left',...
         'VerticalAlignment','middle',...
         'FontSize',font_size,...
         'FontName',font_name,...
         'Interpreter','none');
  % Txt y-Axis Title
    text(0, yscale+0.025*yscale, 'reduction < > increase',...
         'HorizontalAlignment','center',...
         'VerticalAlignment','middle',...
         'FontSize',font_size*0.90,...
         'FontName',font_name,...
         'Interpreter','none');    
  % Txt effect Title
    text(txt_position_eff, ytitle, 'Effect, 95% CI',...
         'HorizontalAlignment','center',...
         'VerticalAlignment','middle',...
         'FontSize',font_size,...
         'FontName',font_name,...
         'Interpreter','none');
  % Txt n Title
    text(txt_position_n, ytitle, 'n',...
         'HorizontalAlignment','center',...
         'VerticalAlignment','middle',...
         'FontSize',font_size,...
         'FontName',font_name,...
         'Interpreter','none');
  % Txt n Title
    text(txt_position_weight, ytitle, 'weight',...
         'HorizontalAlignment','center',...
         'VerticalAlignment','middle',...
         'FontSize',font_size,...
         'FontName',font_name,...
         'Interpreter','none');     
     
%   Txt study Summary
    if p>=0.001
        formatSpec='Total effect (95%% CI): z=%0.2f, p=%0.3f';
        elseif p<0.001
        formatSpec='Total effect (95%% CI): z=%0.2f, p<.%0.0f01'; 
    end
    text(txt_position_study, 1, sprintf(formatSpec,z,p),...
         'HorizontalAlignment','left',...
         'VerticalAlignment','middle',...
         'FontSize',font_size*0.90,...
         'FontWeight','bold',...
         'FontName',font_name,...
         'Interpreter','none');
%   Txt study Summary 2 (Heterogeneity)
    if p_het>=0.001
        formatSpec='Heterogeneity: Chi^2(%d)=%0.2f, p=%0.3f ; Tau^2=%0.2f, I^2=%0.2f%%';
        elseif p_het<0.001
        formatSpec='Heterogeneity: Chi^2(%d)=%0.2f, p<.%0.0f01 ; Tau^2=%0.2f, I^2=%0.2f%%';
    end
    text(txt_position_study, 0, sprintf(formatSpec,df,chisq,p_het,tausq,Isq),...
         'HorizontalAlignment','left',...
         'VerticalAlignment','middle',...
         'FontSize',font_size*0.90,...
         'FontName',font_name);
%   Txt effect Summary
    formatSpec='%0.2f [%0.2f; %0.2f]';
    text(txt_position_eff, 1, sprintf(formatSpec,summary_total,CI_lo,CI_hi),...
         'HorizontalAlignment','center',...
         'VerticalAlignment','middle',...
         'FontSize',font_size*0.90,...
         'FontWeight','bold',...
         'FontName',font_name,...
         'Interpreter','none');
%   Txt n Summary
    text(txt_position_n, 1, num2str(nansum(n)),...
         'HorizontalAlignment','center',...
         'VerticalAlignment','middle',...
         'FontSize',font_size*0.90,...
         'FontWeight','bold',...
         'FontName',font_name,...
         'Interpreter','none');
%   Txt weight Summary
    formatSpec='%0.1f%%';
    text(txt_position_weight, 1, sprintf(formatSpec,nansum(rel_weight)*100),...
         'HorizontalAlignment','center',...
         'VerticalAlignment','middle',...
         'FontSize',font_size*0.90,...
         'FontWeight','bold',...
         'FontName',font_name,...
         'Interpreter','none'); 
hold off
