function Intensity=histoPercentile(Input,Mask,Stacklength,Percentile)
% This code calculate mean intensity of pixels 
% which have(Percentile)intensity from the bottom
Image=imread_big(Input,Stacklength);
Mask=imread_big(Mask,Stacklength);
Mask=Mask>0;
Image(~Mask)=0;
Imagevector=reshape(Image,[],1);
nonzero=find(Imagevector>0);
Imagevector=Imagevector(nonzero);
Intensity=prctile(Imagevector,Percentile,'all');
end