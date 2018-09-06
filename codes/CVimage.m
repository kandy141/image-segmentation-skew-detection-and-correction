function [I,J]=CVimage
%function I=CVimage;
%CVimage returns a normalized (0-1) grey scale image given the path
% I returned image
%%See also: CVimage, CVhough, CVunhough, CVedge, CVline, CVproj
[F,P]=uigetfile('*.pgm;*.jpg;*.jpeg;*.tif;*.tiff;*.bmp;*.png;*.hdf;*.pcx;*.xwd','Choose Image');
if F==0
I=[];
else
PF=[P,F];
ext=PF(findstr(PF,'.')+1:end);
if strcmp(ext,'pgm')
I = readpgm(PF);
else %matlab image types
[Im,MAP]=imread(PF);
size(Im);
J=Im;
%MAP
%I = ind2gray(Im,MAP);
I = rgb2gray(Im);
end
I = I/max(I(:));
end