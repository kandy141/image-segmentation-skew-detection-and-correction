clear;
clc;
%/////////////
[F,P]=uigetfile('*.pgm;*.jpg;*.jpeg;*.tif;*.tiff;*.bmp;*.png;*.hdf;*.pcx;*.xwd','Choose Image');
PF=[P,F];
ext=PF(findstr(PF,'.')+1:end);
[RGB,MAP]=imread(PF);
%converting to gray scale
I= rgb2gray(RGB);
%Binarizing the image
x=RGB;
size(x);
x=imresize(x,[500 800]);
figure;
imshow(x);
title('original image');

z=rgb2hsv(x);       %extract the value part of hsv plane
v=z(:,:,3);
v=imadjust(v);
%now we find the mean and standard deviation required for niblack and %sauvola algorithms

m = mean(v(:))
s=std(v(:))
k=-.4;
value=m+ k*s;
temp=v;
val2=m*(1+.1*((s/128)-1));
t2=v;
for p=1:1:500
for q=1:1:800
    pixel=t2(p,q);
    if(pixel>value)
        t2(p,q)=1;
    else
        t2(p,q)=0;
    end
end
end

figure;
imshow(t2);
title('result by sauvola');



BW=im2bw(I, graythresh(I));
%Complementing the image
cc1 = bwconncomp(BW)
figure,
labeled = labelmatrix(cc1);
RGB_label = label2rgb(labeled, @copper, 'c', 'shuffle');
imshow(RGB_label,'InitialMagnification','fit')
title('Before complementing')
