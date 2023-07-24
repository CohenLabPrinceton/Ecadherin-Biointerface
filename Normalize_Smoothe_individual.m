function [SignalSnorm]=Normalize_Smoothe_individual(Signal)

for i=1:size(Signal,2)
SignalS=smoothdata(Signal);
SignalS_min=min(SignalS(:,i));
%SignalS_Norm=prctile(SignalS(:,i),85,'all');
SignalS_max=max(SignalS(:,i));
SignalSnorm(:,i)=(SignalS(:,i)-SignalS_min)/(SignalS_max-SignalS_min);

end
end