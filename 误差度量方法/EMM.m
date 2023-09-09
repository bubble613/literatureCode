clc;clear;close;
fig = imread('/Users/liwangyang/Desktop/matlab_doc/图片集/lena_std.tif');
% fig = im2double(fig);

figgray = im2gray(fig);
otsu = graythresh(figgray);
t_otsu = otsu * 255;
standard = imbinarize(figgray);
segImage = imread('junyun1.tiff');

emm = EdgeMismatch(standard, segImage);
disp(strcat('边缘不匹配度量为',num2str(emm)));

function [EMM] = EdgeMismatch(standardImage, segmentedImage)
% 函数说明：EMMMethod Edge Mismatch (边缘不匹配算法）
% 参数说明：
%   groundtruthImage：原始图像 BO+FO
%   segmentedImage：分割好的图像（测试图像） 
% 返回值说明：
%   EMM：边缘不匹配错误率
%----------------------------------------------------------------------------------

% 调用示例：[ME] = MisclassificationError(groundtruthImage, segmentedImage)
    [length, width] = size(standardImage);
    w = 10/length;
    maxdist = 0.025 * length;
    Dmax = length / 10;
    alpha = 2;
    
    BW1 = ~(edge(standardImage));
    BW2 = ~(edge(segmentedImage));
    
    EO = ~BW1 & ~(~BW1 & ~BW2);
    ET = ~BW2 & ~(~BW1 & ~BW2);
%     EO = ~BW1 - ~BW2;
%     ET = ~BW2 - ~BW1;
    num1 = nnz(EO);
    num2 = nnz(ET);
    
%     subplot(121); imshow(~EO);
%     subplot(122); imshow(~ET);
    
    h = imhist(BW1);
    Count = imhist(BW2);
    
    EulerDistance = sqrt(sum((h - Count) .* (h - Count)));
    EulerDistance2 = sqrt(sum((Count - h) .* (Count - h)));
    dk = EulerDistance;
    if dk < maxdist
        d = dk;
    else
        d = Dmax;
    end
    
    distance_eo = Dmax;
    distance_et = Dmax;
    
    EMM = 1 - (nnz(~standardImage & ~segmentedImage) / ...
                (nnz(~standardImage & ~segmentedImage) + ...
                w*(abs(num1*distance_eo) + alpha * abs(num2*distance_et))));
end


