% function threshold = th_Entropy(vHist, m, n)
% 
% p = vHist / (m * n); %求各个灰度出现的概率
% Pt = cumsum(p); % 计算出选择不同t值时，A区域的概率
% Ht = -cumsum(p*log(p)); % 计算出选择不同t值时，A区域的熵
% HL = nt(length(Hz)); % 计算出全图的熵
% % 计算出选择不同t值时，判别函数的值
% Yt = log(Pt .* (1 - Pt)) + ht ./Pt +(HL - Ht) ./ (1 - Pt);
% [ans, threshold] = max(Yt); %threshold为最佳阈值
% end

clc,clear;

y_img=imread("/Users/liwangyang/Desktop/matlab_doc/图片集/lena_std.tif");

figure(1),
subplot(121); imshow(y_img); title('原图');
if ndims(y_img) == 3
    bin_img = rgb2gray(y_img);
else
    bin_img = y_img;
end
subplot(122); imshow(bin_img); title('原图灰度图');

h_p = imhist(bin_img); 

[m, n] = size(bin_img);

p = h_p(find(h_p > 0)) / (m * n); %每个灰度值对应的概率
Pt = cumsum(p); %计算出选择不同t值时，A区域的概率
Ht = -cumsum(p .* log(p)); %计算出选择不同t值时，A区域的熵
HL = Ht(length(Ht)); %计算出全图的熵
%计算出选择不同t值时，判别函数的值
Yt = log(Pt .* (1 - Pt)) + Ht ./ Pt + (HL - Ht) ./ (1 - Pt);
[ans, threshold] = max(Yt); %threshold为最佳阈值

level = threshold / 255
img_th = imbinarize(bin_img, level);
figure(2),
imshow(img_th); title('一维最大熵阈值分割图像');

