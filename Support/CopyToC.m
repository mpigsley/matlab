function CopyToC(x)

% Style definitions that can be changed
entriesPerLine = 16;

% Create a commonly used C array (an array or 16-bit integers)
str = sprintf('int16_t x[] = \n{');

for i = 1:entriesPerLine:length(x)
    temp = sprintf('%6d, ', x(i:min(i + entriesPerLine - 1,length(x))));
    str = [str sprintf('\n    ') temp];
end

str = [str(1:end-1) sprintf('\n};')];

clipboard('copy', str);
end