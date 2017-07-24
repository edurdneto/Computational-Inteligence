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
    c1 = [];
    for i=1:cP,
        if(T1(1,i)==1)
            c1 = [c1 1];
        else
            c1 = [c1 0];
        end
    end

    w1 = trainmyperceptron(P,c1);

    %Class 2
    c2 = [];
    for i=1:cP,
        if(T1(2,i)==1)
            c2 = [c2 1];
        else
            c2 = [c2 0];
        end
    end

    w2 = trainmyperceptron(P,c2);

    %Class 3
    c3 = [];
    for i=1:cP,
        if(T1(3,i)==1)
            c3 = [c3 1];
        else
            c3 = [c3 0];
        end
    end

    w3 = trainmyperceptron(P,c3);

    %Class 4
    c4 = [];
    for i=1:cP,
        if(T1(4,i)==1)
            c4 = [c4 1];
        else
            c4 = [c4 0];
        end
    end

    w4 = trainmyperceptron(P,c4);

    %Class 5
    c5 = [];
    for i=1:cP,
        if(T1(5,i)==1)
            c5 = [c5 1];
        else
            c5 = [c5 0];
        end
    end

    w5 = trainmyperceptron(P,c5);

    %Class 6
    c6 = [];
    for i=1:cP,
        if(T1(6,i)==1)
            c6 = [c6 1];
        else
            c6 = [c6 0];
        end
    end

    w6 = trainmyperceptron(P,c6);
    
    OUT = [];
    OUT_w1 = [];
    for i=1:cQ,
        OUT_w1 = [OUT_w1 Myperceptron(w1,Q(:,i))];
    end
    OUT = [OUT;OUT_w1];
    result1 = OUT_w1 == T2(1,:);
    Tx_OK_1(r)=100*(sum(result1)/cQ);

    OUT_w2 = [];
    for i=1:cQ,
        OUT_w2 = [OUT_w2 Myperceptron(w2,Q(:,i))];
    end
    result2 = OUT_w2 == T2(2,:);
    Tx_OK_2(r)=100*(sum(result2)/cQ);
    
    OUT_w3 = [];
    for i=1:cQ,
        OUT_w3 = [OUT_w3 Myperceptron(w3,Q(:,i))];
    end
    result3 = OUT_w3 == T2(3,:);
    Tx_OK_3(r)=100*(sum(result3)/cQ);

    OUT_w4 = [];
    for i=1:cQ,
        OUT_w4 = [OUT_w4 Myperceptron(w4,Q(:,i))];
    end
    result4 = OUT_w4 == T2(4,:);
    Tx_OK_4(r)=100*(sum(result4)/cQ);
    
    OUT_w5 = [];
    for i=1:cQ,
        OUT_w5 = [OUT_w5 Myperceptron(w5,Q(:,i))];
    end
    result5 = OUT_w5 == T2(5,:);
    Tx_OK_5(r)=100*(sum(result5)/cQ);
    
    OUT_w6 = [];
    for i=1:cQ,
        OUT_w6 = [OUT_w6 Myperceptron(w6,Q(:,i))];
    end
    result6 = OUT_w6 == T2(6,:);
    Tx_OK_6(r)=100*(sum(result6)/cQ); 
    
    %PEGA O OUT E VE qual o maior da coluna e faz ele 1 e os outros 0, depois compara com toda a matriz e ve % de acerto 
    
    Tx_OK(r) = 100*(sum(result1)+sum(result2)+sum(result3)+sum(result4)+sum(result5)+sum(result6))/(cQ*6);
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