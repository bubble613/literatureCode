function [IDX, C, PROB, OUTPUT] = misodata(X, options)
% MISODATA is an unsupervised clustering algorithm to capture scenarios 
% from historical series.
%
% IDX = MISODATA(X) partitions the points in the N-by-D data
% matrix X into clusters. Where N is the number of data points and D the
% dimension of the historical series. MISODATA returns an N-by-1 vector IDX
% containing the cluster indices of each point.
%
% IDX = MISODATA(X, options) MISODATA captures the
% scenarios from historical series according to options. 
%
% options is a structure whose fields are:
%       'dMin' - the minimum allowed distance between the centroids.
%       	Default value: 0.04
%       'max_std' - the maximum allowed standard deviation of scenarios. 
%       	Default value: 0.55*options.dMin 
%       'pMin' - scenario's minimum allowed probability of occurence. 
%       	Default value: 1e-10
%       'SimName' - Name of the simulation.
%       	Default value: 'none'
%       'Niter' - Maximum number of iterations.
%       	Default value: 100
%       'ResultsPath' - Path for saving results.
%       	Default value: []
%       'PlotFlag' - Flag to plot two-dimensional graphs.
%       	Default value: false
%       'SaveFlag' - Flag to save results.
%       	Default value: false
%       'nCluMax' - maximum number of clusters.
%       	Default value: internally computed.
%       'nClu0' - initial number of clusters
%       	Default value: 1.
%       'UseDCF' - Use of the dimensional correction factor
%           Default value: true
%       'Display' - off, final or iter
%       	Default value: iter.
%
%    [IDX, C] = MISODATA(___) returns the K cluster centroid locations 
%    in the K-by-P matrix C. 
%
%    [IDX, C, PROB] = MISODATA(___) PROB returns the probability of 
%    occurrence of the scenario associated with each centroid.
%
%    [IDX, C, PROB, OUTPUT] = MISODATA(___) returns the OUTPUT structure
%    that describes the exit condition.
%        ITER is the number of iterations.
%        EXITFLAG conditions:
%            1  Iterative proccess converged;
%            0  Number of iterations reached.
%
% References:
% [1] de Paula, AN, de Oliveira, EJ, Honório, LM, de Oliveira, LW, Moraes, CA.
% m-ISODATA: Unsupervised clustering algorithm to capture representative
% scenarios in power systems. Int Trans Electr Energ Syst. 2021; 
% 31(9):e13005. https://doi.org/10.1002/2050-7038.13005
%
% [2] m-ISODATA in Code Ocean repository. https://doi.org/10.24433/CO.1264423.v1
%
%   See also KMEANS, CLUSTER.

tic  % Measuring elapsed time
%% Input args
if nargin == 1
    options = struct();
end
%% Reading the data
[Nobs, nser] = size(X);  % Number of data points and number of series
%
% Normalizing data
base_data_1 = min(X, [], 1);
base_data_2 = max(X, [], 1);
for iser = 1:nser
    X(:, iser) = (X(:, iser)-base_data_1(iser))/(base_data_2(iser)-base_data_1(iser));
end
%
% Calculating unique observations in the series
data_unique = unique(X,'rows');
[Nobs_unique, ~] = size(data_unique);  % Number of unique observations
%
%% Parameters treatment
% Use of dimensional correction factor
if ~any(strcmp(fieldnames(options), 'UseDCF'))
    % default value
    options.UseDCF = true;
end
%
% Mminimum allowed distance between the centroids
if ~any(strcmp(fieldnames(options), 'dMin'))
    % default value
    options.dMin = 0.04;
end
%
% Applying the Dimensional correction factor
if options.UseDCF
    options.dMin = options.dMin*sqrt(nser);
end
%
% Maximum allowed standard deviation of scenarios
if ~any(strcmp(fieldnames(options), 'max_std'))
    % default value
    options.max_std = options.dMin*0.55;
elseif options.UseDCF
    % Applying the Dimensional correction factor
    options.max_std = options.max_std*sqrt(nser);  % Dimensional correction factor
