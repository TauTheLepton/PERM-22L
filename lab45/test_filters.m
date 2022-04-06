%% wczytywanie sygnalu
[x, fs] = audioread("noised.wav");
%% parametry filtrow
fc1 = 0.2;
fc2 = 0.3;
BW = 0.0002;
window = "blackman";
%% sprawdzenie wszystkich filtrow
low_pass = create_low_pass(fc1, BW, window);
high_pass = create_high_pass(fc1, BW, window);
band_stop = create_band_stop(fc1, fc2, BW, window);
band_pass = create_band_pass(fc1, fc2, BW, window);
test_low_pass = conv(x, low_pass);
test_high_pass = conv(x, high_pass);
test_band_stop = conv(x, band_stop);
test_band_pass = conv(x, band_pass);
%% spektrogramy
subplot(2, 2, 1); spectrogram(test_low_pass, 'yaxis'); title('Low pass');
subplot(2, 2, 2); spectrogram(test_high_pass, 'yaxis'); title('High pass');
subplot(2, 2, 3); spectrogram(test_band_stop, 'yaxis'); title('Band stop');
subplot(2, 2, 4); spectrogram(test_band_pass, 'yaxis'); title('Band pass');
