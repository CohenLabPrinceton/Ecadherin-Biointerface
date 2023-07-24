foldername = uigetdir(pwd,'Select your working folder');
filelist=getFileNamesList('tif',foldername);

for i=1:length(filelist)
     disp(['Processing batch renaming ',num2str(i),'/',num2str(length(filelist))])
    movefile(fullfile(foldername,filelist{i}),fullfile(foldername,['part2_',filelist{i}]),'f');
end