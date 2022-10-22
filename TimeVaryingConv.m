% the main loop for generating the outputs; instead of sample by sample
% generation, we consider blocks of length "jump_length" to expedite
jump_length             = 100;
%
h                       = waitbar(0 , 'Please wait');
for jump_ind = 1 : ceil(length(Input_Audio_samples) / jump_length)
    %jump_ind
    waitbar(jump_ind * jump_length / length(Input_Audio_samples))
    
    % the next block of audio samples
    t_interval          = [1+ (jump_ind-1) * jump_length  :  min(jump_ind * jump_length , length(Input_Audio_samples)) ];
    samples             = Input_Audio_samples(t_interval);
    
    
    % the position of the audio source in the middle of the time interval
    current.elevation   = elevation_desired( floor(mean(t_interval)) );
    current.azimuth     = azimuth_desired( floor(mean(t_interval)) );
    current.range       = range_desired( floor(mean(t_interval)) );
    
    % estimating the impulse response for each of the left and right ears
    % based on the current location
    [Left_ImpResp , Right_ImpResp]  = ImpResp_interpolator(current , far , near);
        
        
    % time-varying colvolution
    Range_L             = [t_interval(1)  :  t_interval(end) + length(Left_ImpResp)-1];
    Output_Audio_Left(Range_L)      = Output_Audio_Left(Range_L) + ...
                                      conv(samples , Left_ImpResp);
        
    % time-varying colvolution
    Range_R             = [t_interval(1)  :  t_interval(end) + length(Right_ImpResp)-1];
    Output_Audio_Right(Range_R)     = Output_Audio_Right(Range_R) + ...
                                      conv(samples , Right_ImpResp);
                              
    
end
close(h)