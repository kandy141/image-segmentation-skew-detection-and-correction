clear;
clc;
[F,P]=uigetfile('*.pgm;*.jpg;*.jpeg;*.tif;*.tiff;*.bmp;*.png;*.hdf;*.pcx;*.xwd','Choose Image');
PF=[P,F];
ext=PF(findstr(PF,'.')+1:end);
%Reading the selected image
[Im,MAP]=imread(PF);
%converting to gray scale
I = rgb2gray(Im);
I1=I;
%Binarizing the image
I=im2bw(I, graythresh(I));
%Complementing the image
I=imcomplement(I);
% % figure,
% % imshow(I);
% % title('Complemented binary image');
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
disp('Entered Detecting Clusters');
A=zeros(size(ClusteringMatrix,1),size(ClusteringMatrix,1));
size(A)
CM=ClusteringMatrix;
sigma=0.5;
 for i=1:size(CM,1)
     for j=1:size(CM,1)
         %A(i,j)=exp(-1*((sum((CM(i,:)-CM(j,:)).^2))/(2*sigma*sigma))); %Here Square Root has been Removed
        A(i,j)=sqrt(sum((CM(i,:)-CM(j,:)).^2));
     end
     A(i,i)=0;
 end
%A=cov(ClusteringMatrix);
d=sum(A,2);
D=diag(d);
L=D*A*D;
%[u s v]=svd(A);
 [u,D] = eig(L,'nobalance');
Y=u(:,1:2); 
for i=1:size(Y,1)
 %   Y(i,:)=Y(i,:)/norm(Y(i,:));
end
[IDX, C]=kmeans(Y,2);
CM=[CM IDX];
[CM1,I]=sortrows(CM,CM(:,end));
 cm1=CM1(find(CM1(:,end)==1),:);
 cm2= CM1(find(CM1(:,end)==2),:);
figure,
imshow(Im)
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

t1=mean((cm1(:,5)))
t2=mean((cm2(:,5)))
figure,
I1=imcomplement(I1);
I11=imrotate(I1,-t1);
imshow(imcomplement(I11));
title('Rotated cluster 1');

figure,
I2=imcomplement(I2);
I21=imrotate(I2,-t2);
imshow(imcomplement(I21));
title('Rotated cluster 2');



figure,
h=subplot(2,1,1);
imshow(imcomplement(I11));


hh=subplot(2,1,2);
imshow(imcomplement(I21));

