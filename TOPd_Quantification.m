clear all;
Fluorfolder='D:\20220405_TOPdgfp\60x\60x_GFP';
Maskfolder='D:\20220405_TOPdgfp\60x\60x_Nuc';
Background=[716 775 691 775 677];
Fluorlist=getFileNamesList('tif',Fluorfolder);
Masklist=getFileNamesList('tif',Maskfolder);

for i=1:length(Masklist)
   Fluor=imread(fullfile(Fluorfolder,Fluorlist{i}));
   Mask=logical(imread(fullfile(Maskfolder,Masklist{i})));
   props{i}=regionprops('table',Mask,Fluor,'MeanIntensity'); 
end
%%
% samplelist=["18hr_EC"; "18hr_Col" ;"38hr_EC"; "38hr_Col" ;"63hr_EC"; "63hr_Col"];
length_i=10;
for i=1:length_i
    index=zeros(length(Masklist),1);
    start=4*(i-1)+1;
    index(start:start+3)=1;
    index=index>0;
    Indexed_Props=props(index);
    Intensity{i}=cat(1,Indexed_Props{:});
end

%%
for i=1:length_i
   True_Intensity{i}= Intensity{i}.MeanIntensity-Background(round(i/2));
end
% %%
% 
% for i=1:2:length_i
%     figure;
%     histogram(True_Intensity{i},'BinWidth',30,'Normalization','probability');
%  hold on;
% histogram(True_Intensity{i+1},'BinWidth',30,'Normalization','probability');
% legend(samplelist{i},samplelist{i+1},'Interpreter','none');
% 
%   xlim([0 2000]);
%     title('Beta-catenin signal distribution')
% end
%%
for i=1:length_i
   MeanIntensity(i)=mean(True_Intensity{i}); 
   StdIntensity(i)=std(True_Intensity{i});
    
end
%%
save('04_05_22_Topd_60x_Result');
disp('Job is done!')