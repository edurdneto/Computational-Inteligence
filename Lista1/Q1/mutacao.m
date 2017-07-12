function Pnew=mutacao(P,Pm);
% Promove mutacao nos genes dos individuos da populacao P,
% com probabilidade Pm

n=size(P);

Pnew=[];
for i=1:n(1),
    t = rand(1);
    a = -1 + (1+1)*rand(1);
    z = round(rand(1));
    if t<=Pm,
        if z==0,
            x1 = P(i,1) + P(i,1)*a;
            x2 = P(i,2);
        else
            x1 = P(i,1);
            x2 = P(i,2) + P(i,2)*a;
        end
    else 
        x1 = P(i,1);
        x2 = P(i,2);
    end    
    Pnew=[Pnew;x1 x2];
end

    
