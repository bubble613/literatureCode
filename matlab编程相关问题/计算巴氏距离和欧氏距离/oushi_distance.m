%% 计算欧氏距离

function EulerDistance = calculateDistance(ThreshImage, OrginImage)

OrginImage_Gray_Eu = rgb2gray(OrginImage); %将图片转为灰度图

h = imhist(OrginImage_Gray_Eu); %原始灰度图每种灰度级像素个数

Count = imhist(ThreshImage); %阈值灰度图每种灰度级像素个数

EulerDistance = sqrt(sum((h - Count) .* (h - Count))); %计算欧氏距离
