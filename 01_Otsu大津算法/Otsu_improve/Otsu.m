clear;clc;close;
% 加权值的Otsu

[fileName,pathName] = uigetfile({'*.*';'*.tif';'*.tiff';'.bmp';'.jpg'},...
                                'Select the original image file');
fileName = strcat(pathName,fileName);
img = imread(fileName);
if (size(img,3) == 3)%如果是三通道图像，将其转化为单通道图像
    figure,imshow(img),title('Original Color Image');
    % img = rgb2gray(img);
end
figure,imshow(img),title('Original Image');
figure,imhist(img),title('Image histogram');
image = double(img);
[m,n]=size(image);

p = imhist(img);
p = p / (m * n);

for i = 1:256
    muI(i) = (i - 1) * p(i);
end

%% main

for k = 1:256
    mu1 = 0; mu2 = 0;
    w1(k) = sum(p(1:k));
    w2(k) = sum(p(k+1 : 256));
    
    for i = 1 : k
        if w1(k) ~= 0
            mu1 = mu1 + ((i - 1) * p(i) / w1(k));
        end
    end
    mu1_k(k) = mu1;
%     if w1(k+1) ~= 0
%         mu1_k(k+1) = sum(((0 : k) .* p(1 : k+1) / w1(k+1)));
%     end
    
    for i = k + 1 : 256
        if w2(k) ~= 0
            mu2 = mu2 + ((i - 1) * p(i) / w2(k));
        end
    end
    mu2_k(k) = mu2;
%     if w2(k+1) ~= 0
%         mu2_k(k) = sum(((k+1 : 255) .* p(k+2 : 256) / w2(k+1)));
%     end
    
end
sigma = (w1 .* power(mu1_k, 2)) + (w2 .* power(mu2_k, 2));
% sigma = W * ((w1 .* power(mu1_k, 2)) + (w2 .* power(mu2_k, 2)));
% 加权值 W
% W为谷强调算法
sigam_weight1 = (1 - p') .* ((w1 .* power(mu1_k, 2)) + (w2 .* power(mu2_k, 2)));

[sigma_max, index] = max(sigma);
[sigma_weight1_max, index_weight1] = max(sigam_weight1);

imgbw1 = imbinarize(image, index);
imgbw2 = imbinarize(image, index_weight1);

figure(1),
subplot(121); imshow(imgbw1); title('Otsu分割结果');
subplot(122); imshow(imgbw2); title('Otsu方法加权（W为谷强调法）分割结果');

%% 新方法  加权值过程
% Automatic image thresholding using Otsu’s method and entropy weighting scheme for surface defect detection
% 文献中提出 一种新的加权方案，以改进Otsu方法的性能，而无需调整或分配参数。
HnTemp = 0;
for i = 1:256
    
    if p(i) ~= 0
        HnTemp = HnTemp - (p(i) * log(p(i)));
        Hn = HnTemp;
    end
end
for k = 1:256
    
    Pk(k) = sum(p(1:k));
    % Hn(k) = -Pk * log(Pk) - (1 - Pk) * log(1 - Pk);
    
    % 最大化Hn 得到Pk = 1 - Pk = 1/2
    
    HkTemp = 0;
    for i = 1 : k
        if p(i) == 0
            HkTemp = HkTemp;
        else
            HkTemp = HkTemp - (p(i) * log(p(i)));
        end
    end
    Hk(k) = HkTemp;
    
end
% 准则函数
Fk = log(Pk .* (1 - Pk)) + Hk ./ Pk + (Hn - Hk) ./ (1 - Pk);
Fk(isnan(Fk)) = 0;
[Fk_max, index_Fk] = max(Fk);
% 将准则函数 Fk 作为Otsu权值 W
sigam_weight2 = Fk .* ((w1 .* power(mu1_k, 2)) + (w2 .* power(mu2_k, 2)));
[sigma_weight2_max, index_weight2] = max(sigam_weight2);
threshold_weight2 = index_weight2 - 1;
imgbw3 = false(size(img));  % 将整幅输入的图像全部置为0/False
imgbw3(img > threshold_weight2) = true;  % 图像矩阵的像素值大于阈值的置为1/True
% imgbw3 = imbinarize(img, index_weight2);
figure(2),
imshow(imgbw3); title('Otsu方法加权（W为Shannon熵的准则函数）分割结果');


%% old method

% 最大类内类间的方差比 阈值
Smax = -1;
kMax = 255;
etaMax = -1;
for T = 0:255    
    sum1 = 0; num1 = 0;                       
    sum2 = 0; num2 = 0;                       
    for i = 1:m       
        for j = 1:n          
            if I(i,j) >= T     
                sum2 = sum2+I(i,j);        
                num2 = num2+1;              
            else
                sum1 = sum1+I(i,j);     
                num1 = num1+1;          
            end
        end
    end
    
    ave1 = sum1/num1;    
    ave2 = sum2/num2;    
    ave = (sum1+sum2) / (m*n); % 整幅图像的平均灰度
    d1 = -1;   
    d2 = -1;     
    for i = 1:m      
        for j = 1:n      
            if I(i,j) >= T        
                d = (I(i, j) - ave2)^2; % 目标区域中像素与平均像素的欧氏距离平方       
                if d2 == -1               
                    d2 = d;               
                else
                    d2 = d2+d; % 求目标区域像素欧氏距离总和 sigma1的平方          
                end
            else
                d = (I(i, j) - ave1)^2;  
                if d1 == -1             
                    d1 = d;        
                else
                    d1 = d1+d; % 求背景区域像素欧氏距离总和 sigma0的平方           
                end
            end
        end
    end
    p = (num1 + num2) / (m * n);
    p1 = num1/(m*n); % 背景像素概率    
    p2 = num2/(m*n); % 目标像素概率    
    S1 = p1 * (ave1 - ave)^2 + p2 * (ave2 - ave)^2; %sigmaB^2    
    S2 = p1 * d1 + p2 * d2; % 求sigmaW^2    
    S = S1 / S2; % 求lambda 判断度量 sigmaB^2 / sigmaW^2 
    
    % 三种度量
    sigmaT = (T - ave)^2 * p;
    k = sigmaT / S2;
    eta = S1 / sigmaT;
    lambda = S;
    
    if S > Smax   
        Smax = S;    
        T_lambda = T;   
    end
    if k < kMax
        kMax = k;
        T_k = T;
    end
    if eta > etaMax
        etaMax = eta;
        T_eta = T;
    end
    
end

T_lambda;

for i=1:m    
    for j=1:n       
        if I(i,j) >= T_lambda      
            I(i,j)=255;       
        else
            I(i,j)=0;      
        end
    end
end

imshow(I),title('最大类内类间方差比法阈值分割效果图');