function Intensity=histoPercentileNomask(Input,Stacklength,Percentile)
Image=imread_big(Input,Stacklength);
Imagevector=reshape(Image,[],1);
nonzero=find(Imagevector>0);
Imagevector=Imagevector(nonzero);
Thres_Intensity=prctile(Imagevector,Percentile,'all');
Targetpixels=Imagevector(Imagevector>=Thres_Intensity);
Intensity=mean(Targetpixels);
end