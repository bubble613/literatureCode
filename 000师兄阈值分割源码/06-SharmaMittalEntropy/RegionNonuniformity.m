function [NU] = RegionNonuniformity(originImage, resultImage)
% 函数说明：计算分割图像的区域不均匀性
% 参数说明：
%   originImage：原始图像
%   resultImage：二值图像
% 返回值说明：
%   NU：区域不均匀程度
%----------------------------------------------------------------------------------

% 调用示例：[NU] = RegionNonuniformity(originImage, resultImage)

    % 1、取反操作（这个操作并非一定要，要看前景图像是由白色像素点还是黑色像素点组成的，黑色的则要取反）
    resultImage = ~resultImage;
    % 2、为避免点乘操作的错误，预先转化为double类型数据
    originImage = im2double(originImage);
    resultImage = im2double(resultImage);
    % 3、计算前景和背景像素点数目
    FT_num = nnz(resultImage);
    BT_num = nnz(~resultImage);
    % 4、计算整体图像的标准差
    sigma = std2(originImage);
    % 5、计算前景图像
    foregroundImage = originImage .* resultImage;
    % 6、计算前景图像的标准差
    foregroundImage(find(foregroundImage == 0)) = [];
    sigma_f = std(foregroundImage);
    % 7、计算区域的不均匀程度
    NU = (FT_num / (FT_num + BT_num)) * power(sigma_f, 2) / power(sigma, 2);
end

