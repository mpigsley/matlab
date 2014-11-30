function[Result] = ParseCCSDatFile(varargin)
% CCS Dat file parser
%   1) Save memory with CCS Tools->Save Memory
%   2) Name file with .dat extension
%   3) Select 16-bit Hex TI Style, memory address and word length
% 
% NOTE: THIS SCRIPT ASSUMES DATA IS SIGNED 16-BIT INTEGERS

% Open file
if length(varargin) == 0
    [FileName,PathName] = uigetfile('*.dat');
    FID = fopen([PathName FileName], 'r');
else
    FID = fopen(varargin{1}, 'r');
end

if FID == -1
    error('fopen error');
end

Result = [];

% Remove header
Header = fscanf(FID, '%x', 6);

% read data as signed hexidecimal integers
Data = fscanf(FID, '%x');
        
% Close file
fclose(FID);

% Data contains 16 bit unsigned numbers.  Unpack and place 16 bit signed integers
% in Result
for i = 1:length(Data)
    word = Data(i);
    if (word > 32767)
        word = word - (2^16);
    end
    Result = [Result word];
end