end
%
% Scenario's minimum allowed probability of occurence
if ~any(strcmp(fieldnames(options), 'pMin'))
    % default value
    options.pMin = 1e-10;
end
%
% Simulation name
if ~any(strcmp(fieldnames(options), 'SimName'))
    % default value
    options.SimName = 'none';
end
%
% Number of iterations
if ~any(strcmp(fieldnames(options), 'Niter'))
    % default value
    options.Niter = 100;
end
%
% Path for results
if ~any(strcmp(fieldnames(options), 'ResultsPath'))
    % default value
    options.ResultsPath = [];  % Current folder
end
%
% Flag to plot two-dimensional graphs
if ~any(strcmp(fieldnames(options), 'PlotFlag'))
    % default value
    options.PlotFlag = false;
end
%
% Flag to save scenarios data as a .csv file
if ~any(strcmp(fieldnames(options), 'SaveFlag'))
    % default value
    options.SaveFlag = false;
end
%
% Flag to display results
if ~any(strcmp(fieldnames(options), 'Display'))
    % default value
    options.Display = 'iter';
end
%
% Maximum number of clusters.
if ~any(strcmp(fieldnames(options), 'nCluMax'))
    % default value
    options.nCluMax = round(1/options.pMin);
    if options.nCluMax > Nobs_unique
        options.nCluMax = Nobs_unique;
    end
else
    if options.nCluMax > Nobs_unique
        options.nCluMax = Nobs_unique;
        disp(['nCluMax greater than number of unique observations and was seted to ' num2str(Nobs_uniqe) '!!!'])
    end
end
%
% Initial number of clusters.
if ~any(strcmp(fieldnames(options), 'nClu0'))
    % default value
    options.nClu0 = 1;
else
    if options.nClu0 > options.nCluMax
        options.nClu0 = options.nCluMax;
        disp(['nClu0 greater than maximum number of clusters and was seted to ' num2str(options.nCluMax) '!!!'])
    elseif options.nClu0 < 1
        options.nClu0 = 1;
        disp('nClu0 smaller than 1 and was seted to 1!!!')
    end
end
%
% OUTPUT structure
OUTPUT = struct();
OUTPUT.exitflag = 0;
OUTPUT.iter = 0;
%
%% m-ISODATA main program
%
% Minimum number of data per cluster
nmin = round(options.pMin*Nobs);
if nmin == 0
    nmin = 1;
