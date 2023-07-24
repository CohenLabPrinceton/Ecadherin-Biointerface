function [G1time_final,G2time_final]=Cellcycleduration_caculator(G1normSorted,G2normSorted,G1cutoff_frame,G2cutoff_frame)
interp_factor = 10 ;
Timeframe=size(G1normSorted,1);
Exptime = linspace(1,Timeframe,Timeframe) ;
Interptime = linspace(1,Timeframe,interp_factor*Timeframe);
for(m=1:size(G1normSorted,2))
    InterpG1=interp1(Exptime, G1normSorted(:,m), Interptime);
    InterpG2=interp1(Exptime, G2normSorted(:,m), Interptime);
    G1Crossingindex=find(InterpG2(1:end-1)>InterpG1(1:end-1) & InterpG2(2:end)<InterpG1(2:end));
    G2Crossingindex=find(InterpG2(1:end-1)<InterpG1(1:end-1) & InterpG2(2:end)>InterpG1(2:end));
    G1Crossingpoint=Interptime(G1Crossingindex);
    G2Crossingpoint=Interptime(G2Crossingindex);
    G1G2Crosstime=sort([G1Crossingpoint,G2Crossingpoint]);
    G1G2time=diff(G1G2Crosstime);
    if (size(G1Crossingpoint)>0 & size(G2Crossingpoint)>0)
        if (G1Crossingpoint(1) < G2Crossingpoint(1))
            G1time=G1G2time(1:2:end);
            G2time=G1G2time(2:2:end);
        else
            G1time=G1G2time(2:2:end);
            G2time=G1G2time(1:2:end);
        end
    G1time_final{m}=G1time(G1time>G1cutoff_frame);
    G2time_final{m}=G2time(G2time>G2cutoff_frame);  
    end
    
end
end
