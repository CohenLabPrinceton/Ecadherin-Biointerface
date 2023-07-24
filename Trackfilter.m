function [Tracklist]=Trackfilter(ID_sort,StartFrame,EndFrame)
disp('Processing track filtering...');
%% Count track number and track length
TrackCount = max(ID_sort.Track_ID)+1;
TrackDur = max(ID_sort.Frame)+1;

%% Figure out start & end of each track
for(i=0:TrackCount-1)
    trackindices=find(ID_sort.Track_ID==i);
    TrackStart(i+1)=ID_sort.Frame(trackindices(1));
    TrackEnd(i+1)=ID_sort.Frame(trackindices(end));
end
%% Filter by track length
StartFramedata=StartFrame-1; %Frame in CSV file starts at 0
EndFramedata=EndFrame -1; %Frame in CSV file starts at 0
goodTracks=find((TrackStart<=StartFramedata)&(TrackEnd>=EndFramedata));

jcounter=1;
for(j=1:length(goodTracks));
    index=goodTracks(j)-1;
    Track = ID_sort(find(ID_sort.Track_ID==index),:);
    Startpoint=find(Track.Frame==StartFramedata); %Crop all tracks to the same length
    Endpoint=find(Track.Frame==EndFramedata);
    Track=Track(Startpoint:Endpoint,:);
    if(size(Track,1)==(EndFramedata-StartFramedata+1))
        Tracklist{jcounter}=Track;
        jcounter=jcounter+1;
    end
    clear Track
end
end