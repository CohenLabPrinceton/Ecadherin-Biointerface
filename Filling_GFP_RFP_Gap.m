function Filling_GFP_RFP_Gap(subfolder)

[~,foldername,~]=fileparts(subfolder);
GFP_input=fullfile(subfolder,[foldername,'_GFP']);
TRITC_input=fullfile(subfolder,[foldername,'_TRITC']);

GFP_output=fullfile(subfolder,[foldername,'_GFP_Filled']);
TRITC_output=fullfile(subfolder,[foldername,'_TRITC_Filled']);

if ~isfolder(GFP_output);
    mkdir (GFP_output);
end
if ~isfolder(TRITC_output);
    mkdir (TRITC_output);
end

GFP_files=getFileNamesList('tif',GFP_input);
TRITC_files=getFileNamesList('tif',TRITC_input);

for i=1:size(GFP_files)
   t=rem(i,7);
   if t==1
       GFP_img=imread(fullfile(GFP_input,GFP_files{i}));
       TRITC_img=imread(fullfile(TRITC_input,TRITC_files{i}));
   end
   imwrite(GFP_img,fullfile(GFP_output,['t',num2str(i,'%3d'),foldername,'_GFP.tif']),'Compression','none','Writemode','overwrite');
   imwrite(TRITC_img,fullfile(TRITC_output,['t',num2str(i,'%3d'),foldername,'_TRITC.tif']),'Compression','none','Writemode','overwrite');   
end

end