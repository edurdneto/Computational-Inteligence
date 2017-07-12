function mi=distancia(x)
%
% Retorna as pertinências da medida x aos conjuntos fuzzy
% definidos para a variável lingüística VELOCIDADE.
%
% Funcoes de pertinencia TRIANGULARES/TRAPEZOIDAS
%
% Data: 19/09/2009
% Autor: Guilherme A. Barreto

% Conjunto de Distancias LE
if x<=30,
   mi(1)=1;
elseif x>30 & x<35,
   mi(1)=-(1/5)*(x-35);
else
   mi(1)=0;
end

% Conjunto de Distancias LC
if x<=30,
   mi(2)=0;
elseif x>30 & x<=35,
   mi(2)=(1/5)*(x-30);
elseif x>35 & x<=45,
   mi(2)=1;
elseif x>45 & x<50,
   mi(2)=-(1/5)*(x-50);
else
   mi(2)=0;
end

% Conjunto de Distancias CE
if x<=45,
   mi(3)=0;
elseif x>45 & x<=50,
   mi(3)=(1/5)*(x-45);
elseif x>50 & x<55,
   mi(3)=-(1/5)*(x-55);
else
   mi(3)=0;
end

% Conjunto de Distancias RC
if x<=50,
   mi(4)=0;
elseif x>50 & x<=55,
   mi(4)=(1/5)*(x-50);
elseif x>55 & x<=65,
   mi(4)=1;
elseif x>65 & x<70,
   mi(4)=-(1/5)*(x-70);
else
   mi(4)=0;
end

% Conjunto de Distancias HI
if x>70
   mi(5)=1;
elseif x>65 & x<=70,
   mi(5)=(1/5)*(x-65);
else
   mi(5)=0;
end
