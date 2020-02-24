function avgNoiseAmplitude = localNoiseAmplitude(segmentLocation, originalSignal)
% localNoiseAmplitude: calculate the average amplitude of local noise
% contained in a given segment
%
% Input Arguments:
%       segmentLocation: a 1x2 vector storing the beginning and the ending
%                        of a given segment
%        originalSignal: the original signal
%              residual: a rough guess of the residual
%
% Output Argument:
%     avgNoiseAmplitude: the averaged local noise amplitude
%
% Author: Zhilin Zhang
% Date  : Oct.20, 2013
%

loc1 = segmentLocation(1);
loc2 = segmentLocation(2);

prePt = loc1 - 50;
postPt = loc2 + 50;

if prePt < 1
    prePt = 1;
end

if postPt > 1440
    postPt = 1440;
end

if loc1 == 1  & loc2 ~= 1440
    avgNoiseAmplitude = min(originalSignal(loc2+1 : postPt));
%     if avgNoiseAmplitude > 600,
%         avgNoiseAmplitude = residual;
%     end
elseif loc1 ~= 1 & loc2 == 1440
    avgNoiseAmplitude = min(originalSignal(prePt: loc1-1));
%     if avgNoiseAmplitude > 600,
%         avgNoiseAmplitude = residual;
%     end
else
    avgNoiseAmplitude = min(originalSignal([prePt:loc1-1, loc2+1:postPt]));
%     if avgNoiseAmplitude > 600,
%         avgNoiseAmplitude = residual;
%     end
end

 
    
    