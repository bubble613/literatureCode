%% （4）计算适应度

%适应度2
% function fitness = compute_fit(pop,hist)
% [row list] = size(pop);
% 
% %将每个个体进行排序  后续调整回来
% [sort_pop order] = sort(pop,2);
% 
% %(4.1)计算类间方差
% %(4.1.1)计算阈值段内像素的平均值
% m = zeros([row list+1]);
% %(4.1.2)计算阈值段内概率
% p = zeros([row list+1]);
% %(4.1.3)计算全局像素平均值
% mg = zeros(row,1);
% sum_i = zeros([row list+1]);
% for k = 1:row     %row 个个体
%     for i=1:list+1
%         %确定阈值段开始
%         if i == 1
%             m_start = 1;
%         else
%             m_start = pop(k,i-1);
%         end
%         %确定阈值段开始
%         if i == list+1
%             m_end = 256;
%         else
%             m_end = pop(k,i)-1;
%         end
%         
%         for j = m_start:m_end
%             m(k,i) = m(k,i) + j * hist(j);           %通俗理解：阈值段内总灰度
%             sum_i(k,i) = sum_i(k,i) + hist(j);       %通俗理解：阈值段内像素点总个数
%         end
%     end
%     sum_i(k,sum_i(k,:)==0) = 0.0001;
%     m(k,:) = m(k,:)./sum_i(k,:);              %阈值段内像素灰度平均值
%     p(k,:) = sum_i(k,:)./sum(sum_i(k,:));     %各个阈值段的像素点数占总体像素点数概率
% end
% mg = sum(m.*p,2);                %各个个体  总体灰度值期望  row * 1
% S_bo = sum(p .* ((m - mg) .^ 2),2);    %Between objects 方差  row*1
% 
% %(4.2)计算类内方差
% %（4.2.1）计算阈值段内方差Si
% si = zeros([row list+1]);
% for k = 1:row     %row 个个体
%     for i=1:list+1
%         %确定阈值段开始
%         if i == 1
%             m_start = 1;
%         else
%             m_start = pop(k,i-1);
%         end
%         %确定阈值段开始
%         if i == list+1
%             m_end = 256;
%         else
%             m_end = pop(k,i)-1;
%         end
%         for j = m_start:m_end
%             si(k,i) = si(k,i) + (hist(j) - m(k,i)).^2;   %row * list+1
%         end
%     end
% end
% %图像的全局方差
% sg = zeros(row,1);
% for j=1:256
%     sg = sg + hist(j) .*  (j - mg).^2;      %row*1
% end
% 
% S_wo = sum(si./sg,2);  %row*1
% S_wo(S_wo==0) = 0.001;
% % S_bo
% % S_wo
% fitness = S_bo ./ S_wo;
% end
 
%适应度1
function fitness = compute_fit(pop, hist, q)
    [row, list] = size(pop);
    % 将每个个体进行排序，后续调整回来
    [sort_pop, order] = sort(pop, 2);
    % 计算邻域权重
  
    % 整幅图像的灰度期望
    gray = 1 : 256;
    mg = sum(gray .* hist);
   
    pk = zeros(row, list + 1);    % 各个阈值段总概率
    mk = zeros(row, list + 1);    % 各个阈值段灰度值期望
    hk = zeros(row, list + 1);    % 各个阈值段的Tsallis熵
    
    for i = 1 : row
        for j = 1 : list + 1
            % 确定开始位置
            if j == 1
                m_start = 1;
            else
                m_start = sort_pop(i, j - 1) + 1;
                if m_start > 256
                    m_start = 256;
                end
            end
            % 确定结束位置
            if j == list + 1
                m_end = 256;
            else
                m_end = sort_pop(i,j);
            end
            % 计算像素被分到各个阈值段的总概率
            pk(i, j) = sum(hist(m_start : m_end)); 
            % 防止pk为0成为分母
            if pk(i, j) == 0
                pk(i, j) = 0.0001;
            end
            % 计算各个阈值段的灰度值期望
            mk(i, j) = sum((gray(m_start : m_end) .* hist(m_start : m_end)) / pk(i, j));
            hk(i, j) = (1 - sum(power(hist(m_start : m_end) / pk(i, j), q))) / (q - 1);
        end
    end
    
    % 计算邻域权重
    h_t = zeros(row, 1);
    for i = 1 : row
        for j = 1 : list
            temp = 0;
            for k = -5 : 1 : 5
               temp = temp + hist(mod(sort_pop(i, j) + k + 256, 256) + 1);
            end
            h_t(i, 1) = h_t(i, 1) + temp;
        end
        h_t(i, 1) = 1 - h_t(i, 1);
    end
    
    % 计算Tsallis熵权重
    T = zeros(row, 1);
    for i = 1 : row
       T(i, 1) = sum(hk(i, :)) + (1 - q) * prod(hk(i, :));
    end
    % 计算类间方差
    H = pk .* ((mk - mg) .^ 2);
    
    S = sum(H , 2) .* T .* h_t;  % sum(H, 2)以矩阵H的每一行为对象，对一行内的数字求和。
    fitness = S;
end