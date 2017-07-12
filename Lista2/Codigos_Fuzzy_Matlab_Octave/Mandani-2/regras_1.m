function [mi yi]=regras_1(mi1,mi2,mi_out,y)
% Exemplo simples de base de regras nebulosas
%
% ENTRADA
%     mi1: graus de pertinencia da variavel x1 (distancia, m)
%     mi2: graus de pertinencia da variavel x2 (angulo, graus)
%     mi_out: funcoes de pertinencia da variavel de saida y (angulo, graus)
%
% SAIDA
%
%    RULE_OUT: Conjuntos fuzzy de saida modificados para todas as regras    
%
% Autor: Guilherme A. Barreto
% Data: 03/10/2009


%% REGRA 1 %%%%
%
% SE ((X1 = 1(LE)) E (X2 = 1(RB)))
% ENTAO (Y = PS(5))
%

m1=min(mi1(1),mi2(1));
mi_out_R1=min(m1,mi_out(:,5));

%figure;
%plot(y,mi_out_R1); hold on; plot(y,m1*ones(length(y)),'k.');
%xlabel('ANGULO');
%title('Conjunto Fuzzy de Saida - REGRA 1');
%axis([-90 270 -0.5 1.5]); hold off

y=y(:);
mi_out_R1=mi_out_R1(:);

if sum(mi_out_R1) ==0
    y1=0;
else
    y1 = sum(mi_out_R1.*y)/sum(mi_out_R1); %valor desfuzzificado da regra 1
end
%% REGRA 2 %%%%
%
% SE ((X1 = 1(LE)) E (X2 = 2(RU)))
% ENTAO (Y = PS(3))
%

m2=min(mi1(1),mi2(2));
mi_out_R2=min(m2,mi_out(:,3));

%figure;
%plot(y,mi_out_R2); hold on; plot(y,m1*ones(length(y)),'k.');
%xlabel('ANGULO');
%title('Conjunto Fuzzy de Saida - REGRA 2');
%axis([-90 270 -0.5 1.5]); hold off

mi_out_R2=mi_out_R2(:);

if sum(mi_out_R2) ==0
    y2=0;
else
    y2 = sum(mi_out_R2.*y)/sum(mi_out_R2); %valor desfuzzificado da regra 1
end
%% REGRA 3 %%%%
%
% SE ((X1 = 1(LE)) E (X2 = 3(RV)))
% ENTAO (Y = NM(2))
%

m3=min(mi1(1),mi2(3));
mi_out_R3=min(m3,mi_out(:,2));

%figure;
%plot(y,mi_out_R3); hold on; plot(y,m1*ones(length(y)),'k.');
%xlabel('ANGULO');
%title('Conjunto Fuzzy de Saida - REGRA 3');
%axis([-90 270 -0.5 1.5]); hold off

mi_out_R3=mi_out_R3(:);

if sum(mi_out_R3) ==0
    y3=0;
else
    y3 = sum(mi_out_R3.*y)/sum(mi_out_R3); %valor desfuzzificado da regra 1
end
%% REGRA 4 %%%%
%
% SE ((X1 = 1(LE)) E (X2 = 4(VE)))
% ENTAO (Y = NM(2))
%

m4=min(mi1(1),mi2(4));
mi_out_R4=min(m4,mi_out(:,2));

%figure;
%plot(y,mi_out_R4); hold on; plot(y,m1*ones(length(y)),'k.');
%xlabel('ANGULO');
%title('Conjunto Fuzzy de Saida - REGRA 4');
%axis([-90 270 -0.5 1.5]); hold off

mi_out_R4=mi_out_R4(:);

if sum(mi_out_R4) ==0
    y4=0;
else
    y4 = sum(mi_out_R4.*y)/sum(mi_out_R4); %valor desfuzzificado da regra 1
end
%% REGRA 5 %%%%
%
% SE ((X1 = 1(LE)) E (X2 = 5(VE)))
% ENTAO (Y = NM(1))
%

