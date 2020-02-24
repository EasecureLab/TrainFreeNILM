
    
function [dryerFlag, DRest,  residual] = detectDryer(ts, windowLen, thr_crossRate, incremental)
% detectDryer: detect & estimate dryer/oven's power signal from aggregated signal ts
%
% Input Arguments:
%             ts - aggregated signal in one day
%      windowLen - window length (used to slide the aggregated signal)
%  thr_crossRate - thresholding for level-crossing counting (a dryer should
%                  have larger counting than this value)
%    incremental - value to increase the level for level-crossing counting
%
% Output Arguments:
%       dryerFlag - If dryerFlag==1, dryer/oven exists; If dryerFlag==0, not exists
%           DRest - The estimated dryer/oven signals in the whole day
%        residual - The residual noise in the aggregated signal ts
%
% Version: 2.1: 
%     Enhance the robustness by
%         * Using multiple level-crossing counts to detect whether a candiate bump
%           is a dryer or not
%         * Detecting the leading part of some kinds of dryers (which is a
%           bump with the same amplitude as the rest part of the dryers)
%         * Change the median filtering order from 300 to 400
%
%
% Author: Zhilin Zhang
%   Date: Sept.17, 2013
% 


 
DRest = zeros(size(ts));

windowNum = ceil(length(ts)/windowLen);
seg_index = [];
for i = 1 : windowNum       % sliding the window
    
    seg = ts( (i-1)*windowLen+1 : i*windowLen );
    
    % check the level-crossings at different levels
    maxVal = max(seg);
    startVal = maxVal/2;
    levelNum = ceil((maxVal - startVal)/incremental);
    
    D = [];
    for j = 1 : levelNum
        level = startVal + j * incremental;
        
        seg2 = seg - level;
        d = [];
        for k = 2 : windowLen
            d(k) = abs(sign(seg2(k)) - sign(seg2(k-1)))/2 ;
        end
        D(j) = sum(d);
    end
    [maxCrossRate(i,1),ix] = max(D);            % find the largest level-crossings among the levels
        D(ix) = 0;
    [maxCrossRate(i,2),ix] = max(D);            % find the second largest level-crossings among the levels
        D(ix) = 0;   
    [maxCrossRate(i,3),ix] = max(D);            % find the third largest level-crossings among the levels
        D(ix) = 0; 
    
    % Find the dryer signal (the three largest level-crossing counts should be larger than the threshold)  
    % The goal is to remove some residual noise with small oscillated amplitude
    if mean(maxCrossRate(i,:) > thr_crossRate) == 1,  
        seg_index = [seg_index,i];
        DRest((i-1)*windowLen+1 : i*windowLen) = seg;
    end
end


% Remove residual signal. The order should be very large; here is 300
residual = medfilt1(ts,400);
DRest = DRest - residual ;
DRest(DRest<0) = 0;
 

% Modify the estimated dryer signal
% Here are two modifications:
% (1) Remove candiate bumps with amplitude less than 3000 (W)
% (2) Add the leading part of some kinds of dryer, which is a bump with the
%     same amplitude as the rest of the dryer. This leading part is
%     sometimes ignored by the above procedure.
for k = 1 : length(seg_index)
    i = seg_index(k);   % the physical starting location of the k-th bump
    
    % remove segments with amplitude lower than 3000 (W)
    if max(DRest((i-1)*windowLen+1 : i*windowLen)) < 3000
        DRest((i-1)*windowLen+1 : i*windowLen) = 0;
        
    % Solve the issue when using the level-crossing counting (it will ignore
    % the leading part of dryer, which is a bump of some duration). Here is the
    % goal is to add such bumps.   
    else 

        if k >= 2   % If candidate bumps have two or more, we need to know 
                    % whether the two bumps are side by side. If are, we 
                    % need to avoid to replace the first bump with the 
                    % leading part of the second bump, i.e, do nothing. 
                    % If not side by side, we then decide whether the
                    % leading part of the second bump exists or not. If
                    % exists, then add this part in DRest.
                    % 
        
            if seg_index(k)-seg_index(k-1) > windowLen   % if not side by side
                
                % locations of the space (length: windowLen) before the second dryer
                aug_index = [(i-1)*windowLen+1 : i*windowLen ] - windowLen; 
                
                % find the locations in the above space where the signal
                % amplitude is larger than the 80% of the maximum value of
                % the second dryer (which is believed to be the leading
                % part of the second dryer)
                bump_ind = find( ts(aug_index) > max( ts( (i-1)*windowLen+1 : i*windowLen  ) )*0.8);
                
                % construct the leading part of the second dryer and add it
                % to the DRest.
                DRest(aug_index(bump_ind)) = max( DRest((i-1)*windowLen+1 : i*windowLen) );
        
            end
            
        else  % now dealing with the first bump in DRest. Need to pay attention to the bound isssue.
            
            if i > 1  % if the first bump is not in the first window
                aug_index = [(i-1)*windowLen+1 : i*windowLen ] - windowLen; 
                bump_ind = find( ts(aug_index) > max( ts( (i-1)*windowLen+1 : i*windowLen  ) )*0.8);
                DRest(aug_index(bump_ind)) = max( DRest((i-1)*windowLen+1 : i*windowLen) );
            end
        end

            
    end
    
    
end

% set the detection flag
if norm(DRest) > 1
    dryerFlag = 1;
else
    dryerFlag = 0;
end

DRest = DRest + 1;   % add the bias