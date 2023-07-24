clear all;
inputfolder = uigetdir(pwd,'Select your input folder');
filelist=getFileNamesList('mat',inputfolder);
[~,inputfoldername,~]=fileparts(inputfolder);
for i=1:length(filelist)
    disp(['Calculating total G1 G2 time ',num2str(i),'/',num2str(length(filelist))])
    data=load(fullfile(inputfolder,filelist{i}));
    TotalG1time{i}=[data.G1time{:}]*data.Hourperframe;
    TotalG2time{i}=[data.G2time{:}]*data.Hourperframe;
    Total_G1_Aligned_signal{i}=Getting_mean_peak_graph(data.TRITCsmooth,data.TRITC_RealPeakrange,data.TRITC_RealPeakLoc);
    Total_G2_Aligned_signal{i}=Getting_mean_peak_graph(data.GFPsmooth,data.GFP_RealPeakrange,data.GFP_RealPeakLoc);
    Total_G1_Risetime{i}=data.TRITC_Risetime_fr*data.Hourperframe;
    Total_G1_Falltime{i}=data.TRITC_Falltime_fr*data.Hourperframe;
    Total_G2_Risetime{i}=data.GFP_Risetime_fr*data.Hourperframe;
    Total_G2_Falltime{i}=data.GFP_Falltime_fr*data.Hourperframe;    
end
clear data;
%%
concat_G1time=cat(2,TotalG1time{:}).';
concat_G2time=cat(2,TotalG2time{:}).';
concat_G1_Aligned_signal=cat(1,Total_G1_Aligned_signal{:});
concat_G2_Aligned_signal=cat(1,Total_G2_Aligned_signal{:});
concat_G1_Risetime=cat(2,Total_G1_Risetime{:}).';
concat_G1_Falltime=cat(2,Total_G1_Falltime{:}).';
concat_G2_Risetime=cat(2,Total_G2_Risetime{:}).';
concat_G2_Falltime=cat(2,Total_G2_Falltime{:}).';
%%
Mean_G1time=mean(concat_G1time);
Std_G1time=std(concat_G1time);
Mean_G2time=mean(concat_G2time);
Std_G2time=std(concat_G2time);

Mean_G1_Aligned_signal=mean(concat_G1_Aligned_signal);
Std_G1_Aligned_signal=std(concat_G1_Aligned_signal);
Mean_G2_Aligned_signal=mean(concat_G2_Aligned_signal);
Std_G2_Aligned_signal=std(concat_G2_Aligned_signal);

Mean_G1_Risetime=mean(concat_G1_Risetime);
Std_G1_Risetime=std(concat_G1_Risetime);
Mean_G1_Falltime=mean(concat_G1_Falltime);
Std_G1_Falltime=std(concat_G1_Falltime);
Mean_G2_Risetime=mean(concat_G2_Risetime);
Std_G2_Risetime=std(concat_G2_Risetime);
Mean_G2_Falltime=mean(concat_G2_Falltime);
Std_G2_Falltime=std(concat_G2_Falltime);

save(fullfile(inputfolder,[inputfoldername,'_merged']));
disp('Job is done!');