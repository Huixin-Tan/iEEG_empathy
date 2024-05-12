function [ROI1_ROI2_PAC_temp,ROI2_ROI1_PAC_temp] = compute_PAC(data1,data2,AmpFreqVector,PhaseFreqVector,paddedDataLength,PhaseFreq_BandWidth,sampling_rate)

%% data1:time seris of Region A's raw signal ;
%% data2:time seris of Region B's raw signal ;
%% AmpFreqVector: vector of amplitude frequency
%% PhaseFreqVector: vector of phase frequency
%% paddedDataLength: length of data padded before and after the time range of interest
%% PhaseFreq_BandWidth: if you set PhaseFreq_BandWidth as x, the data are bandpass filtered around phase frequency with a bandwidth +/- 1/2*x
%% required to download eegfilt function from EEGlab and circ_corrcl function

%% zero-padded to aviod edge effect
data1 = [zeros(2000,1);data1;zeros(2000,1)]; %% padding with zero
data2 = [zeros(2000,1);data2;zeros(2000,1)]; %% padding with zero
no_Amp = length(AmpFreqVector);
no_Phase = length(PhaseFreqVector);
                        
    parfor ii=1:no_Amp
        for jj=1:no_Phase
            
            Pf1 = PhaseFreqVector(jj) - 1/2*PhaseFreq_BandWidth; %% lower-bound phase frequency
            Pf2 = PhaseFreqVector(jj) + 1/2*PhaseFreq_BandWidth; %% higher-bound phase frequency
                                
            ROI1_PhaseFreq=eegfilt(data1',sampling_rate,Pf1,Pf2); % filtering
            temp = angle(hilbert(ROI1_PhaseFreq(2001:end-2000)));  %% exclude zero
            ROI1_PhaseFreqTransformed = temp(paddedDataLength+1:end-paddedDataLength); % getting the phase time series, and excluded padded data before and after post-stimulus 0-500 time window
                                
            ROI2_PhaseFreq=eegfilt(data2',sampling_rate,Pf1,Pf2); % filtering 
            temp = angle(hilbert(ROI2_PhaseFreq(2001:end-2000)));
            ROI2_PhaseFreqTransformed = temp(paddedDataLength+1:end-paddedDataLength); % getting the phase time series
                                
                                
            Af1 = AmpFreqVector(ii) - PhaseFreqVector(jj);
            Af2=  AmpFreqVector(ii) + PhaseFreqVector(jj);
             
            ROI1_AmpFreq=eegfilt(data1',sampling_rate,Af1,Af2); % filtering
            temp = abs(hilbert(ROI1_AmpFreq(2001:end-2000))); 
            ROI1_AmpFreqTransformed =  temp(paddedDataLength+1:end-paddedDataLength); % getting the amplitude envelope

            ROI2_AmpFreq=eegfilt(data2',sampling_rate,Af1,Af2); % filtering
            temp = abs(hilbert(ROI2_AmpFreq(2001:end-2000))); 
            ROI2_AmpFreqTransformed =  temp(paddedDataLength+1:end-paddedDataLength); % getting the amplitude envelope

            ROI1_ROI2_PAC_temp(ii,jj)=circ_corrcl(ROI1_PhaseFreqTransformed,ROI2_AmpFreqTransformed);
            ROI2_ROI1_PAC_temp(ii,jj)=circ_corrcl(ROI2_PhaseFreqTransformed,ROI1_AmpFreqTransformed);
            
        end
    end
end