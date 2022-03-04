% Liczba ramek do wczytania (przy 10 sekundach i 30 FPS będzie to 300)
N = 321;

% wektor jasności
br = zeros(1, N);

% lista obrazów do analizy
imds = imageDatastore('movie', 'FileExtension', '.jpg');

% alternatywnie można załadować bezpośrednio plik wideo
% v = VideoReader('movie.mp4');


% wczytanie pierwszych N obrazów i analiza jasności
for i=1:N
    % wczytujemy obraz i przekształcamy go do skali szarości
    I = rgb2gray(imread(imds.Files{i}));
    % dla pliku wideo ładowanie ramki z otwartego źródła
    % I = rgb2gray(read(v,i));

    % wyznaczamy średnią z całego obrazu
    br(i) = mean(I, 'all');
end

% dla ułatwienia późniejszej analizy od razu można odjąć od sygnału składową stałą
br = br - mean(br);

% Parametry systemu
Fs = 30;     % Częstotliwość próbkowania [Hz]
T = 1/Fs;      % Okres próbkowania [s]
L = N;         % Długość sygnału (liczba próbek)
t = (0:L-1)*T; % Podstawa czasu

x = br;
Y = fft(x);     % transformata Fouriera

A = abs(Y);     % amplituda sygnału
A = A/L;        % normalizacja amplitudy

A = A(1:L/2+1); % wycięcie istotnej części spektrum
A(2:end-1) = 2*A(2:end-1);

F = angle(Y);   % faza sygnału
F = F(1:L/2+1); % wycięcie istotnej części spektrum

f_step = Fs/L;     % zmiana częstotliwości
f = 0:f_step:Fs/2; % oś częstotliwości do wykresu

figure;
subplot(2, 1, 1)
plot(f, A);        % wykres amplitudowy
subplot(2, 1, 2)
plot(f, F);        % wykres fazowy

[maxA, maxI] = maxk(A, 1);
bmp = f(maxI)*60

plot_size = 300;
figure; plot(br(1:plot_size));
