[x, fs] = audioread("aeiouy.wav");
% function f0 = pitchwin(x, fs, win)
% x = x - mean(x);
% x = x / max(x);

% długość okna analizy: 200 ms
win = round(fs * 0.1);

% energia chwilowa
ste = conv(x.^2, ones(1,win), 'same');
ste = ste / max(ste);

% wersja z pierwiastkiem
str = sqrt(ste);

speech = str > 0.05;
% f0 = speech;

% frekwencja bazowa

f_max = 300;
lag_min = fs / f_max;

f0 = zeros(size(x));
for i=1:win:length(x)-win

    [c, lags] = xcorr(x(i:i+win), "normalized");
    c = c(lags > lag_min);
    lags = lags(lags > lag_min);
    [pks, loc] = findpeaks(c, "MinPeakProminence", 0.2, "MinPeakWidth", 3);
    
    [peak, idx] = maxk(pks, 1);
    peak;
    lags(loc(idx));
    if size(lags(loc(idx))) == [1 0]
        pass=0;
    else
        f0(i:i+win) = lags(loc(idx));
    end
end
t = linspace(0, length(x)/fs, length(x));
subplot(2, 1, 1);
% plot(lags, c);
plot(t, x);
subplot(2, 1, 2);
plot(t, f0);
ylim([0 200]);
% hold on;
% plot(lags(loc),s pks, "x");
% xlim([0 0.5])

% end

