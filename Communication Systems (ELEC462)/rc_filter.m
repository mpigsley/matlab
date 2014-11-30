function [b,a] = rc_filter(R, C, Fs, filter_type)
% Returns equivalent IIR coefficients for an analog RC filter
%
% Usage:     [B,A] = RC_FILTER(r, c, fs, type);
%
%             R is the resistance value (in ohms)
%             C is the capacitance value (in farrads)
%             FS is the digital sample rate (in Hz)
%             type is a character string defining filter type
%                 Choices are: 'high' or 'low'
%
% Highpass filters have the analog structure:
%
%
%                  | | 
%     Vi  o--------| |----------+---------o  Vo
%                  | |          |
%                     C         | 
%                              --- 
%                              | |  R
%                              | | 
%                              ---   
%                               |
%                               |
%         o---------------------+---------o
%                              GND
%
%
% Lowpass filters have the analog structure:
%
%
%                  |-----| 
%     Vi  o--------|     |------+---------o  Vo
%                  |-----|      |
%                     R         | 
%                             ----- C
%                             ----- 
%                               | 
%                               |
%         o---------------------+---------o
%                              GND
%
% This function uses a pre-calculated equation for both of these circuits
% that only requires the resistance and capacitance value to get a true
% digital filter equivalent to a basic analog filter.
%
% The math behind these equations is based off the basic bilinear transform
% technique that can be found in many DSP textbooks.  The reference paper
% for this function was "Conversion of Analog to Digital Transfer 
% Functions" by C. Sidney Burrus, page 6.
%
% This is also the equivalent of a 1st order butterworth with a cuttoff
% frequency of Fc = 1/(2*pi*R*C);
%
% Author: Jeff Tackett 07/01/09
%

% Default to allpass if invalid type is selected
b = [ 1 0 ];
a = [ 1 0 ];

% Constants
RC = R * C;
T  = 1 / Fs;

% Analog Cutoff Fc
w = 1 / (RC);

% Prewarped coefficient for Bilinear transform
A = 1 / (tan((w*T) / 2));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The following equations were derived from
%
%            s
% T(s) =  -------
%          s + 1
%
%
% using Bilinear transform of
%
%             1          ( 1 - z^-1 )
% s -->  -----------  *  ------------
%         tan(w*T/2)     ( 1 + z^-1 )
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(strcmp(filter_type,'high'))
    
    b(1) = (A)     / (1 + A);
    b(2) = -b(1);
    a(2) = (1 - A) / (1 + A);

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The following equations were derived from
%
%            1
% T(s) =  -------
%          s + 1
%
%
% using Bilinear transform of
%
%             1          ( 1 - z^-1 )
% s -->  -----------  *  ------------
%         tan(w*T/2)     ( 1 + z^-1 )
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(strcmp(filter_type,'low'))
    
    b(1) = (1)     / (1 + A);
    b(2) = b(1);
    a(2) = (1 - A) / (1 + A);

end