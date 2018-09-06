clear;
clc;
[F,P]=uigetfile('*.pgm;*.jpg;*.jpeg;*.tif;*.tiff;*.bmp;*.png;*.hdf;*.pcx;*.xwd','Choose Image');
PF=[P,F];
ext=PF(findstr(PF,'.')+1:end);
%Reading the selected image
[Im,MAP]=imread(PF);
%converting to gray scale
I = rgb2gray(Im);
%Binarizing the image
I=im2bw(I, graythresh(I));
%Complementing the image
I=imcomplement(I);
figure,
imshow(I);
title('Complemented binary image');
%CC = bwconncomp(I,8);

%Morphology
Ifill=imfill(I,'holes');
figure,
imshow(Ifill);
title('Image filled with holes');
figure,
imshow(Ifill);
title('Final Image');
hold on;

%66666666666666666666
boundaries = bwboundaries(Ifill);
numberOfBoundaries = size(boundaries);
for k = 1 : numberOfBoundaries
    thisBoundary = boundaries{k};
    if(k==36)
    plot(thisBoundary(:,2), thisBoundary(:,1), 'g', 'LineWidth', 2);
    end
    %rectangle('position',thisBoundary(:,2),'edgecolor','r');
end
%66666666666666666666