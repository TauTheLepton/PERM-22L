function lbls = label(x, fs)

lbls = zeros(size(x));
voiced_threshold = 0.4;
speech_threshold = 0.06;

win = 100;
win = round(fs * 0.025);

% x = x - mean(x);
% x = x / max(x);

% energia chwilowa
ste = conv(x.^2, ones(1,win), 'same');
ste = ste / max(ste);

% wersja z pierwiastkiem
str = sqrt(ste);

speech = zeros(size(x));
zcrs = zeros(size(x));
for i = 1 : win : length(x)-win
    if mean(str(i:i+win)) > speech_threshold
        speech(i:i+win) = 1;
    end
    zcr = zerocrossrate(x(i:i+win));
    zcrs(i:i+win) = zcr;
    if zcr > voiced_threshold
        lbls(i:i+win) = 1; % bezdzwieczne
    else
        lbls(i:i+win) = 2; % dzwieczne
    end
end
lbls = lbls .* speech;

% subplot(2, 1, 1);
% hold on;
% stairs(x);
% stairs(lbls);
% hold off;
% subplot(2, 1, 2);
% stairs(zcrs)

end
