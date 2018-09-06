clear;
clc;
[F,P]=uigetfile('*.pgm;*.jpg;*.jpeg;*.tif;*.tiff;*.bmp;*.png;*.hdf;*.pcx;*.xwd','Choose Image');
PF=[P,F];
ext=PF(findstr(PF,'.')+1:end);
%Reading the selected image
[Im,MAP]=imread(PF);
%converting to gray scale
I = rgb2gray(Im);
II=I;
I1=I;
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
    %orient(k)=theta;
    orient(k)=s(k).Orientation;
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
%cm3= CM1(find(CM1(:,end)==3),:);
figure,
imshow(Im)
title('donnooo');
hold on
plot(cm1(:,1),cm1(:,2),'r.',cm2(:,1),cm2(:,2),'b.');
%plot(cm1(:,1),cm1(:,2),'r.',cm2(:,1),cm2(:,2),'b.',cm3(:,1),cm3(:,2),'g.');
center=[];


minxycm1=abs(min(cm1));
maxxycm1=abs(max(cm1));
minxycm2=abs(min(cm2));
maxxycm2=abs(max(cm2));

figure,
I1=imcrop(Im,[round(minxycm1(1)) round(minxycm1(2)) round(maxxycm1(3)-minxycm1(1)) round(maxxycm1(4)-minxycm1(2))]);
imshow(I1);
title('Cluster1');
figure,
I2=imcrop(Im,[round(minxycm2(1)) round(minxycm2(2)) round(maxxycm2(3)-minxycm2(1)) round(maxxycm2(4)-minxycm2(2))]);
imshow(I2);
title('Cluster2');

%kandikandikandikandikandikandikandikandikandikandikandikandikandikandikandikandikandikandikandikandi

%kandikandikandikandikandikandikandikandikandikandikandikandikandikandikandikandikandikandikandikandi


t1=mean(abs(cm1(:,5)));
t2=mean(abs(cm2(:,5)));
figure,
I11=rgb2gray(I1);
I11=im2bw(I11, graythresh(I11));
I11=imcomplement(I11);
imshow(imcomplement(imrotate(I11,-t1)));
title('Rotated cluster 1');
figure,
I21=rgb2gray(I2);
I21=im2bw(I21, graythresh(I21));
I21=imcomplement(I21);
imshow(imcomplement(imrotate(I21,-t2)));
title('Rotated cluster 2');
%t1
%t2


if(t1<t2)
    t3=t2;
    I3=I2;
else
    t3=t1;
    I3=I1;
end;  

I3=rgb2gray(I3);
I3=im2bw(I3, graythresh(I3));
I3=imcomplement(I3);
I3=imrotate(I3,-t3);
I3=imcomplement(I3);
%figure,
%imshow(I3);

figure,
if(t1<t2)
    subplot(2,1,1);
    if(t1>3.5)
        imshow(imcomplement(imrotate(I11,-t1)));
    else
        imshow(imcomplement(I11));
    end
    hh=subplot(2,1,2);
    imshow(I3);
    title('hehehe--1');
else
    subplot(2,1,1);
    if(t2>3.5)
        imshow(imcomplement(imrotate(I21,-t2)));
    else
        imshow(imcomplement(I21));
    end;    
    hh=subplot(2,1,2);
    imshow(I3);
    title('hehehe--2');
end;


