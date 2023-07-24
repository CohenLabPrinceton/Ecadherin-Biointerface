function [TotalG1time,TotalG2time,meanG1time,meanG2time,stdG1time,stdG2time]=G1G2time_caculator(G1time,G2time,Hourperframe)

TotalG1time=[G1time{:}]*Hourperframe;
TotalG2time=[G2time{:}]*Hourperframe;
meanG1time=mean(TotalG1time);
meanG2time=mean(TotalG2time);
stdG1time=std(TotalG1time);
stdG2time=std(TotalG2time);

end