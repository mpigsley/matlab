ParseCCSDatFile('G:\General Files\Code Composer Workspace\bios_dft_analyzer\data.dat');
re = ans(1:2:end);
im = ans(2:2:end);
mag = round(16*(sqrt(re.^2 + im.^2)/32767));
plot(mag);