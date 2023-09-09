clc
clear
close all
img = double(rgb2gray(...
    imread('/Users/liwangyang/Desktop/matlab_doc/图片集/lena_std.tif')));

%设置聚类数
cluster_num = 4;

%随机初始化参数--至关重要
%我这样选择可以更大程度的贴近真实均值
%从而效果才会更好
mu = (1:cluster_num) ./(cluster_num + 1) * max(max(img));
sigma = mu;
pw = zeros(cluster_num, size(img, 1) * size(img, 2));
pc = rand(1, cluster_num);
pc = pc /sum(pc);%将类概率归一化
max_iter = 50;%以迭代次数来作为停止的条件
iter = 1;
while iter <= max_iter
    %----------E-------------------
    for i = 1:cluster_num
        %矩阵操作--速度快
        MU = repmat(mu(i),size(img,1)*size(img,2),1);
        %高斯模型
        temp = 1/sqrt(2*pi*sigma(i))*exp(-(img(:)-MU).^2/2/sigma(i));
        temp(temp<0.000001) = 0.000001;% 防止出现0
        % pw(i,:) = log(pc(i)) + log(temp);
        pw(i,:) = pc(i) * temp;
    end
    pw = pw./(repmat(sum(pw),cluster_num,1));%归一
    %----------M---------------------
    %更新参数集
    for i = 1:cluster_num
         pc(i) = mean(pw(i,:));
         mu(i) = pw(i,:)*img(:)/sum(pw(i,:));
         sigma(i) = pw(i,:)*((img(:)-mu(i)).^2)/sum(pw(i,:));
    end
    %------------show-result---------------
    [~,label] = max(pw);
    %改大小
    label = reshape(label,size(img));
    imshow(label,[])
    title(['iter = ',num2str(iter)]);
    pause(0.1);
    M(iter,:) = mu;
    S(iter,:) = sigma;
    iter = iter + 1;
end
%将均值与方差的迭代过程显示出来
figure
for i = 1:cluster_num
    plot(M(:,i));
    hold on
end
figure
for i = 1:cluster_num
    plot(S(:,i));
    hold on
end
