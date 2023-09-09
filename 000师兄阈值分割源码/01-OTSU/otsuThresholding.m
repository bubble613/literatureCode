function [finalThreshold] = otsuThresholding(Histogram)
% 函数说明：利用OTSU法对直方图进行阈值选择
% 参数说明：
%   Histogram：归一化直方图
% 返回值说明：
%   finalThreshold：最佳阈值
%----------------------------------------------------------------------------------

% 调用示例：[finalThreshold] = otsuThresholding(Histogram)

    % 1、OTSU法（此处采用累加的方法）
    wk = 0;
    uk = 0;
    L = length(Histogram);
    uT = sum((0 : L - 1) .* Histogram);

    for k = 1 : L
        wk = wk + Histogram(k);
        uk = uk + (k - 1) * Histogram(k);
        eta(k) = (wk * uT - uk)^2 / (wk * (1 - wk));
    end

    % 2、得出对应最大值的索引-1即为所求阈值
    [maxValue, threshold] = max(eta);
    finalThreshold = threshold - 1;
    disp([maxValue, finalThreshold]);

    % 3、绘制并展示图像
    %   3.1、为了便于观察eta值构成的曲线，将eta的值进行了归一化[0,1]
    etaNormal = (eta - min(eta)) ./ (max(eta) - min(eta));
    
    %   3.2、为了便于观察灰度值出现的频率构成的曲线（灰度直方图），将Histogram值进行了归一化[0,1]
    frequencyNormal = (Histogram - min(Histogram)) ./ (max(Histogram) - min(Histogram));

    figure, hold on,
    plot(0 : (L - 1), etaNormal(:), '-r'),
    plot([finalThreshold, finalThreshold],[0.0 1.0],'r-.'),  % 标记处计算的阈值的位置
    plot(0 : (L - 1), frequencyNormal),
    xlim([0  (L - 1)]),
    title('类间方差变化曲线及其最优阈值'),
    text(finalThreshold, 0.5, ['\leftarrow' num2str(finalThreshold)], 'HorizontalAlignment', 'left'),
    hold off;
end