clear;
clc;
%/////////////
[F,P]=uigetfile('*.pgm;*.jpg;*.jpeg;*.tif;*.tiff;*.bmp;*.png;*.hdf;*.pcx;*.xwd','Choose Image');
PF=[P,F];
ext=PF(findstr(PF,'.')+1:end);
[Im,MAP]=imread(PF);
%converting to gray scale
I = rgb2gray(Im);
%Binarizing the image
I=im2bw(I, graythresh(I));
%Complementing the image
I=imcomplement(I);
for i=1:100
    se = strel('line',3,0);
    bw2 = imdilate(I,se);
   % bw2 = imdilate(I,ones(1));
end;
bw4=bw2;
bw3=imcomplement(bw2);
%Image eroding
bw2 = imerode(bw2,se);
figure,
imshow(imcomplement(bw2)), title('1st eroded')
%Image morphing(skeletonization)
BW2 = bwmorph((bw2),'skel',1);
figure,
imshow(imcomplement(BW2)), title('2nd morphology')
I=imcomplement(I);
bw2=imcomplement(bw2);
%s=ones(3);
%i=(conv2(double(I),s,'same')>0)

%figure(2);
%imshow(I), title('Original')
figure,
imshow(bw3), title('Dilated')
%B = bwboundaries(BW2);
figure,
%[B,L] = bwboundaries(bw2,'noholes');
%imshow(label2rgb(L, @jet, [.5 .5 .5]))
%hold on
%for k = 1:length(B)
 %   boundary = B{k};
 %   plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)
%end


%-----------------------------------------

[B,L,N] = bwboundaries(bw2,'noholes');
figure; imshow(bw2); hold on;
for k=1:length(B),
    boundary = B{k};
    if(k > N)
        plot(boundary(:,2),...
            boundary(:,1),'g','LineWidth',2);
    else
        plot(boundary(:,2),...
            boundary(:,1),'r','LineWidth',2);
    end
end
%-------------------------------------------------------------------------
%figure(4);
%imshow(B),title('detected boundaries')
%callingCVimage(Im,imcomplement(bw4));
callingCVimage(Im,(bw4));