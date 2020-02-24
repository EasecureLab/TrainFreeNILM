function signal = getSignal(segmentInfo, orgSignal)
% getSignal: reconstruct a new signal from a given signal, 'orgSignal', using
% the segment information, 'segmentInfo'.

if isempty(segmentInfo),
    signal = zeros(size(orgSignal));
else
    
    signal = zeros(size(orgSignal));
    segNb = size(segmentInfo);
    for k = 1 : segNb
        signal(segmentInfo(k,1):segmentInfo(k,2)) = orgSignal(segmentInfo(k,1):segmentInfo(k,2));
    end
    
end


