function ACindicator = ACdetector(signal)
% Detect whether air-conditioner signature exists in signal, return '1' or '0'

if isempty(signal)
    ACindicator = 0;
    return;
end

maxLag = min(length(signal),150)-1;

% calculate its autocorrelation 
ACF = xcorr(signal,'coeff');
ACF_half = ACF(length(signal): end);   
ACF_half(ACF_half<0.2) = 0;

% figure;
% subplot(211);plot(signal);
% subplot(212);plot(ACF_half);

[peakLoc] = myfindpeaks(ACF_half);

if isempty(peakLoc)
    ACindicator = 0;
    return;
else
    
    % find highest peaks in the order from highest to lowest
    [val,  ind] = max( ACF_half(peakLoc) );
    
    highPeakLoc(1) = peakLoc(ind);
    
    if  (12 < highPeakLoc(1)) & (highPeakLoc(1) < 60)
        ACindicator = 1;
    else
        ACindicator = 0;
    end
    
end


%------------------------------------------------------------------------
function n = myfindpeaks(x)
% Find peaks.
% n = findpeaks(x)

n    = find(diff(diff(x) > 0) < 0);
u    = find(x(n+1) > x(n));
n(u) = n(u)+1;



