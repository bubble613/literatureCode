clear;clc;close;

I=rgb2gray(imread('/Users/liwangyang/Desktop/matlab_doc/图片集/lena_std.tif'));%转换为灰度图像  
I=double(I);
[m,n]=size(I); 
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