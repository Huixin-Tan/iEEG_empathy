% THX @ SANP LAB
% Reference: 2019_NC_coordinated representaional reinstatement in the human
% hippocampus and lateral temporal cortex during episodic memory retrieval

clear; 

%% load the data
file_path = 'F:\HuixinT\empathy\Data\preprocessed\';
file = dir('F:\HuixinT\empathy\Data\preprocessed');
sub_pool = 3:length(file); %% exclude '.','..'file

for i = sub_pool %start from the 4th file
%% load the data
    subject_file_path = [file_path,file(i).name];
    load([ subject_file_path,'\EmpathyPure\white_matter\data_RR.mat']);


%% wavelet transform for experiment 1
    cfg = [];
    cfg.method  = 'wavelet';% implements multitaper time-frequency transformation
    cfg.output ='pow';  
    cfg.pad='nextpow2';
    cfg.foi = [1:1:34,35:5:150] ;  
    cfg.toi = E1_data_RR.time{1,1}(1)+3:0.01:E1_data_RR.time{1,1}(end)-3; %downsample to 100Hz, remove 3s data padded before and after the data series
    cfg.width=[linspace(3,6,34) linspace(6,12,24)];
    E1_data_TF = ft_freqanalysis(cfg, E1_data_RR);


%%  Save the data
    eval(['save ' [subject_file_path, '/EmpathyPure/white_matter/data_TF.mat']  ' E1_data_TF']);
      
      
end
