function mi=vento(x)
%
% Retorna as pertinências da medida x aos conjuntos fuzzy
% definidos para a variável lingüística VELOCIDADE.
%
% Funcoes de pertinencia TRIANGULARES/TRAPEZOIDAS
%
% Data: 19/09/2009
% Autor: Guilherme A. Barreto

% Conjunto de VELOCIDADES BAIXAS
if x<=5,
   mi(1)=1;
elseif x>5 & x<9,
   mi(1)=-(1/4)*(x-9);
else
   mi(1)=0;
end

% Conjunto de VELOCIDADES MEDIAS
if x<=5,
   mi(2)=0;
elseif x>5 & x<=9,
   mi(2)=(1/4)*(x-5);
elseif x>9 & x<13,
   mi(2)=-(1/4)*(x-13);
else
   mi(2)=0;
end

% Conjunto de VELOCIDADES ALTAS
if x>=13,
   mi(3)=1;
elseif x>=9 & x<=13,
   mi(3)=(1/4)*(x-9);
else
   mi(3)=0;
end