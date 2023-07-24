% G1 time t-test
function p_mean=subsampling_t_test(data1,data2,samplesize,iteration)
    data1=data1(~isnan(data1));
    data2=data2(~isnan(data2));
for i=1:iteration
    disp(['Processing: ',num2str(i),'/',num2str(iteration)]);
    data1_sub=datasample(data1,samplesize);
    data2_sub=datasample(data2,samplesize);
    p(i)=ranksum(data1_sub,data2_sub);
end
p_mean=mean(p);
disp('Job is done!');
end

