% Demo file to show using the proposed algorithm to estimate the electric
% Vehicle charging load day by day.
%
% Zhilin Zhang (zhilinzhang@ieee.org)
% https://sites.google.com/site/researchbyzhang/
%
% Samsung Research America -- Dallas
% Date: August 6, 2014
%
% Reference:
%   Zhilin Zhang, Jae Hyun Son, Ying Li, Mark Trayer, Zhouyue Pi, 
%   Dong Yoon Hwang, Joong Ki Moon, Training-Free Non-Intrusive Load 
%   Monitoring of Electric Vehicle Charging with Low Sampling Rate, 
%   The 40th Annual Conference of the IEEE Industrial Electronics Society 
%   (IECON 2014), Oct.29-Nov.1, 2014, Dallas, TX


clear;  clc; close all;

addpath(genpath('Data'));
 
% load monthly data (detailed descriptions can be found in the 'Data' fold)
ID = '3367_2013_05';    % 3367 is the House ID, 2013 is the Year, 05 is the month
 

load(ID);
 

% -------------------- Estimate EV day by day ------------------
EVsignal = zeros(size(agg_signal));
for k =  1 : size(agg_signal,2) 
    ts = agg_signal(:,k);
   
    if strcmp(ID(end-1:end),'09') | strcmp(ID(end-1:end),'08') | strcmp(ID(end-1:end),'07') | strcmp(ID(end-1:end),'06')
        contextInfo.season = 1;   % summer season
    else
        contextInfo.season = 0;
    end
    
    contextInfo.EVamplitude = 3000;   % pre-defined amplitude of EV power signal (unit: Watt)
    
    verbose = 0;   % not show estimation progress
    
    [EVsignal(:,k)] = estEV(ts, contextInfo, verbose); 
    
end



% ----------------------- show the result day by day -------------------- 

for k  = 1 : size(agg_signal,2)
    figure;
    subplot(411);plot(agg_signal(:,k));  title(['Whole-house Aggregated Power Signal ',num2str(k)]);  xlim([-inf,inf]); ylim([0,12000]);
    
    subplot(412);plot(AC(:,k));  title(['Air-Conditioner Power Signal']);  xlim([-inf,inf]); ylim([0,6000]);
    
    subplot(413);plot(EV(:,k),'r','linewidth',2); title(['EV:  (',num2str(sum(EV(:,k))/60000),')']);
    if max(EV(:,k)) < 2500, axis([-inf,inf,0,6000]); else, xlim([-inf,inf]); ylim([0,6000]); end;
    title('Ground-Truth of Electric Vehicle Charging Load');
    
    subplot(414);
    plot(EVsignal(:,k),'m','linewidth',2); title(['New Algorithm:  (',num2str( sum(EVsignal(:,k))/60000  ), ')']);
    if max(EVsignal(:,k)) < 2500, axis([-inf,inf,0,6000]); else, xlim([-inf,inf]); ylim([0,6000]); end;
    title('Estiamted Electric Vehicle Charging Load');
    
end
    
 
% calculate the percentage of EV in the aggregated signal in a month
EVpercentage = sum(sum(EV))/sum(sum(agg_signal));

% Energy estimation accuracy  
EVPE = 1-abs(sum(sum(EV))-sum(sum(EVsignal)))/(sum(sum(EV)));

% Normalized MSE
MSE = (norm(EV - EVsignal,'fro')/norm(EV,'fro'))^2;

fprintf('\nResult: Energy Accuracy: %3.1f%% |Difference(kWh): %4.1f |MSE: %f | Percentage: %3.2f%%  | Truth: %g (kWh); Estimated: %g (kWh) \n',...
    EVPE*100, sum(sum(EV))/60/1000 - sum(sum(EVsignal))/60/1000, mean(MSE),EVpercentage*100, sum(sum(EV))/60/1000, sum(sum(EVsignal))/60/1000);
 



