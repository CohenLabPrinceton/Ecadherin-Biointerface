clear all;
inputfolder = uigetdir(pwd,'Select your input folder');
filelist=getFileNamesList('2_to_80',inputfolder);
[~,inputfoldername,~]=fileparts(inputfolder);
for i=1:length(filelist)
    disp(['Calculating max G1 G2 intensity ',num2str(i),'/',num2str(length(filelist))])
    data=load(fullfile(inputfolder,filelist{i}));
    maxG1intensity{i}=(max(data.TRITCsignal)-data.TRITC_BG);
    maxG2intensity{i}=(max(data.GFPsignal)-data.GFP_BG); 
end
clear data;
%%
total_maxG1=[maxG1intensity{:}].';
total_maxG2=[maxG2intensity{:}].';
save(fullfile(inputfolder,[inputfoldername,'_maxintensity_individual']));
disp('Job is done!');