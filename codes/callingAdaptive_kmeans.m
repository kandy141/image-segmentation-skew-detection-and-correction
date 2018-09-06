clear;
clc;
[F,P]=uigetfile('*.pgm;*.jpg;*.jpeg;*.tif;*.tiff;*.bmp;*.png;*.hdf;*.pcx;*.xwd','Choose Image');
PF=[P,F];
ext=PF(findstr(PF,'.')+1:end);
%Reading the selected image
[Im,MAP]=imread(PF);
gray=rgb2gray(Im);
%[lb,center]=GrayClustering(gray);

%function [lb,center] = GrayClustering(gray)
gray = double(gray);
array = gray(:); % Copy value into an array.
% distth = 25;
i = 0;j=0; % Intialize iteration Counters.
tic
while(true)
    seed = mean(array); % Initialize seed Point.
    i = i+1; %Increment Counter for each iteration.
    while(true)
        j = j+1; % Initialize Counter for each iteration.
        dist = (sqrt((array-seed).^2)); % Find distance between Seed and Gray Value.
        distth = (sqrt(sum((array-seed).^2)/numel(array)));% Find bandwidth for Cluster Center.
        %         distth = max(dist(:))/5;
        qualified = dist<distth;% Check values are in selected Bandwidth or not.
        newseed = mean(array(qualified));% Update mean.
        
        if isnan(newseed) % Check mean is not a NaN value.
            break;
        end
        
        if seed == newseed || j>10 % Condition for convergence and maximum iteration.
            j=0;
            array(qualified) = [];% Remove values which have assigned to a cluster.
            center(i) = newseed; % Store center of cluster.
            break;
        end
        seed = newseed;% Update seed.
    end
    
    if isempty(array) || i>10 % Check maximum number of clusters.
        i = 0; % Reset Counter.
        break;
    end
    
end
toc

center = sort(center); % Sort Centers.
newcenter = diff(center);% Find out Difference between two consecutive Centers. 
intercluster = (max(gray(:)/10));% Findout Minimum distance between two cluster Centers.
center(newcenter<=intercluster)=[];% Discard Cluster centers less than distance.

% Make a clustered image using these centers.

vector = repmat(gray(:),[1,numel(center)]); % Replicate vector for parallel operation.
centers = repmat(center,[numel(gray),1]);

distance = ((vector-centers).^2);% Find distance between center and pixel value.
[~,lb] = min(distance,[],2);% Choose cluster index of minimum distance.
lb = reshape(lb,size(gray));% Reshape the labelled index vector.
