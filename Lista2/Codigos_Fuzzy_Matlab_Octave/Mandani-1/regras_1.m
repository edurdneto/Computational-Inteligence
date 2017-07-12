function RULE_OUT=regras(mi1,mi2,mi_out,y)
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

%%figure;
%%plot(y,mi_out_R1); hold on; %plot(y,m1*ones(length(y)),'k.');
%%xlabel('ANGULO');
%%title('Conjunto Fuzzy de Saida - REGRA 1');
%%axis([-90 270 -0.5 1.5]); hold off


%% REGRA 2 %%%%
%
% SE ((X1 = 1(LE)) E (X2 = 2(RU)))
% ENTAO (Y = PS(3))
%

m1=min(mi1(1),mi2(2));
mi_out_R2=min(m1,mi_out(:,3));

%%figure;
%%plot(y,mi_out_R2); hold on; %plot(y,m1*ones(length(y)),'k.');
%%xlabel('ANGULO');
%%title('Conjunto Fuzzy de Saida - REGRA 2');
%%axis([-90 270 -0.5 1.5]); hold off

%% REGRA 3 %%%%
%
% SE ((X1 = 1(LE)) E (X2 = 3(RV)))
% ENTAO (Y = NM(2))
%

m1=min(mi1(1),mi2(3));
mi_out_R3=min(m1,mi_out(:,2));

%%figure;
%%plot(y,mi_out_R3); hold on; %plot(y,m1*ones(length(y)),'k.');
%%xlabel('ANGULO');
%%title('Conjunto Fuzzy de Saida - REGRA 3');
%%axis([-90 270 -0.5 1.5]); hold off

%% REGRA 4 %%%%
%
% SE ((X1 = 1(LE)) E (X2 = 4(VE)))
% ENTAO (Y = NM(2))
%

m1=min(mi1(1),mi2(4));
mi_out_R4=min(m1,mi_out(:,2));

%figure;
%plot(y,mi_out_R4); hold on; %plot(y,m1*ones(length(y)),'k.');
%xlabel('ANGULO');
%title('Conjunto Fuzzy de Saida - REGRA 4');
%axis([-90 270 -0.5 1.5]); hold off

%% REGRA 5 %%%%
%
% SE ((X1 = 1(LE)) E (X2 = 5(VE)))
% ENTAO (Y = NM(1))
%

m1=min(mi1(1),mi2(5));
mi_out_R5=min(m1,mi_out(:,1));

%figure;
%plot(y,mi_out_R5); hold on; %plot(y,m1*ones(length(y)),'k.');
%xlabel('ANGULO');
%title('Conjunto Fuzzy de Saida - REGRA 5');
%axis([-90 270 -0.5 1.5]); hold off

%% REGRA 6 %%%%
%
% SE ((X1 = 1(LE)) E (X2 = 6(VE)))
% ENTAO (Y = NM(1))
%

m1=min(mi1(1),mi2(6));
mi_out_R6=min(m1,mi_out(:,1));

%figure;
%plot(y,mi_out_R6); hold on; %plot(y,m1*ones(length(y)),'k.');
%xlabel('ANGULO');
%title('Conjunto Fuzzy de Saida - REGRA 6');
%axis([-90 270 -0.5 1.5]); hold off

%% REGRA 7 %%%%
%
% SE ((X1 = 1(LE)) E (X2 = 7(VE)))
% ENTAO (Y = NM(1))
%

m1=min(mi1(1),mi2(7));
mi_out_R7=min(m1,mi_out(:,1));

%figure;
%plot(y,mi_out_R7); hold on; %plot(y,m1*ones(length(y)),'k.');
%xlabel('ANGULO');
%title('Conjunto Fuzzy de Saida - REGRA 7');
%axis([-90 270 -0.5 1.5]); hold off

%% REGRA 8 %%%%
%
% SE ((X1 = 2(LE)) E (X2 = 1(VE)))
% ENTAO (Y = NM(6))
%

