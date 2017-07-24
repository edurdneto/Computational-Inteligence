function [y net]=Myperceptron(w,x)
net=w'*x;
%use step, theta=0
if(net>0)
    y=0;
else
    y=1;
end
end
