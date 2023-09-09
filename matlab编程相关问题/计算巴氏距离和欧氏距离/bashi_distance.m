%% 计算距离 计算巴氏距离
function Bashi = calculateDistance_b(ThreshImage, OrginImage)

[m, n]=size(ThreshImage);
Count2 = imhist(ThreshImage);
OrginImage_Gray = rgb2gray(OrginImage);
[Count1, x] = imhist(OrginImage_Gray) ;%原始灰度图的每种灰度值的像素数Count1

Sum1 = sum(Count1);
Sum2 = sum(Count2);%阈值后灰度图的每种灰度值的像素数Count2
Sumup = sqrt(Count1 .* Count2); % 每个元素对应相乘再开平方根
SumDown = sqrt(Sum1 * Sum2); % 每幅图像像素总数相乘开平方根
Sumup = sum(Sumup); 

Bashi = 1-sqrt(1 - Sumup / SumDown); %计算图像直方图距离 %巴氏系数计算法