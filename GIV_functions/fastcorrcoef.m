function r=fastcorrcoef(A,B,exclude_nan)
    % Calculates pearson's correlation coefficient between two matrices A and B
    % COLUMN-WISE
    % bsxfun speeds up the procedure vastly compared to corrcoef
    % Columns containing NaN return NaN by default
    % Setting the field excluded_nan to true excludes NaNs.
    
    if ~exist('exclude_nan')
        exclude_nan=false;
    end
    
    if  any([isempty(A),isempty(B)])
       r=[] ; % If A or B is empty return empty instead of nan
    elseif exclude_nan==1|strcmp(exclude_nan,'exclude_nan') % If nans should be excluded
        An=bsxfun(@minus,A,nanmean(A,1)); %%% zero-mean
        Bn=bsxfun(@minus,B,nanmean(B,1)); %%% zero-mean
        An=bsxfun(@times,An,1./realsqrt(nansum(An.^2,1))); %% L2-normalization
        Bn=bsxfun(@times,Bn,1./realsqrt(nansum(Bn.^2,1)));
        r=nansum(An.*Bn,1);
    else             % If nan should return nans (default)
        An=bsxfun(@minus,A,mean(A,1)); %%% zero-mean
        Bn=bsxfun(@minus,B,mean(B,1)); %%% zero-mean
        An=bsxfun(@times,An,1./realsqrt(sum(An.^2,1))); %% L2-normalization
        Bn=bsxfun(@times,Bn,1./realsqrt(sum(Bn.^2,1))); %% L2-normalization
        r=sum(An.*Bn,1);
    end
    r=round(r,12); % Fixes possible round-off problems, while preserving NaN: limit r to [-1,1].

end