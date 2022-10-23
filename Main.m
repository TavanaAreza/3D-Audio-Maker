clc
clear all
close all


% Adding the folder that contains our written functions to the list of 
% paths that MATLAB checks
addpath('Functions_and_Subroutines')



%%


%%%%%%%%%%%%%
% reading the input Audio
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Input_Audio_samples , f_sampling_input]    = audioread('./InputData/MonoChannelAudio.wav');

% playing the audio
sound(Input_Audio_samples , f_sampling_input);



%%


%%%%%%%%%%%%%
% moving-source location
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PathGeneration



%%


%%%%%%%%%%%%%
% loading the recordings
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('./Recordings/Impulse_Responses.mat');


%%%%%%%%%%%%%
% generating stereo output
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% defining the output audio samples for the left and right ears
Output_Audio_Left       = zeros(length(Input_Audio_samples) + far.ImpResp_Length , 1);
Output_Audio_Right      = zeros(length(Input_Audio_samples) + far.ImpResp_Length , 1);

% time varying convolution for generating the output
TimeVaryingConv



%%


%%%%%%%%%%%%%
% playing and saving the output
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% playing the audio
sound([Output_Audio_Left , Output_Audio_Right] , f_sampling_input);

% saving the audio file
audiowrite('./Results/StereoAudio.wav' , [Output_Audio_Left , Output_Audio_Right] , f_sampling_input);


