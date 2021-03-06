function stats=create_meta_stats_behavior(df)
%Preallocate stats for speed
n_studies=length(df.studies);
stats(n_studies).mu=[];
stats(n_studies).sd_diff=[];
stats(n_studies).sd_pooled=[];
stats(n_studies).se_mu=[];
stats(n_studies).n=[];
stats(n_studies).r=[];
stats(n_studies).d=[];
stats(n_studies).se_d=[];
stats(n_studies).g=[];
stats(n_studies).se_g=[];
stats(n_studies).delta=[];
stats(n_studies).std_delta=[];
stats(n_studies).ICC=[];
stats(n_studies).r_external=[];
stats(n_studies).n_r_external=[];


for i=1:length(df.studies) % Calculate for all studies except...
    if df.consOnlyRating(i)==0 %...data-sets where only contrasts are available
        if df.BetweenSubject(i)==0 %Calculate within-subject studies
           stats(i)=withinMetastats(df.con_rating{i},df.pla_rating{i}); %Note: Contrast is inversed compared to brain imaging data on purpose: this way results can be interpreted as "placebo analgesia" straightforward instead of "changes in pain ratings"
        elseif df.BetweenSubject(i)==1 %Calculate between-group studies
           stats(i)=betweenMetastats(df.con_rating{i},df.pla_rating{i});  %Note: Contrast is inversed compared to brain imaging data on purpose: this way results can be interpreted as "placebo analgesia" straightforward instead of "changes in pain ratings"
        end        
    end
end
% Calculate for those (within-subject) studies where only pla>con contrasts are available
conOnly=find(df.consOnlyRating==1);
impu_r=nanmean([stats.r]); % ... impute the mean within-subject study correlation observed in all other studies
for i=conOnly'
    stats(i)=withinMetastats(df.pla_rating{i}.*-1,impu_r);  %Note: Contrast is inversed compared to brain imaging data on purpose: this way results can be interpreted as "placebo analgesia" straightforward instead of "changes in pain ratings"
end

end