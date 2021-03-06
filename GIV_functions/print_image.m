function printImage(masked_stats,maskpath,outbasename)

% Backtransform to image
maskheader=spm_vol(maskpath);
mask=logical(spm_read_vols(maskheader));
masking=mask(:);
outImg=zeros(size(mask));

% Print Pain all
outImg(masking)=masked_stats;
outpath=fullfile([outbasename,'.nii']);
outheader=maskheader;
outheader.fname=outpath;
outheader.dt=[4,0]; %data_type (see: spm_type) should be at least int16 to allow for negative values
outheader=rmfield(outheader,'pinfo'); %remove pinfo otherwise there may be scaling problems with the data
outheader.descrip='spm - algebra';
spm_write_vol(outheader,outImg);

if any(sum(masked_stats<0)) %if the picture contains positive and negative values
    % Print Pain positive effects only
    outImg(masking)=masked_stats;
    outImg(outImg<0)=0;
    outpath=fullfile([outbasename,'_pos.nii']);
    outheader=maskheader;
    outheader.fname=outpath;
    outheader.dt=[4,0]; %data_type (see: spm_type) should be at least int16 to allow for negative values
    outheader=rmfield(outheader,'pinfo'); %remove pinfo otherwise there may be scaling problems with the data
    spm_write_vol(outheader,outImg);

    % Print Pain negative effects only
    outImg(masking)=masked_stats.*-1;
    outImg(outImg<=0)=0;
    outpath=fullfile([outbasename,'_neg.nii']);
    outheader=maskheader;
    outheader.fname=outpath;
    outheader.dt=[4,0]; %data_type (see: spm_type) should be at least int16 to allow for negative values
    outheader=rmfield(outheader,'pinfo'); %remove pinfo otherwise there may be scaling problems with the data
    spm_write_vol(outheader,outImg);
end
end