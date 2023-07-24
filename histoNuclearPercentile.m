function Intensity=histoNuclearPercentile(Input,Mask,Stacklength,Percentile)
% This code calculate mean intensity of pixels 
% which have(Percentile)intensity from the bottom
Image=imread_big(Input,Stacklength);
Mask=imread_big(Mask,Stacklength);
Mask=Mask>0;
Imageintensity=regionprops(Mask,Image,'MeanIntensity');
Imagevector=cat(1,Imageintensity.MeanIntensity);
Intensity=prctile(Imagevector,Percentile,'all');
end