% Implementacao de um AG binario canonico para encontrar o maximo da
% funcao f(x)=x^2, 0<=x<=31.
%
% Autor: Guilherme A. Barreto
% Data: 17/08/2009

clear; clc;

%%% Parametros do AG
N=50;     % Tamanho da populacao
M=5;    % Tamanho do cromossomo (no. de genes)
pc=0.8;  % Probabilidade de cruzamento
pm=0.05; % Probabilidade de mutacao
Ng=100;   % Numero de geracoes
a = 0.005;

%%% Geracao da populacao inicial 
P=-5.12 + (5.12+5.12)*rand(N,2);
%%% Calcula fitness da populacao inicial
[F Fn]=aptidao(P);  % Retorna a aptida de cada individuo da populcao
%Fn = sort(Fn);
%Fn(2,N) = Fn(1,N);
%for t=N-1:-1:1,
%    Fn(2,t) = Fn(1,t)+Fn(2,t+1);
%end
%%% Roda AG por Ng geracoes
Gfn = [];
G = [];
GfnM = [];
tic;
for t=1:Ng,
    geracao=t,
    S=selecao_torneio(P,Fn);
%    S=selecao_roleta(P,Fn);
    P=cruzamento(P,S,pc,a);
    P=mutacao(P,pm);
%
    [F Fn]=aptidao(P);
    Fn2 = sort(Fn);
    Gfn = [Gfn;Fn2(1)];
    GfnM = [GfnM;mean(Fn2)];
    G = [G;t];
 %   Fn(2,N) = Fn(1,N);
 %   for t=N-1:-1:1,
 %       Fn(2,t) = Fn(1,t)+Fn(2,t+1);
 %   end
   
end
timeElapsed = toc
figure
plot(G,Gfn);
title('fun��o de aptid�o do melhor indiv�duo por gera��o')
xlabel('gera��o') % x-axis label
ylabel('fitness') % y-axis label
saveas(gcf, 'ApitidaoDoMelhor.jpg');
figure
plot(G,GfnM);
title('m�dia da fun��o de aptid�o da popula��o por gera��o')
xlabel('gera��o') % x-axis label
ylabel('m�dia fitness') % y-axis label
saveas(gcf, 'MediadaApitidao.jpg');
