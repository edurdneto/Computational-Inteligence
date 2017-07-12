function mi=vento_gauss(x,spread)
%
% Retorna as pertinências da medida x aos conjuntos fuzzy
% definidos para a variável lingüística VELOCIDADE.
%
% Funcoes de pertinencia TRIANGULARES/TRAPEZOIDAS
%
% Data: 06/05/2016
% Autor: Guilherme A. Barreto

% Conjunto de VELOCIDADES BAIXAS
if x<=0,
    mi(1)=1;
else
    mi(1)=exp(-x^2/(2*spread^2));   
end

% Conjunto de VELOCIDADES MEDIAS
mi(2)=exp(-(x-7.5)^2/(2*spread^2));

% Conjunto de VELOCIDADES ALTAS
if x>=15,
   mi(3)=1;
else
   mi(3)=exp(-(x-15)^2/(2*spread^2));
end