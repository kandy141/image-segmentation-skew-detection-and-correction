function []=thetha_plot(I,BW,RGB)
[H,T,R] = hough(BW,'RhoResolution',0.5,'Theta',-90:0.5:89.5);
figure(1);
imshow(I);
figure(2);
% Display the original image.
subplot(2,1,1);
imshow(RGB);
title('Imw2 Image');

% Display the Hough matrix.
subplot(2,1,2);
imshow(imadjust(mat2gray(H)),'XData',T,'YData',R,...
      'InitialMagnification','fit');
title('Hough Transform of Gantrycrane Image');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;
colormap(hot);

