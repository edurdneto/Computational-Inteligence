function y = evaluateSolutions(x,X)

[numParticles, numVariables] = size(x);

y = zeros(1,numParticles);

for i=1:numParticles
    %y(i) = rosenbrock(x(i,:));
    y(i) = ackley(x(i,:),X);
end

function y = ackley(x,X)
v = X(:,1);
p = X(:,2);
%B = polyfit(v, p,7);
ypred=polyval(x,v);
erro=p-ypred;
SEQ=sum(erro.^2);
y = SEQ;