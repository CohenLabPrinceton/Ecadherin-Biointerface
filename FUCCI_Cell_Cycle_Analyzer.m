function FUCCI_Cell_Cycle_Analyzer(inputpath,outputpath,StartFrame,EndFrame,Hourperframe,G1cutoff_frame,G2cutoff_frame,TRITC_BG,GFP_BG)
TRITC_CH_name='MEAN_INTENSITY_CH1';
GFP_CH_name='MEAN_INTENSITY_CH2';
% minThres=0.15; %Minimum normailzed signal to threshold tracks
% maxThres=10; %Maximum normailzed signal to threshold tracks
%cutoff=6; % cutoff frame value of too short G1,G2 time
ID_sort=CSV_trackreader(inputpath);
Tracklist=Trackfilter(ID_sort,StartFrame,EndFrame);
Framelength=size(Tracklist{1},1);
Tracklist_sorted=Sorting_Outlier(Tracklist,TRITC_BG,GFP_BG,TRITC_CH_name,GFP_CH_name);
Active_cycling_fraction=size(Tracklist_sorted,2)/size(Tracklist,2);
for(m=1:size(Tracklist_sorted,2))
    TRITCsignal(:,m)=Tracklist_sorted{m}{:,TRITC_CH_name};
    GFPsignal(:,m)=Tracklist_sorted{m}{:,GFP_CH_name};
end

TRITCsmooth=Normalize_Smoothe_individual(TRITCsignal);
GFPsmooth=Normalize_Smoothe_individual(GFPsignal);
%quick_signal_test(TRITCsmooth,GFPsmooth);
%% G1 G2 time calculation
[G1time,G2time]=Cellcycleduration_caculator(TRITCsmooth,GFPsmooth,G1cutoff_frame,G2cutoff_frame);
[TotalG1time,TotalG2time,meanG1time,meanG2time,stdG1time,stdG2time]=G1G2time_caculator(G1time,G2time,Hourperframe);
%% Peak detection and Rise_Fall time calculation
[GFP_RealPeakrange,GFP_RealPeakLoc,GFP_peakaligninfo]= Peak_range_detector(GFPsmooth);
[TRITC_RealPeakrange,TRITC_RealPeakLoc,TRITC_peakaligninfo]= Peak_range_detector(TRITCsmooth);
[TRITC_Risetime_fr,TRITC_Falltime_fr,TRITC_risefalltime_info]=Rise_Fall_Time(TRITCsmooth,TRITC_RealPeakrange,TRITC_peakaligninfo.Bottomvalue);
[GFP_Risetime_fr,GFP_Falltime_fr,GFP_risefalltime_info]=Rise_Fall_Time(GFPsmooth,GFP_RealPeakrange,GFP_peakaligninfo.Bottomvalue);
save(outputpath);
end