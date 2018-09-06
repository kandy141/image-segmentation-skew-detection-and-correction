clear;
clc;
[F,P]=uigetfile('*.pgm;*.jpg;*.jpeg;*.tif;*.tiff;*.bmp;*.png;*.hdf;*.pcx;*.xwd','Choose Image');
PF=[P,F];
ext=PF(findstr(PF,'.')+1:end);
[RGB,MAP]=imread(PF);
size(RGB);
% Convert to intensity.
I  = rgb2gray(RGB);
% Extract edges.
BW = edge(I,'canny');
figure,
imshow(BW); title('edge canny');
%calling hough function
[H,theta,rho] = hough(BW);  %default values teeskuntunnai
%calling houghpeaks function
[r, c, hnew] = houghpeaks(H,5);  %default values teeskuntunnai
%for every bin 
rbin=r;
cbin=c;
%[rr, cc] = houghpixels(BW, theta, rho, rbin, cbin);
lines = houghlines(BW,theta,rho,r,c);
size(lines)
thetha_plot(I,BW,RGB);
figure, imshow(I), hold on
max_len = 0;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','green');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','green');

   % Determine the endpoints of the longest line segment
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end
% highlight the longest line segment
plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','red');







