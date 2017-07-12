clear;
clc;

topology = 0; % global - 0, local - 1
neighborLength = 2;
numVariables = 2;                    %Rosenbrock
minValues = -5.12*ones(1,numVariables); %Rosenbrock
maxValues = 5.12*ones(1,numVariables);  %Rosenbrock
% numVariables = 1;                     %Ackley
% minValues = -5*ones(1,numVariables); %Ackley
% maxValues = 5*ones(1,numVariables);  %Ackley

% Par�metros

% N�mero de part�culas
numParticles = 100;
% N�mero de ciclos (itera��es)
numCycles = 100;
% Limite de velocidade (vMin = -limVelocity, vMax = limVelocity)
limVelocity = 0.2*(maxValues - minValues);
% Par�metro de in�rcia inicial
wInit = 0.9;
% Par�metro de in�rcia final
wFinal = 0.4;
% Par�metros de altera��o de velocidade
k1 = 2.05;
k2 = 2.05;
kp = k1 + k2;
kx = 2/(abs(2 - kp - sqrt(kp^2 - 4*kp)));

% Matriz posi��o de part�culas
particles = zeros(numParticles, numVariables);
% Matriz de aptid�es das part�culas
values = zeros(1,numParticles);
% Matriz de velocidades
velocity = zeros(numParticles, numVariables);

% Vetor de melhores aptid�es de cada part�cula
bestValues = inf*ones(1,numParticles);
% Vetor de melhores posi��es de cada part�cula
bestPositions = zeros(numParticles,numVariables);

% Melhor aptid�o global
bestGlobalValue = inf;
% Melhor posi��o global
bestGlobalPosition = zeros(1,numVariables);

if(topology == 1)
    % Melhor aptid�o da vizinhan�a
    bestLocalValue = inf*ones(1,numParticles);
    % Melhor posi��o da vizinhan�a
    bestLocalPositions = zeros(numParticles, numVariables);
end

% Inicializa as part�culas
for i=1:numParticles
    particles(i,:) = minValues + (maxValues - minValues).*rand(1,numVariables);
end

% Ciclos de execu��o do algoritmo
w = wInit;
histBest = zeros(1,numCycles);
tic;
for i=1:numCycles
    
    % Verifica a aptid�o de cada part�cula
    values = evaluateSolutions(particles);
    
    % Verifica se a solu��o encontrada � melhor que a anterior para cada part�cula
    for j=1:numParticles
        if(values(j) < bestValues(j))
            bestValues(j) = values(j);
            bestPositions(j,:) = particles(j,:);
        end
    end
    
    % Verifica se uma melhor solu��o global foi encontrada
    [minValue minValueIndex] = min(values);
    if(minValue < bestGlobalValue)
        bestGlobalValue = minValue;
        bestGlobalPosition = particles(minValueIndex,:);
    end
    
    if(topology == 1)
        % Verifica se uma melhor solu��o da vizinhan�a foi encontrada
        for j=1:numParticles
            
            neighborIndex = zeros(1,neighborLength+1);
            for p=1:neighborLength+1
                aux = j - neighborLength/2 + p - 1;
                if(aux <= 0)
                    aux = numParticles + aux;
                end
                if(aux > numParticles)
                    aux = aux - numParticles;
                end
                neighborIndex(p) = aux;
            end
            
            particlesNeighbor = bestPositions(neighborIndex,:);
            valuesNeighbor = bestValues(neighborIndex);
            
            for p=1:neighborLength+1
                if(valuesNeighbor(p) < bestLocalValue(j))
                    bestLocalValue(j) = valuesNeighbor(p);
                    bestLocalPositions(j,:) = particlesNeighbor(p,:);
                end
            end
        end
    end
    
    %if((mod(i,10) == 0 || i == 1) && numVariables == 1)
    %    figure; hold;
    %    x = minValues:0.01:maxValues;
    %    a=20; b=0.2; c=2*pi;
    %    plot(x, -a*exp(-b*sqrt(x.^2)) -exp(cos(c*x)) + a + exp(1));
    %    plot(particles, values, 'b*', 'MarkerSize' , 10);
    %    plot(bestGlobalPosition, bestGlobalValue, 'r*', 'MarkerSize' , 10);
    %    hold;
    %    pause(1);
    %end
    %if((mod(i,10) == 0 || i == 1) && numVariables == 2)
    %    figure; hold;
    %    axis([minValues(1) maxValues(1) minValues(2) maxValues(2)]);
    %    plot(particles(:,1), particles(:,2), 'b*', 'MarkerSize' , 10);
    %    plot(bestGlobalPosition(1), bestGlobalPosition(2), 'r*', 'MarkerSize' , 10);
    %    hold;
    %    pause(1);
    %end
    
    % Atualiza a velocidade das part�culas
    for j=1:numParticles
        if(topology == 0)
            velocity(j,:) = w*velocity(j,:) + k1*rand()*(bestPositions(j,:) - particles(j,:)) + k2*rand()*(bestGlobalPosition - particles(j,:));
            %velocity(j,:) = kx*(velocity(j,:) + k1*rand()*(bestPositions(j,:) - particles(j,:)) + k2*rand()*(bestGlobalPosition - particles(j,:)));
        else
            velocity(j,:) = w*velocity(j,:) + k1*rand()*(bestPositions(j,:) - particles(j,:)) + k2*rand()*(bestLocalPositions(j,:) - particles(j,:));
            %velocity(j,:) = kx*(velocity(j,:) + k1*rand()*(bestPositions(j,:) - particles(j,:)) + k2*rand()*(bestLocalPositions(j,:) - particles(j,:)));
        end
        for k=1:numVariables
            if(velocity(j,k) > limVelocity(k))
                velocity(j,k) = limVelocity(k);
            end
            if(velocity(j,k) < -limVelocity(k))
                velocity(j,k) = -limVelocity(k);
            end
        end
    end
    
    % Atualiza a posi��o das part�culas
    particles = particles + velocity;
    
    % Atualiza o par�metro de in�rcia
    w = wFinal + (wInit - wFinal)*(numCycles - i)/(numCycles - 1);
    
    histBest(i) = bestGlobalValue;
end
timeElapsed = toc

display('Melhor solu��o obtida:');
display(bestGlobalPosition);
display('Melhor fun��o objetivo encontrada:');
display(bestGlobalValue);

figure;
plot(histBest(1:i));
xlabel('Ciclos');
ylabel('Fun��o objetivo');
saveas(gcf, 'HistoryPso.jpg');
