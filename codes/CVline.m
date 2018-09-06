function [XL,YL]=CVline(SL,TL,X)
%CVline converts lines in distance-orientation representation
% to x and y coordinates for a given range of X
%
%function [XL,YL]=CVline(SL,TL,X)
% X range of X (e.g X=1:50;)
% SL distances of selected lines
% TL orientations of selected lines
% XL X's of generated lines
% YL Y's of generated lines
%%See also: CVimage, CVhough, CVunhough, CVedge, CVline, CVproj
X=X(:)'; %make X a row vector
%s=x cos(th) + y sin(th) ==> %y=(s - x cos(th))/sin(th)
YL=((repmat(SL,1,length(X))-cos(TL)*X)./...
    sin(repmat(TL,1,length(X))))';
XL=repmat(X,size(YL,2),1)';