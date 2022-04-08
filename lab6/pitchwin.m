function f0 = pitchwin(x, fs, win)

f_max = 300;
lag_min = fs / f_max;

f0 = zeros(size(x));
for i=1 : win : length(x)-win
    x_tmp = x(i:i+win);
    [c, lags] = xcorr(x_tmp, "normalized");
    c = c(lags > lag_min);
    lags = lags(lags > lag_min);
    [pks, loc] = findpeaks(c, "MinPeakProminence", 0.2, "MinPeakWidth", 3);
    [peak, idx] = max(pks);
    if size(lags(loc(idx))) == [1 1]
        f0(i:i+win) = fs/lags(loc(idx));
%         disp("DOBRZE");
%     else
%         disp("ZLE");
    end
end

% t = linspace(0, length(x)/fs, length(x));
% [pks, loc] = findpeaks(c, "MinPeakProminence", 0.2, "MinPeakWidth", 3);
% subplot(2, 1, 1);
% plot(lags, c);
% plot(t, x);
% % hold on;
% % plot(lags(loc), pks, "x");
% 
% subplot(2, 1, 2);
% plot(t, f0');
% ylim([0 200]);

end
