function [dist]=edistance(x,y)
if(x*x'>0)
    lambda=0.2;
    I=diag(ones(1,size(x,2)));
    M=(I-(x'*x)/(x*x'))/lambda+lambda*((x'*x)/(x*x'));
    dist=(x-y)*M*(x-y)';
else
    dist=sqrt(sum((x-y).^2));
end
end