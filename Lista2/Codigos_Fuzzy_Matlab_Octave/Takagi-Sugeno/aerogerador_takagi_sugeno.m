% Implementacao de um sistema de inferencia fuzzy
% ENTRADAS: x1 (velocidade, Km/h), x2 (raio de curvatura, m)
% SAIDA:  y (forca no pedal de freio, N)
%
% Autor: Guilherme A. Barreto 
% Data:  03/10/2009

clear; clc; close all;

% Valores medidos de x1 e x2
D=load('data.dat');

x=D(:,2);  % veloc. ventos
y=D(:,1);  % potencia gerada

%%%%%%%%%%%%%%%%%%%%
%Funcao de pertinencia das variaveis de entrada
%%%%%%%%%%%%%%%%%%%%
z = 0:0.1:250;
mi_out =[];
for i=1:length(z),
	aux=data_regras(z(i));
    mi_out=[mi_out; aux];
end
figure;
plot(z,mi_out);
xlabel('funcão de pertinência variável x');
title('Funcao de pertinencia distancia');
axis([0 250 -0.5 1.5])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% ESTIMACAO DE PARAMETROS DOS MODELOS LOCAIS %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%
% ETAPA 1: DETERMINACAO DAS ATIVACOES NORMALIZADAS DAS REGRAS PARA CADA VALOR MEDIDO 
%          DA VELOCIDADE DO VENTO E MONTAGEM DA MATRIZ DE DADOS CORRESPONDENTES
%%%%%%%%%%%%
spread=3;   % Abertura da gaussiana

Lx=length(x);
wi=[];
X=[];
for i=1:Lx,
	%mi=vento(x(i));      % Pertinencias para variavel VELOCIDADE do vento
    %mi=vento_gauss(x(i),spread);      % Pertinencias para variavel VELOCIDADE do vento
    mi=data_regras(x(i),spread);
	wi=mi/sum(mi);       % Calcula as ativacoes normalizadas das 3 regras
    X=[X; wi wi*x(i)];   % Monta matriz de dados
end

%%%%%%%%%%%%
% ETAPA 2: ESTIMACAO PELO METODO DOS MINIMOS QUADRADOS
%%%%%%%%%%%%
%B=inv(X'*X)*X'*y;
B=pinv(X)*y;

%%%%%%%%%%%%
% ETAPA 3: PREDICAO PARA NOVOS DADOS
%%%%%%%%%%%%
xx=min(x):0.1:max(x); 
xx=xx'; % Define faixa de valores para velocidade

Lxx=length(xx);
for i=1:Lxx,
	%mi=vento(xx(i));      % Pertinencias para variavel VELOCIDADE do vento
    %mi=vento_gauss(xx(i),spread);      % Pertinencias para variavel VELOCIDADE do vento
    mi=data_regras(xx(i),spread);
	wi=mi/sum(mi);        % Calcula as ativacoes normalizadas das 3 regras
    ypred(i)=[wi wi*xx(i)]*B;  % Realiza a predicao
end

%%%%%%%%%%%%
% ETAPA 4: GRAFICO DA CURVA DE REGRESSAO
%%%%%%%%%%%%
figure; plot(x,y,'bo'); hold on; grid; % diagrama de dispersao
xlabel('Velocidade do vento [m/s]'); 
ylabel('Potencia gerada [kWatts]');

plot(xx,ypred,'r-'); % Sobrepoe curva de regressao aos dados
hold off; 








