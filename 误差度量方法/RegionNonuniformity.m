function [NU] = RegionNonuniformity(originImage, resultImage)
% 函数说明：计算分割图像的区域不均匀性
% 参数说明： originImage：原始图像
%           resultImage：分割后的二值图像
% 返回值:
%           NU:区域不均匀程度
%-----------------------------------------------------------------------------

% 调用实例：NU = RegionNonuniformity(originImage, resultImage)

    % 取反操作（注意此操作不一定要执行，要根据前景（目标像素）像素为白色或黑色来判断，如果为黑色则要取反操作）
    resultImage = ~resultImage;
    % 为避免点乘操作出现误差，先将数据类型变为double
    originImage = im2double(originImage);
    resultImage = im2double(resultImage);
    % 计算前景（目标）和背景像素的个数
    FT_num = nnz(resultImage);
    BT_num = nnz(~resultImage);
    % 计算整幅图像的标准差
    sigma = std2(originImage);
    % 计算前景图像
    foregroundImage = originImage .* resultImage;
    % 计算前景图像标准差
    % 操作分割出来的前景图像，将其为0的像素设置为空数组，方便计算矩阵的标准差
    foregroundImage(find(foregroundImage == 0)) = []; 
    sigma_f = std(foregroundImage);
    % 计算区域的不均匀程度
    NU = (FT_num / (FT_num + BT_num)) * power(sigma_f, 2) / power(sigma, 2);

end