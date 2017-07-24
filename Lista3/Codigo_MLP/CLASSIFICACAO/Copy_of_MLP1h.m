% Implementacao da rede MLP canonica (backpropagation com gradiente descendente)
% Usando as funcoes built-in (internas) do matlab
%
% Exemplo para disciplina de ICA
% Autor: Guilherme de A. Barreto
% Date: 06/07/2016

%
% X = Vetor de entrada
% d = saida desejada (escalar)
% W = Matriz de pesos Entrada -> Camada Oculta
% M = Matriz de Pesos Camada Oculta -> Camada saida
% eta = taxa de aprendizagem
% alfa = fator de momento

clear; clc; close all

% Carrega DADOS
%=================
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

% Define tamanho dos conjuntos de treinamento/teste (hold out)
ptrn=0.8;    % Porcentagem usada para treino
ptst=1-ptrn; % Porcentagem usada para teste


% DEFINE ARQUITETURA DA REDE
%===========================
Ne = 200; % No. de epocas de treinamento
Nr = 100;   % No. de rodadas de treinamento/teste
Nh = 0;   % No. de neuronios na camada oculta
No = 6;   % No. de neuronios na camada de saida

eta=0.1;   % Passo de aprendizagem
mom=0.0;  % Fator de momento

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
    total_classes=[sum(T2(1,:)),sum(T2(2,:)),sum(T2(3,:)),sum(T2(4,:)),sum(T2(5,:)),sum(T2(6,:))];
  
    % Inicia matrizes de pesos
    WW=0.01*rand(Nh,lP+1);   % Pesos entrada -> camada oculta
    WW_old=WW;              % Necessario para termo de momento
    
    MM=0.01*rand(No,Nh+1);   % Pesos camada oculta -> camada de saida
    MM_old = MM;            % Necessario para termo de momento
    
    %%% ETAPA DE TREINAMENTO
    for t=1:Ne,
        
        Epoca=t;
        
        I=randperm(cP); P=P(:,I); T1=T1(:,I);   % Embaralha vetores de treinamento e saidas desejadas
        
        EQ=0;
        for tt=1:cP,   % Inicia LOOP de epocas de treinamento
            % CAMADA OCULTA
            X=[-1; P(:,tt)];      % Constroi vetor de entrada com adicao da entrada x0=-1
            Ui = WW * X;          % Ativacao (net) dos neuronios da camada oculta
            Yi = 1./(1+exp(-Ui)); % Saida entre [0,1] (funcao logistica)
            
            % CAMADA DE SAIDA
            Y=[-1; Yi];           % Constroi vetor de entrada DESTA CAMADA com adicao da entrada y0=-1
            Uk = MM * Y;          % Ativacao (net) dos neuronios da camada de saida
            Ok = 1./(1+exp(-Uk)); % Saida entre [0,1] (funcao logistica)
            
            % CALCULO DO ERRO
            Ek = T1(:,tt) - Ok;           % erro entre a saida desejada e a saida da rede
            EQ = EQ + 0.5*sum(Ek.^2);     % soma do erro quadratico de todos os neuronios p/ VETOR DE ENTRADA
            
            
            %%% CALCULO DOS GRADIENTES LOCAIS
            Dk = Ok.*(1 - Ok) + 0.05;  % derivada da sigmoide logistica (camada de saida)
            DDk = Ek.*Dk;       % gradiente local (camada de saida)
            
            Di = Yi.*(1 - Yi) + 0.05; % derivada da sigmoide logistica (camada oculta)
            DDi = Di.*(MM(:,2:end)'*DDk);    % gradiente local (camada oculta)
            
            % AJUSTE DOS PESOS - CAMADA DE SAIDA
            MM_aux=MM;
            MM = MM + eta*DDk*Y' + mom*(MM - MM_old);
            MM_old=MM_aux;
            
            % AJUSTE DOS PESOS - CAMADA OCULTA
            WW_aux=WW;
            WW = WW + eta*DDi*X' + mom*(WW - WW_old);
            WW_old=WW_aux;
        end   % Fim de uma epoca
        
        % MEDIA DO ERRO QUADRATICO P/ EPOCA
        EQM(t)=EQ/cP;
    end   % Fim do loop de treinamento
    
    OUT1=[];
    for tt=1:cP,   % Inicia LOOP de epocas de treinamento
            % CAMADA OCULTA
            X=[-1; P(:,tt)];      % Constroi vetor de entrada com adicao da entrada x0=-1
            Ui = WW * X;          % Ativacao (net) dos neuronios da camada oculta
            Yi = 1./(1+exp(-Ui)); % Saida entre [0,1] (funcao logistica)
            
            
            % CAMADA DE SAIDA
            Y=[-1; Yi];           % Constroi vetor de entrada DESTA CAMADA com adicao da entrada y0=-1
            Uk = MM * Y;          % Ativacao (net) dos neuronios da camada de saida
            Ok = 1./(1+exp(-Uk)); % Saida entre [0,1] (funcao logistica)
            OUT1=[OUT1 Ok];
            
    end
    
    %% ETAPA DE GENERALIZACAO  %%%
    EQ2=0;
    OUT2=[];
    HID2=[];
    for tt=1:cQ,
        % CAMADA OCULTA
        X=[-1; Q(:,tt)];      % Constroi vetor de entrada com adicao da entrada x0=-1
        Ui = WW * X;          % Ativacao (net) dos neuronios da camada oculta
        Yi = 1./(1+exp(-Ui)); % Saida entre [0,1] (funcao logistica)
        HID2=[HID2 Yi];
        
        % CAMADA DE SAIDA
        Y=[-1; Yi];           % Constroi vetor de entrada DESTA CAMADA com adicao da entrada y0=-1
        Uk = MM * Y;          % Ativacao (net) dos neuronios da camada de saida
        Ok = 1./(1+exp(-Uk)); % Saida entre [0,1] (funcao logistica)
        OUT2=[OUT2 Ok];       % Armazena saida da rede
        
        % Gradiente local da camada de saida
        Ek = T2(:,tt) - Ok;   % erro entre a saida desejada e a saida da rede
        Dk = Ok.*(1 - Ok);    % derivada da sigmoide logistica
        DDk = Ek.*Dk;         % gradiente local igual ao erro x derivada da funcao de ativacao
        
        % ERRO QUADRATICO GLOBAL (todos os neuronios) POR VETOR DE ENTRADA
        EQ2 = EQ2 + 0.5*sum(Ek.^2);
        
        % Gradiente local da camada oculta
        Di = Yi.*(1 - Yi); % derivada da sigmoide logistica
        DDi = Di.*(MM(:,2:end)'*DDk);
    end
    
    % MEDIA DO ERRO QUADRATICO COM REDE TREINADA (USANDO DADOS DE TREINAMENTO)
    EQM2=EQ2/cQ;
    
    % CALCULA TAXA DE ACERTO
    count_OK=0;  % Contador de acertos
    count_OK_c=[0,0,0,0,0,0]; % Contador de acertos por classe
    for t=1:cQ,
        c = [0;0;0;0;0;0];
        [T2max iT2max]=max(T2(:,t));  % Indice da saida desejada de maior valor
        [OUT2_max iOUT2_max]=max(OUT2(:,t)); % Indice do neuronio cuja saida eh a maior
        if iT2max==iOUT2_max,   % Conta acerto se os dois indices coincidem
            count_OK=count_OK+1;
            count_OK_c(iT2max)=count_OK_c(iT2max)+1;
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
    Tx_OK_c=[Tx_OK_c;[100*(count_OK_c(1)/total_classes(1)),100*(count_OK_c(2)/total_classes(2)),100*(count_OK_c(3)/total_classes(3)),100*(count_OK_c(4)/total_classes(4)),100*(count_OK_c(5)/total_classes(5)),100*(count_OK_c(6)/total_classes(6))]];
    
        
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

%[C,order] = confusionmat(T2,OUT2)