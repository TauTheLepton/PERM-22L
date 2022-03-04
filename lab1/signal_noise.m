% Parametry systemu
Fs = 1000;     % Częstotliwość próbkowania [Hz]
T = 1/Fs;      % Okres próbkowania [s]
L = 2000;      % Długość sygnału (liczba próbek)
t = (0:L-1)*T; % Podstawa czasu

% Przygotowanie sygnału
N = 3;               % Liczba sinusoid w mieszaninie
A = [1.0   0.4  0.8] % Amplitudy kolejnych sinusoid
B = [ 15    27   83] % Częstotliwości kolejnych sygnałów [Hz]
C = [  0 -pi/3 pi/7] % Przesunięcia fazowe kolejnych sygnałów


x = zeros(size(t));
for i = 1:N
  x = x + A(i) * cos(2 * pi * B(i) * t + C(i));
end
x_orig = x;
x=x+randn(size(t))/3;

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
% figure;
subplot(2, 1, 2)
plot(f, F);        % wykres fazowy

odtw = zeros(size(t));
[maxA, maxI] = maxk(A, 3);
freq = maxI;
freq = freq - 1;
freq = freq/2;
maxA
maxI
freq
for i=1:3
    odtw = odtw + maxA(i) * cos(2 * pi * freq(i) * t + F(maxI(i)));
end

plot_size = 300;
figure; plot(x(1:plot_size));
hold on; plot(odtw(1:plot_size));
legend('Original with noise', 'Recreated');

figure; plot(x_orig(1:plot_size));
hold on; plot(odtw(1:plot_size));
legend('Original without noise', 'Recreated');
