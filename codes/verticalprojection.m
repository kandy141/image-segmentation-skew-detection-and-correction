clear;
clc;
PEAK_DELTA_FACTOR = 6;

RGB = imread('ext.jpg');
size(RGB);
% Convert to intensity.
I  = rgb2gray(RGB);
im=I;
    % Transform the image in black and white
    level = graythresh(I);
    bw = im2bw(I,level);
    % Generate a histogram
    bw_trans = (bw(:,2:end) - bw(:,1:end-1)) ~= 0;
    im_hist = sum(bw_trans,2);
    %im_hist1=im_hist;
    % Smooth the histogram with a 1-D median filter
    im_hist = medfilt1(im_hist);
    % Find minima in histogram
    [max_peaks, min_peaks] = newPeakdet(im_hist, floor(max(im_hist)/PEAK_DELTA_FACTOR)); 
    % Plot the histogram
    figure, area(im_hist);
    hold on; 
    plot(min_peaks(:,1), min_peaks(:,2), 'r*');
    h = legend('Histogram of lines', 'Significant Minima');
    title('Vertical Histogram');
    % Plot the file with horizontal cuts
    x = 1:1:size(im,2);
    figure,
    imshow(im,[]);
    hold on
    plot(x, repmat(min_peaks(:,1), [1, size(im,2)]), '-');
    title('Original text segmented in lines');
    
    
    
    vp=[];
    for i=1:length(min_peaks(:,1))
    vp=sum((bw((i-1)*min_peaks(i)+1:i*min_peaks(i),:)));
    vp=medfilt1(vp);
    floor(max(vp)/2)
    [max_peaks1, min_peaks1] = newPeakdet(vp', floor(max(vp)/9));
    x1 = (i-1)*min_peaks(i)+1:i*min_peaks(i);
   figure,
   imshow((bw((i-1)*min_peaks(i)+1:i*min_peaks(i),:)));
    %imshow(im,[]);
    %hold on
   % plot(repmat(min_peaks1(:,1), [1, size(im,2)]),x , '|');
     % plot(x1,repmat((min_peaks1(:,1)),[1,size(x1,2)]) , '-');
    
    %plot(repmat((min_peaks1(:,1)),[1,size(x1,2)]),x1 , '|');
    
    end
    
    
    
    