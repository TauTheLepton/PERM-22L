data = {};
names = ["lewo_1.wav" "lewo_2.wav" "lewo_3.wav"...
    "prawo_1.wav" "prawo_2.wav" "prawo_3.wav"...
    "start_1.wav" "start_2.wav" "start_3.wav"...
    "stop_1.wav" "stop_2.wav" "stop_3.wav"]';
labels = [1 1 1 2 2 2 3 3 3 4 4 4];

[~, fs] = audioread(names{1});
for i=1:length(names)
    data{i} = audioread(names(i));
    data{i} = data{i} / max(data{i});
end

train_ids = [1 2 4 5 7 8 10 11];
test_ids = [3 6 9 12];

tmp = extract(data{1}, fs);
feats = zeros(length(tmp), length(data));
for k=1:length(data)
    feats(:,k) = extract(data{k}, fs);
end

% test
[model, model_labels] = fit_geom(feats(:, train_ids), labels(train_ids));
[predictions, dist] = predict_geom(feats(:, test_ids), model, model_labels)

[model, model_labels] = fit_my(feats(:,train_ids), labels(train_ids));
[predictions, dist] = predict_my(feats(:, test_ids), model, model_labels)

%% stream
stream = audioread('data/stream.wav');

len = round(0.8 * fs);
overlap = round(0.1 * fs);

predictions = zeros(length(stream), 1);
dist = zeros(length(stream), 1);

for i = 1 : overlap : length(stream) - len
    r = stream(k:k+len);
    r = r / max(r);
    f = extract(r, fs);
    [predictions(k:k+len), dist(k:k+len)] = predict_geom(f, model, model_labels);
end

predictions(dist > 0.3) = 0; % odfiltrowanie slabego dopasowania

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
nfft = 256;
f = pwelch(x, 512, 256, nfft, fs);
f = f / max(f);
end

function preds = predict(data, labels, x)

end
