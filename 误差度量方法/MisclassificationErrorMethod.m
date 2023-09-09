%% 
% [length, width] = size(img);
% tag1 = mod(length, 2);
% tag2 = mod(width, 2);
% if tag
%     me =
% else
%     me = 
% end


%% function MisclassificationError
% clc;clear;close;
% fig = imread('/Users/liwangyang/Desktop/matlab_doc/图片集/lena_std.tif');
% fig = im2double(fig);
[fileName,pathName] = uigetfile({'*.*';'*.jpg';'*.*'},'File Selector');
fileName = strcat(pathName,fileName);
standard = imread(fileName);

% figgray = im2gray(fig);
% otsu = graythresh(figgray);
% t_otsu = otsu * 255;
% standard = imbinarize(figgray);
segImage1 = binaryImg;
segImage2 = binaryImg2;
segImage3 = binaryImg3;

ME1 = MisclassificationError(standard, segImage1);
ME2 = MisclassificationError(standard, segImage2);
ME3 = MisclassificationError(standard, segImage3);

function [ME] = MisclassificationError(groundtruthImage, segmentedImage)
% 函数说明：Misclassification error (误分割错误）
% 参数说明：
%   groundtruthImage：原始图像 BO+FO
%   segmentedImage：分割好的图像（测试图像） 
% 返回值说明：
%   ME：误分割错误率
%----------------------------------------------------------------------------------

% 调用示例：[ME] = MisclassificationError(groundtruthImage, segmentedImage)
    ME = 1 - (nnz(~groundtruthImage & ~segmentedImage) + ...
        nnz(groundtruthImage & segmentedImage)) / numel(groundtruthImage);
end
%% 
% function [ME] = MisclassificationError(standardImage, segImage)
% % 函数说明：Misclassification error (误分割错误）
% % 参数说明：
% %   groundtruthImage：原始图像 BO+FO
% %   segmentedImage：分割好的图像（测试图像） 
% % 返回值说明：
% %   ME：误分割错误率
% %----------------------------------------------------------------------------------
% 
% % 调用示例：[ME] = MisclassificationError(groundtruthImage, segmentedImage)
%     ME = 1 - (nnz(~standardImage & ~segImage) + ...
%         nnz(standardImage & segImage)) / numel(standardImage);
%     [m, n] = size(segImage);
% end
