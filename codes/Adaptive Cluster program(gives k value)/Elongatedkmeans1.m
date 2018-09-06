function [ID,C]= Elongatedkmeans1(X,C)
    % X input vectors as columns
    % ID is row vector of numbers 1..K, ith ID is number of cluster to which ith column form X belong
    % C is matrix where ith column is representing ith centroid
    %   - initial centroids are passed as arguments
%plot2dStep = 0;
    % K is number of desired clusters
    K = size(C,1);
    % T threshold
    T = 0.5;
    % number of input data
    n = size(X,1);
    disp('Entered Elongated K means');
    % incorrect patameters parsing
    error_msg = 'Usage k_means(X, K, [plot=1]) \n X input vectors as columns\n K is number of desired clusters';
 
    if nargin < 2 
        error(error_msg);    
    end
    if size(X,1) < 1
        error([error_msg, '\n X should contain some data!!!']);
    end
    if n < K | K < 1
        error([error_msg, '\n You should supply atleast as many column vectors in X as many clusters K you want!!!']); 
    end
      
    % program logic

    % init of ID: all vectors belong to the first cluster - it will change;)
    ID = ones(n, 1);
    step = 0;
    prev_err = 0;
    err = 0;
    while(true)  
        %step = step +1;
        % DISPLAY THE SITUATION
        % FINDING NEAREST CENTROID
        disp('Finding Nearest Centroid section');
        disp('The Cluster Centrioids are');
        disp(C);
        disp('The data is ');
        disp(X);
        for j = 1:n
            % Find nearest centroid for X(j,:)
            min_i = 1;
            min_dist = edistance(C(1,:),X(j,:)); 
            for i = 2:K
                d = edistance(C(i,:), X(j,:));
                if ( d < min_dist )
                    min_dist = d;
                    min_i = i;
                end
            end
            % we update the centroids for each input vector as I promised;)
            ID(j,1) = min_i; 
        end
        ID'
        % UPDATING CENTROIDS 
        prev_err = err;
        for i = 1:K
            % indexes to input vectors belonging to centroid i
            ID_i = find(ID == i);
            % compute centroidi i as expected value of input vectors belonging to i
            C(i,:) = sum(X(ID_i,:),1)/length(ID_i);
            mi=((X(ID_i,:)- repmat(C(i,:),length(ID_i),1)));
            err = sum(sqrt(sum( mi.^2,2 )));
        end

        % TODO FINAL CONDITION
        % abs is because of first step
        if ( abs(prev_err - err) < T)
            disp(prev_err - err);
            break;
        end
    end

end