end
%
% Extracting initial clusters (as forecasted)
nClu = options.nClu0;
centrF = data_unique(randperm(Nobs_unique,nClu)', :);
%
% Historic of number of clusters
nClu_hist = zeros(options.Niter, 1);
%
% Stop criteria flags and counters
countSTOP = 0;
flagOSCI = 0;
nClu_old_s = nClu;  % For stop criteria purposes
nClu_old_m = nClu;  % For stop criteria purposes
iter = 0;
hist_desv = 1;
iter_odd = false;
%
% main loop
if strcmp(options.Display, 'iter')
    disp(' ')
end
while true
    %
    nClu_old = nClu;  % For stop criteria purposes
    %
    if countSTOP == 0
        %
        % Grouping data into clusters
        [IDX, clucount] = GroupData(X, centrF);
        %
        % Erasing empty clusters
        if any(clucount==0)
            empty_idx = find(clucount==0)';
            c = 0;
            for idx = empty_idx
                IDX(IDX>idx-c) = IDX(IDX>idx-c)-1;
                c = c+1;
            end
            nClu = nClu-length(empty_idx);
            clucount(empty_idx) = [];
        end
        %
        % Updating stop criterion
        if nClu == nClu_old
            countSTOP = 1;
        else
            nClu_old = nClu;
            countSTOP = 0;
        end
    end
    
    if strcmp(options.Display, 'iter')
        disp(['iter: ' num2str(iter) ' | nClu: ' num2str(nClu)]);
    end
    
    % Verifying stop criteria
    if iter == options.Niter || countSTOP == 3 || (flagOSCI >= 4 && ~iter_odd) || (hist_desv < 0.05 && ~iter_odd)
        %
        %
        % Calculating centroids
        C = CalcCentr(IDX, X, clucount);
        if options.PlotFlag
            if nser == 2
                plot_groups(nClu, nser, X, IDX, options)
            else
                disp('Warning: "plot_flag = true" only available for two-dimensional series')
            end
        end
        %
        % Defining exitflag
        OUTPUT.iter = iter;
        if iter == options.Niter
            OUTPUT.exitflag = 0;  % Número de iterações atingido
        else
            OUTPUT.exitflag = 1;  % Parada por estabilização
        end
        %
        % Exit m-ISODATA program
        break
    end
    %
    % Updating iteration
    iter = iter+1;
    iter_odd = rem(iter, 2) ~= 0;
    nClu_hist(iter) = nClu;
    if iter>=10
        hist_desv = std(nClu_hist(iter-9:iter))/mean(nClu_hist(iter-9:iter));
    end
    %
    % Calculating centroids
    C = CalcCentr(IDX, X, clucount);
    %
    % Calculating distances between centroids and data and obtaining medoids
    [clu_desv, clu_bevec] = CalcDesv(X, IDX, clucount);
    %
    % Verifying if iteration is odd or even
    if iter_odd && iter ~= options.Niter
        %
        %  Accessing split function
        [centrF, nClu] = Split(clu_desv, clu_bevec, IDX, C, nmin, options);
        %
        % Updating stop criterion
        if nClu == nClu_old_s
            flagOSCI = flagOSCI+1;
        else
            nClu_old_s = nClu;
            flagOSCI = 0;
        end
    else
        %
        %  Accessing merge function
        [centrF, nClu] = Merge(C, nClu, options);
        %
        % Updating stop criterion
        if nClu == nClu_old_m
            flagOSCI = flagOSCI+1;
        else
            nClu_old_m = nClu;
            flagOSCI = 0;
        end
    end
    %
    % Updating stop criterion
    if nClu == nClu_old
        countSTOP = countSTOP+1;
    else
        countSTOP = 0;
    end
    %
end
%
%% Scenarios OUTPUT
if strcmp(options.Display, 'iter')  || strcmp(options.Display, 'final')
    disp(['iter: ' num2str(iter)]);
end
%
% Returning data ranges
for iser = 1:nser
    C(:, iser) = C(:, iser)*(base_data_2(iser)-base_data_1(iser))+base_data_1(iser);
end
%
% Calculating the probabilities of occurrence
PROB = clucount/Nobs;
%
% Saving data in the .csv file
if options.SaveFlag
    %
    % Scenarios table
    tbl = [C PROB];
    %
    % Sorting scenarios into decreasing probabilities
    [pB,I] = sort(tbl(:, nser+1),'descend');
    tblB = [tbl(I, 1:nser) pB];
    writetable(table(tblB),[options.ResultsPath options.SimName '.csv'],'WriteVariableNames', false)
    disp(['The results were saved in ' options.ResultsPath options.SimName '.csv'])
end
%
%
end
%
%% Function to group data into clusters
function [IDX, clucount] = GroupData(data, centrF)
[Nobs, ~] = size(data);
[nClu, ~] = size(centrF);
IDX = zeros(Nobs, 1);
clucount = zeros(nClu, 1);
%
for iobs = 1:Nobs
    dmax = inf;
    for iclu = 1:nClu
        d = norm(data(iobs, :)-centrF(iclu, :));
        if d < dmax
            dmax = d;
            kclu = iclu;
        end
    end
    IDX(iobs) = kclu;
    clucount(kclu) = clucount(kclu)+1;
end
%
%
end
%
%% Function to calculate distances between centroids and data
function [clu_desv, clu_bevec] = CalcDesv(data, IDX, clucount)
[~, dim] = size(data);
nClu = length(clucount);
%
clu_desv = zeros(nClu, 1);
clu_bevec = zeros(nClu, dim);
%
% Calculating standard deviations
for iclu = 1:nClu
    if clucount(iclu) > 0
        idata = data(IDX==iclu, :);
        %
        if clucount(iclu) > 1
            %
            % Covariance matrix
            data_cov = cov(idata, 1);
            %
            % Maximum calculated standard deviation of current cluster 
            clu_desv(iclu) = sqrt(max(diag(data_cov)));
            %
            % Eigenvectors and eigenvalues of covariance matrix
            [Evec, Eval] = eig(data_cov);
            %
            % Finding the eigenvector associated with the greatest eigenvalue
            max_Eval_idx = diag(Eval) == max(diag(Eval));
            if sum(max_Eval_idx) > 1
                new_Eval_idx = find(max_Eval_idx);
                max_Eval_idx = new_Eval_idx(1);
            end
            clu_bevec(iclu, :) = Evec(:, max_Eval_idx')';
        else
            clu_desv(iclu) = 0;
            clu_bevec(iclu, :) = zeros(1, dim);
        end
    end
end
%
%
end
%
%% Calculating centroids
function C = CalcCentr(IDX, data, clucount)
[~, dim] = size(data);
nClu = length(clucount);
C = zeros(nClu, dim);
for iclu = 1:nClu
    idata = data(IDX==iclu, :);
    if clucount(iclu) == 1
        C(iclu, :) = idata;
    else
        C(iclu, :) = mean(idata);
    end
end
%
%
end
%
%% Merge function
function [centrF, nClu] = Merge(C, nClu, options)
merge_clu = zeros(round(nClu/2), 2);
merge_cont = 0;
is_merge = zeros(nClu, 1);
for iclu = 1:nClu
    if is_merge(iclu)
        continue
    end
    %
    dmax = inf;
    for jclu = 1:nClu
        if jclu == iclu
            continue
        end
        %
        d = norm(C(iclu, :)-C(jclu, :));
        if d<dmax
            dmax = d;
            jmerge = jclu;
        end
    end
    if dmax < options.dMin
        % Merging clusters
        if is_merge(jmerge) == 0 && jmerge > iclu
            merge_cont = merge_cont+1;
            merge_clu(merge_cont, :) = [iclu jmerge];
            is_merge(jmerge) = 1;
        else
            is_merge(iclu) = 1;
        end
    end
end
%
% Merging clusters
for imrg = 1:merge_cont
    iclu = merge_clu(imrg, 1);
    jclu = merge_clu(imrg, 2);
    C(iclu, :) = (C(iclu, :)+C(jclu, :))/2;
end
%
C(logical(is_merge), :) = [];
%
% Forecasted centroids
centrF = C;
nClu = nClu-sum(is_merge);
%
%
end
%
%% Split function
function [centrF, nClu] = Split(clu_desv, clu_bevec, IDX, C, nmin, options)
[nClu, dim] = size(C);
nc_counter = 0;  % Counter of new clusters
nc_max = options.nCluMax-nClu;  % Maximum number of new clusters
if nc_max > 2*nClu
    nc_max = nClu;
end
clusters_tmp = zeros(nc_max, dim);

if nc_max > 0
    idx_grupos = unique(IDX);
    for iclu = 1:nClu
        idx = idx_grupos(iclu);
        Nparobs = sum(IDX==idx);
        if clu_desv(iclu) > options.max_std && Nparobs > 2*nmin
            nc_counter = nc_counter+1;
            %
            % New clusters
            clusters_tmp(nc_counter, :) = C(iclu, :)+clu_desv(iclu)*clu_bevec(iclu, :);
            C(iclu, :) = C(iclu, :)-clu_desv(iclu)*clu_bevec(iclu, :);
        end
        %
        if nc_counter == nc_max
            break
        end
    end
end
%
% Forecasted centroids
centrF = [C; clusters_tmp(1:nc_counter, :)];
nClu = nClu+nc_counter;
%
%
end
%