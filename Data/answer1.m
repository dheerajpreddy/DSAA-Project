load('DATA_01_TYPE01.mat');

% Read data input
x1 = sig(2, :);
x2 = sig(3, :);
% Adding both channels of ppg
x = x1 + x2;

% Fs = 125;
% L = 37937;
% F=(-L/2:L/2-1)*Fs/L;
% figure;
% plot(F, fftshift(abs((fft(x)))));

% Filtering noise. Only allowing 0.5 Hz to 4 Hz
[b,a]=butter(1,[0.5 4]/(125/2),'bandpass');
out = filter(b, a, x);

% figure;
% plot(F, fftshift(abs(fft(out))));


