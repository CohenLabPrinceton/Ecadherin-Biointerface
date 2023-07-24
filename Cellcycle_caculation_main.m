clear all;
inputfolder = uigetdir(pwd,'Select your input folder');
outputfolder = uigetdir(pwd,'Select your output folder');
StartFrame=2;
EndFrame=80;
Hourperframe=1/3;
G1cutoff_frame=14;
G2cutoff_frame=14;
TRITC_BG=453;
GFP_BG=2605;
filelist=getFileNamesList('csv',inputfolder);
%%
for i=1:length(filelist)
    disp(['Calculating cell cycle duration ',num2str(i),'/',num2str(length(filelist))])
    inputpath=fullfile(inputfolder,filelist{i});
    outputpath=fullfile(outputfolder,[filelist{i}(1:end-4),'_',num2str(StartFrame),'_to_',num2str(EndFrame)]);
    FUCCI_Cell_Cycle_Analyzer(inputpath,outputpath,StartFrame,EndFrame,Hourperframe,G1cutoff_frame,G2cutoff_frame,TRITC_BG,GFP_BG);
end
disp(['Job is done!']);