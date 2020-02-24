        
function width = getSignalWidth(signal, height) 
% getSegWidth: return the width of the first bump in a signal at a given
% height. The signal can have any waveform with many bumps of different
% heights on it.
%
% 
% Author: Zhilin Zhang
% Date: Sept.19, 2013


% find the support
support = signal >= height;

support = [0, support, 0];

% determine the continuity of the support
diffsup = diff(support);

% vector recording locations of all positive spikes
Positive = find(diffsup > 0);
% if length(Positive)> 0
%     Positive = Positive + 1;
% end
 

% vector recording locations of all negative spikes
Negative = find(diffsup < 0);
% if length(Negative) > 0
%     Negative = Negative + 1;
% end

if isempty(Positive) | isempty(Negative)
    width = 0;
else
    firstPositive = Positive(1);
    firstNegative = Negative(1);
    width = firstNegative - firstPositive  + 1;
end