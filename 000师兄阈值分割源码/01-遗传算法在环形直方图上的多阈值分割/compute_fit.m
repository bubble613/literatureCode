%% ��4��������Ӧ��

%��Ӧ��2
% function fitness = compute_fit(pop,hist)
% [row list] = size(pop);
% 
% %��ÿ�������������  ������������
% [sort_pop order] = sort(pop,2);
% 
% %(4.1)������䷽��
% %(4.1.1)������ֵ�������ص�ƽ��ֵ
% m = zeros([row list+1]);
% %(4.1.2)������ֵ���ڸ���
% p = zeros([row list+1]);
% %(4.1.3)����ȫ������ƽ��ֵ
% mg = zeros(row,1);
% sum_i = zeros([row list+1]);
% for k = 1:row     %row ������
%     for i=1:list+1
%         %ȷ����ֵ�ο�ʼ
%         if i == 1
%             m_start = 1;
%         else
%             m_start = pop(k,i-1);
%         end
%         %ȷ����ֵ�ο�ʼ
%         if i == list+1
%             m_end = 256;
%         else
%             m_end = pop(k,i)-1;
%         end
%         
%         for j = m_start:m_end
%             m(k,i) = m(k,i) + j * hist(j);           %ͨ����⣺��ֵ�����ܻҶ�
%             sum_i(k,i) = sum_i(k,i) + hist(j);       %ͨ����⣺��ֵ�������ص��ܸ���
%         end
%     end
%     sum_i(k,sum_i(k,:)==0) = 0.0001;
%     m(k,:) = m(k,:)./sum_i(k,:);              %��ֵ�������ػҶ�ƽ��ֵ
%     p(k,:) = sum_i(k,:)./sum(sum_i(k,:));     %������ֵ�ε����ص���ռ�������ص�������
% end
% mg = sum(m.*p,2);                %��������  ����Ҷ�ֵ����  row * 1
% S_bo = sum(p .* ((m - mg) .^ 2),2);    %Between objects ����  row*1
% 
% %(4.2)�������ڷ���
% %��4.2.1��������ֵ���ڷ���Si
% si = zeros([row list+1]);
% for k = 1:row     %row ������
%     for i=1:list+1
%         %ȷ����ֵ�ο�ʼ
%         if i == 1
%             m_start = 1;
%         else
%             m_start = pop(k,i-1);
%         end
%         %ȷ����ֵ�ο�ʼ
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
% %ͼ���ȫ�ַ���
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
 
%��Ӧ��1
function fitness = compute_fit(pop, hist, q)
    [row, list] = size(pop);
    % ��ÿ������������򣬺�����������
    [sort_pop, order] = sort(pop, 2);
    % ��������Ȩ��
  
    % ����ͼ��ĻҶ�����
    gray = 1 : 256;
    mg = sum(gray .* hist);
   
    pk = zeros(row, list + 1);    % ������ֵ���ܸ���
    mk = zeros(row, list + 1);    % ������ֵ�λҶ�ֵ����
    hk = zeros(row, list + 1);    % ������ֵ�ε�Tsallis��
    
    for i = 1 : row
        for j = 1 : list + 1
            % ȷ����ʼλ��
            if j == 1
                m_start = 1;
            else
                m_start = sort_pop(i, j - 1) + 1;
                if m_start > 256
                    m_start = 256;
                end
            end
            % ȷ������λ��
            if j == list + 1
                m_end = 256;
            else
                m_end = sort_pop(i,j);
            end
            % �������ر��ֵ�������ֵ�ε��ܸ���
            pk(i, j) = sum(hist(m_start : m_end)); 
            % ��ֹpkΪ0��Ϊ��ĸ
            if pk(i, j) == 0
                pk(i, j) = 0.0001;
            end
            % ���������ֵ�εĻҶ�ֵ����
            mk(i, j) = sum((gray(m_start : m_end) .* hist(m_start : m_end)) / pk(i, j));
            hk(i, j) = (1 - sum(power(hist(m_start : m_end) / pk(i, j), q))) / (q - 1);
        end
    end
    
    % ��������Ȩ��
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
    
    % ����Tsallis��Ȩ��
    T = zeros(row, 1);
    for i = 1 : row
       T(i, 1) = sum(hk(i, :)) + (1 - q) * prod(hk(i, :));
    end
    % ������䷽��
    H = pk .* ((mk - mg) .^ 2);
    
    S = sum(H , 2) .* T .* h_t;  % sum(H, 2)�Ծ���H��ÿһ��Ϊ���󣬶�һ���ڵ�������͡�
    fitness = S;
end