m1=min(mi1(2),mi2(1));
mi_out_R8=min(m1,mi_out(:,6));

%figure;
%plot(y,mi_out_R8); hold on; %plot(y,m1*ones(length(y)),'k.');
%xlabel('ANGULO');
%title('Conjunto Fuzzy de Saida - REGRA 8');
%axis([-90 270 -0.5 1.5]); hold off

%% REGRA 9 %%%%
%
% SE ((X1 = 2(LE)) E (X2 = 2(VE)))
% ENTAO (Y = NM(5))
%

m1=min(mi1(2),mi2(2));
mi_out_R9=min(m1,mi_out(:,5));

%figure;
%plot(y,mi_out_R9); hold on; %plot(y,m1*ones(length(y)),'k.');
%xlabel('ANGULO');
%title('Conjunto Fuzzy de Saida - REGRA 9');
%axis([-90 270 -0.5 1.5]); hold off

%% REGRA 10 %%%%
%
% SE ((X1 = 2(LE)) E (X2 = 3(VE)))
% ENTAO (Y = NM(3))
%

m1=min(mi1(2),mi2(3));
mi_out_R10=min(m1,mi_out(:,3));

%figure;
%plot(y,mi_out_R10); hold on; %plot(y,m1*ones(length(y)),'k.');
%xlabel('ANGULO');
%title('Conjunto Fuzzy de Saida - REGRA 10');
%axis([-90 270 -0.5 1.5]); hold off

%% REGRA 11 %%%%
%
% SE ((X1 = 2(LE)) E (X2 = 4(VE)))
% ENTAO (Y = NM(2))
%

m1=min(mi1(2),mi2(4));
mi_out_R11=min(m1,mi_out(:,2));

%figure;
%plot(y,mi_out_R11); hold on; %plot(y,m1*ones(length(y)),'k.');
%xlabel('ANGULO');
%title('Conjunto Fuzzy de Saida - REGRA 11');
%axis([-90 270 -0.5 1.5]); hold off

%% REGRA 12 %%%%
%
% SE ((X1 = 2(LE)) E (X2 = 5(VE)))
% ENTAO (Y = NM(2))
%

m1=min(mi1(2),mi2(5));
mi_out_R12=min(m1,mi_out(:,2));

%figure;
%plot(y,mi_out_R12); hold on; %plot(y,m1*ones(length(y)),'k.');
%xlabel('ANGULO');
%title('Conjunto Fuzzy de Saida - REGRA 12');
%axis([-90 270 -0.5 1.5]); hold off

%% REGRA 13 %%%%
%
% SE ((X1 = 2(LE)) E (X2 = 6(VE)))
% ENTAO (Y = NM(1))
%

m1=min(mi1(2),mi2(6));
mi_out_R13=min(m1,mi_out(:,1));

%figure;
%plot(y,mi_out_R13); hold on; %plot(y,m1*ones(length(y)),'k.');
%xlabel('ANGULO');
%title('Conjunto Fuzzy de Saida - REGRA 13');
%axis([-90 270 -0.5 1.5]); hold off

%% REGRA 14 %%%%
%
% SE ((X1 = 2(LE)) E (X2 = 7(VE)))
% ENTAO (Y = NM(1))
%

m1=min(mi1(2),mi2(7));
mi_out_R14=min(m1,mi_out(:,1));

%figure;
%plot(y,mi_out_R14); hold on; %plot(y,m1*ones(length(y)),'k.');
%xlabel('ANGULO');
%title('Conjunto Fuzzy de Saida - REGRA 14');
%axis([-90 270 -0.5 1.5]); hold off

%% REGRA 15 %%%%
%
% SE ((X1 = 1(LE)) E (X2 = 4(VE)))
% ENTAO (Y = NM(2))
%

m1=min(mi1(3),mi2(1));
mi_out_R15=min(m1,mi_out(:,6));