m5=min(mi1(1),mi2(5));
mi_out_R5=min(m5,mi_out(:,1));

%figure;
%plot(y,mi_out_R5); hold on; plot(y,m1*ones(length(y)),'k.');
%xlabel('ANGULO');
%title('Conjunto Fuzzy de Saida - REGRA 5');
%axis([-90 270 -0.5 1.5]); hold off

mi_out_R5=mi_out_R5(:);

if sum(mi_out_R5) ==0
    y5=0;
else
    y5 = sum(mi_out_R5.*y)/sum(mi_out_R5); %valor desfuzzificado da regra 1
end
%% REGRA 6 %%%%
%
% SE ((X1 = 1(LE)) E (X2 = 6(VE)))
% ENTAO (Y = NM(1))
%

m6=min(mi1(1),mi2(6));
mi_out_R6=min(m6,mi_out(:,1));

%figure;
%plot(y,mi_out_R6); hold on; plot(y,m1*ones(length(y)),'k.');
%xlabel('ANGULO');
%title('Conjunto Fuzzy de Saida - REGRA 6');
%axis([-90 270 -0.5 1.5]); hold off

mi_out_R6=mi_out_R6(:);

if sum(mi_out_R6) ==0
    y6=0;
else
    y6 = sum(mi_out_R6.*y)/sum(mi_out_R6); %valor desfuzzificado da regra 1
end
%% REGRA 7 %%%%
%
% SE ((X1 = 1(LE)) E (X2 = 7(VE)))
% ENTAO (Y = NM(1))
%

m7=min(mi1(1),mi2(7));
mi_out_R7=min(m7,mi_out(:,1));

%figure;
%plot(y,mi_out_R7); hold on; plot(y,m1*ones(length(y)),'k.');
%xlabel('ANGULO');
%title('Conjunto Fuzzy de Saida - REGRA 7');
%axis([-90 270 -0.5 1.5]); hold off

mi_out_R7=mi_out_R7(:);

if sum(mi_out_R7) ==0
    y7=0;
else
    y7 = sum(mi_out_R7.*y)/sum(mi_out_R7); %valor desfuzzificado da regra 1
end
%% REGRA 8 %%%%
%
% SE ((X1 = 2(LE)) E (X2 = 1(VE)))
% ENTAO (Y = NM(6))
%

m8=min(mi1(2),mi2(1));
mi_out_R8=min(m8,mi_out(:,6));

%figure;
%plot(y,mi_out_R8); hold on; plot(y,m1*ones(length(y)),'k.');
%xlabel('ANGULO');
%title('Conjunto Fuzzy de Saida - REGRA 8');
%axis([-90 270 -0.5 1.5]); hold off

mi_out_R8=mi_out_R8(:);

if sum(mi_out_R8) ==0
    y8=0;
else
    y8 = sum(mi_out_R8.*y)/sum(mi_out_R8); %valor desfuzzificado da regra 1
end
%% REGRA 9 %%%%
%
% SE ((X1 = 2(LE)) E (X2 = 2(VE)))
% ENTAO (Y = NM(5))
%

m9=min(mi1(2),mi2(2));
mi_out_R9=min(m9,mi_out(:,5));

%figure;
%plot(y,mi_out_R9); hold on; plot(y,m1*ones(length(y)),'k.');
%xlabel('ANGULO');
%title('Conjunto Fuzzy de Saida - REGRA 9');
%axis([-90 270 -0.5 1.5]); hold off

mi_out_R9=mi_out_R9(:);

if sum(mi_out_R9) ==0
    y9=0;
else
    y9 = sum(mi_out_R9.*y)/sum(mi_out_R9); %valor desfuzzificado da regra 1
end
%% REGRA 10 %%%%
%
% SE ((X1 = 2(LE)) E (X2 = 3(VE)))
% ENTAO (Y = NM(3))
%

m10=min(mi1(2),mi2(3));
mi_out_R10=min(m10,mi_out(:,3));

