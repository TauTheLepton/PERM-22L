%% wczytywanie sygnalu
[x, fs] = audioread("noised.wav");
%% parametry filtrow
BW = 0.005;
%% filtracja sygnalu
sig = x;
sig = conv(sig, create_band_stop(6000, 6250, BW, fs));
sig = conv(sig, create_band_stop(4000, 4250, BW, fs));
sig = conv(sig, create_high_pass(200, BW, fs));
%% spektrogramy
subplot(1, 2, 1); spectrogram(x, 'yaxis'); title('Original');
subplot(1, 2, 2); spectrogram(sig, 'yaxis'); title('Filtered');
%% zapisanie sygnalu i odsluchanie
% audiowrite("denoised.wav", sig, fs);
sound(sig, fs);