%figure;
%plot(y,mi_out_R15); hold on; %plot(y,m1*ones(length(y)),'k.');
%xlabel('ANGULO');
%title('Conjunto Fuzzy de Saida - REGRA 15');
%axis([-90 270 -0.5 1.5]); hold off

%% REGRA 16 %%%%
%
% SE ((X1 = 1(LE)) E (X2 = 4(VE)))
% ENTAO (Y = NM(2))
%

m1=min(mi1(3),mi2(2));
mi_out_R16=min(m1,mi_out(:,6));

%figure;
%plot(y,mi_out_R16); hold on; %plot(y,m1*ones(length(y)),'k.');
%xlabel('ANGULO');
%title('Conjunto Fuzzy de Saida - REGRA 16');
%axis([-90 270 -0.5 1.5]); hold off

%% REGRA 17 %%%%
%
% SE ((X1 = 1(LE)) E (X2 = 4(VE)))
% ENTAO (Y = NM(2))
%

m1=min(mi1(3),mi2(3));
mi_out_R17=min(m1,mi_out(:,5));

%figure;
%plot(y,mi_out_R17); hold on; %plot(y,m1*ones(length(y)),'k.');
%xlabel('ANGULO');
%title('Conjunto Fuzzy de Saida - REGRA 17');
%axis([-90 270 -0.5 1.5]); hold off

%% REGRA 18 %%%%
%
% SE ((X1 = 1(LE)) E (X2 = 4(VE)))
% ENTAO (Y = NM(2))
%

m1=min(mi1(3),mi2(4));
mi_out_R18=min(m1,mi_out(:,4));

%figure;
%plot(y,mi_out_R18); hold on; %plot(y,m1*ones(length(y)),'k.');
%xlabel('ANGULO');
%title('Conjunto Fuzzy de Saida - REGRA 18');
%axis([-90 270 -0.5 1.5]); hold off

%% REGRA 19 %%%%
%
% SE ((X1 = 1(LE)) E (X2 = 4(VE)))
% ENTAO (Y = NM(2))
%

m1=min(mi1(3),mi2(5));
mi_out_R19=min(m1,mi_out(:,3));

%figure;
%plot(y,mi_out_R19); hold on; %plot(y,m1*ones(length(y)),'k.');
%xlabel('ANGULO');
%title('Conjunto Fuzzy de Saida - REGRA 19');
%axis([-90 270 -0.5 1.5]); hold off

%% REGRA 20 %%%%
%
% SE ((X1 = 1(LE)) E (X2 = 4(VE)))
% ENTAO (Y = NM(2))
%

m1=min(mi1(3),mi2(6));
mi_out_R20=min(m1,mi_out(:,2));

%figure;
%plot(y,mi_out_R20); hold on; %plot(y,m1*ones(length(y)),'k.');
%xlabel('ANGULO');
%title('Conjunto Fuzzy de Saida - REGRA 20');
%axis([-90 270 -0.5 1.5]); hold off

%% REGRA 21 %%%%
%
% SE ((X1 = 1(LE)) E (X2 = 4(VE)))
% ENTAO (Y = NM(2))
%

m1=min(mi1(3),mi2(7));
mi_out_R21=min(m1,mi_out(:,2));

%figure;
%plot(y,mi_out_R21); hold on; %plot(y,m1*ones(length(y)),'k.');
%xlabel('ANGULO');
%title('Conjunto Fuzzy de Saida - REGRA 21');
%axis([-90 270 -0.5 1.5]); hold off

%% REGRA 22 %%%%
%
% SE ((X1 = 1(LE)) E (X2 = 4(VE)))
% ENTAO (Y = NM(2))
%

m1=min(mi1(4),mi2(1));
mi_out_R22=min(m1,mi_out(:,7));

%figure;
%plot(y,mi_out_R22); hold on; %plot(y,m1*ones(length(y)),'k.');
%xlabel('ANGULO');
%title('Conjunto Fuzzy de Saida - REGRA 22');
%axis([-90 270 -0.5 1.5]); hold off

