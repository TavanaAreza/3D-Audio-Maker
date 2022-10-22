function [Left_ImpResp , Right_ImpResp]  = ImpResp_interpolator(SourcePosition , recording1 , recording2)
%
% [Left_ImpResp , Right_ImpResp]  = ImpResp_interpolator(SourcePosition , recording1 , recording2)
%
% This function estimates the impulse response of an audio source located
% at a given position with respect to head position of a listener for each 
% of the left and right ears.
%
% "SourcePosition" is a strcuture that includes the location of the source 
% with respect to the listener:
%       SourcePosition.elevation :  the elevation of the source in degrees
%       SourcePosition.azimuth :    the azimuth of the source in degrees
%       SourcePosition.range :      the distance of the source in cm
%
% "recording1" and "recording2" are two strcutures that consist of a number
% of measured impulse responses (to both ears) for a source located at 
% multiple locations with fixed range. The used range in "recording1" is
% different from "recording2":
%       recording.azimuth_degree:       the vector of azimuth angles
%       recording.elevation_degree:     the vector of elevation angles
%       recording.range_cm:             the value of range which is fixed
%       recording.ImpResp_LeftEar:      the matrix of impulse responses (left ear); each column is an impulse response
%       recording.ImpResp_RightEar:     the matrix of impulse responses (right ear); each column is an impulse response
%       recording.fs_Hz:                the sampling frequency used in recordings
%       recording.number_of_angles:     the sampling frequency used in recordings


% for a unit-length vector in the direction of "SourcePosition", we find 
% the inner-product with the unit-length vectors in the direction of all
% measured points in each of the recordings

innerproducts1      = zeros(recording1.number_of_angles  ,  1);
t_recording1 = 1 : recording1.number_of_angles;

innerproducts1(t_recording1) = (sin(SourcePosition.azimuth.*pi/180).*sin(recording1.azimuth_degree(t_recording1).*pi/180).*(cos((pi/180).*((90-SourcePosition.elevation) - ...
(90-recording1.elevation_degree(t_recording1)))))) + cos((SourcePosition.azimuth - recording1.azimuth_degree(t_recording1)).*pi/180);

innerproducts2      = zeros(recording2.number_of_angles  ,  1);
t_recording2 = 1 : recording2.number_of_angles;

innerproducts2(t_recording2) = (sin(SourcePosition.azimuth.*pi/180).*sin(recording2.azimuth_degree(t_recording2).*pi/180).*(cos((pi/180).*((90-SourcePosition.elevation) - ...
(90-recording2.elevation_degree(t_recording2)))))) + cos((SourcePosition.azimuth - recording2.azimuth_degree(t_recording2)).*pi/180);



% find  directions with inner-products no less that 0.9
ind1                = (innerproducts1 >= 0.9);
ind2                = (innerproducts2 >= 0.9);


%%%%%%%%%%%%%%%%%%%%%%
% interpolating to find the impulse responses
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Left ear with range1
Left_ImpResp1       = recording1.ImpResp_LeftEar(: , ind1) * (innerproducts1(ind1).^2);
Left_ImpResp1       = Left_ImpResp1 / sum(innerproducts1(ind1).^2);
% Left ear with range 2
Left_ImpResp2       = recording2.ImpResp_LeftEar(: , ind2) * (innerproducts2(ind2).^2);
Left_ImpResp2       = Left_ImpResp2 / sum(innerproducts2(ind2).^2);
% combining the two ranges
Left_ImpResp        = ( (recording2.range_cm - SourcePosition.range) * Left_ImpResp1 + ...
                        (SourcePosition.range - recording1.range_cm) * Left_ImpResp2 ) / ...
                        (recording2.range_cm - recording1.range_cm);

% Right ear with range1
Right_ImpResp1      = recording1.ImpResp_RightEar(: , ind1) * (innerproducts1(ind1).^2);
Right_ImpResp1      = Right_ImpResp1 / sum(innerproducts1(ind1).^2);
% Right ear with range 2
Right_ImpResp2      = recording2.ImpResp_RightEar(: , ind2) * (innerproducts2(ind2).^2);
Right_ImpResp2      = Right_ImpResp2 / sum(innerproducts2(ind2).^2);
% combining the two ranges
Right_ImpResp       = ( (recording2.range_cm - SourcePosition.range) * Right_ImpResp1 + ...
                        (SourcePosition.range - recording1.range_cm) * Right_ImpResp2 ) / ...
                        (recording2.range_cm - recording1.range_cm);