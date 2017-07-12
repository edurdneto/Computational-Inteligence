function result = rosen(x,y);
% Objective function for Differential Evolution
%
% Input Arguments:   
% ---------------
% x                  : parameter vector to be optimized
% y                  : data vector (remains fixed during optimization)
%
% Output Arguments:
% ----------------
% result              : objective function value
%


%-----Rosenbrock's saddle------------------
 result = 20 + x(1)^2 + x(2)^2 - 10*(cos(2*pi*x(1))+cos(2*pi*x(2)));