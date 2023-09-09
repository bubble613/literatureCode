function [Qe] = Q(originImage, resultImage)
% 函数说明：Q法评估分割图像的质量
% 参数说明：
%   originImage：原始图像
%   resultImage：二值图像
% 返回值说明：
%   Q：评估值，值越小越好。
%----------------------------------------------------------------------------------

% 调用示例：[Qe] = Q(originImage, resultImage)
    
    % 1、计算图像的大小，并调整图像数据类型
    [M, N] = size(originImage);
    maxValue = max(max(originImage));
    originImage = im2double(originImage);
    resultImage = im2double(resultImage);
    originImage = originImage * double(maxValue);
    
    % 2、计算前景和背景图像
    foregroundImage = originImage .* resultImage;
    backgroundImage = originImage .* ~resultImage;
    
    % 3、计算前景和背景图像的像素个数
    foregroundImage_size = nnz(resultImage);
    backgroundImage_size = nnz(~resultImage);
    
    % 4、计算前景和背景图像的总的灰度像素值
    foregroundImage_value_sum = sum(sum(foregroundImage));
    backgroundImage_value_sum = sum(sum(backgroundImage));
    
    % 5、计算前景和背景图像的灰度均值
    foregroundImage_value_average = foregroundImage_value_sum / foregroundImage_size;
    backgroundImage_value_average = backgroundImage_value_sum / backgroundImage_size;
    
    % 6、计算前景和背景图像的均值矩阵
    foregroundImage_average_matrix = resultImage .* foregroundImage_value_average;
    backgroundImage_average_matrix = ~resultImage .* backgroundImage_value_average;
    
    % 7、计算前景和背景图像的差值矩阵
    foregroundImage_diff_matrix = foregroundImage - foregroundImage_average_matrix;
    backgroundImage_diff_matrix = backgroundImage - backgroundImage_average_matrix;
    
    % 8、计算前景和背景图像的平方颜色误差
    e1_2 = sum(sum(power(foregroundImage_diff_matrix, 2)));
    e2_2 = sum(sum(power(backgroundImage_diff_matrix, 2)));
    
    % 9、给定RAi的值，实际上要做判断才能得出
    RA1 = 1;
    RA2 = 1;
    
    % 10、计算Q值
    Qe = (sqrt(2) / (N * M)) * ((e1_2 / (1 + log(foregroundImage_size)) + power((RA1 / foregroundImage_size), 2)) + (e2_2 / (1 + log(backgroundImage_size)) + power((RA2 / backgroundImage_size), 2)));
end

