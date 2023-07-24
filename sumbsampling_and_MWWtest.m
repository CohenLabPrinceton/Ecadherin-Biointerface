% G1 time t-test
samplesize=50;
p_G1=[];
p_G2=[];
iteration=50;
for i=1:iteration
    disp(['Processing: ',num2str(i),'/',num2str(iteration)]);
    Col_G1time=Col_G1time(~isnan(Col_G1time));
    Col_G2time=Col_G2time(~isnan(Col_G2time));
    Ecad_G1time=Ecad_G1time(~isnan(Ecad_G1time));
    Ecad_G2time=Ecad_G2time(~isnan(Ecad_G2time));
    ColG1=datasample(Col_G1time,samplesize);
    ECG1=datasample(Ecad_G1time,samplesize);
    ColG2=datasample(Col_G2time,samplesize);
    ECG2=datasample(Ecad_G2time,samplesize);
    p_G1(i)=ranksum(ColG1,ECG1);
    p_G2(i)=ranksum(ColG2,ECG2);
end
p_G1_mean=mean(p_G1);
p_G2_mean=mean(p_G2);
disp('Job is done!');

