function mi=angulo(x)
%
% Retorna as pertinências da medida x aos conjuntos fuzzy
% definidos para a variável lingüística VELOCIDADE.
%
% Funcoes de pertinencia TRIANGULARES/TRAPEZOIDAS
%
% Data: 19/09/2009
% Autor: Guilherme A. Barreto

% Conjunto de Angulo RB
if x<=0,
   mi(1)=1;
elseif x>0 & x<15,
   mi(1)=-(1/15)*(x-15);
else
   mi(1)=0;
end

% Conjunto de Distancias RU
if x<=0,
   mi(2)=0;
elseif x>0 & x<=15,
   mi(2)=(1/15)*(x);
elseif x>15 & x<=30,
   mi(2)=1;
elseif x>30 & x<45,
   mi(2)=-(1/15)*(x-45);
else
   mi(2)=0;
end

% Conjunto de Distancias RV
if x<=30,
   mi(3)=0;
elseif x>30 & x<=45,
   mi(3)=(1/15)*(x-30);
elseif x>45 & x<=80,
   mi(3)=1;
elseif x>80 & x<90
   mi(3)=-(1/10)*(x-90);
else
   mi(3)=0;
end

% Conjunto de Distancias VE
if x<=80,
   mi(4)=0;
elseif x>80 & x<=90,
   mi(4)=(1/10)*(x-80);
elseif x>90 & x<105,
   mi(4)=-(1/15)*(x-105);
else
   mi(4)=0;
end

% Conjunto de Distancias LV
if x<=90,
   mi(5)=0;
elseif x>90 & x<=105,
   mi(5)=(1/15)*(x-90);
elseif x>105 & x<=135,
   mi(5)=1;
elseif x>135 & x<150,
   mi(5)=-(1/15)*(x-150);
else
   mi(5)=0;
end

% Conjunto de Distancias LU
if x<=135,
   mi(6)=0;
elseif x>135 & x<=150,
   mi(6)=(1/15)*(x-135);
elseif x>150 & x<=160,
   mi(6)=1;
elseif x>160 & x<=180,
   mi(6)=-(1/20)*(x-180);
else
   mi(6)=0;
end

% Conjunto de Distancias LV
if x>180,
   mi(7)=1;
elseif x>160 & x<=180,
   mi(7)=(1/20)*(x-160);
else
   mi(7)=0;
end
