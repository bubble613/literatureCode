function [V_new, U_new] = FCMclassic(Img, U, V, sigma, clust_n)

% 实现核化FCM聚类算法的子函数程序
% 输入参数：Img -- 待分割的图像
%         U -- 类隶属度矩阵
%         V -- 类隶属度矩阵
%         sigma -- 核函数宽度
%         clust_n -- 子类总数
% 输出参数：V_new -- 返回新的聚类中心
%         U_new --返回新的隶属度矩阵

for i = 1:clust_n
    % 计算K(Ij, vi)
    K_1_V(:, :, i) = exp(-(Img - V(i)).^2 / sigma / sigma);
    
    % 计算新的聚类中心
    V_new(i) = sum(sum((U(:, :, i).^2) .* K_1_V(:, :, i) .* Img)) / sum(sum(U(:, :, i).^2 .* K_1_V(:, :, i)));
    % 计算[1-K(Ij, vi)]^(-1/m-1)
    Img_V_new(:, :, i) = (1 - K_1_V(:, :, i)).^(-1);
end

for i=1:clust_n
    U_new(:,:,i) = Img_V_new(:,:,i)./sum(Img_V_new,3);%计算新的类隶属度矩阵
end
