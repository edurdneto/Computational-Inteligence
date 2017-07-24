% Implementacao de um AG binario canonico para encontrar o maximo da
% funcao f(x)=x^2, 0<=x<=31.
%
% Autor: Guilherme A. Barreto
% Data: 17/08/2009

clear; clc;

%%% Parametros do AG
N=10;     % Tamanho da populacao
M=5;    % Tamanho do cromossomo (no. de genes)
pc=0.8;  % Probabilidade de cruzamento
pm=0.05; % Probabilidade de mutacao
Ng=1000;   % Numero de geracoes
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
for i=1:100,
    Gfg = [];
    Gfmg = [];
    G = [];
    P=-5.12 + (5.12+5.12)*rand(N,2);
%%% Calcula fitness da populacao inicial
    [F Fn]=aptidao(P);
    for t=1:Ng,
        geracao=t,
        S=selecao_torneio(P,Fn);
    %    S=selecao_roleta(P,Fn);
        P=cruzamento(P,S,pc,a);
        P=mutacao(P,pm);
    %
        [F Fn]=aptidao(P);
        Fn2 = sort(Fn);
        Gfg = [Gfg,Fn2(1)];
        %Gfn = [Gfn;Fn2(1)];
        Gfmg = [Gfmg,mean(Fn2)];
        %GfnM = [GfnM;mean(Fn2)];
        G = [G;t];
     %   Fn(2,N) = Fn(1,N);
     %   for t=N-1:-1:1,
     %       Fn(2,t) = Fn(1,t)+Fn(2,t+1);
     %   end

    end
    Gfn = [Gfn;Gfg];
    GfnM = [GfnM;Gfmg];
end
Gfn = sum(Gfn,1)/100;
Gfn = Gfn.';

GfnM = sum(GfnM,1)/100;
GfnM = GfnM.';
%MEDIA DE X ITERACOES DO MELHOR INDIVIDUO
timeElapsed = toc
figure
plot(G,Gfn);
title('função de aptidão do melhor indivíduo por geração')
xlabel('geração') % x-axis label
ylabel('fitness') % y-axis label
saveas(gcf, 'ApitidaoDoMelhor.jpg');
%MEDIA DE X ITERACOES DA MEDIA 
figure
plot(G,GfnM);
title('média da função de aptidão da população por geração')
xlabel('geração') % x-axis label
ylabel('média fitness') % y-axis label
saveas(gcf, 'MediadaApitidao.jpg');