%figure;
%plot(y,mi_out_R10); hold on; plot(y,m1*ones(length(y)),'k.');
%xlabel('ANGULO');
%title('Conjunto Fuzzy de Saida - REGRA 10');
%axis([-90 270 -0.5 1.5]); hold off

mi_out_R10=mi_out_R10(:);

if sum(mi_out_R10) ==0
    y10=0;
else
    y10 = sum(mi_out_R10.*y)/sum(mi_out_R10); %valor desfuzzificado da regra 1
end
%% REGRA 11 %%%%
%
% SE ((X1 = 2(LE)) E (X2 = 4(VE)))
% ENTAO (Y = NM(2))
%

m11=min(mi1(2),mi2(4));
mi_out_R11=min(m11,mi_out(:,2));

%figure;
%plot(y,mi_out_R11); hold on; plot(y,m1*ones(length(y)),'k.');
%xlabel('ANGULO');
%title('Conjunto Fuzzy de Saida - REGRA 11');
%axis([-90 270 -0.5 1.5]); hold off

mi_out_R11=mi_out_R11(:);

if sum(mi_out_R11) ==0
    y11=0;
else
    y11 = sum(mi_out_R11.*y)/sum(mi_out_R11); %valor desfuzzificado da regra 1
end

%% REGRA 12 %%%%
%
% SE ((X1 = 2(LE)) E (X2 = 5(VE)))
% ENTAO (Y = NM(2))
%

m12=min(mi1(2),mi2(5));
mi_out_R12=min(m12,mi_out(:,2));

%figure;
%plot(y,mi_out_R12); hold on; plot(y,m1*ones(length(y)),'k.');
%xlabel('ANGULO');
%title('Conjunto Fuzzy de Saida - REGRA 12');
%axis([-90 270 -0.5 1.5]); hold off

mi_out_R12=mi_out_R12(:);

if sum(mi_out_R12) ==0
    y12=0;
else
    y12 = sum(mi_out_R12.*y)/sum(mi_out_R12); %valor desfuzzificado da regra 1
end
%% REGRA 13 %%%%
%
% SE ((X1 = 2(LE)) E (X2 = 6(VE)))
% ENTAO (Y = NM(1))
%

m13=min(mi1(2),mi2(6));
mi_out_R13=min(m13,mi_out(:,1));

%figure;
%plot(y,mi_out_R13); hold on; plot(y,m1*ones(length(y)),'k.');
%xlabel('ANGULO');
%title('Conjunto Fuzzy de Saida - REGRA 13');
%axis([-90 270 -0.5 1.5]); hold off

mi_out_R13=mi_out_R13(:);

if sum(mi_out_R13) ==0
    y13=0;
else
    y13 = sum(mi_out_R13.*y)/sum(mi_out_R13); %valor desfuzzificado da regra 1
end
%% REGRA 14 %%%%
%
% SE ((X1 = 2(LE)) E (X2 = 7(VE)))
% ENTAO (Y = NM(1))
%

m14=min(mi1(2),mi2(7));
mi_out_R14=min(m14,mi_out(:,1));

%figure;
%plot(y,mi_out_R14); hold on; plot(y,m1*ones(length(y)),'k.');
%xlabel('ANGULO');
%title('Conjunto Fuzzy de Saida - REGRA 14');
%axis([-90 270 -0.5 1.5]); hold off

mi_out_R14=mi_out_R14(:);

if sum(mi_out_R14) ==0
    y14=0;
else
    y14 = sum(mi_out_R14.*y)/sum(mi_out_R14); %valor desfuzzificado da regra 1
end
%% REGRA 15 %%%%
%
% SE ((X1 = 1(LE)) E (X2 = 4(VE)))
% ENTAO (Y = NM(2))
%

m15=min(mi1(3),mi2(1));
mi_out_R15=min(m15,mi_out(:,6));

