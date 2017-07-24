function w=trainmyperceptron(x,d)
%matrix de entrada
%matrix de saida
[m,k]=size(x);
eta=-0.1;
w=rand(m,1);
E=0;
finish_flag=0;
t=0;
while ~finish_flag,
    t=t+1;
    for i=1:k,
        y=Myperceptron(w,x(:,i));
        w=w+eta*(d(i)-y)*x(:,i);
        E=E+0.5*(d(i)-y)^2;
    end
    if(E==0)
        finish_flag=1;
    else
        E=0;
    end
    if(t==200)
        finish_flag=1;
    end
end
end
        