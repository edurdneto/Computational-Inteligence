X = importdata('data.dat');
v = X(:,2);
p = X(:,1);

%%% Normalizacao dos dados de entrada e saida
v=(v - min(v))/(max(v)-min(v));  % normaliza entradas entre 0 e 1
p=(p - min(p))/(max(p)-min(p));  % normaliza saidas entre 0 e 1

v=2*v-1;  % Normaliza entradas entre -1 e +1
p=2*p-1;  % Normaliza saidas entre -1 e +1
tic;
B = polyfit(v, p,8)
timeElapsed=toc
ypred=polyval(B,v);
erro=p-ypred;
SEQ=sum(erro.^2);

figure; plot(v,p,'bo'); hold on; grid; % diagrama de dispersao
xlabel('y'); 
ylabel('x');

plot(v,ypred,'r-'); % Sobrepoe curva de regressao aos dados
hold off; 


