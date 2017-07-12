% Implementacao de regressao linear por partes em intervalos rigidos
% (crisp intervals)
%
% Autor: Guilherme de Alencar Barreto
% Data: 06/05/2016

clear; clc; close all

load aerogerador.dat % carrega arquivo de dados

v=aerogerador(:,1); % medidas de velocidades
P=aerogerador(:,2); % medidas de potencia

figure; plot(v,P,'bo'); grid; % diagrama de dispersao
xlabel('Velocidade do vento [m/s]'); 
ylabel('Potencia gerada [kWatts]');