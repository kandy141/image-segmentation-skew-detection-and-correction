function [SL,TL,intSL,intTL]=CVunhough(H,m,b,P)
%CVunhough finds lines from a Hough histogram
%function [SL,TL,intSL,intTL]=CVunhough(H,m,b,P)
% H votes histogram of size [nT,nS]
% P percentage threshold
% m and b: distance mapping parameters
% [1..nS] = [Smin...Smax]*m + b
% SL distances of selected lines
% TL orientations of selected lines
% intSL distances of selected lines after mapping to 1:nS
% intTL orientations of selected lines after mapping to 1:nT
%%See also: CVimage, CVhough, CVunhough, CVedge, CVline, CVproj
DILATEFRAC=.02;
if nargin<3
error('require at least 3 input arguments: histogram matrix H, 2 distance mapping parameters m & b');
elseif nargin<4
warning('defualt value of 0.7 assigned to percentage threshold P');
P=0.7;
end
[nT,nS]=size(H);
%locate the peeks in the histogram with
%votes more than P*100% of the highest vote
%note: r~orientation, c~distance
%TMP% [r,c]=find(H>=P*max(H(:)));
%Theshhold H --> TH
%TH=im2bw(H,P*max(H(:)));
TH=im2bw(H,0.5);
%Morphological
H1=imdilate(TH,ones(round(DILATEFRAC*size(H))),1);
%Labeling
L=bwlabel(H1,8);
n=max(L(:));
%for the n lines found above
%we collect the indices into the Hough votes matrix
intSL=[]; intTL=[];
for k=1:n,
[r,c]=find(L==k);
intTL=[intTL; mean(r)];
intSL=[intSL; mean(c)];
end
%remap r to orientation, we want
% r=1 --> 0 rad and
% r=nT --> pi-pi/nT rad
TL=(intTL-1)*pi/nT;
%remap c to distance
%in hough we mapped (y=mx+b):
% [1..nS] = [Smin...Smax]*m + b
%now we need to reverse mapping
% x=(y-b)/m
%where
% m=(nS-1)/(Smax-Smin)
% b=(Smax-nS*Smin)/(Smax-Smin)
SL=(intSL-b)/m;
%printing the lines on the matlab workspace
disp('Selected lines in the form [a b c]')
disp('----------------------------------')
for k=1:n,
a=num2str(cos(TL(k)));
b=num2str(sin(TL(k)));
c=num2str(-SL(k));
disp(['Line ',num2str(k),'/',num2str(n),': [ ',a,' ',b,' ',c,']']);
end