%figure;
%plot(y,mi_out_R15); hold on; plot(y,m1*ones(length(y)),'k.');
%xlabel('ANGULO');
%title('Conjunto Fuzzy de Saida - REGRA 15');
%axis([-90 270 -0.5 1.5]); hold off

mi_out_R15=mi_out_R15(:);

if sum(mi_out_R15) ==0
    y15=0;
else
    y15 = sum(mi_out_R15.*y)/sum(mi_out_R15); %valor desfuzzificado da regra 1
end
%% REGRA 16 %%%%
%
% SE ((X1 = 1(LE)) E (X2 = 4(VE)))
% ENTAO (Y = NM(2))
%

m16=min(mi1(3),mi2(2));
mi_out_R16=min(m16,mi_out(:,6));

%figure;
%plot(y,mi_out_R16); hold on; plot(y,m1*ones(length(y)),'k.');
%xlabel('ANGULO');
%title('Conjunto Fuzzy de Saida - REGRA 16');
%axis([-90 270 -0.5 1.5]); hold off

mi_out_R16=mi_out_R16(:);

if sum(mi_out_R16) ==0
    y16=0;
else
    y16 = sum(mi_out_R16.*y)/sum(mi_out_R16); %valor desfuzzificado da regra 1
end
%% REGRA 17 %%%%
%
% SE ((X1 = 1(LE)) E (X2 = 4(VE)))
% ENTAO (Y = NM(2))
%

m17=min(mi1(3),mi2(3));
mi_out_R17=min(m17,mi_out(:,5));

%figure;
%plot(y,mi_out_R17); hold on; plot(y,m1*ones(length(y)),'k.');
%xlabel('ANGULO');
%title('Conjunto Fuzzy de Saida - REGRA 17');
%axis([-90 270 -0.5 1.5]); hold off

mi_out_R17=mi_out_R17(:);

if sum(mi_out_R17) ==0
    y17=0;
else
    y17 = sum(mi_out_R17.*y)/sum(mi_out_R17); %valor desfuzzificado da regra 1
end
%% REGRA 18 %%%%
%
% SE ((X1 = 1(LE)) E (X2 = 4(VE)))
% ENTAO (Y = NM(2))
%

m18=min(mi1(3),mi2(4));
mi_out_R18=min(m18,mi_out(:,4));

%figure;
%plot(y,mi_out_R18); hold on; plot(y,m1*ones(length(y)),'k.');
%xlabel('ANGULO');
%title('Conjunto Fuzzy de Saida - REGRA 18');
%axis([-90 270 -0.5 1.5]); hold off

mi_out_R18=mi_out_R18(:);

if sum(mi_out_R18) ==0
    y18=0;
else
    y18 = sum(mi_out_R18.*y)/sum(mi_out_R18); %valor desfuzzificado da regra 1
end
%% REGRA 19 %%%%
%
% SE ((X1 = 1(LE)) E (X2 = 4(VE)))
% ENTAO (Y = NM(2))
%

m19=min(mi1(3),mi2(5));
mi_out_R19=min(m19,mi_out(:,3));

%figure;
%plot(y,mi_out_R19); hold on; plot(y,m1*ones(length(y)),'k.');
%xlabel('ANGULO');
%title('Conjunto Fuzzy de Saida - REGRA 19');
%axis([-90 270 -0.5 1.5]); hold off

mi_out_R19=mi_out_R19(:);

if sum(mi_out_R19) ==0
    y19=0;
else
y19 = sum(mi_out_R19.*y)/sum(mi_out_R19); %valor desfuzzificado da regra 1
end
%% REGRA 20 %%%%
%
% SE ((X1 = 1(LE)) E (X2 = 4(VE)))
% ENTAO (Y = NM(2))
%

m20=min(mi1(3),mi2(6));
mi_out_R20=min(m20,mi_out(:,2));

%figure;
%plot(y,mi_out_R20); hold on; plot(y,m1*ones(length(y)),'k.');
%xlabel('ANGULO');
%title('Conjunto Fuzzy de Saida - REGRA 20');
%axis([-90 270 -0.5 1.5]); hold off

