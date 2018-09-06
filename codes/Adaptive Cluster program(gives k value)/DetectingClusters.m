function [k] = DetectingClusters(CM)
disp('Entered Detecting Clusters');
A=zeros(size(CM,1),size(CM,1));
size(A)

sigma=0.5;
for i=1:size(CM,1)
    for j=1:size(CM,1)
        %A(i,j)=exp(-1*(sqrt(sum((CM(i,:)-CM(j,:)).^2))/(2*sigma*sigma))); %Here Square Root has been Removed
        A(i,j)=sqrt(sum((CM(i,:)-CM(j,:)).^2));
    end
    A(i,i)=0;
end

d=sum(A,2);
D=diag(d.^-.5);
L=D*A*D;
size(L);
q=2;
cc=[];
indi=[];
while(true)
    [u s v]=svd(L);
    Y=u(:,1:q); % Got the first q eigenvectors
    %code for elongated k means
    if(q==2)
        disp('Entered q=2 value section');
        nor=sum(Y.*Y,2);
        [val,idx]=max(nor);
        cc(1,:)=Y(idx,:);
        [h id]=sortrows([Y,sum(Y.*Y,2), Y*cc(1,:)'],[-3,4]);
        cc(2,:)=h(2,1:2);
        cc(3,:)=zeros(1,2);
        [Id,C]=Elongatedkmeans1(Y,cc);%getting the cluster centroids and their Indexes
        disp('Displaying cluster centrioid when q=2');
        cc=C
        indi=Id;
    else
        disp('Entered q>2 value section');
        [B L]=sortrows([Y indi],size([Y indi],2));
        for p=1:max(indi)
            cc=[];
            p
            find(B(:,end)==p)
            B( find(B(:,end)==p),1:(size(B,2)-1))
            cc(p,:)=mean(B( find(B(:,end)==p),1:(size(B,2)-1)));
        end
        %cc=Y(indi);
        size(Y)
        cc
        cc(q+1,:)=zeros(1,q);
        [Id,C]=Elongatedkmeans1(Y,cc);%getting the cluster centroids and their Indexes
        disp('Displaying cluster centrioid when q>2');
        indi=Id;
        %cc=C
    end
     fprintf('value of q is %d and length(find(Id==q+1))==1 is %d \n',q,length(find(Id==q+1))==1);
    if(length(find(Id==q+1))==0)
        break;
    else if (q>4)
            break;
        end
       q=q+1;
    end
end
k=q
end