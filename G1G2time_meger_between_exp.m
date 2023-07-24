clear all;
inputfolder = uigetdir(pwd,'Select your input folder');
filelist=getFileNamesList('mat',inputfolder);
for i=1:length(filelist)
    disp(['Calculating total G1 G2 time ',num2str(i),'/',num2str(length(filelist))])
    data=load(fullfile(inputfolder,filelist{i}));
    Total_Col_G1time{i}=[data.Collagen_G1time];
    Total_Col_G2time{i}=[data.Collagen_G2time];
    Total_Ecad_G1time{i}=[data.Ecad_G1time];
    Total_Ecad_G2time{i}=[data.Ecad_G2time];
end
%%
concat_Total_Col_G1time=cat(2,Total_Col_G1time{:});
concat_Total_Col_G2time=cat(2,Total_Col_G2time{:});
concat_Total_Ecad_G1time=cat(2,Total_Ecad_G1time{:});
concat_Total_Ecad_G2time=cat(2,Total_Ecad_G2time{:});
%%
Total_Mean_Col_G1=mean(concat_Total_Col_G1time);
Total_Std_Col_G1=std(concat_Total_Col_G1time);
Total_Mean_Col_G2=mean(concat_Total_Col_G2time);
Total_Std_Col_G2=std(concat_Total_Col_G2time);

Total_Mean_Ecad_G1=mean(concat_Total_Ecad_G1time);
Total_Std_Ecad_G1=std(concat_Total_Ecad_G1time);
Total_Mean_Ecad_G2=mean(concat_Total_Ecad_G2time);
Total_Std_Ecad_G2=std(concat_Total_Ecad_G2time);

TP_concat_Col_G1time=concat_Total_Col_G1time.';
TP_concat_Col_G2time=concat_Total_Col_G2time.';
TP_concat_Ecad_G1time=concat_Total_Ecad_G1time.';
TP_concat_Ecad_G2time=concat_Total_Ecad_G2time.';