


Wn=[0.3];

Blo16=fir1(16,Wn);
[Hlo16,w]=freqz(Blo16,1,2^18);

Blo128=fir1(128,Wn);
[Hlo128,w]=freqz(Blo128,1,2^18);

Blo1024=fir1(1024,Wn);
[Hlo1024,w]=freqz(Blo1024,1,2^18);

plot(w/pi,20*log10(abs([Hlo16 Hlo128 Hlo1024])),'LineWidth',2)
axis([0 1 -100 10])
grid
legend('length 17','length 129','length 1025')

pause
Blo128r=fir1(128,Wn,boxcar(129));
[Hlo128r,w]=freqz(Blo128r,1,2^18);

plot(w/pi,20*log10(abs([Hlo128 Hlo128r])),'LineWidth',2)
axis([0 1 -100 10])
grid
legend('Hamming','Rectangular')



