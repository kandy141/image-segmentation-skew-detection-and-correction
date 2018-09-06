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
%Ifill=bwmorph(Ifill,'fill',Inf);
se = strel('line',3,0);
for i=1:3
    %se=strel('square',10);
    Ifill = imdilate(Ifill,se);
    if(mod(i,2)==0)
    Ifill=imerode(Ifill,se);
    end;
    % bw2 = imdilate(I,ones(1));
end;


figure,
imshow(Ifill);
title('Dilated using fill');

%blob analysis
[Ilabel num]=bwlabel(Ifill);
disp(num);
figure,
imshow(Ilabel);
title('Ilabel image');
%Ibox=regionprops(Ilabel,'Orientation');
s = regionprops(Ilabel, 'Orientation', 'MajorAxisLength', 'MinorAxisLength', 'Eccentricity','Centroid');
%Ibox=[Iprops.Orientation];
figure,
imshow(Im)
hold on
phi = linspace(0,2*pi,50);
cosphi = cos(phi);
sinphi = sin(phi);
xmin=[];
ymin=[];
xmax=[];
ymax=[];
orient=[];
for k = 1:length(s)
    xbar = s(k).Centroid(1);
    ybar = s(k).Centroid(2);

    a = s(k).MajorAxisLength/2;
    b = s(k).MinorAxisLength/2;

    theta = pi*s(k).Orientation/180;
    R = [ cos(theta)   sin(theta)
         -sin(theta)   cos(theta)];

    xy = [a*cosphi; b*sinphi];
    xy = R*xy;

    x = xy(1,:) + xbar;
    y = xy(2,:) + ybar;
    [xmin(k),minloc]=min(x);
    [xmax(k),maxloc]=max(x);
    ymin(k)=y(minloc);
    ymax(k)=y(maxloc);
    orient(k)=theta;
    endpo1=[xmin,xmax];
    endpo2=[ymin,ymax];
    plot(x,y,'r','LineWidth',2);
    plot(endpo1,endpo2,'.');
end
hold off;
ClusteringMatrix=[xmin',ymin',xmax',ymin',orient'];
[IDX, C]=kmeans(ClusteringMatrix,2);

CM=ClusteringMatrix;
CM=[CM IDX];
[CM1,I]=sortrows(CM,CM(:,end));
 cm1=CM1(find(CM1(:,end)==1),:);
 cm2= CM1(find(CM1(:,end)==2),:);
figure,
imshow(Im)
hold on
plot(cm1(:,1),cm1(:,2),'r.',cm2(:,1),cm2(:,2),'b.')

minxy=min(cm1);
maxxy=max(cm1);
%x=[minxy(1)];
%y=[minxy(2)];

skew=0;
for i = 1:length(s)
   skew=skew+ s(i).Orientation;
end
skew=skew/length(s)

%figure;
%imshow(imrotate(Im,-skew,'loose'));
arrai=[];
 for i=1:length(s)
    len=(s(i).MajorAxisLength)/2;
    arrai(i,:)=[s(i).Centroid(1)+len*cos(s(i).Orientation) , s(i).Centroid(2)+len*sin(s(i).Orientation)];
end;
figure,
imshow(Im)
hold on
plot(arrai(1),arrai(2),'b','LineWidth',2);