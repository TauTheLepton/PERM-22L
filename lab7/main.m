data = {};
names = ["lewo_1.wav" "lewo_2.wav" "lewo_3.wav"...
    "prawo_1.wav" "prawo_2.wav" "prawo_3.wav"...
    "start_1.wav" "start_2.wav" "start_3.wav"...
    "stop_1.wav" "stop_2.wav" "stop_3.wav"]';
for i=1:length(names)
    [data{i}, fs] = audioread("lewo_1.wav");
end


function preds = predict(data, labels, x)

end