mi_out_R20=mi_out_R20(:);

if sum(mi_out_R20) ==0
    y20=0;
else
    y20 = sum(mi_out_R20.*y)/sum(mi_out_R20);
end
%% REGRA 21 %%%%
%
% SE ((X1 = 1(LE)) E (X2 = 4(VE)))
% ENTAO (Y = NM(2))
%

m21=min(mi1(3),mi2(7));
mi_out_R21=min(m21,mi_out(:,2));

%figure;
%plot(y,mi_out_R21); hold on; plot(y,m1*ones(length(y)),'k.');
%xlabel('ANGULO');
%title('Conjunto Fuzzy de Saida - REGRA 21');
%axis([-90 270 -0.5 1.5]); hold off

mi_out_R21=mi_out_R21(:);

if sum(mi_out_R21) ==0
    y21=0;
else
    y21 = sum(mi_out_R21.*y)/sum(mi_out_R21);
end
%% REGRA 22 %%%%
%
% SE ((X1 = 1(LE)) E (X2 = 4(VE)))
% ENTAO (Y = NM(2))
%

m22=min(mi1(4),mi2(1));
mi_out_R22=min(m22,mi_out(:,7));

%figure;
%plot(y,mi_out_R22); hold on; plot(y,m1*ones(length(y)),'k.');
%xlabel('ANGULO');
%title('Conjunto Fuzzy de Saida - REGRA 22');
%axis([-90 270 -0.5 1.5]); hold off

mi_out_R22=mi_out_R22(:);

if sum(mi_out_R22) ==0
    y22=0;
else
    y22 = sum(mi_out_R22.*y)/sum(mi_out_R22);
end
%% REGRA 23 %%%%
%
% SE ((X1 = 1(LE)) E (X2 = 4(VE)))
% ENTAO (Y = NM(2))
%

m23=min(mi1(4),mi2(2));
mi_out_R23=min(m23,mi_out(:,7));

%figure;
%plot(y,mi_out_R23); hold on; plot(y,m1*ones(length(y)),'k.');
%xlabel('ANGULO');
%title('Conjunto Fuzzy de Saida - REGRA 23');
%axis([-90 270 -0.5 1.5]); hold off

mi_out_R23=mi_out_R23(:);

if sum(mi_out_R23) ==0
    y23=0;
else
    y23 = sum(mi_out_R23.*y)/sum(mi_out_R23);
end
%% REGRA 24 %%%%
%
% SE ((X1 = 1(LE)) E (X2 = 4(VE)))
% ENTAO (Y = NM(2))
%

m24=min(mi1(4),mi2(3));
mi_out_R24=min(m24,mi_out(:,6));

%figure;
%plot(y,mi_out_R24); hold on; plot(y,m1*ones(length(y)),'k.');
%xlabel('ANGULO');
%title('Conjunto Fuzzy de Saida - REGRA 24');
%axis([-90 270 -0.5 1.5]); hold off

mi_out_R24=mi_out_R24(:);

if sum(mi_out_R24) ==0
    y24=0;
else
    y24 = sum(mi_out_R24.*y)/sum(mi_out_R24);
end
%% REGRA 25 %%%%
%
% SE ((X1 = 1(LE)) E (X2 = 4(VE)))
% ENTAO (Y = NM(2))
%

m25=min(mi1(4),mi2(4));
mi_out_R25=min(m25,mi_out(:,6));

%figure;
%plot(y,mi_out_R25); hold on; plot(y,m1*ones(length(y)),'k.');
%xlabel('ANGULO');
%title('Conjunto Fuzzy de Saida - REGRA 25');
%axis([-90 270 -0.5 1.5]); hold off

mi_out_R25=mi_out_R25(:);

if sum(mi_out_R25) ==0
    y25=0;
else
    y25 = sum(mi_out_R25.*y)/sum(mi_out_R25);
