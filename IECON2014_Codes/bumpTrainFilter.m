function [segmentInfo_new, rmvSegmentInfo, flag] = bumpTrainFilter(segment, min_shrtDuration, max_duration, incrPercentage)
% bumpTrainFilter - A bump-pruning filter which removes a number of bumps
% (indexes given by the input 'segment') according to the bumps' width
% dynamics. It returns the information of the remained bumps.
%
% The function is to remove a train of bumps whose width may be increased
% gradually. To remove the train of bumps, it is difficult to set a fixed
% threshold to the width of which a bump should be pruned out, since we do
% not know how wide a bump (at the end of the train) will be. However, this
% function can successfully remove the train. 
%
% It first finds the bumps with the width less than or equal to the
% min_shrtDuration, which are called 'seeds'. Then from each 'seed', the
% function searches forward the bump nearest to the 'seed', checking
% whether the bump' width is less than or equal to the width of the
% 'seed' multiplying with (1 + incrPercentage). If so, then prune out the
% bump. Then set the bump as the 'seed', and search forward as before.
% Simiarly, the above procedure repeats backward. To prevent from pruning
% out bumps with very large width, one can set the max_duration. Thus, all
% the pruned bumps have width no more than max_duration. However, note that
% generally not all bumps with width <= max_duration will be pruned out; 
% they will be purned out only if their width does not increase sharply
% compared to their relative locations.
%
% Input Arguments:
%              segment:  A matrix storing information of each bump. Its
%                        (i,1) entry stores the location index of the 
%                        beginning element of the i-th bump, and its (i,2) 
%                        entry stores the location index of the ending 
%                        element of the i-th bump.
%
%     min_shrtDuration:  A threshold to find 'seed' bumps whose width <= it
%
%         max_duration:  A threshold to constrain the largest width of
%                        which a bump may be pruned.
%
%       incrPercentage:  The allowed increased percentage in width when
%                        pruning a bump besides the `seed' bump
%
% Output Argument:
%      segmentInfo_new:  A matrix with the same structure as `segment'. It
%                        stores the remained bumps' information
%       rmvSegmentInfo:  Same structure as segmentInfo_new, which stores
%                        the removed bumps' information.
%                 flag:  flag == 1 indicates bumps are removed; 
%                        flag == 0 indicates no bump is removed.
%
%
% Author: Zhilin Zhang (zhilinzhang@ieee.org)
%         Samsung Research America - Dallas
%
% Version: 1.0 (Oct. 16, 2013)
%


segLenList = diff(segment');

% Find "seeds" -- the bumps with short duration less than
% min_shrtDuration

[val,indx] = find(segLenList <= min_shrtDuration);

if isempty(indx)
    segmentInfo_new = segment;
    rmvSegmentInfo = [];
    flag = 0;
    return;
end

seedNb = length(indx);
del_flag = [];   % to store the indexes of bumps which should be pruned out

for i  = 1 : seedNb
    
    seed = indx(i);
    del_flag = [del_flag,seed];
    
    
    % ==============================
    %    backward search
    % ==============================
    if indx(i) > 1,
        duration = min(max_duration, segLenList(seed)*(1+ incrPercentage) );
        backCheck = seed - 1;
        
        while(backCheck >=1)
            % Examine if the width of the bump is no more than the constraint,
            % and if the bump is physically nearby
            if (segLenList(backCheck) <= duration)  &  (segment(seed,1) - segment(backCheck,2) < min(duration*3, 90))
                seed = backCheck;
                del_flag = [del_flag, seed];
                
                duration = min(max_duration, segLenList(seed)*(1+ incrPercentage) );
                backCheck = seed - 1;
            else
                break;
            end
        end
    end
        
    
    % ==============================
    %     forward search
    % ==============================
    if indx(i) < length(segLenList)
        duration = min(max_duration, min_shrtDuration*(1+ incrPercentage) );
        forwardCheck = indx(i) + 1;
        
        while(forwardCheck <= length(segLenList))
            % Examine if the width of the bump is no more than the constraint,
            % and if the bump is physically nearby

            if (segLenList(forwardCheck) <= duration) & ...
                    (segment(forwardCheck,1) - segment(seed,2) < min(duration*3, 90))
                seed = forwardCheck;
                del_flag = [del_flag, seed];
                
                duration = min(max_duration, segLenList(seed)*(1+ incrPercentage) );
                forwardCheck = seed + 1;
            else
                break;
            end
        end
    end
end

del_flag = unique(del_flag); 
if isempty(del_flag), flag = 0; else, flag = 1; end;
rmvSegmentInfo = segment(del_flag,:);

segmentInfo_new = segment;
segmentInfo_new(del_flag,:) = [];





