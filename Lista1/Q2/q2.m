X = importdata('aerogerador.dat');
v = X(:,1);
p = X(:,2);
B = polyfit(v, p,5)
ypred=polyval(B,v);
erro=p-ypred;
SEQ=sum(erro.^2)

figure; plot(v,p,'bo'); hold on; grid; % diagrama de dispersao
xlabel('Velocidade do vento [m/s]'); 
ylabel('Potencia gerada [kWatts]');

plot(v,ypred,'r-'); % Sobrepoe curva de regressao aos dados
hold off; 