end
%% REGRA 26 %%%%
%
% SE ((X1 = 1(LE)) E (X2 = 4(VE)))
% ENTAO (Y = NM(2))
%

m26=min(mi1(4),mi2(5));
mi_out_R26=min(m26,mi_out(:,5));

%figure;
%plot(y,mi_out_R26); hold on; plot(y,m1*ones(length(y)),'k.');
%xlabel('ANGULO');
%title('Conjunto Fuzzy de Saida - REGRA 26');
%axis([-90 270 -0.5 1.5]); hold off

mi_out_R26=mi_out_R26(:);

if sum(mi_out_R26) ==0
    y26=0;
else
    y26 = sum(mi_out_R26.*y)/sum(mi_out_R26);
end
%% REGRA 27 %%%%
%
% SE ((X1 = 1(LE)) E (X2 = 4(VE)))
% ENTAO (Y = NM(2))
%

m27=min(mi1(4),mi2(6));
mi_out_R27=min(m27,mi_out(:,3));

%figure;
%plot(y,mi_out_R27); hold on; plot(y,m1*ones(length(y)),'k.');
%xlabel('ANGULO');
%title('Conjunto Fuzzy de Saida - REGRA 27');
%axis([-90 270 -0.5 1.5]); hold off

mi_out_R27=mi_out_R27(:);

if sum(mi_out_R27) ==0
    y27=0;
else
    y27 = sum(mi_out_R27.*y)/sum(mi_out_R27);
end
%% REGRA 28 %%%%
%
% SE ((X1 = 1(LE)) E (X2 = 4(VE)))
% ENTAO (Y = NM(2))
%

m28=min(mi1(4),mi2(7));
mi_out_R28=min(m28,mi_out(:,2));

%figure;
%plot(y,mi_out_R28); hold on; plot(y,m1*ones(length(y)),'k.');
%xlabel('ANGULO');
%title('Conjunto Fuzzy de Saida - REGRA 28');
%axis([-90 270 -0.5 1.5]); hold off

mi_out_R28=mi_out_R28(:);

if sum(mi_out_R28) ==0
    y28=0;
else
    y28 = sum(mi_out_R28.*y)/sum(mi_out_R28);
end
%% REGRA 29 %%%%
%
% SE ((X1 = 1(LE)) E (X2 = 4(VE)))
% ENTAO (Y = NM(2))
%

m29=min(mi1(5),mi2(1));
mi_out_R29=min(m29,mi_out(:,7));

%figure;
%plot(y,mi_out_R29); hold on; plot(y,m1*ones(length(y)),'k.');
%xlabel('ANGULO');
%title('Conjunto Fuzzy de Saida - REGRA 29');
%axis([-90 270 -0.5 1.5]); hold off

mi_out_R29=mi_out_R29(:);

if sum(mi_out_R29) ==0
    y29=0;
else
    y29 = sum(mi_out_R29.*y)/sum(mi_out_R29);
end
%% REGRA 30 %%%%
%
% SE ((X1 = 1(LE)) E (X2 = 4(VE)))
% ENTAO (Y = NM(2))
%

m30=min(mi1(5),mi2(2));
mi_out_R30=min(m30,mi_out(:,7));

%figure;
%plot(y,mi_out_R30); hold on; plot(y,m1*ones(length(y)),'k.');
%xlabel('ANGULO');
%title('Conjunto Fuzzy de Saida - REGRA 30');
%axis([-90 270 -0.5 1.5]); hold off

mi_out_R30=mi_out_R30(:);

if sum(mi_out_R30) ==0
    y30=0;
else
    y30 = sum(mi_out_R30.*y)/sum(mi_out_R30);
end
%% REGRA 31 %%%%
%
% SE ((X1 = 1(LE)) E (X2 = 4(VE)))
% ENTAO (Y = NM(2))
%

m31=min(mi1(5),mi2(3));
mi_out_R31=min(m31,mi_out(:,7));

