function callingCVimage(I,BW)
[H,theta,rho] = hough(BW);
P1 = houghpeaks(H,200,'threshold',ceil(0.3*max(H(:))));
size(P1)

x = theta(P1(:,2));
y = rho(P1(:,1));
plot(x,y,'s','color','black');
 %[r, c] =houghpixels(BW, theta, rho, rbin, cbin);
lines = houghlines(BW,theta,rho,P1,'FillGap',1,'MinLength',1); 
 size(lines)
 lines
figure, imshow(I), hold on
max_len = 0;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',0.2,'Color','green');

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'LineWidth',2,'Color','green');
   plot(xy(2,1),xy(2,2),'LineWidth',2,'Color','green');

   % Determine the endpoints of the longest line segment
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end
% highlight the longest line segment
plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','green');

