% THX @ SANP LAB
% Reference: 2019_NC_coordinated representaional reinstatement in the human
% hippocampus and lateral temporal cortex during episodic memory retrieval

cfg = [];
cfg.method  = 'wavelet';
cfg.output ='pow';  
cfg.pad='nextpow2';
cfg.foi = [1:1:34,35:5:150] ;  
cfg.toi = E1_data_RR.time{1,1}(1)+3:0.01:E1_data_RR.time{1,1}(end)-3; %downsample to 100Hz, remove 3s data padded before and after the data series
cfg.width=[linspace(3,6,34) linspace(6,12,24)];
E1_data_TF = ft_freqanalysis(cfg, E1_data_RR);
