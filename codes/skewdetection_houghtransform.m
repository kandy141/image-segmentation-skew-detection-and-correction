clear;
clc;
image1=imread('4.tif');

size1=size(image1);

d1=size1(1);

d2=size1(2);

PMAX=sqrt(d1*d1+d2*d2)*5+1;

percision=1; % for precision*/

start_angle=0;

end_angle =45;

step=1;

while ge(percision,0.1)

HTABLE3= zeros (PMAX, 45);

size1=size(image1);

d1=size1(1);

d2=size1(2);

ind=1;

for i=1:d1

for j=1:d2

if(image1(i,j)==0)

ind_ang=1;

for a=start_angle:step:end_angle

p=j*sin((a*pi)/180.0)+i*cos((a*pi)/180.0);

p1=round(p*5)+1;

HTABLE3(p1,ind_ang)=HTABLE3(p1,ind_ang)+1;

ind_ang=ind_ang+1;

end

end

end

end

maxm=max(HTABLE3);

maxv=max(max(HTABLE3));

maxind=find(maxm==maxv);

angle=step*(maxind-1)+start_angle;

start_angle=angle-step;

end_angle=angle+step;

step=step/10.0;

percision=percision/10.0;

end

angle=mean(angle);

fprintf('\nangle is %f ',angle);

%B=imrotate(image1,-1*angle,'bilinear','crop');
%imshow(image1);
