%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   灰度图阈值分割提取前后背景
%   otsu法和一种改进的方法
%   th为最终确定的阈值
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
clc;
I=imread('/Users/liwangyang/Desktop/matlab_doc/图片集/lena_std.tif'); %替换图片

a=rgb2gray(I);
% a=I;
figure(1),
imshow(a);

count = imhist(a);    %统计的是图像上对应像素值的个数，是1-256的列向量            
[m, n]=size(a); 
count = count / (m * n); %归一化数据，概率百分比，每一个灰度级别的概率

figure(2),
[n, xout] = hist(a( : ), 0 : 255);  %n是落在该灰度值的个数，xout是中心点的刻度
% xout = 125;
bar(xout, n);
xlim([0 255]);      %把x轴的范围设置在0-255之间

%%%%%%%%%%%%%%%%%%%%%%%%%%
%方法1 
%   otsu法来求阈值分割图像
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% E = [];   %E是一个行向量，存储中间变量的值
% for TH = 1:1:256  %阈值从1开始计算   
%     av0 = 0;
%     av1 = 0;
%     w0 = sum(count(1 : TH));  %统计  1~（阈值+1）处的总的概率和w0
%     w1 = 1 - w0;
%     %第一类  背景区域
%     for i=1 : TH
%         av0 = av0 + i * count(i);   % 求背景区域的平均灰度值
%     end 
%     u0 = av0 / w0;                 %平均灰度值/背景的总概率
%     %第二类
%     for i = TH+1:256
%         av1 = av1 + i * count(i);   %这是一个计算前景均值的方法
%     end 
%     u1 = av1 / w1;      %平均灰度值/背景的总概率
%     E(TH) = w0 * w1 * (u1 - u0) * (u1 - u0);   %将两者的平均值相加
% end 
% postion = find(E == max(E));  %找到E最大处的值的位置，这个位置就可以确定为阈值  
% th = postion; 

%%%%%%%%%%%%%%%%%%%%%%%
%方法2
%不是otsu法，是一种新的方法
%%%%%%%%%%%%%%%%%%%%%%
 
L = 256;

for i = 1 : L             %找到开始的位置
    if count(i) ~= 0    %频数不等于0的地方开始
        st = i-1;       %从小到大，找到第一个非零点st
        break;
    end
end 
for j = L : -1 : 1 %找到结束的位置
    if count(j) ~= 0        %从最后开始L=256
    nd = j - 1;               %从后到前找到第一个非零点nd
    break;
    end 
end

%曲线拟合  多项式拟合,
cline = (st : nd);    %cline从st到nd，中间差值为1，是一个行向量，包含了非零点的数目

%曲线拟合函数，cline作为一个横坐标值，count是一个包含频数的矩阵，
%对应着频数值，一阶直线拟合，二阶抛物线拟合，并非阶次越高越好，看拟合情况而定。
p = polyfit(cline, count(st : nd)', 5); 
%为什么对count进行一个转置，因为统计出来的频数count是一个列向量，转置成行向量
y = polyval(p, cline);   %多项式在每一个cline处的值y
plot((1 : 256), count, '*r', cline, y);  %画出拟合曲线图

%[value,index]=max(y)

IndMin = find(diff(sign(diff(y))) > 0) + 1;  %极小值点
IndMax = find(diff(sign(diff(y))) < 0) + 1;  %极大值点
f = count(st + 1 : nd + 1);

% 
% %%%%%%%%%%%%%%%%%
% %%   计算阈值   %%
% %%%%%%%%%%%%%%%%%
%
E = [];  %E是一个行向量，存储中间变量的值
for TH = st : 1 : nd - 1   %阈值从非空的点开始计算 st=32
    av1 = 0;
    av2 = 0;
    p_th = sum(count(1 : TH + 1));    %统计  1 ~（阈值+1）处的总的概率和w0
    %第一类  背景区域
    for i = 0 : TH
        %这是一个计算背景均值的方法   求和pi/w0*log（pi/w0+0.0001）
        %每一个点的概率除以第一类的总概率
        av1 = av1 - count(i + 1) / p_th *...
            log(count(i + 1) / p_th + 0.00001);   
    end 
    %第二类  目标
    for i = TH + 1 : L-1
        %这是一个计算前景均值的方法
        av2 = av2 - count(i + 1) / (1 - p_th) *...
            log(count(i + 1) / (1 - p_th) + 0.00001); 
    end 
    E(TH - st + 1) = av1 + av2;   %将两者的平均值相加
end 
postion = find(E == max(E));  %找到E最大处的值的位置，这个位置就可以确定为阈值   
th = st + postion - 1; 

% 
% %%%%%%%%%%%%%%%%%%%%%%%%%
% %%   根据阈值来分割图像   %%
% %%%%%%%%%%%%%%%%%%%%%%%%%
%
for i = 1 : m
    for j = 1 : n
        if a(i, j) > th
            a(i, j) = 255;
        else 
            a(i, j) = 0;
        end 
    end 
end 
figure(3);
imshow(a)
 
 
 