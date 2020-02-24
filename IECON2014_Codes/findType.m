function [type, changeAmplitude] = findType(segment, heightResolution, differentiateRange)
% findType: Find the type of the segment and the amplitudes at which the
% segment waveform has significant changes.
%   heightResolution : If not save computation load, you can set it to 1.
%                      To save computational load, you can set it to other
%                      integers > 1. 
%  differentiateRange: To decide the change point in ampliutde, the code
%                      compares the current height and the height at
%                      (current height + differentiateRange)
%
% Author: Zhilin Zhang (zhilinzhang@ieee.org)
%


max_val = max(segment);


for h = 1  : ceil(max_val/heightResolution)
    val = (h-1)*heightResolution + 1;
    ptNb(h) = length(find(segment>= val));
end
ptNb = medfilt1(ptNb,20);

% differentiate with range
len = length(ptNb);
ptNb = [ptNb, zeros(1,differentiateRange-1)];
totalNb = length(segment);
for k = 1 : len
    % differentiate
    dptNb(k) = ptNb(k) - ptNb(k+differentiateRange-1);
    
    % rate of the change range to the point number at the changepoint
    dptRate(k) = dptNb(k)/totalNb;
end
ptNb(end-differentiateRange+1 : end) = [];




% find peaks in dptNb
dptNb_aug = [0,dptNb,0];
[pks, locs] = findpeaks(dptNb_aug, 'minpeakdistance', round(2000/heightResolution),'minpeakheight',max(dptNb_aug)*0.2,'sortstr','descend');
 

if isempty(pks), type = 0; changeAmplitude = [];  end;


locs = locs - 1;

if length(pks) == 1
    type = 1;   % no overlap (or EV overlaps with a signal with narrow width)
    changeAmplitude = (locs-1)*heightResolution + 1;
    
elseif length(pks) >= 2
    
    % need to calculat the area to further classify
    % if the area is larger than 1/3
    dptNb_n = dptNb/max(dptNb); dptNb_n(dptNb_n==0) = [];
    
    areaRate = sum(dptNb_n)/length(dptNb_n);
    if areaRate > 0.4,
        type = 0; changeAmplitude = [];
    else
        type = 2;   % overlap (EV and AC overlaps)
        changeAmplitude = (sort(locs, 'ascend' )-1)*heightResolution + 1;
    end
     
end

 

 
 

