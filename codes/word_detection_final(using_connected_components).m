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

%blob analysis
[Ilabel num]=bwlabel(Ifill);
disp(num);
figure,
imshow(Ilabel);
title('Ilabel image');
Iprops=regionprops(Ilabel);
Ibox=[Iprops.BoundingBox];
%reshaping
Ibox=reshape(Ibox,[4,num]);
figure,
imshow(Ifill);
title('Final Image');
%plotting the object loaction
hold on;
for cnt=1:num
    rectangle('position',Ibox(:,cnt),'edgecolor','r');
end
hold off;