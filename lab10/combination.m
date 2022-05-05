clear;
close all;

I1c = imread('974-1.jpg');
I2c = imread('975-1.jpg');

I1 = rgb2gray(I1c);
I2 = rgb2gray(I2c);

% Find the SURF features. MetricThreshold controls the number of detected
% points. To get more points make the threshold lower.
points1 = detectSURFFeatures(I1, 'MetricThreshold', 1000);
points2 = detectSURFFeatures(I2, 'MetricThreshold', 1000);

% Extract the features.
[f1,vpts1] = extractFeatures(I1, points1);
[f2,vpts2] = extractFeatures(I2, points2);

% Match points and retrieve the locations of matched points.
indexPairs = matchFeatures(f1,f2, 'MaxRatio', 1, "MatchThreshold", 1.0) ;
matchedPoints1 = vpts1(indexPairs(:,1));
matchedPoints2 = vpts2(indexPairs(:,2));

% Extract point pairs
pts1 = double(vpts1(indexPairs(:,1)).Location);
pts2 = double(vpts2(indexPairs(:,2)).Location);

[tform, inlierPoints1, inlierPoints2] = estimateGeometricTransform(matchedPoints1, matchedPoints2, 'projective', 'MaxDistance', 1.5);
figure;
showMatchedFeatures(I1, I2, inlierPoints1, inlierPoints2, 'montage');
title('Właściwe dopasowania');

[J, ref1] = imwarp(I1c, tform);
ref2 = imref2d(size(I2));
figure;
imshowpair(J, ref1, I2c, ref2, 'blend');