%% REGRA 23 %%%%
%
% SE ((X1 = 1(LE)) E (X2 = 4(VE)))
% ENTAO (Y = NM(2))
%

m1=min(mi1(4),mi2(2));
mi_out_R23=min(m1,mi_out(:,7));

%figure;
%plot(y,mi_out_R23); hold on; %plot(y,m1*ones(length(y)),'k.');
%xlabel('ANGULO');
%title('Conjunto Fuzzy de Saida - REGRA 23');
%axis([-90 270 -0.5 1.5]); hold off

%% REGRA 24 %%%%
%
% SE ((X1 = 1(LE)) E (X2 = 4(VE)))
% ENTAO (Y = NM(2))
%

m1=min(mi1(4),mi2(3));
mi_out_R24=min(m1,mi_out(:,6));

%figure;
%plot(y,mi_out_R24); hold on; %plot(y,m1*ones(length(y)),'k.');
%xlabel('ANGULO');
%title('Conjunto Fuzzy de Saida - REGRA 24');
%axis([-90 270 -0.5 1.5]); hold off

%% REGRA 25 %%%%
%
% SE ((X1 = 1(LE)) E (X2 = 4(VE)))
% ENTAO (Y = NM(2))
%

m1=min(mi1(4),mi2(4));
mi_out_R25=min(m1,mi_out(:,6));

%figure;
%plot(y,mi_out_R25); hold on; %plot(y,m1*ones(length(y)),'k.');
%xlabel('ANGULO');
%title('Conjunto Fuzzy de Saida - REGRA 25');
%axis([-90 270 -0.5 1.5]); hold off

%% REGRA 26 %%%%
%
% SE ((X1 = 1(LE)) E (X2 = 4(VE)))
% ENTAO (Y = NM(2))
%

m1=min(mi1(4),mi2(5));
mi_out_R26=min(m1,mi_out(:,5));

%figure;
%plot(y,mi_out_R26); hold on; %plot(y,m1*ones(length(y)),'k.');
%xlabel('ANGULO');
%title('Conjunto Fuzzy de Saida - REGRA 26');
%axis([-90 270 -0.5 1.5]); hold off

%% REGRA 27 %%%%
%
% SE ((X1 = 1(LE)) E (X2 = 4(VE)))
% ENTAO (Y = NM(2))
%

m1=min(mi1(4),mi2(6));
mi_out_R27=min(m1,mi_out(:,3));

%figure;
%plot(y,mi_out_R27); hold on; %plot(y,m1*ones(length(y)),'k.');
%xlabel('ANGULO');
%title('Conjunto Fuzzy de Saida - REGRA 27');
%axis([-90 270 -0.5 1.5]); hold off

%% REGRA 28 %%%%
%
% SE ((X1 = 1(LE)) E (X2 = 4(VE)))
% ENTAO (Y = NM(2))
%

m1=min(mi1(4),mi2(7));
mi_out_R28=min(m1,mi_out(:,2));

%figure;
%plot(y,mi_out_R28); hold on; %plot(y,m1*ones(length(y)),'k.');
%xlabel('ANGULO');
%title('Conjunto Fuzzy de Saida - REGRA 28');
%axis([-90 270 -0.5 1.5]); hold off

%% REGRA 29 %%%%
%
% SE ((X1 = 1(LE)) E (X2 = 4(VE)))
% ENTAO (Y = NM(2))
%

m1=min(mi1(5),mi2(1));
mi_out_R29=min(m1,mi_out(:,7));

%figure;
%plot(y,mi_out_R29); hold on; %plot(y,m1*ones(length(y)),'k.');
%xlabel('ANGULO');
%title('Conjunto Fuzzy de Saida - REGRA 29');
%axis([-90 270 -0.5 1.5]); hold off

%% REGRA 30 %%%%
%
% SE ((X1 = 1(LE)) E (X2 = 4(VE)))
% ENTAO (Y = NM(2))
%

