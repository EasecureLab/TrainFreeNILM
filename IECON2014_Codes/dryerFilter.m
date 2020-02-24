function [signal_filtered, newSegmentInfo] = dryerFilter(signal)
% dryerFilter: filters the dryer/oven segments in the given signal, and
%              returns the filtered signal and its segment information
%
% Input Arguments:
%           signal: the given signal
%
% Output Arguments:
%       signal_filtered: the dryer/oven-filtered signal
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
    
    % check if the segment is a dryer/oven waveform
    windowLen = length(curSegment);     % window length (used to slide the aggregated signal)
    thr_crossRate = 5*windowLen/30;     % thresholding for level-crossing counting (a dryer should have larger counting than this value)
    incremental = 200;                  % value to increase the level for level-crossing counting
    [dryerFlag,~] = detectDryer(curSegment, windowLen, thr_crossRate, incremental); % detect whether dryer exists
    
    if ~dryerFlag   % if current segment is not a dryer/oven waveform
        nb = nb + 1;
        newSegmentInfo(nb,1:2) = segmentInfo(k,:);
        
    end
    
end

signal_filtered = getSignal(newSegmentInfo, signal);

