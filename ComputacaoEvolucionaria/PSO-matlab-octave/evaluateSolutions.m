function y = evaluateSolutions(x)

[numParticles, numVariables] = size(x);

y = zeros(1,numParticles);

for i=1:numParticles
    y(i) = rosenbrock(x(i,:));
    %y(i) = ackley(x(i,:));
end

function y = rosenbrock(x)

y = (1 - x(1))^2 + 100*(x(2) - x(1)^2)^2;

function y = ackley(x)

a=20; b=0.2; c=2*pi;
y = -a*exp(-b*abs(x)) -exp(cos(c*x)) + a + exp(1);
