function print_clusters(in_img,threshold,atlas,out_file)
%% Print and label results cluster-wise
% Wrapper for fsl's "cluster" function as implemented in
% the "autoaq" script.
%
% The function requires:
% fsl 5.0.10 and an update of permissions (chmod a+x) for
% /usr/local/fsl/bin/atlasquery
% 
% Available atlases (see: https://brainder.org/2012/07/30/automatic-atlas-queries-in-fsl/, or atlasquery --dumpatlases)
%     ?Cerebellar Atlas in MNI152 space after normalization with FLIRT?
%     ?Cerebellar Atlas in MNI152 space after normalization with FNIRT?
%     ?Harvard-Oxford Cortical Structural Atlas?
%     ?Harvard-Oxford Subcortical Structural Atlas?
%     ?JHU ICBM-DTI-81 White-Matter Labels?
%     ?JHU White-Matter Tractography Atlas?
%     ?Juelich Histological Atlas?
%     ?MNI Structural Atlas?
%     ?Oxford Thalamic Connectivity Probability Atlas?
%     ?Oxford-Imanova Striatal Connectivity Atlas 3 sub-regions?
%     ?Oxford-Imanova Striatal Connectivity Atlas 7 sub-regions?
%     ?Oxford-Imanova Striatal Structural Atlas?
%     ?Talairach Daemon Labels?


[ipath,iname,iext] = fileparts(in_img);
if ~exist(ipath,'dir')==7
    in_img=fullfile(pwd,[iname,'.',iext]); 
end

[~,oname,oext] = fileparts(out_file);
if ~exist(path,'dir')==7
    out_file=fullfile(pwd,[oname,'.',oext]); 
end

command= ['/usr/local/fsl/bin/autoaq',...
             ' -i ', in_img,...
             ' -t ', num2str(threshold),...
             ' -a "', atlas,'"'...
             ' -o ', out_file,...
             ' -p']; %Forces peak values instead of "center of mass"

% set FSL environment
setenv('FSLDIR','/usr/local/fsl');  % this to tell where FSL folder is
setenv('FSLOUTPUTTYPE', 'NIFTI_GZ'); % this to tell what the output type would be
system(command);
disp(['Cluster results printed to: ' out_file])

end