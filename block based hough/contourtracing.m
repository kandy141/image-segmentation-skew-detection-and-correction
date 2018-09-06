BW = imread('ext.jpg');
imshow(BW,[]);
s=size(BW);
I  = rgb2gray(BW);
im=I;
    % Transform the image in black and white
    level = graythresh(I);
    BW = im2bw(I,level);

for row = 2:55:s(1)
   for col=1:s(2)
      if BW(row,col),
         break;
      end
   end

   contour = bwtraceboundary(BW, [row, col], 'W', 8, 200,...
                                   'counterclockwise');
   if(~isempty(contour))
      hold on;
      plot(contour(:,2),contour(:,1),'g','LineWidth',2);
      hold on;
      plot(col, row,'gx','LineWidth',2);
   else
      hold on; plot(col, row,'rx','LineWidth',2);
   end
end