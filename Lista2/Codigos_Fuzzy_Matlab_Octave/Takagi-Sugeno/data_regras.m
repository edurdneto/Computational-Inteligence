function mi=data_regras(x,spread)
%
% Retorna as pertinências da medida x aos conjuntos fuzzy
% definidos para a variável lingüística VELOCIDADE.
%
% Funcoes de pertinencia TRIANGULARES/TRAPEZOIDAS
%
% Data: 19/09/2009
% Autor: Guilherme A. Barreto

% Conjunto de VELOCIDADES BAIXAS
if x<=50,
    mi(1)=1;
elseif x>50 & x<90
    mi(1)=-(1/40)*(x-90); 
else
    mi(1)=0;
end

% Conjunto de VELOCIDADES MEDIAS
if x>50 & x<=90,
    mi(2)=(1/40)*(x-50);
elseif x>90 & x<=110,
    mi(2)=1;
elseif x>110 & x<120,
    mi(2)=-(1/10)*(x-120);
else
    mi(2)=0;
end

if x>110 & x<=120,
    mi(3)=(1/10)*(x-110);
elseif x>120 & x<=130,
    mi(3)=1;
elseif x>130 & x<145,
    mi(3)=-(1/15)*(x-145);
else
    mi(3)=0;
end

if x>130 & x<=145,
    mi(4)=(1/15)*(x-130);
elseif x>145 & x<150,
    mi(4)=-(1/5)*(x-150);
else
    mi(4)=0;
end

if x>145 & x<=150,
    mi(5)=(1/5)*(x-145);
elseif x>150 & x<=170,
    mi(5)=1;
elseif x>170 & x<200,
    mi(5)=-(1/30)*(x-200);
else
    mi(5)=0;
end
    
if x>170 & x<=200,
    mi(6)=(1/30)*(x-170);
elseif x>200,
    mi(6)=1;
else
    mi(6)=0;
end


% Conjunto de VELOCIDADES ALTAS
%if x>=15,
%   mi(3)=1;
%else
%   mi(3)=exp(-(x-15)^2/(2*spread^2));
%end