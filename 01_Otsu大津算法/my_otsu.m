function [level] = my_otsu(I)

if ~isempty(I)
    img = I;

    [m, n] = size(img);

    %counts为图片总像素个数值
    counts = m * n;

    %count是一个256行一列的矩阵 记录了每个灰度级上像素点的个数
    count = imhist(img);

    %每个灰度级上像素点占总像素点数量的比例（概率）
    p = count / counts;

    %cumsum 计算累加概率 w(k)
    w0 = cumsum(p);

    %mu 计算的是平均灰度  比如灰度级为0~125的平均灰度值
    %(1:256)' 矩阵转置 1行256列转换为256行1列
    mu = cumsum(p .* (1:256)');

    %mu_end是全局平均灰度
    mu_end = mu(end);

    %d 求方差 d是256行一列的矩阵
    d = ((w0 * mu_end - mu).^2) ./ (w0 .* (1 - w0));

    %在d中寻找为最大方差的灰度值 这里y是最大方差的灰度值
    [level, y] = max(d);

    %为了和im2bw配合使用 进行归一化
    %x为所得阈值
    level = (y - 1) / 255;
    
end



