function height = getHeight(signal)
% getHeight: calculate the height of a given signal

maxVal = max(signal);
wd = [];
for nn = 1 : maxVal
    wd(nn) = getSignalWidth(signal, nn);
end
[~, indx] = find(wd >= wd(1)*0.7);

height = indx(end);









