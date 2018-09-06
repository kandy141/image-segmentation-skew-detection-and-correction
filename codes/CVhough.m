function [H,m,b]=CVhough(edgedata,nT,nS)
%CVhough Hough transform of a binary matrix
%
%function [H,m,b]=CVhough(edgedata,nT,nS)
% edgedata a 2-row matrix, with the x and y coordinates of the edges
% nT number of orientations(thetas)~ 1/orientation resolution
% nS number of distances ~ 1/distance resolution
% H votes histogram
% m and b: distance mapping parameters
% [1..nS] = [Smin...Smax]*m + b%
%%See also: CVimage, CVhough, CVunhough, CVedge, CVline, CVproj
MAXDIST=1.2;
if nargin<1
error('require at least one input argument: binary image')
elseif nargin<2
warning('defualt value of 200 assigned to number of orientationsnT')
nT=200;
warning(['defualt value of', max(edgedata(:))*MAXDIST,'assigned to number of orientations nS' ])
nS=max(edgedata(:))*MAXDIST;
elseif nargin<3
warning(['defualt value of', max(edgedata(:))*MAXDIST, 'assigned to number of orientations nS'])
nS=max(edgedata(:))*MAXDIST;
end
row=edgedata(2,:)';
col=edgedata(1,:)';
%defining the range of the orientations of line
Ts=[0:pi/nT:pi-pi/nT]';

%cos and sin of all the angles
CsT=cos(Ts);
SnT=sin(Ts);
%solving for distances for all orientations at all nonzero pixels
%size of S is: [length(row) , length(Ts)]
S=row*CsT' + col*SnT';
%mapping:
% Smin = min(S(:))--> 1
% Smax = max(S(:))--> nS
%gives (y=mx+b):
% m=(nS-1)/(Smax-Smin)
% b=(Smax-nS*Smin)/(Smax-Smin)
%and then round it and get rounded mapped S:rmS
Smin=min(S(:));
Smax=max(S(:));
m =(nS-1)/(Smax-Smin);
b =(Smax-nS*Smin)/(Smax-Smin);
rmS=round(m*S + b);
%Note: H is [nT,nS]
% rmS is [nP,nT] nP:number of edge points
H=[];
hw=waitbar(0,'Performing Hough Transform...');
for k=1:nS,
isEq=(rmS==k);
% H=[H,sum(isEq)']; %sum(isEq) 1 x nT
H(:,k)=sum(isEq)';
waitbar(k/nS,hw);
end

close(hw);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% USING 3D MATRICES
%
% we tried to calculate the votes for all the S,T pairs
% in the hough transform using 3D matrices and without
% using for loops, but 3D matrices took a lot of memory
% and resulted in slower performance. (See below...)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%counting number of specific distances for each angle
%first produce a 3D matrix with repS(:,:,i)=i, where i=1:nS
%TMP% repS=shiftdim(repmat(1:nS,[nT,1,length(row)]),2);
%then we repeat the rmS matrix and get a 3D reprmS(:,:,i)=rmS, wherei=1:nS
%TMP% reprmS=repmat(rmS,[1 1 nS]);
%then we compare repS with reprmS
%dim1=#nonzeros pixels
%dim2=number of orientations nT
%dim3=number of distances nS
%TMP% isEq=(repS==reprmS);
%we sum up the ones for each direction at each distance
%and obtain H(histogram of votes) of size [nT,nS]
%TMP% H=squeeze(sum(isEq,1));