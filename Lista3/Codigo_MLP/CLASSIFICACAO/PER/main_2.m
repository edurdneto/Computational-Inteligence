clear; clc; close all

load derm_input.txt;
load derm_target.txt;

dados=derm_input;  % Vetores (padroes) de entrada
alvos=derm_target; % Saidas desejadas correspondentes
total_classes=[sum(alvos(1,:)),sum(alvos(2,:)),sum(alvos(3,:)),sum(alvos(4,:)),sum(alvos(5,:)),sum(alvos(6,:))];
 
clear derm_input;  % Libera espaco em memoria
clear derm_target;

% Embaralha vetores de entrada e saidas desejadas
[LinD ColD]=size(dados);

% Normaliza componetes para media zero e variancia unitaria
for i=1:LinD,
	mi=mean(dados(i,:));  % Media das linhas
    di=std(dados(i,:));   % desvio-padrao das linhas 
	dados(i,:)= (dados(i,:) - mi)./di;
end 
Dn=dados;

ptrn=0.8;    % Porcentagem usada para treino
ptst=1-ptrn; % Porcentagem usada para teste

Nr = 100;   % No. de rodadas de treinamento/teste
No = 6;   % No. de neuronios na camada de saida


Tx_OK_c=[];
T2_out = [];
T2_in =[];

for r=1:Nr,  % LOOP de rodadas de treinamento/teste
    
    rodada=r,
    
    I=randperm(ColD); Dn=Dn(:,I); alvos=alvos(:,I);   % Embaralha pares entrada/saida 
        
    % Vetores para treinamento e saidas desejadas correspondentes
    J=floor(ptrn*ColD);
    P = Dn(:,1:J); T1 = alvos(:,1:J);
    [lP cP]=size(P);   % Tamanho da matriz de vetores de treinamento
    
    % Vetores para teste e saidas desejadas correspondentes
    Q = Dn(:,J+1:end); T2 = alvos(:,J+1:end);
    [lQ cQ]=size(Q);   % Tamanho da matriz de vetores de teste
   
  
    %Class 1
    w1 = trainmyperceptron(P,T1(1,:));

    %Class 2
    w2 = trainmyperceptron(P,T1(2,:));

    %Class 3
    w3 = trainmyperceptron(P,T1(3,:));

    %Class 4
    w4 = trainmyperceptron(P,T1(4,:));

    %Class 5
    w5 = trainmyperceptron(P,T1(5,:));

    %Class 6
    w6 = trainmyperceptron(P,T1(6,:));
    
    OUT = [];
    OUT_w1 = [];
    for i=1:cQ,
        [y net] = Myperceptron(w1,Q(:,i));
        OUT_w1 = [OUT_w1 net];
    end
    OUT = [OUT;OUT_w1];

    OUT_w2 = [];
    for i=1:cQ,
        [y net] = Myperceptron(w2,Q(:,i));
        OUT_w2 = [OUT_w2 net];
    end
    OUT = [OUT;OUT_w2];
    
    OUT_w3 = [];
    for i=1:cQ,
        [y net] = Myperceptron(w3,Q(:,i));
        OUT_w3 = [OUT_w3 net];
    end
    OUT = [OUT;OUT_w3];
    
    OUT_w4 = [];
    for i=1:cQ,
        [y net] = Myperceptron(w4,Q(:,i));
        OUT_w4 = [OUT_w4 net];
    end
    OUT = [OUT;OUT_w4];
    
    OUT_w5 = [];
    for i=1:cQ,
        [y net] = Myperceptron(w5,Q(:,i));
        OUT_w5 = [OUT_w5 net];
    end
    OUT = [OUT;OUT_w5];
    
    OUT_w6 = [];
    for i=1:cQ,
        [y net] = Myperceptron(w6,Q(:,i));
        OUT_w6 = [OUT_w6 net];
    end
    OUT = [OUT;OUT_w6];
    
    count_OK=0;  % Contador de acertos
    for t=1:cQ,
        c = [0;0;0;0;0;0];
        [T2max iT2max]=max(T2(:,t));  % Indice da saida desejada de maior valor
        [OUT2_max iOUT2_max]=min(OUT(:,t)); % Indice do neuronio cuja saida eh a maior
        if iT2max==iOUT2_max,   % Conta acerto se os dois indices coincidem
            count_OK=count_OK+1;
        end
        c(iOUT2_max)=1;
       
        T2_out = [T2_out c];
    end
    
    T2_in = [T2_in T2];
    % Plota curva de aprendizagem
    % Se quiser visualizar a curva de aprendizagem para uma rodada
    % basta fazer Nr=1 e descomentar a linha de codigo abaixo.
    %figure; plot(EQM);  
    
    % Taxa de acerto global
    Tx_OK(r)=100*(count_OK/cQ);
    
    %PEGA O OUT E VE qual o maior da coluna e faz ele 1 e os outros 0, depois compara com toda a matriz e ve % de acerto 
    
    %Tx_OK(r) = 100*(sum(result1)+sum(result2)+sum(result3)+sum(result4)+sum(result5)+sum(result6))/(cQ*6);
end

mediaDasClasses=mean(Tx_OK_c)
figure;
plot(Tx_OK);
xlabel('Rodada');
ylabel('Taxa de acerto');
saveas(gcf, 'TaxaDeAcerto.jpg');
% Estatisticas Descritivas
Media=mean(Tx_OK)
Mediana=median(Tx_OK)
[Maxima Imax]=max(Tx_OK)
[Minima Imin]=min(Tx_OK)
DevPadrao=std(Tx_OK)

save('t2_in.mat','T2_in');
save('t2_out.mat','T2_out');
