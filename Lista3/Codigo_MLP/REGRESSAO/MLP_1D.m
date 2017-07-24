% Implementacao da rede MLP canonica (backpropagation com gradiente descendente e termo de momento)
%
% Autor: Guilherme de A. Barreto
% Date: 06/07/2006
% 
% Objetivo verificar a ocorrencia de overfitting

% X = Vetor de entrada
% d = saida desejada (escalar)
% W = Matriz de pesos Entrada -> Camada Oculta
% M = Matriz de Pesos Camada Oculta -> Camada saida
% eta = taxa de aprendizagem
% alfa = fator de momento

clear; clc;

% Carrega DADOS
%=================
load function1d.dat;   % Dados sem ruido
load noisy1d.dat;      % Dados com ruido

[LinD ColD]=size(X);

% DEFINE ARQUITETURA DA REDE
%===========================
Ne =100; % No. de epocas de treinamento
Nr = 1;   % No. de rodadas de treinamento/teste
Nh = 10;   % No. de neuronios na camada oculta
No = 1;   % No. de neuronios na camada de saida

eta=0.01;   % Passo de aprendizagem
mom=0;  % Fator de momento

% Inicia matrizes de pesos
WW=1.0*rand(Nh,2);   % Pesos entrada -> camada oculta
WW_old=WW;              % Necessario para termo de momento

MM=1.0*rand(No,Nh+1);   % Pesos camada oculta -> camada de saida
MM_old = MM;            % Necessario para termo de momento

%%% ETAPA DE TREINAMENTO
for t=1:Ne,
    
    %Epoca=t;

    % Embaralha vetores de entrada e saidas desejadas
    I=randperm(LinD); 
    X=X(I,:);
    
    EQ=0;
    for tt=1:LinD,   % Inicia LOOP de epocas de treinamento
        % CAMADA OCULTA
        x =[+1; X(tt,1)];      % Constroi vetor de entrada com adicao da entrada x0=-1
        Ui = WW * x;          % Ativacao (net) dos neuronios da camada oculta
        Yi = 1./(1+exp(-Ui)); % Saida entre [0,1] (funcao logistica)

        % CAMADA DE SAIDA 
        Y=[+1; Yi];           % Constroi vetor de entrada DESTA CAMADA com adicao da entrada y0=-1
        Uk = MM * Y;          % Ativacao (net) dos neuronios da camada de saida
        Ok = 1./(1+exp(-Uk)); % Saida entre [0,1] (funcao logistica)
	
        % CALCULO DO ERRO 
        Ek = X(tt,2) - Ok;           % erro entre a saida desejada e a saida da rede

        EQ = EQ + 0.5*sum(Ek.^2);     % soma do erro quadratico de todos os neuronios p/ VETOR DE ENTRADA

        %%% CALCULO DOS GRADIENTES LOCAIS
        Dk = Ok.*(1 - Ok);  % derivada da sigmoide logistica (camada de saida)
        DDk = Ek.*Dk;       % gradiente local (camada de saida)

        Di = Yi.*(1 - Yi); % derivada da sigmoide logistica (camada oculta)
        DDi = Di.*(MM(:,2:end)'*DDk);    % gradiente local (camada oculta)

        % AJUSTE DOS PESOS - CAMADA DE SAIDA
        MM_aux=MM;
        MM = MM + eta*DDk*Y' + mom*(MM - MM_old);
        MM_old=MM_aux;

        % AJUSTE DOS PESOS - CAMADA OCULTA
        WW_aux=WW;
        WW = WW + eta*DDi*x' + mom*(WW - WW_old);
        WW_old=WW_aux;
    end   % Fim de uma epoca
    
    % MEDIA DO ERRO QUADRATICO P/ EPOCA
    EQM(t)=EQ/LinD;
end   % Fim do loop de treinamento


% VERIFICACAO DE REDUNDANCIA COM A REDE JAH TREINADA
% USA DADOS DE TREINAMENTO, MAS NAO ALTERA OS PESOS
EQ1=0;
HID1=[];
OUT1=[];
for tt=1:LinD,
    % CAMADA OCULTA
        x=[+1; X(tt,1)];       % Constroi vetor de entrada com adicao da entrada x0=-1
        Ui = WW * x;           % Ativacao (net) dos neuronios da camada oculta
        Yi = 1./(1+exp(-Ui));  % Saida entre [0,1] (funcao logistica)
        HID1=[HID1 Yi];        % Armazena saida dos neuronios ocultos

        % CAMADA DE SAIDA 
        Y=[+1; Yi];            % Constroi vetor de entrada DESTA CAMADA com adicao da entrada y0=-1
        Uk = MM * Y;           % Ativacao (net) dos neuronios da camada de saida
        Ok = 1./(1+exp(-Uk));  % Saida entre [0,1] (funcao logistica)

        OUT1=[OUT1 Ok];        % Armazena saida dos neuronios de saida

        Ek = X(tt,2) - Ok;           % erro entre a saida desejada e a saida da rede
        EQ1 = EQ1 + 0.5*sum(Ek.^2);     % soma do erro quadratico de todos os neuronios p/ VETOR DE ENTRADA
end

% MEDIA DO ERRO QUADRATICO COM REDE TREINADA (USANDO DADOS DE TREINAMENTO)
EQM1=EQ1/LinD;

Ch=cov(HID1');  % Matriz de covariancia das saidas dos neuronios da camada OCULTA
Av=eig(Ch);     % Autovalores da matriz Ch
Rc=1/cond(Ch)    % Razao entre menor e maior autovalor da matriz Ch

%I=1; Plam=100*(sum(Av(end-I:end))/sum(Av));


%% ETAPA DE GENERALIZACAO  %%%
Z=0:0.001:1;
OUT2=[];
for tt=1:length(Z),
    % CAMADA OCULTA
    x=[+1; Z(tt)];      % Constroi vetor de entrada com adicao da entrada x0=-1
    Ui = WW * x;          % Ativacao (net) dos neuronios da camada oculta
    Yi = 1./(1+exp(-Ui)); % Saida entre [0,1] (funcao logistica)

    % CAMADA DE SAIDA 
    Y=[+1; Yi];           % Constroi vetor de entrada DESTA CAMADA com adicao da entrada y0=-1
    Uk = MM * Y;          % Ativacao (net) dos neuronios da camada de saida
    Ok = 1./(1+exp(-Uk)); % Saida entre [0,1] (funcao logistica)

    OUT2=[OUT2 Ok];       % Armazena saida da rede 
end

R=[Z' OUT2'];   % Resultado da interpolacao feita pela rede MLP

% Graficos
figure(1); 
%plot(F(:,1),F(:,2),'k:',X(:,1),X(:,2),'ro')
plot(F(:,1),F(:,2),'k:',X(:,1),X(:,2),'ro',R(:,1),R(:,2),'b-');