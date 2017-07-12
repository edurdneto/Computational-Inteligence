% Implementacao de um sistema de inferencia fuzzy do tipo Mandani-1
% (agrega, depois desfuzifica)
% ENTRADAS: x1 (velocidade, Km/h), x2 (raio de curvatura, m)
% SAIDA:  y (forca no pedal de freio, N)
%
% Autor: Guilherme A. Barreto 
% Data:  03/10/2009

clear; clc; close all;

%%%%%%%%%%%%%%%%%%%%
%Funcao de pertinencia das variaveis de entrada
%%%%%%%%%%%%%%%%%%%%
%x = 0:0.1:100;
%mi_out =[];
%for i=1:length(x),
%	aux=distancia(x(i));
%    mi_out=[mi_out; aux];
%end
%figure;
%plot(x,mi_out);
%xlabel('distancia');
%title('Funcao de pertinencia distancia');
%axis([0 100 -0.5 1.5])

%x = -90:0.1:270;
%mi_out =[];
%for i=1:length(x),
%	aux=angulo_entrada(x(i));
%    mi_out=[mi_out; aux];
%end
%figure;
%plot(x,mi_out);
%xlabel('angulo');
%title('Funcao de pertinencia angulo de entrada');
%axis([-90 270 -0.5 1.5])

%%%%%%%%%%%%%%%%%%%
%EXEMPLO 
%%%%%%%%%%%%%%%%%%%
% Valores medidos de x1 (VEL) e x2 (CURVATURA)
x1=54;
x2=93;

%%%%%%%%%%%%
% ETAPA 1: FUZZIFICACAO
%%%%%%%%%%%%

%%mi1=velocidade(x1);   % Pertinencias para variavel VELOCIDADE
%%mi2=curvatura(x2);     % Pertinencias para variavel CURVATURA

mi1=distancia(x1);
mi2=angulo_entrada(x2);

% Funcoes de Pertinencia (VARIAVEL DE SAIDA)
y=-90:0.1:270;   % Universo de discurso da variavel de saida
mi_out=[];
for i=1:length(y),
	aux=angulo_saida(y(i));
    %aux=forca_pedal_freio(y(i));
	mi_out=[mi_out; aux];
end

%figure;
%plot(y,mi_out);
%xlabel('angulo');
%title('Funcao de pertinencia angulo de saida');
%axis([-90 270 -0.5 1.5])

%%%%%%%%%%%%
% ETAPA 2: AVALIACAO DAS REGRAS FUZZY
%%%%%%%%%%%%

%RULE_OUT=regras(mi1,mi2,mi_out,y);  % Conjuntos fuzzy de saida de todas as regras
RULE_OUT = regras_1(mi1,mi2,mi_out,y);
%%%%%%%%%%%%
% ETAPA 3: INFERENCIA FUZZY (AGREGACAO - OR (operador de maximo))
%%%%%%%%%%%%

F_OUT=max(RULE_OUT);

figure;
plot(y,F_OUT);
xlabel('Angulo de Saida');
title('Conjunto Fuzzy de Saida Agregado');
axis([-90 270 -0.5 1.5])

%%%%%%%%%%%%
% ETAPA 4: DESFUZZIFICACAO (CENTRO DE GRAVIDADE)
%%%%%%%%%%%%

Y=sum(F_OUT.*y)/sum(F_OUT)
