function low_pass = create_low_pass(fc, BW, fs)
fc = fc/fs;
M = 4 / BW;
t = (-M/2 : 1 : M/2);
t_moved = (0 : 1 : M);
h = (sin(2*pi*fc*t) ./ t);
h(M/2+1) = 2*pi*fc;
h = h / sum(h);
%% okno
window = "blackman";
hamming = 0.54 - 0.46 * cos(2*pi*t_moved/M);
blackman = 0.42 - 0.5 * cos(2*pi*t_moved/M) + 0.08 * cos(4*pi*t_moved/M);
if window == "hamming"
    low_pass = h .* hamming;
elseif window == "blackman"
    low_pass = h .* blackman;
end
%% plot
% subplot(2, 2, 1);
% plot(t_moved, h);
% title('Funkcja Sinc')
% 
% subplot(2, 2, 2);
% plot(t_moved, blackman);
% title('Okno Blackmana')
% 
% subplot(2, 2, 3);
% plot(t_moved, kernel);
% title('Kernel')
% 
% result = fft(kernel); % fourier, nwm po co
% subplot(2, 2, 4);
% plot(result);
% title('Fourier kernela')
end