m1=min(mi1(5),mi2(2));
mi_out_R30=min(m1,mi_out(:,7));

%figure;
%plot(y,mi_out_R30); hold on; %plot(y,m1*ones(length(y)),'k.');
%xlabel('ANGULO');
%title('Conjunto Fuzzy de Saida - REGRA 30');
%axis([-90 270 -0.5 1.5]); hold off

%% REGRA 31 %%%%
%
% SE ((X1 = 1(LE)) E (X2 = 4(VE)))
% ENTAO (Y = NM(2))
%

m1=min(mi1(5),mi2(3));
mi_out_R31=min(m1,mi_out(:,7));

%figure;
%plot(y,mi_out_R31); hold on; %plot(y,m1*ones(length(y)),'k.');
%xlabel('ANGULO');
%title('Conjunto Fuzzy de Saida - REGRA 31');
%axis([-90 270 -0.5 1.5]); hold off

%% REGRA 32 %%%%
%
% SE ((X1 = 1(LE)) E (X2 = 4(VE)))
% ENTAO (Y = NM(2))
%

m1=min(mi1(5),mi2(4));
mi_out_R32=min(m1,mi_out(:,6));

%figure;
%plot(y,mi_out_R32); hold on; %plot(y,m1*ones(length(y)),'k.');
%xlabel('ANGULO');
%title('Conjunto Fuzzy de Saida - REGRA 32');
%axis([-90 270 -0.5 1.5]); hold off

%% REGRA 33 %%%%
%
% SE ((X1 = 1(LE)) E (X2 = 4(VE)))
% ENTAO (Y = NM(2))
%

m1=min(mi1(5),mi2(5));
mi_out_R33=min(m1,mi_out(:,6));

%figure;
%plot(y,mi_out_R33); hold on; %plot(y,m1*ones(length(y)),'k.');
%xlabel('ANGULO');
%title('Conjunto Fuzzy de Saida - REGRA 33');
%axis([-90 270 -0.5 1.5]); hold off

%% REGRA 34 %%%%
%
% SE ((X1 = 1(LE)) E (X2 = 4(VE)))
% ENTAO (Y = NM(2))
%

m1=min(mi1(5),mi2(6));
mi_out_R34=min(m1,mi_out(:,5));

%figure;
%plot(y,mi_out_R34); hold on; %plot(y,m1*ones(length(y)),'k.');
%xlabel('ANGULO');
%title('Conjunto Fuzzy de Saida - REGRA 34');
%axis([-90 270 -0.5 1.5]); hold off

%% REGRA 35 %%%%
%
% SE ((X1 = 1(LE)) E (X2 = 4(VE)))
% ENTAO (Y = NM(2))
%

m1=min(mi1(5),mi2(7));
mi_out_R35=min(m1,mi_out(:,3));

%figure;
%plot(y,mi_out_R35); hold on; %plot(y,m1*ones(length(y)),'k.');
%xlabel('ANGULO');
%title('Conjunto Fuzzy de Saida - REGRA 35');
%axis([-90 270 -0.5 1.5]); hold off

RULE_OUT=[mi_out_R1'; mi_out_R2'; mi_out_R3'; mi_out_R4'; mi_out_R5'; mi_out_R6'; mi_out_R7'; mi_out_R8'; mi_out_R9'; mi_out_R10'; mi_out_R11'; mi_out_R12'; mi_out_R13'; mi_out_R14'; mi_out_R15'; mi_out_R16'; mi_out_R17'; mi_out_R18'; mi_out_R19'; mi_out_R20'; mi_out_R21'; mi_out_R22'; mi_out_R23'; mi_out_R24'; mi_out_R25'; mi_out_R26'; mi_out_R27'; mi_out_R28'; mi_out_R29'; mi_out_R30'; mi_out_R31'; mi_out_R32'; mi_out_R33'; mi_out_R34'; mi_out_R35'];

