clear all;
Frameperhour=20;
StartFrame=2;
EndFrame=55;
ERK_CH_name='MEAN_INTENSITY_CH4';
maxmin=1;
selpath = uigetdir(pwd,'Select your working folder');
CSVname=getFileNamesList('csv',selpath);
for i=1:length(CSVname)
   disp(['Processing file: ',num2str(i),'/',num2str(length(CSVname))]);
   filename=CSVname{i};
   ID_sort=CSV_trackreader(fullfile(selpath,filename));
   Tracklist=Trackfilter(ID_sort,StartFrame,EndFrame);
   ERK_Frequency=SignalFrequencyanalyzer(Tracklist,ERK_CH_name,Frameperhour,maxmin);
   save(fullfile(selpath,filename(1:end-4))); 
end