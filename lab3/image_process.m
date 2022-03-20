%% wczytywanie obrazu
% Liczba ramek do wczytania (przy 10 sekundach i 30 FPS będzie to 300)
N = 321;

% wektor jasności
br = zeros(1, N);

% lista obrazów do analizy
imds = imageDatastore('../lab1/movie', 'FileExtension', '.jpg');

% wczytanie pierwszych N obrazów i analiza jasności
for i=1:N
	% wczytujemy obraz i przekształcamy go do skali szarości
	I = rgb2gray(imread(imds.Files{i}));

	% wyznaczamy średnią z całego obrazu
	br(i) = mean(I, 'all');
end

% dla ułatwienia późniejszej analizy od razu można odjąć od sygnału składową stałą
br = br - mean(br);

%% dodawanie filtrow

% filtrowanie sygnału
f3 = ones(1,3) / 3;
c3 = conv(br, f3, 'same');

f15 = ones(1,15) / 15;
c15 = conv(br, f15, 'same');

g3 = fspecial('gaussian', [1,  3], 1);
cg3 = conv(br, g3, 'same');

g15 = fspecial('gaussian', [1, 15], 3);
cg15 = conv(br, g15, 'same');

% dodaj filrowanie
br = cg15;

%% znajdowanie tetna autokorelacja

[r1, lags] = xcorr(br);
% wycięcie jedynie dodatnich przesunięć
r1 = r1(lags >= 0);
lags = lags(lags >= 0);

[pks, loc] = findpeaks(r1, "MinPeakDistance", 10, "MinPeakProminence", 20);
fs = 30;

% przesunięcie w sekundach
lag_s = lags(loc(1)) * 1/fs;

% częstotliwość bazowa
freq = 1/lag_s;
bmp = freq * 60

figure;
subplot(2, 1, 1);
plot(br);
subplot(2, 1, 2);
plot(r1);
