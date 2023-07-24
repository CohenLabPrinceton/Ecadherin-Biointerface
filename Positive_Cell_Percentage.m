
for j=1:length(props)
   sample=CleanedProp(:,j);
    nanlessCleanProp{j}=sample(~isnan(sample));
end
length_i=6;
number_of_replicates=4;
for i=1:length_i
    index=zeros(length(Mask_files),1);
    start=number_of_replicates*(i-1)+1;
    index(start:start+3)=1;
    index=index>0;
    Indexed_Props=nanlessCleanProp(index);
    ConcatCleanProp{i}=cat(1,Indexed_Props{:});
end


%%
Thres=prctile(ConcatCleanProp{5},90,'all');

for j=1:length(props)
    sample=nanlessCleanProp{j};
    positivesample=sample(sample>Thres);
    Positive_Percent(j)=length(positivesample)/length(sample)*100;
end

for j=1:6
    sample=ConcatCleanProp{j};
    positivesample=sample(sample>Thres);
    Positive_Percent_Merged(j)=length(positivesample)/length(sample)*100;
end
