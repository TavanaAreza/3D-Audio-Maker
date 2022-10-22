% This file is to create the desired angle vectors (azimuth and elevation) 
% in addition to the range vector for creating a 3D audio file. 
%
% The specifications are as follows:
%
%   time (s)    elevation (degree)      azimuth (degree)        range (cm)
%    < 14               20                      0                   120
%      14               20                      0                   120
%      22                0                     90                    70
%      30              -20            (+ or -)180                   120
%      38                0                    -90                    70
%      45                0                      0                    70
%    > 45                0                      0                    70
%
% For instance, before t=14s, the elevation is fixed at 20deg and then, it 
% linearly deccreases to 0deg at t=22s, and the decrease continues until
% t=30s which reaches -20deg. This linear change applies to azimuth and
% range as well.


% finding the time stamp of each sample according to the sampling rate
samp_time           = [0 : length(Input_Audio_samples)-1] / f_sampling_input;

% initializing the desired angle/range vectors
elevation_desired   = 20 * ones(length(samp_time) , 1);
azimuth_desired     = zeros(length(samp_time) , 1);
range_desired       = 120 * ones(length(samp_time) , 1);




% time interval (14 22]
t_ind           = (samp_time > 14)&(samp_time <= 22);
t_ind_size = ((22-14)/50)*length(t_ind);
t_ind_samp = 1:t_ind_size;
elevation_desired(t_ind)    = 20 - (t_ind_samp.* (20./length(t_ind_samp)));
azimuth_desired(t_ind)      = 0 + (t_ind_samp.* (90./length(t_ind_samp)));
range_desired(t_ind)        = 120 - (t_ind_samp.* (50./length(t_ind_samp)));
% time interval [22 30)
t_ind           = (samp_time > 22)&(samp_time <= 30);
t_ind_size = ((30-22)/50)*length(t_ind);
t_ind_samp = 1:t_ind_size;
elevation_desired(t_ind)    = 0 - (t_ind_samp.* (20./length(t_ind_samp)));
azimuth_desired(t_ind)      = 90 + (t_ind_samp.* (90./length(t_ind_samp)));
range_desired(t_ind)        = 70 + (t_ind_samp.* (50./length(t_ind_samp)));

% time interval [30 38)
t_ind           = (samp_time > 30)&(samp_time <= 38);
t_ind_size = ((38-30)/50)*length(t_ind);
t_ind_samp = 1:t_ind_size;
elevation_desired(t_ind)    = -20 + (t_ind_samp.* (20./length(t_ind_samp)));
azimuth_desired(t_ind)      = 180 + (t_ind_samp.* (90./length(t_ind_samp)));
range_desired(t_ind)        = 120 - (t_ind_samp.* (50./length(t_ind_samp)));
% time interval [38 45)
t_ind           = (samp_time > 38)&(samp_time <= 45);
t_ind_size = ((45-38)/50)*length(t_ind);
t_ind_samp = 1:t_ind_size;
elevation_desired(t_ind)    = 0;
azimuth_desired(t_ind)      = 270 + (t_ind_samp.* (90./length(t_ind_samp)));
range_desired(t_ind)        = 70;
% time interval >= 45
t_ind           = (samp_time > 45);
elevation_desired(t_ind)    = 0;
azimuth_desired(t_ind)      = 0;
range_desired(t_ind)        = 70;



save(['./Results/Coordinates.mat'] , 'elevation_desired' , 'azimuth_desired' , 'range_desired');