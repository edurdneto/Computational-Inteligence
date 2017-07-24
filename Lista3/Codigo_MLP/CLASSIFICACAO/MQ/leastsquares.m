clear; clc; close all

% Carrega DADOS
%=================
load derm_input.txt;
load derm_target.txt;

dados=derm_input';  % Vetores (padroes) de entrada
alvos=derm_target'; % Saidas desejadas correspondentes
 
clear derm_input;  % Libera espaco em memoria
clear derm_target;

% Embaralha vetores de entrada e saidas desejadas
[LinD ColD]=size(dados);

T2_out = [];
T2_in =[];

% Normaliza componetes para media zero e variancia unitaria
for i=1:LinD,
	mi=mean(dados(i,:));  % Media das linhas
    di=std(dados(i,:));   % desvio-padrao das linhas 
	dados(i,:)= (dados(i,:) - mi)./di;
end 
Dn=dados;

% Define tamanho dos conjuntos de treinamento/teste (hold out)
ptrn=0.8;    % Porcentagem usada para treino

for i=1:100,

  I=randperm(LinD); Dn=Dn(I,:); alvos=alvos(I,:);   % Embaralha pares entrada/saida 
      
  % Vetores para treinamento e saidas desejadas correspondentes
  J=floor(ptrn*LinD);
  P = Dn(1:J,:); T1 = alvos(1:J,:);
  [lP cP]=size(P);   % Tamanho da matriz de vetores de treinamento

  % Vetores para teste e saidas desejadas correspondentes
  Q = Dn(J+1:end,:); T2 = alvos(J+1:end,:);
  [lQ cQ]=size(Q);   % Tamanho da matriz de vetores de teste

  % Solve least squares problem
  lam = 0.01;
  w = T1'*P*inv(P'*P+lam*eye(size(P'*P)));
  %w = ols(P,T1);
  y = Q*w';

  count_OK=0;
  for j=1:lQ,
    c = [0;0;0;0;0;0];
    [pred iPred] = max(y(j,:));
    [real iReal] = max(T2(j,:));
    if iPred == iReal,
      count_OK=count_OK+1;
    end
    c(iPred)=1;
       
    T2_out = [T2_out c];
  end

 taxa_acerto(i)=100*(count_OK/lQ);
 T2_in = [T2_in T2'];
end

figure;
plot(taxa_acerto);
xlabel('Rodada');
ylabel('Taxa de acerto');
saveas(gcf, 'TaxaDeAcerto.jpg');
Media=mean(taxa_acerto)
Mediana=median(taxa_acerto)
[Maxima iMax]=max(taxa_acerto)
[Minima iMin]=min(taxa_acerto)
DevPadrao=std(taxa_acerto)

save -mat7-binary t2_in.mat  T2_in
save -mat7-binary t2_out.mat T2_out