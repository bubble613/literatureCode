function [V_new, U_new] = FCMclassic(Img, U, clust_n)
% 实现经典FCM聚类算法的子函数程序
% 输入参数：Img -- 待分割的图像
%         U -- 类隶属度矩阵
%         clust_n -- 子类总数
% 输出参数：V_new -- 返回新的聚类中心
%         U_new --返回新的隶属度矩阵
for i = 1:clust_n
    % 计算新的聚类中心
    V_new(i) = sum(sum((U(:, :, i).^2) .* Img)) / sum(sum(U(:, :, i).^2));
    % 计算||Ij - vi||^(-2 / m - 1)
    Img_V_new(:, :, i) = (Img - V_new(i)).^(-2);
    
end

for i = 1:clust_n
    %计算新的隶属度矩阵
    U_new(:, :, i) = Img_V_new(:, :, i) ./ sum(Img_V_new, 3);
    
end
