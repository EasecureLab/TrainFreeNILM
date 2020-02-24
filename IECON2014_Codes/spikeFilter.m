function [signal_filtered, newSegmentInfo] = spikeFilter(signal, duration)
% spikeFilter: filters spikes in the given signal, and
%              returns the filtered signal and its segment information
%
% Input Arguments:
%                signal: the given signal
%              duration: remove segments with width <= duration
%
% Output Arguments:
%       signal_filtered: the spike-filtered signal
%           segmentInfo: the structure storing each segment information
%
% Author: Zhilin Zhang
% Oct. 21, 2013
%
%

[segmentInfo, segNum] = getSegment(signal);
nb = 0;
newSegmentInfo = [];

for k =  1 : segNum
    curSegment = signal( segmentInfo(k,1): segmentInfo(k,2) );
    
    if length(curSegment) > duration
        nb = nb + 1;
        newSegmentInfo(nb,1:2) = segmentInfo(k,:);
        
    end
    
end

if isempty(newSegmentInfo)
    signal_filtered = zeros(size(signal));
else
    signal_filtered = getSignal(newSegmentInfo, signal);
end
