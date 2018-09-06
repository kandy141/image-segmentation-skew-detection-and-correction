function edgedata=CVedge(I,M,T,A);
%CVedge finds the coordinates of the edges in an image
%
%function edgedata=CVedge(I,M,T,A);
% M 1:subpixel
% T T:threshold = T
% A A:width of smoothing kernel = B
% M 2:edge function
% T T:threshold
% A A:method ex. 'Sobel', 'Roberts'
% edgedata a 2-row matrix, with the x and y coordinates of the edges
%%See also: CVimage, CVhough, CVunhough, CVedge, CVline, CVproj
if M>2
error('M should be 1(subpixel) or 2(edge)');
elseif M==1 %SUBPIXEL
edgedata=[];
for rownr = 1:size(I,1);
row = I(rownr,:);
edgeposfine=rowedges(row,A,T);
edgedata=[edgedata
    [edgeposfine;rownr*ones(size(edgeposfine))]];
end;
elseif M==2 %EDGE
switch A
case 1,
meth='sobel';
case 2,
meth='prewitt';
case 3,
meth='roberts';
case 4,
meth='log';
case 5,
meth='zerocross';
case 6,
meth='canny';
otherwise,
error('edge method values only 1 through 6');
end
E=edge(I,meth,T);
[r,c]=find(E);
edgedata=[c';r'];
end