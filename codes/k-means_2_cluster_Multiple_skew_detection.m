clear;
clc;
[F,P]=uigetfile('*.pgm;*.jpg;*.jpeg;*.tif;*.tiff;*.bmp;*.png;*.hdf;*.pcx;*.xwd','Choose Image');
PF=[P,F];
ext=PF(findstr(PF,'.')+1:end);
%Reading the selected image
[Im,MAP]=imread(PF);
%converting to gray scale
I = rgb2gray(Im);
bigger1=I;
II=I;
I1=I;
%Binarizing the image
I=im2bw(I, graythresh(I));

%Complementing the image
I=imcomplement(I);
%--figure,
%--imshow(I);
%--title('Complemented binary image');
%CC = bwconncomp(I,8);

%Morphology
Ifill=imfill(I,'holes');
%--figure,
%--imshow(Ifill);
%--title('Image filled with holes');
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


%--figure,
%--imshow(Ifill);
%--title('Dilated using fill');

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
hold on ;
plot([round(minxycm1(1)) ; round(maxxycm1(3)-minxycm1(1))],[ round(minxycm1(2)) ;round(maxxycm1(4)-minxycm1(2))],'r.');
hold off;
title('Cluster1');
figure,
I2=imcrop(Im,[round(minxycm2(1)) round(minxycm2(2)) round(maxxycm2(3)-minxycm2(1)) round(maxxycm2(4)-minxycm2(2))]);
imshow(I2);
hold on ;
plot([round(minxycm2(1)) ; round(maxxycm2(3)-minxycm2(1))],[ round(minxycm2(2)) ;round(maxxycm2(4)-minxycm2(2))],'b.');
hold off;
title('Cluster2');


t1=mean((cm1(:,5)));
t2=mean((cm2(:,5)));


if(t1<t2)
    t3=t2;
    I3=I2;
else
    t3=t1;
    I3=I1;
end;  

    
t1
t2

I11=rgb2gray(I1);
I11=im2bw(I11, graythresh(I11));
I11=imcomplement(I11);
figure,
I1=imcomplement(I1);
I1=imrotate(I1,-t1);
I1=imcomplement(I1);
imshow(I1);
title('Rotated cluster 1');
I21=rgb2gray(I2);
I21=im2bw(I21, graythresh(I21));
I21=imcomplement(I21);
figure,
I2=imcomplement(I2);
I2=imrotate(I2,-t2);
I2=imcomplement(I2);
imshow(I2);
title('Rotated cluster 2');
t1
t2


t3=t3+7;

I3=rgb2gray(I3);
I3=im2bw(I3, graythresh(I3));
I3=imcomplement(I3);
I3=imrotate(I3,-t3);
I3=imcomplement(I3);
%--figure,
%--imshow(I3);

 figure,
  if(t1<t2)
     subplot(2,1,1);
     imshow(I1);
     hh=subplot(2,1,2);
     imshow(I3);
     title('hehehe--1');
   else
     subplot(2,1,1);
     imshow(I2);
     hh=subplot(2,1,2);
     imshow(I3);
     title('hehehe--2');
 end;

%kandikandikandikandikandikandikandikandikandikandikandikandikandikandikandikandikandikandikandikandi

% % % % im1=bigger1;
% % % % [height width]=size(im1)
% % % % % note: initialise the data type as well as the size
% % % % bigger=zeros(height+200,width+200, 'uint8');
% % % % figure('name','original');imshow(im1); 
% % % % bigger(1:height,1:width)=im1(:,:); 
% % % % figure('name','after');imshow(bigger); 


imm=I3;
% % % % [height1 width1]=size(imm);
% % % % % note: initialise the data type as well as the size
% % % % big=zeros(height1+200,width1+200, 'uint8');
% % % % %big=imcomplement(big);
% % % % figure('name','original kandi');imshow(imm); 
% % % % big(1:height1,1:width1)=imm(:,:); 
% % % % figure('name','kandi after');imshow(big); 

%kandikandikandikandikandikandikandikandikandikandikandikandikandikandikandikandikandikandikandikandi
% I1=rgb2gray(I1);
% I1=im2bw(I1, graythresh(I1));
% I2=rgb2gray(I2);
% I2=im2bw(I2, graythresh(I2));

I11=imrotate(I11,-t1);
I11=imcomplement(I11);
I21=imrotate(I21,-t2);
I21=imcomplement(I21);

q1=size(I11);
q2=size(I21);
q=round(abs((q1(2)-q2(2))/2));

if(t1<t2)
    X2 = addborder(I21,round(q) , 255, 'outer');
    vf=size(X2);
    xfill=zeros(abs((vf(1)-q1(1))),q1(2));
    xfill=imcomplement(xfill);
    stitchedVertically = [I11;xfill];
    XF=vertcat(stitchedVertically,X2);
    figure('name','last-1');
    imshow(XF);
    
else
    X2 = addborder(I11,round(q) , 255, 'outer');
    vf=size(X2);
    xfill=zeros(abs((vf(1)-q2(1))),q2(2));
    xfill=imcomplement(xfill);
    stitchedVertically = [I21;xfill];
    XF=vertcat(stitchedVertically,X2);
    figure('name','last-2');
    imshow(XF);
    
end;
    
