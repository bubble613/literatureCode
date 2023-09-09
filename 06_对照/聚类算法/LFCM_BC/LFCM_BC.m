function [C_new,b_new,U_new]=LFCM_BC(Img,K,U0,b0,clust_n)

%实现局部FCM聚类算法的子函数程序
%输入变量：Img -- 待分割图像； K -- 高斯截断核函数
% U0 -- 类隶属度矩阵； b0 -- 偏移场
% clust_n -- 聚类子类总数
%输出变量: C_new 更新的常数ci； U_new 更新的类隶属度矩阵
% b_new 更新的偏移场

K_1 = conv2(ones(size(Img)),K,'same');%计算卷积1*K
K_b = conv2(b0,K,'same');%计算卷积b*K
K_b2 = conv2(b0.^2,K,'same');%计算卷积b^2*K

for i = 1:clust_n
    U2(:,:,i) = U0(:,:,i).^2;%计算u^2
    U2_J(:,:,i) = U2(:,:,i).*Img;%计算乘积u^2×J
    K_U2(:,:,i) = conv2(U2(:,:,i),K,'same');%计算卷积u^2*K
    K_U2_J(:,:,i) = conv2(U2_J(:,:,i),K,'same');%计算卷积(u^2×J)*K
    
    %更新常数ci
    C_new(i) = sum(sum(K_U2_J(:,:,i)-b0.*K_U2(:,:,i)))/sum(sum(K_U2(:,:,i)+eps));
    K_CU2(:,:,i) = conv2(U2(:,:,i)*C_new(i),K,'same');%计算卷积(c×u^2)*K
    d(:,:,i) = K_1.*((Img-C_new(i)).^2)-2*K_b.*(Img-C_new(i))+K_b2+eps;
end

b_new = (sum(K_U2_J,3)-sum(K_CU2,3))./(sum(K_U2,3)+eps);%更新偏移场b
for i = 1:clust_n
    U_new(:,:,i) = (d(:,:,i).^(-1))./sum(d.^(-1),3);%更新类隶属度ui
    Nb = ones(5,5); Nb(3,3) = 0;
    h(:,:,i) = conv2(U_new(:,:,i),Nb,'same');%计算空域函数hi(x)=sum(ui(x)) xNb
end
for i = 1:clust_n
    Unew_s(:,:,i) = U_new(:,:,i).*h(:,:,i)./sum(U_new.*h,3);%校正类隶属度
end
U_new = Unew_s;