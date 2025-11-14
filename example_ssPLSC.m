% --------------------------------------------------------------------
% Example script for ssPLSC algorithm
% 
% Sample data for real Stroke dataset is provided
% 
% Author: Jingyao Sun, sunjy22@mails.tsinghua.edu.cn
% Date created: November-14-2025
% @Tsinghua University
% --------------------------------------------------------------------

clear,clc
close all

addpath('.\dataset\')
addpath('.\function\')
addpath(genpath('.\FISTA-master\'))

% load data of one stroke patient
load('Example_Stroke_Grip.mat')

% initialize
SF = 1000;
para = [0.01 0.01 0.1 0.1];

% calculate ssPLSC
EEGsensor = 59; EMGsensor = 6; TrialNum = 1080;
alpha0 = ones(EEGsensor,1)/EEGsensor;
beta0 = ones(EMGsensor,1)/EMGsensor;
phi0 = pi/4;
Alpha_PLSC = cell(1,2); Beta_PLSC = cell(1,2);
objCMC_PLSC = cell(1,2);
for f = 1:length(foi)
    % health
    data = struct;
    data.X = DataHealth(:,1:59,f);
    data.Y = DataHealth(:,60:65,f);
    data.PX = get_connectivity(data.X);
    data.PY = get_connectivity(data.Y);
    data.Sxx = zscore(data.X)'*zscore(data.X);
    data.Sxy = zscore(data.X)'*zscore(data.Y);
    data.Syy = zscore(data.Y)'*zscore(data.Y);
    
    [objCMC_PLSC{1}(f),Alpha_PLSC{1}(f,:),Beta_PLSC{1}(f,:)] = PLSC(data,para,alpha0,beta0,phi0,'false');
    
    % lesion
    data = struct;
    data.X = DataLesion(:,1:59,f);
    data.Y = DataLesion(:,60:65,f);
    data.PX = get_connectivity(data.X);
    data.PY = get_connectivity(data.Y);
    data.Sxx = zscore(data.X)'*zscore(data.X);
    data.Sxy = zscore(data.X)'*zscore(data.Y);
    data.Syy = zscore(data.Y)'*zscore(data.Y);

    [objCMC_PLSC{2}(f),Alpha_PLSC{2}(f,:),Beta_PLSC{2}(f,:)] = PLSC(data,para,alpha0,beta0,phi0,'false');

end

% visualize CMC spectrum
figure,plot(foi,objCMC_PLSC{1},foi,objCMC_PLSC{2},'LineWidth',3)

legend('Unaffected hand','Affected hand','FontName','Arial','FontSize',12)
set(gca,'FontSize',15)
xlim([4 40]),ylim([0 0.05])
xlabel('Frequency'),ylabel('Coherence')

% visualize CMC topographies
[~,idxHealth] = max(objCMC_PLSC{1});
EEGproj_Health = Alpha_PLSC{1}(idxHealth,:);

[~,idxLesion] = max(objCMC_PLSC{2});
EEGproj_Lesion = Alpha_PLSC{2}(idxLesion,:);

figure,subplot(1,2,1)
topoplot(EEGproj_Health,chanlocs,'maplimits',[-0.3 0.3],'electrodes','off','gridscale',300,'whitebk','on','style','map');
subplot(1,2,2)
topoplot(EEGproj_Lesion,chanlocs,'maplimits',[-0.3 0.3],'electrodes','off','gridscale',300,'whitebk','on','style','map');
