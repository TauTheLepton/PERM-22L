%% wczytywanie sygnalu
[x, fs] = audioread("noised.wav");
% win_len = 1024;
% win_overlap = 512;
% nfft = 512;
%% parametry filtrow
% Częstotliwość progowa jest wyrażona jako ułamek częstotliwości
% próbkowania, a zatem musi wynosić od 0 do 0.5.
fc = 0.2;

% Wartość dla M odpowiada wymaganej szerokości pasma przejściowego:
% M ~= 4 / BW
% gdzie BW jest szerokością pasma przejściowego, mierzoną od miejsca,
% w którym krzywa ledwo opuszcza wartość 1, do miejsca, w którym prawie
% osiąga zero (powiedzmy: 99% do 1% ). Szerokość pasma przejściowego jest
% wyrażona jako ułamek częstotliwości próbkowania – stąd musi wynosić od 0
% do 0.5.
BW = 0.0002;
window = "blackman";
%% filtracja sygnalu
sig = x;
sig = conv(sig, create_band_stop(0.49/2, 0.53/2, BW, window));
sig = conv(sig, create_band_stop(0.75/2, 0.79/2, BW, window));
sig = conv(sig, create_band_stop(0.93/2, 0.95/2, BW, window));
sig = conv(sig, create_band_stop(0.2/2, 0.25/2, BW, window));
sig = conv(sig, create_band_stop(0.000001/2, 0.05/2, BW, window));
%% spektrogramy
subplot(1, 2, 1); spectrogram(x, 'yaxis'); title('Original');
subplot(1, 2, 2); spectrogram(sig, 'yaxis'); title('Filtered');
%% zapisanie sygnalu i odsluchanie
% audiowrite("denoised.wav", sig, fs);
sound(sig, fs);
