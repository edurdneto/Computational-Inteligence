function mi=angulo_saida(x)
%
% Retorna as pertinências da medida x aos conjuntos fuzzy
% definidos para a variável lingüística VELOCIDADE.
%
% Funcoes de pertinencia TRIANGULARES/TRAPEZOIDAS
%
% Data: 19/09/2009
% Autor: Guilherme A. Barreto

% Conjunto de Angulo NB
if x<=-22,
   mi(1)=1;
elseif x>-22 & x<-15,
   mi(1)=-(1/7)*(x+15);
else
   mi(1)=0;
end

% Conjunto de Distancias NM
if x<=-22,
   mi(2)=0;
elseif x>-22 & x<=-15,
   mi(2)=(1/7)*(x+22);
elseif x>-15 & x<=-10,
   mi(2)=1;
elseif x>-10 & x<-5,
   mi(2)=-(1/5)*(x+5);
else
   mi(2)=0;
end

% Conjunto de Distancias NS
if x<=-10,
   mi(3)=0;
elseif x>-10 & x<=-5,
   mi(3)=(1/5)*(x+10);
elseif x>-5 & x<=0,
   mi(3)=-(1/5)*(x);
else
   mi(3)=0;
end

% Conjunto de Distancias ZE
if x<=-5,
   mi(4)=0;
elseif x>-5 & x<=0,
   mi(4)=(1/5)*(x+5);
elseif x>0 & x<5,
   mi(4)=-(1/5)*(x-5);
else
   mi(4)=0;
end

% Conjunto de Distancias PS
if x<=0,
   mi(5)=0;
elseif x>0 & x<=5,
   mi(5)=(1/5)*(x);
elseif x>5 & x<10,
   mi(5)=-(1/5)*(x-10);
else
   mi(5)=0;
end

% Conjunto de Distancias PM
if x<=5,
   mi(6)=0;
elseif x>5 & x<=15,
   mi(6)=(1/10)*(x-5);
elseif x>15 & x<=22,
   mi(6)=-(1/7)*(x-22);
else
   mi(6)=0;
end

% Conjunto de Distancias PB
if x>22,
   mi(7)=1;
elseif x>15 & x<=22,
   mi(7)=(1/7)*(x-15);
else
   mi(7)=0;
end
