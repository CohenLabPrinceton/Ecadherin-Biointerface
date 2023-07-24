DIC_input='F:\20220204_FUCCI20x_Wnt\DICstack';
data_output='F:\20220204_FUCCI20x_Wnt\PIV';
Pixel_size_micron=0.325;
PIV_Pass1_size=320;
densitybox_size=160;
frames_per_hour=3;
PIV_smoothing_frame=3;
DICFilenames = getFileNamesList('tif',DIC_input);
[u,v]=Running_PIV_stack(DIC_input,Pixel_size_micron,frames_per_hour,PIV_Pass1_size);
for i=1:length(DICFilenames)
   for j=1:size(u{i},3)
       velocityfield=sqrt(u{i}(:,:,j).^2+v{i}(:,:,j).^2);
       speed(j,i)= mean(velocityfield,'all');
       clear velocityfield;
   end
    
end
save(fullfile(data_output,'PIV_320'));
