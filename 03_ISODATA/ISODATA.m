function ISODATA(x,K,theta_N,theta_S,theta_c,L,I)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%input parameters%%%%%%
% x : data
% K : 预期的聚类中心数
% theta_N : 每一聚类中心中最少的样本数，少于此数就不作为一个独立的聚类
% theta_S ：一个聚类中样本距离分布的标准差
% theta_c : 两聚类中心之间的最小距离，如小于此数，两个聚类进行合并
% L : 在一次迭代运算中可以和并的聚类中心的最多对数
% I ：迭代运算的次数序号
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% step1
n = size(x,1);
N_c = K;
mean = cell(K,1);
for i=1:K
    mean{i} = x(i,:);
end
ite = 1;
while ite<I
    flag = 1;
    while flag
    %% step2
    class = cell(size(mean));
    for i=1:n
        num = Belong2(x(i,:),mean);
        class{num} =  [class{num};x(i,:)];
    end
    %% step3
    for i=1:N_c
        size_i = size(class{i},1);
        if size_i<theta_N
          class_i = class{i};
          mean = DeleteRow(mean,i);
          class = DeleteRow(class,i);
          N_c = N_c-1;
          for j=1:size_i
            class_ij = class_i(j,:);%the j'th row of class{i}
            num = Belong2(class_ij,mean);
            class{num} = [class{num};class_ij];
          end
        end
    end
 
    %% step4
    for i=1:N_c
        if ~isempty(mean{i})
            mean{i} = sum(class{i})./size(class{i},1);
        end
    end
    %% step5
    Dis = zeros(N_c,1);
    for i=1:N_c
        if ~isempty(class{i})
            N_i =size(class{i},1);
            tmp = bsxfun(@minus,class{i},mean{i});
            Dis(i) = sum(arrayfun(@(x)norm(tmp(x,:)),1:N_i))/N_i;
        end
    end
    %% step6
    D = 0;
    for i=1:N_c
        if ~isempty(class{i})
            N_i =size(class{i},1);
            D = D + N_i*Dis(i);
        end
    end
    D = D/n;
    %% step7
    flag = 0;
    if ite == I
        theta_c = 0;
        flag = 0;
    elseif ~(N_c > K/2)
        flag = 1;
    elseif mod(ite,2)==0 || ~(N_c<2*K)
        flag = 0;
    end
    %% 分裂处理
    %% step8
    if flag
        flag = 0;
        delta = cell(N_c,1);
        for i=1:N_c
            if ~isempty(class{i})
                 N_i =size(class{i},1);
                 tmp = bsxfun(@minus,class{i},mean{i});
                 delta{i} = arrayfun(@(x)norm(tmp(:,x)),1:size(tmp,2))/N_i;
            end
        end
 
    %% step9
    delta_max = cell(N_c,1);
    for i=1:N_c
        if ~isempty(class{i})
            max_i = max(delta{i});
            sub = find(delta{i}==max_i,1);
            delta_max{i} = [max_i,sub];
        end
    end
    %% step10  
    for i=1:N_c
        if delta_max{i}(1) > theta_S
            N_i =size(class{i},1);
            con1 = (Dis(i)>D && N_i>2*(theta_N + 1));
            con2 = ~(N_c>K/2);
            if con1 || con2
               %%%%这里分裂%%%%%
               flag = 1;%一旦发生分裂，那么分裂一次后就返回第二步；若没发生分裂，则直接进入合并处理步
               lamda = 0.5;
               max_sub = delta_max{i}(2);
               mean{i}(max_sub) = mean{i}(max_sub) + lamda * delta_max{i}(1);
               addOneMean =  mean{i};
               addOneMean(max_sub) = addOneMean(max_sub) - lamda * delta_max{i}(1);
               mean = [mean;addOneMean];
               N_c = N_c+1;
               break;
            end
        end
     end
 
    end
 
    end
    %% 合并处理
    if L
    %% step11
    Distance = zeros(N_c,N_c);
    for i=1:N_c-1
        for j=i:N_c
            Distance(i,j) = norm(mean{i}-mean{j});
        end
    end
    %% step12
    index = find(-Distance>theta_c);
    keepIndex = [Distance(index),index];
    [~, index] = sort(keepIndex(:,1));
    if size(index,1) > L
        index = index(1:L,:);
    end
    %% step13
    if size(index,1) ~= 0
        for id=1:size(index,1)
            [m_i m_j]= seq2idx(index(id),N_c);
            %%%%%这里合并%%%%%
            N_mi = size(class{m_i},1);
            N_mj = size(class{m_j},1);
            mean{m_i} = (N_mi*mean{m_i} + N_mj*mean{m_j})/(N_mi+N_mj);
            mean = DeleteRow(mean,m_j);
            class{m_i} = [class{m_i};class{m_j}];
            class = DeleteRow(class,m_j);
        end  
    end
    end
    %% step14
    ite=ite+1;
end
   for  i=1:N_c
       fprintf('第%d类聚类中心为\n',i);
       disp(mean{i});
       fprintf('第%d类中元素为\n',i);
       disp(class{i});
   end
end
 
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function number = Belong2(x_i,means)
    INF = 10000;
    min = INF;
    kk = size(means,1);
    number = 1;
    for i=1:kk
        if ~isempty(means{i})
            if norm(x_i - means{i}) < min
                min = norm(x_i - means{i});
                number = i;
            end
        end
    end
end
 
function A_del = DeleteRow(A,r)
    n = size(A,1);
    if r == 1
        A_del = A(2:n,:);
    elseif r == n
        A_del = A(1:n-1,:);
    else
        A_del = [A(1:r-1,:);A(r+1:n,:)];
    end
end
 
 
function [row col] = seq2idx(id,n)
    if mod(id,n)==0
        row = n;
        col = id/n;
    else
        row = mod(id,n);
        col = ceil(id/n);
    end
end