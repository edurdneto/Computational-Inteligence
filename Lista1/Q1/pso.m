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

% Parâmetros

% Número de partículas
numParticles = 100;
% Número de ciclos (iterações)
numCycles = 100;
% Limite de velocidade (vMin = -limVelocity, vMax = limVelocity)
limVelocity = 0.2*(maxValues - minValues);
% Parâmetro de inércia inicial
wInit = 0.9;
% Parâmetro de inércia final
wFinal = 0.4;
% Parâmetros de alteração de velocidade
k1 = 2.05;
k2 = 2.05;
kp = k1 + k2;
kx = 2/(abs(2 - kp - sqrt(kp^2 - 4*kp)));

% Matriz posição de partículas
particles = zeros(numParticles, numVariables);
% Matriz de aptidões das partículas
values = zeros(1,numParticles);
% Matriz de velocidades
velocity = zeros(numParticles, numVariables);

% Vetor de melhores aptidões de cada partícula
bestValues = inf*ones(1,numParticles);
% Vetor de melhores posições de cada partícula
bestPositions = zeros(numParticles,numVariables);

% Melhor aptidão global
bestGlobalValue = inf;
% Melhor posição global
bestGlobalPosition = zeros(1,numVariables);

if(topology == 1)
    % Melhor aptidão da vizinhança
    bestLocalValue = inf*ones(1,numParticles);
    % Melhor posição da vizinhança
    bestLocalPositions = zeros(numParticles, numVariables);
end

% Inicializa as partículas
for i=1:numParticles
    particles(i,:) = minValues + (maxValues - minValues).*rand(1,numVariables);
end

% Ciclos de execução do algoritmo
w = wInit;
histBest = zeros(1,numCycles);
tic;
for i=1:numCycles
    
    % Verifica a aptidão de cada partícula
    values = evaluateSolutions(particles);
    
    % Verifica se a solução encontrada é melhor que a anterior para cada partícula
    for j=1:numParticles
        if(values(j) < bestValues(j))
            bestValues(j) = values(j);
            bestPositions(j,:) = particles(j,:);
        end
    end
    
    % Verifica se uma melhor solução global foi encontrada
    [minValue minValueIndex] = min(values);
    if(minValue < bestGlobalValue)
        bestGlobalValue = minValue;
        bestGlobalPosition = particles(minValueIndex,:);
    end
    
    if(topology == 1)
        % Verifica se uma melhor solução da vizinhança foi encontrada
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
    
    % Atualiza a velocidade das partículas
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
    
    % Atualiza a posição das partículas
    particles = particles + velocity;
    
    % Atualiza o parâmetro de inércia
    w = wFinal + (wInit - wFinal)*(numCycles - i)/(numCycles - 1);
    
    histBest(i) = bestGlobalValue;
end
timeElapsed = toc

display('Melhor solução obtida:');
display(bestGlobalPosition);
display('Melhor função objetivo encontrada:');
display(bestGlobalValue);

figure;
plot(histBest(1:i));
xlabel('Ciclos');
ylabel('Função objetivo');
saveas(gcf, 'HistoryPso.jpg');
