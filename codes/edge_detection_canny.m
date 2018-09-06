clear;
clc;
RGB = imread('ext.jpg');
size(RGB)
% Convert to intensity.
I  = rgb2gray(RGB);

% Extract edges.
BW = edge(I,'canny');
size(BW)
figure(12);
imshow(BW);
figure(13);
thetha_plot(I,BW,RGB);

