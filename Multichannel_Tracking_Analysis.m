%Open CSV exports directly from trackmate (double click)
clear all;
%Want columns 3,9,12,13,14
Trackdata=readtable('Ecad_1_half1.csv');
Tracks = Trackdata{(:,{'Track_ID','Frame','MEAN_INTENSITY_CH1','MEAN_INTENSITY_CH2',}};
ID_sort = sortrows(Tracks,{'Track_ID','Frame'});

nonefilter=~isnan(ID_sort.TRACK_ID);
ID_sort = ID_sort(nonefilter(:,1),:);

ID_final=ID_sort.TRACK_ID;
%%
ID_final=[ID_final,table2array(ID_sort(:,2:end))];

TrackCount = max(ID_final(:,1))+1;
TrackDur = max(ID_final(:,2))+1; 
Framerate=1/20; 
%%
%INPUT: Reprocess Tracks?
reprocess = 1;


%Determine length of each track

if(reprocess==1)
    for(i=0:TrackCount-1) 
        trackindices=find(ID_final(:,1)==i);
        TrackStart(i+1)=ID_final(trackindices(1),2);
        TrackEnd(i+1)=ID_final(trackindices(end),2);
    end
end
%%
%Filter by track length
StartFrame=2;
EndFrame=55;
StartFramedata=StartFrame-1; %Frame in CSV file starts at 0
EndFramedata=EndFrame -1; %Frame in CSV file starts at 0 
goodTracks=find((TrackStart<=StartFramedata)&(TrackEnd>=EndFramedata));


%%
%Separate the target tracks
clear Track Tracklist
jcounter=1;
for(j=1:length(goodTracks));
    index=goodTracks(j)-1;
    Track = ID_final(find(ID_final(:,1)==index),:);
    Startpoint=find(Track(:,2)==StartFramedata); %Crop all tracks to the same length
    Endpoint=find(Track(:,2)==EndFramedata);
    Track=Track(Startpoint:Endpoint,:);
    if(size(Track,1)==(EndFramedata-StartFramedata+1))
    Tracklist(:,:,jcounter)=Track;
    jcounter=jcounter+1;
    end
    clear Track
end
%%
%normalize
clear G1norm G1normS G2norm G2normS G1pre G2pre
GFP_Normalization=4600;
RFP_Normalization=;

for(m=1:size(Tracklist,3))
    G1pre =Tracklist(:,3,m);
    G2pre = Tracklist(:,4,m);
    %G1norm(:,3,m) = G1pre./max(G1pre);
    G1norm=G1pre/RFP_Normalization; %choose how to normalize, not normalized right now. 
    G2norm=G2pre/GFP_Normalization;
    G1normS(:,m)=smooth(G1norm,3);
    G2normS(:,m)=smooth(G2norm,3);
    %Tracklist(:,3,m)=smooth(Tracklist(:,3,m)./max(Tracklist(:,3,m)));
    %Tracklist(:,4,m)=smooth(Tracklist(:,4,m)./max(Tracklist(:,4,m)));
end
%% cutting off samples
clear G1normSorted G2normSorted
minThres=0.15;
maxThres=10;
mcounter=1;
for m=1:size(G1normS,2)
     if((max(G1normS(:,m))>minThres)&(max(G1normS(:,m))<maxThres)&(max(G2normS(:,m))>minThres)&(max(G2normS(:,m))<maxThres))
        G1normSorted(:,mcounter)=G1normS(:,m);
        G2normSorted(:,mcounter)=G2normS(:,m);
        mcounter=mcounter+1;
     end
end
%%
figure;
%Plot array
for(k=1:20)
    subplot(5,4,k);
    kk=randi(size(G1normSorted,2));
    G1=G1normSorted(:,kk); 
    G2=G2normSorted(:,kk);
    
    
    plot(G1,'r');
    hold on;
    plot(G2,'g');
    
end
%% Interpolationn and find the G1,G2crosspoint
clear G1time_final G2time_final
interp_factor = 10 ;
Timeframe=size(G1normSorted,1);
Exptime = linspace(1,Timeframe,Timeframe) ;
Interptime = linspace(1,Timeframe,interp_factor*Timeframe);
cutoff=6;
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
        
    end
    G1time_final{m}=G1time(G1time>cutoff);
    G2time_final{m}=G2time(G2time>cutoff);
end
%% Averaging
clear TotalG1time TotalG2time meanG1time meanG2time;
TotalG1time=[G1time_final{:}]*Framerate;
TotalG2time=[G2time_final{:}]*Framerate;
meanG1time=mean(TotalG1time);
meanG2time=mean(TotalG2time);
stdG1time=std(TotalG1time);
stdG2time=std(TotalG2time);
%%
save('Collagen_0to100frames.mat');