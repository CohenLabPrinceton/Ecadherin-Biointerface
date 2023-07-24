clear all;
selpath = uigetdir(pwd,'Select your working folder');
subfolder=Get_subfolder(selpath);
ERK_background=440; 
densitybox_size=160;
Pixel_size_micron=0.365;
for i=1: length(subfolder)
    [~,foldername,~]=fileparts(subfolder{i});
    data_output=fullfile(subfolder{i},[foldername,'_data']);
    if ~isfolder(data_output)
        mkdir(data_output);
    end
%     name=getFileNamesList('mat',data_output);
%     load(fullfile(data_output,name{1}));
    nuc_input=fullfile(subfolder{i},[foldername,'_Nuc_Mask']); %need to be removed later
    Cy5_input=fullfile(subfolder{i},[foldername,'_Cy5']);
    %  clear name;
    [density,localCount,totalCells,ERK_intensity,Mean_ERK_intensity]=density_Erk_signal_nomask(nuc_input,Cy5_input,densitybox_size,Pixel_size_micron);
    ERK_True_intensity=ERK_intensity-ERK_background;
    ERK_Activity=1./ERK_True_intensity;
    Mean_True_ERK_intensity=Mean_ERK_intensity-ERK_background;
    save(fullfile(data_output,foldername));
%% Drawing static kymograph 
%Kymograph_Static_Speed=Drawing_Static_Kymograph(size(u,3),size(u,2),speed_smooth);
%Kymograph_Static_ERK_Intensity=Drawing_Static_Kymograph(size(u,3),size(u,2),ERK_True_intensity);
%Kymograph_Static_ERK_Activity=1./Kymograph_Static_ERK_Intensity;
%Kymograph_Static_Density=Drawing_Static_Kymograph(size(u,3),size(u,2),density);

%% Drawing dynamic kymograph
%{
Distmap=Making_Distance_Map(PIV_mask_output);
%Kymograph_Dynamic_Speed=Drawing_Distmap_Kymograph(size(u,3),size(u,2),speed_smooth,Distmap);
Kymograph_Dynamic_ERK_Intensity=Drawing_Distmap_Kymograph(size(u,3),size(u,2),ERK_True_intensity,Distmap);
Kymograph_Dynamic_ERK_Activity=1./Kymograph_Dynamic_ERK_Intensity;
%Kymograph_Dynamic_Density=Drawing_Distmap_Kymograph(size(u,3),size(u,2),density,Distmap);
%}
%%
%{
Heatmap_Movie(speed_smooth,[1 size(speed_smooth,3)],data_output,...
    'Speed Heatmap High Resolution','Sample 1 speed heat map','default',[0 50],PIV_Pass1_size/4*Pixel_size_micron);
%}
%{
Heatmap_Movie(ERK_Activity,[1 size(speed_smooth,3)],data_output,...
    'ERK Activity Heatmap High Resolution','Sample 1 ERK activity heat map','default',[0 13/1000],densitybox_size/2*Pixel_size_micron);
Heatmap_Movie(density,[1 size(speed_smooth,3)],data_output,...
    'Density Heatmap High Resolution','Sample 1 density heat map','default',[0 4000],densitybox_size/2*Pixel_size_micron);


%%

kymograph_Plot(Kymograph_Static_Speed,[1 size(speed_smooth,3)],data_output,...
    'Speed Kymograph','Sample 1 speed kymograph','Distance(um)','Time(h)','default',[0 50],PIV_Pass1_size/4*Pixel_size_micron,1/frames_per_hour);

kymograph_Plot(Kymograph_Static_ERK_Activity,[1 size(speed_smooth,3)],data_output,...
    'ERK Activity Kymograph 1over100','Sample 1 ERK Activity kymograph','Distance(um)','Time(h)','default',[2/1000 10/1000],densitybox_size/2*Pixel_size_micron,1/frames_per_hour);

kymograph_Plot(Kymograph_Static_Density,[1 size(speed_smooth,3)],data_output,...
    'Density Kymograph','Sample 1 Density kymograph','Distance(um)','Time(h)','default',[0 4000],densitybox_size/2*Pixel_size_micron,1/frames_per_hour);
%}
%%
%[Moving_distance,Edge_velocity]=mask_velocity_calculation(mask_output,frames_per_hour,Pixel_size_micron,20);
%save(fullfile(data_output,[foldername,'_data']));
end

