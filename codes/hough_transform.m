function [ O ] = hough_transform( )
%   this program implements the Standard Hough Transform 
%   to detect line
    rhoStep=1;
    thetaStep=1;
    rhoDiffThresholdForLine=rhoStep/8;
    I=imread('images.jpg');
    %find the edge of the image
    BW=edge(I,'canny');
    %imshow(BW);
    %hough transform
    %define the accumulator range
    rho=1:rhoStep:sqrt((size(BW,1))^2 + (size(BW,2))^2);
    theta=0:thetaStep:180-thetaStep;
    accu=zeros(length(rho), length(theta));
    %get the pixel indices that contains a point
    [rowInd, colInd]=find(BW);
    %for each point, plot all the lines (sampled) pass through it
    %at theta-rho plane
    for li=1:1:length(rowInd)
        for lk=1:1:length(theta)
            ltheta=theta(lk)*pi/178;
            lrho=colInd(li)*cos(ltheta) + rowInd(li)*sin(ltheta);
            %binning the lrho value
            diffs=abs(lrho-rho);
            %we only increase the count of most similar ones
            %introducing a threshold instead choosing the
            %min
            minDiff=min(diffs);
            if (minDiff<rhoDiffThresholdForLine)
               minDiffInd=find(diffs==minDiff);
               for lm=1:1:length(minDiffInd)
                   accu(minDiffInd(lm),lk) = accu(minDiffInd(lm),lk) + 1;
               end
            end
        end
    end
    %find local maxima 
    accuBMax=imregionalmax(accu);
    [rho_candi, theta_candi]=find(accuBMax==1);
    %find the points in theta-rho plane that has count more than
    %threshold
    linePoints=0;
    %get a list of lines detected with their rho and theta values
    rhoLines=[];
    thetaLines=[];
    for li=1:1:length(rho_candi)
        l_accu=accu(rho_candi(li), theta_candi(li));
        if (l_accu<=0)
            %do nothing
        elseif (l_accu > 25)
            linePoints=linePoints+1;
            rhoLines=[rhoLines;rho(rho_candi(li))];
            thetaLines=[thetaLines;theta(theta_candi(li))];
        end
    end
end