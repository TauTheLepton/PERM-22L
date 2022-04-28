% data = {};
% names = ["lewo_1.wav" "lewo_2.wav" "lewo_3.wav"...
%     "prawo_1.wav" "prawo_2.wav" "prawo_3.wav"...
%     "start_1.wav" "start_2.wav" "start_3.wav"...
%     "stop_1.wav" "stop_2.wav" "stop_3.wav"]';
% labels = [1 1 1 2 2 2 3 3 3 4 4 4];
% 
% [~, fs] = audioread(names{1});
% for i=1:length(names)
%     data{i} = audioread(names(i));
%     data{i} = data{i} / max(data{i});
% end
% 
% train_ids = [1 2 4 5 7 8 10 11];
% test_ids = [3 6 9 12];
clear;
[data, fs, train_ids, train_lbl, test_ids, test_lbl] = load_data();

tmp = extract(data{1}, fs);
feats = zeros(length(tmp), length(data));
for k=1:length(data)
    feats(:,k) = extract(data{k}, fs);
end

% test
[model, model_labels] = fit_geom(feats(:, train_ids), train_lbl);
[predictions, dist] = predict_geom(feats(:, test_ids), model, model_labels);
disp(append("Geom: ", string(mean(predictions == test_lbl))))

[model, model_labels] = fit_my(feats(:,train_ids), train_lbl);
[predictions, dist] = predict_my(feats(:, test_ids), model, model_labels);
disp(append("My: ", string(mean(predictions == test_lbl))))

clf;
hold on;
plot(dist);
plot((predictions == test_lbl)*0.2 + 0.5)

%% stream
% stream = audioread('data/stream.wav');
% 
% len = round(0.8 * fs);
% overlap = round(0.1 * fs);
% 
% predictions = zeros(length(stream), 1);
% dist = zeros(length(stream), 1);
% 
% for i = 1 : overlap : length(stream) - len
%     r = stream(k:k+len);
%     r = r / max(r);
%     f = extract(r, fs);
%     [predictions(k:k+len), dist(k:k+len)] = predict_geom(f, model, model_labels);
% end
% 
% predictions(dist > 0.3) = 0; % odfiltrowanie slabego dopasowania

%% funkcje
function [model, labels_new] = fit_geom(feats, labels)
cls_num = max(labels);
model = zeros(size(feats,1), cls_num);
for i = 1 : cls_num
    model(:,i) = mean(feats(:,labels==i), 2);
end
labels_new = 1:cls_num;
end

function [labels_new, dist] = predict_geom(feats, model, labels)
dm = pdist2(feats', model', 'cosine');
[dist, min_idx] = min(dm, [], 2);
labels_new = labels(min_idx);
end

function [model, labels_new] = fit_my(feats, labels)
model = feats;
labels_new = labels;
end

function [labels_new, dist] = predict_my(feats, model, labels)
dm = pdist2(feats', model', 'cosine');
for i = 1 : size(dm,1)
    for j = 1 : max(labels)
        mn(i, j) = mean(dm(i, labels==j));
    end
end
[dist, labels_new] = min(mn, [], 2);
labels_new = labels_new';
% [dist, min_idx] = min(dm, [], 2);
% labels_new = labels(min_idx);
end

function f = extract(x, fs)
nfft = 512;
f = pwelch(x, 512, 256, nfft, fs);
f = f / max(f);
end

function [data, fs, train_ids, train_lbl, test_ids, test_lbl] = load_data()
train_subjects = [1 2 5 7 8 9 10 12 14 15 16 17 18 19 20 22 23];
test_subjects = [3 4 6 11 13 21];

N1 = length(train_subjects);
N2 = length(test_subjects);

files = {};

lbl = [1 1 1 2 2 2 3 3 3 4 4 4];

train_ids = 1:(N1*12);
train_lbl = repmat(lbl, 1, N1);

test_ids = (N1*12+1):((N1+N2)*12);
test_lbl = repmat(lbl, 1, N2);

names = {
    'prawo'
    'lewo'
    'stop'
    'start'
};

for k=1:N1
    for n=1:length(names)
        for f=1:3
            s = sprintf("data/%02d/%s_%d.wav", train_subjects(k), names{n}, f);
            files{end+1,1} = s;
        end
    end
end

for k=1:N2
    for n=1:length(names)
        for f=1:3
            s = sprintf("data/%02d/%s_%d.wav", test_subjects(k), names{n}, f);
            files{end+1,1} = s;
        end
    end
end

% zakładamy takie samo fs dla wszystkich nagrań
[~, fs] = audioread(files{1});

data = {};

for k=1:length(files)
    data{k} = audioread(files{k});
end
end

function [data, fs, train_ids, train_lbl, test_ids, test_lbl] = load_stream()
% train_subjects = [1 2 5 7 8 9 10 12 14 15 16 17 18 19 20 22 23];
% folder 12 pusty
subjects = [1 2 3 4 5 6 7 8 9 10 11 13 14 15 16 17 18 19 20 21 22 23];
% test_subjects = [3 4 6 11 13 21];

N1 = length(subjects);
% N2 = length(test_subjects);

files = {};

lbl = [1 1 1 2 2 2 3 3 3 4 4 4];

train_ids = 1:(N1*12);
train_lbl = repmat(lbl, 1, N1);

test_ids = (N1*12+1):((N1+N2)*12);
test_lbl = repmat(lbl, 1, N2);

names = {
    'prawo'
    'lewo'
    'stop'
    'start'
};

for k=1:N1
    for n=1:length(names)
        for f=1:3
            s = sprintf("data/%02d/%s_%d.wav", train_subjects(k), names{n}, f);
            files{end+1,1} = s;
        end
    end
end

for k=1:N2
    for n=1:length(names)
        for f=1:3
            s = sprintf("data/%02d/%s_%d.wav", test_subjects(k), names{n}, f);
            files{end+1,1} = s;
        end
    end
end

% zakładamy takie samo fs dla wszystkich nagrań
[~, fs] = audioread(files{1});

data = {};

for k=1:length(files)
    data{k} = audioread(files{k});
end
end
