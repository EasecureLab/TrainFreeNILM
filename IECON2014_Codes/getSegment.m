
function [segment, segNum] = getSegment(EVsignal)
% getSegment: Find each segment of EVsignal and return the starting and ending 
% locations of each segment, and the number of segments.
%
% Input Arguments:
%       EVsignal : a given signal contains arbitrary number of segments
%
% Output Arguments:
%        segment : a matrix with each row representing a segment's starting 
%                  point and ending point. 
%        segNum  : the number of segments.
% 
% Author: Zhilin Zhang (zhilinzhang@ieee.org)
% Version: 1.0

 
idx = EVsignal > 0;
if iscolumn(idx), idx = idx'; end;
idx2 = [0, idx, 0];

prePt = [];  postPt = [];

for i = 2 : length(idx2)-1
    if idx2(i-1) == 0 & idx2(i) == 1 & idx2(i+1) == 1
        prePt = [prePt, i-1];
    end
    
    if idx2(i-1) == 1 & idx2(i) == 1 & idx2(i+1) == 0
        postPt = [postPt,i-1];
    end
end

segNum = length(prePt);

segment = [];
for k = 1 : segNum
    segment(k,:) = [prePt(k), postPt(k)];
end
