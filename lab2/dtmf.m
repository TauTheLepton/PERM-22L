function out = dtmf(x, fs)
% x - wektor próbek audio
% fs - częstotliwość próbkowania

% % możliwe etykiety danych
% labels = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "*", "0", "#"];

%% moje rozwiazanie
win_len = 1024;     % wielkość okna do analizy
win_overlap = 512; % nakładanie ramek
nfft = 512;        % liczba próbek do FFT

% wyznaczenie widma częstotliwości w oknach i wyznaczenie amplitudy funkcji składowych
[s, f, t] = spectrogram(x, win_len, win_overlap, nfft, fs);
A = abs(s) / nfft;

freq_list = [697 770 852 941 1209 1336 1477];

[lenf, lent] = size(A);
my_sum = zeros(1, lent);
for freq=freq_list
    idx = 0;
    for i=1:length(f)
        if freq > f(i)
            idx = i;
        end
    end
    my_sum = my_sum + A(idx,:);
end

peak_list = [];
status = 0; % 0 - szczyt; 1 - podloga
for i=1:length(my_sum)
    if status == 0
        if my_sum(i) > 0.02
            status = 1;
            tmp = i;
        end
    else
        if my_sum(i) < 0.02
            status = 0;
            tmp = floor((tmp + i)/2);
            peak_list = [peak_list; tmp];
        end
    end
end
% peak_list
results = [];
for i=1:length(peak_list)
    [peaks, peaks_idx] = maxk(A(:, peak_list(i)),2);
    temp_results = [];
    for j=1:length(peaks_idx)
        temp_results = [temp_results f(peaks_idx(j))];
    end
    results = [results; sort(temp_results)];
end

results_small = results(:, 1);
results_big = results(:, 2);
dict_small = [697 770 852 941];
dict_big = [1209 1336 1477];
dict_symbols = [1 2 3 4 5 6 7 8 9 "*" 0 "#"];

best_small = [];
for i=1:length(results_small)
    best_match = 0;
    smallest_error = inf;
    for j=1:length(dict_small)
        error = abs(results_small(i) - dict_small(j));
        if error < smallest_error
            smallest_error = error;
            best_match = j;
        end
    end
    best_small = [best_small; best_match];
end

best_big = [];
for i=1:length(results_big)
    nest_match = 0;
    smallest_error = inf;
    for j=1:length(dict_big)
        error = abs(results_big(i) - dict_big(j));
        if error < smallest_error
            smallest_error = error;
            best_match = j;
        end
    end
    best_big = [best_big; best_match];
end

best_indexes = [];
for i=1:length(best_big)
    best_idx = (best_small(i) - 1)*3 + best_big(i);
    best_indexes = [best_indexes; best_idx];
end

symbols = dict_symbols(best_indexes);
out = symbols;
end