%figure;
%plot(y,mi_out_R31); hold on; plot(y,m1*ones(length(y)),'k.');
%xlabel('ANGULO');
%title('Conjunto Fuzzy de Saida - REGRA 31');
%axis([-90 270 -0.5 1.5]); hold off

mi_out_R31=mi_out_R31(:);

if sum(mi_out_R31) ==0
    y31=0;
else
    y31 = sum(mi_out_R31.*y)/sum(mi_out_R31);
end
%% REGRA 32 %%%%
%
% SE ((X1 = 1(LE)) E (X2 = 4(VE)))
% ENTAO (Y = NM(2))
%

m32=min(mi1(5),mi2(4));
mi_out_R32=min(m32,mi_out(:,6));

%figure;
%plot(y,mi_out_R32); hold on; plot(y,m1*ones(length(y)),'k.');
%xlabel('ANGULO');
%title('Conjunto Fuzzy de Saida - REGRA 32');
%axis([-90 270 -0.5 1.5]); hold off

mi_out_R32=mi_out_R32(:);

if sum(mi_out_R32) ==0
    y32=0;
else
    y32 = sum(mi_out_R32.*y)/sum(mi_out_R32);
end
%% REGRA 33 %%%%
%
% SE ((X1 = 1(LE)) E (X2 = 4(VE)))
% ENTAO (Y = NM(2))
%

m33=min(mi1(5),mi2(5));
mi_out_R33=min(m33,mi_out(:,6));

%figure;
%plot(y,mi_out_R33); hold on; plot(y,m1*ones(length(y)),'k.');
%xlabel('ANGULO');
%title('Conjunto Fuzzy de Saida - REGRA 33');
%axis([-90 270 -0.5 1.5]); hold off

mi_out_R33=mi_out_R33(:);

if sum(mi_out_R33) ==0
    y33=0;
else
    y33 = sum(mi_out_R33.*y)/sum(mi_out_R33);
end
%% REGRA 34 %%%%
%
% SE ((X1 = 1(LE)) E (X2 = 4(VE)))
% ENTAO (Y = NM(2))
%

m34=min(mi1(5),mi2(6));
mi_out_R34=min(m34,mi_out(:,5));

%figure;
%plot(y,mi_out_R34); hold on; plot(y,m1*ones(length(y)),'k.');
%xlabel('ANGULO');
%title('Conjunto Fuzzy de Saida - REGRA 34');
%axis([-90 270 -0.5 1.5]); hold off

mi_out_R34=mi_out_R34(:);

if sum(mi_out_R34) ==0
    y34=0;
else
    y34 = sum(mi_out_R34.*y)/sum(mi_out_R34);
end
%% REGRA 35 %%%%
%
% SE ((X1 = 1(LE)) E (X2 = 4(VE)))
% ENTAO (Y = NM(2))
%

m35=min(mi1(5),mi2(7));
mi_out_R35=min(m35,mi_out(:,3));

%figure;
%plot(y,mi_out_R35); hold on; plot(y,m1*ones(length(y)),'k.');
%xlabel('ANGULO');
%title('Conjunto Fuzzy de Saida - REGRA 35');
%axis([-90 270 -0.5 1.5]); hold off

mi_out_R35=mi_out_R35(:);

if sum(mi_out_R35) ==0
    y35=0;
else
    y35 = sum(mi_out_R35.*y)/sum(mi_out_R35);
end
mi=[m1; m2; m3; m4; m5; m6; m7; m8; m9; m10; m11; m12; m13; m14; m15; m16; m17; m18; m19; m20; m21; m22; m23; m24; m25; m26; m27; m28; m29; m30; m31; m32; m33; m34; m35];  % ativacoes das regras
yi=[y1; y2; y3; y4; y5; y6; y7; y8; y9; y10; y11; y12; y13; y14; y15; y16; y17; y18; y19; y20; y21; y22; y23; y24; y25; y26; y27; y28; y29; y30; y31; y32; y33; y34; y35];  % saidas desfuzzificadas de cada regra
