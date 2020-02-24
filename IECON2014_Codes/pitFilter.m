function [signal, newSegmentInfo] = pitFilter(originalSignal,segmentInfo,gapDistanceMax)
% pitFilter: according to the segmentInfo, fills the pits between two
% successive segments of the originalSignal; The pit distance is no more 
% than gapDistanceMax.

signal = getSignal(segmentInfo, originalSignal); 
 
for k =  1 : size(segmentInfo,1)-1
    if segmentInfo(k+1,1) - segmentInfo(k,2) <= gapDistanceMax
        signal([segmentInfo(k,2)+1: segmentInfo(k+1,1)-1]) ...
            = (originalSignal(segmentInfo(k,2))+originalSignal(segmentInfo(k+1,1)))/2;
    end
end

newSegmentInfo = getSegment(signal);
  




    
