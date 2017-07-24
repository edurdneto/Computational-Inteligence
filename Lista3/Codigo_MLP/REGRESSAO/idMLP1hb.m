% Implementacao da rede MLP canonica (backpropagation com gradiente descendente)
% Usando as funcoes built-in (internas) do matlab
%
% Objetivo: demonstrar a problematica do OVERFITTING a dados ruidosos
%
% Nota: o mapeamento a ser aprendido eh estatico e unidimensional, logo
%       a rede neural terá uma entrada e uma saida apenas. O unico parametro
%       variavel eh o numero de neuronios ocultos.
%
% Exemplo para disciplina de ICA
% Autor: Guilherme de A. Barreto
% Date: 13/09/2010
%
%
% X = Vetor de entrada
% d = saida desejada (escalar)
% W = Matriz de pesos Entrada -> Camada Oculta
% M = Matriz de Pesos Camada Oculta -> Camada saida
% eta = taxa de aprendizagem
% alfa = fator de momento

clear; clc; close all;

% Carrega DADOS
%=================
%load aerogerador.dat;
load noisy1d.dat; 
aerogerador=noisy1d;

x=aerogerador(:,1); % entrada
d=aerogerador(:,2); % saida desejada

%%% Normalizacao dos dados de entrada e saida
%x=(x - min(x))/(max(x)-min(x));  % normaliza entradas entre 0 e 1
%d=(d - min(d))/(max(d)-min(d));  % normaliza saidas entre 0 e 1

%x=2*x-1;  % Normaliza entradas entre -1 e +1
%d=2*d-1;  % Normaliza saidas entre -1 e +1

%x=(x-mean(x))/std(x); d=(d-mean(d))/std(d);   % Normalizacao Z-score

[LinD ColD]=size(aerogerador);

% DEFINE ARQUITETURA DA REDE
%===========================
Ne = 100; % No. de epocas de treinamento
Ni = 1;   % No. de unidades de entrada
Nh = 1000;   % No. de neuronios na camada oculta
No = 1;   % No. de neuronios na camada de saida

eta=0.01;   % Passo de aprendizagem

% Inicia matrizes de pesos
WW=rand(Nh,Ni+1);   % Pesos entrada -> camada oculta
WW=2*WW-1;

MM=rand(No,Nh+1);   % Pesos camada oculta -> camada de saida
MM=2*MM-1;

%%% ETAPA DE TREINAMENTO
for t=1:Ne,
    
    Epoca=t,

    % Embaralha vetores de treinamento e saidas desejadas
    I=randperm(LinD); 
    x=x(I); d=d(I);   
    
    EQ=0;
    for tt=1:LinD,   % Inicia LOOP de epocas de treinamento
        % CAMADA OCULTA
        X=[-1; x(tt)];        % Constroi vetor de entrada com adicao da entrada x0=-1
        Ui = WW * X;          % Ativacao (net) dos neuronios da camada oculta
        Yi = 1./(1+exp(-Ui)); % Saida entre [0,1] (funcao logistica)
        Yi=2*Yi-1;            % Saida entre [-1,1] (funcao tanh)
        
        % CAMADA DE SAIDA 
        Y=[-1; Yi];           % Constroi vetor de entrada DESTA CAMADA com adicao da entrada y0=-1
        Uk = MM * Y;          % Ativacao (net) dos neuronios da camada de saida
	    Ok = Uk;	      % Saida linear = funcao identidade
        %Ok = 1/(1+exp(-Uk)); % Saida entre [0,1] (funcao logistica)
        %Ok = 2*Ok -1;       % Saida entre [-1,1] (funcao tanh)
        
        % CALCULO DO ERRO 
        Ek = d(tt) - Ok;           % erro entre a saida desejada e a saida da rede
        EQ = EQ + 0.5*sum(Ek.^2);     % soma do erro quadratico de todos os neuronios p/ VETOR DE ENTRADA

        
        %%% CALCULO DOS GRADIENTES LOCAIS
        Dk=1;		        % derivada da funcao identidade (camada de saida)
        %Dk = Ok*(1 - Ok);  % derivada da sigmoide logistica (camada de saida)
        %Dk = 1 - Ok.^2;     % derivada da tangente hiperbolica (camada de saida)
        
        DDk = Ek*Dk;        % gradientes locais (camada de saida)
        
        %Di = Yi.*(1 - Yi); % derivada da sigmoide logistica (camada oculta)
        Di=1-Yi.^2; % derivada da tangente hiperbolica (camada oculta)
        
        DDi = Di.*(MM(:,2:end)'*DDk);    % gradientes locais (camada oculta)

        % AJUSTE DOS PESOS - CAMADA DE SAIDA
        MM = MM + eta*DDk*Y';
        
        % AJUSTE DOS PESOS - CAMADA OCULTA
        WW = WW + eta*DDi*X';

    end   % Fim de uma epoca de treinamento
    
    EQM(t)=EQ/LinD; % MEDIA DO ERRO QUADRATICO P/ EPOCA

end   % Fim do loop de treinamento



%% ETAPA DE GENERALIZACAO  %%%
xn=sort(x,'ascend');
LinD=length(xn);
EQ=0;
for tt=1:LinD,   % Inicia LOOP de epocas de treinamento
        % CAMADA OCULTA
        X=[-1; xn(tt)];       % Constroi vetor de entrada com adicao da entrada x0=-1
        Ui = WW * X;          % Ativacao (net) dos neuronios da camada oculta
        Yi = 1./(1+exp(-Ui)); % Saida entre [0,1] (funcao logistica)
        Yi=2*Yi-1;              % Saida entre [-1,1] (funcao tanh)
        
        % CAMADA DE SAIDA 
        Y=[-1; Yi];              % Constroi vetor de entrada DESTA CAMADA com adicao da entrada y0=-1
        Uk = MM * Y;             % Ativacao (net) dos neuronios da camada de saida
	    Ok(tt) = Uk;	         % Saida linear = funcao identidade
        %Ok(tt) = 1/(1+exp(-Uk)); % Saida entre [0,1] (funcao logistica)
        %Ok(tt) = 2*Ok(tt)-1;     % Saida entre [-1,1] (funcao tanh)
end

% Plota curva de aprendizagem
figure; plot(EQM);

% Plota dados reais versus dados preditos
figure; plot(x,d,'r*',xn,Ok,'b-');

