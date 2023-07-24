% Sort out outlier samples that have too low or high normalized signal value

function Tracklist_sorted=Sorting_Outlier(Tracklist,TRITC_BG,GFP_BG,TRITC_CH_name,GFP_CH_name)

mcounter=1;
for m=1:size(Tracklist,2)
    TRITCsignal=Tracklist{m}{:,TRITC_CH_name};
    GFPsignal=Tracklist{m}{:,GFP_CH_name};
    
    if((max(TRITCsignal)>=(1.2*TRITC_BG))&(max(GFPsignal)>=(1.2*GFP_BG)))
    Tracklist_sorted{mcounter}=Tracklist{m};
    mcounter=mcounter+1;
    end
    
end
end