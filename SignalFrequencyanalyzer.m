function [frequency]=SignalFrequencyanalyzer(Tracklist,Channelname,Frameperhour,maxmin)
% maxnin is getting local maxia/minima for maxia put 1, for minima put -1
disp('Analyzing signal frequency...');
Framelength=size(Tracklist{1},1);
for(m=1:size(Tracklist,2))
    Channelsignal=Tracklist{m}{:,Channelname};
    out=peakfinder(Channelsignal, [], [], maxmin);
    frequency(m)=length(out)/(Framelength/Frameperhour);
end

end