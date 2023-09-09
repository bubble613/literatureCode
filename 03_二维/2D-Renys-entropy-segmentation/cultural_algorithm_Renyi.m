function [x, fval, xdata, ydata] = cultural_algorithm_Renyi( nub,E)
%% Parameters
% population size
popSize = 60;
n = nub*3;;
lb = [0.*ones(1,n)];
ub=[255.*ones(1,n)];
% constants
accept = 0.35;   % acceptance ratio (40 %)
alpha = 0.3;

% maximum iteration to solution
maxIterations = 1000;

%% Initialize
% randomly genarate initial population
population = repmat(ub-lb,popSize,1).*rand(popSize,n) + repmat(lb,popSize,1);

% belief space
situationalCost = Inf;
normativeMin = inf .* ones(1,n);
normativeMax = -inf .* ones(1,n);
normativeL = inf .* ones(1,n);
normativeU = inf .* ones(1,n);

% data for graph
xdata = zeros(1,maxIterations);
ydata = zeros(1,maxIterations);

%% Iterate
iter = 1;
repeat = 0;

while iter <= maxIterations && repeat <= 50
    
    % evaluate population
    cost = zeros(popSize,1);
    for i = 1:popSize
        cost(i) = fitnessfuncsc208(population(i,:),E);
    end
    
    % sort population with their cost
    [cost, idx] = sort(cost);
    population = population(idx,:);
    
    % select sub-population to update belief space
    nSelect = round(accept * popSize);
    subPopulation = population(1:nSelect,:);
    subCost = cost(1:nSelect,:);
    
    % update belief space
    update = 1;
    for i = 1:nSelect
        
        % update situational knowledge
        if subCost(i) < situationalCost
            situationalCost = subCost(i);
            situationalPopulation = subPopulation(i,:);
            update = 0;
            repeat = 0;
        end
        
        % update normative knowledge
        for j = 1:n
            if subPopulation(i,j) < normativeMin(j) || subCost(i) < normativeL(j)
                normativeMin(j) = subPopulation(i,j);
                normativeL(j) = subCost(i);
            end
            if subPopulation(i,j) > normativeMax(j) || subCost(i) < normativeU(j)
                normativeMax(j) = subPopulation(i,j);
                normativeU(j) = subCost(i);
            end
        end
        normativeSize = normativeMax - normativeMin;
    end
    repeat = repeat + update;
    % print
    if ~rem(iter,10)
        fprintf('.');
    end
    
    % update graph data
    xdata(iter) = iter;
    ydata(iter) = situationalCost;
    
    % update iteration count
    iter = iter + 1;
    
    % update population using normative and situational knowledge
    for i = 1:popSize
        for j = 1:n
            sigma = alpha * normativeSize(j);
            dx = sigma * randn;
            if population(i,j) < situationalPopulation(j)
                dx = abs(dx);
            elseif population(i,j) > situationalPopulation(j)
                dx = -1 * abs(dx);
            end
            population(i,j) = population(i,j) + dx;
            
            % boundary check
            if population(i,j) < lb(j)
                population(i,j) = lb(j);
            elseif population(i,j) > ub(j)
                population(i,j) = ub(j);
            end
            
        end
    end
end
%% optput
x = situationalPopulation;
fval = situationalCost(1);

% graph
figure();
plot(xdata(1:iter-1),ydata(1:iter-1),'r','linewidth',2);
xlim([1, iter-1]);
grid on
xlabel('Iteration Number');
ylabel('Cultural Best');
title('Cultural Algorithm');

%% eof