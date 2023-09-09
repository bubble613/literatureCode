function [finalThreshold] = myOtsu(Histogram)
%{
函数说明： 使用Otsu方法对直方图进行阈值选择函数
参数说明： 
	Histogram：待处理的二值图像直方图
返回值说明：
    finalThreshold：得到的阈值
---------------------------------------------------------------------------

调用示例：[finalThreshold] = otsuThresholding(Histogram)
%}
    % 1 Otsu方法（此处使用的为累加的方法）
    wk = 0;
    muk = 0;
    L = length(Histogram);
    muT = sum((0 : L - 1) .* Histogram);
    w1 = 0;
    w2 = 0;
    mu1 = 0;
    mu2 = 0;

    for k = 1 : L
        wk = wk + Histogram(k);
        muk = muk + (k - 1) * Histogram(k);
        sigma_B(k) = (muT * wk - muk)^2 / (wk * (1 - wk));
        
    end
    
    for i = 1:L
        for k = 1:i
            w1 = w1 + Histogram(k);
            mu1 = mu1 + (k - 1) * Histogram(k);
            % mu2 = mu2 + (L - k + 1) * Histogram(k + 1);
        end
        for k = L:-1:i+1
            w2 = w2 + Histogram(k);
            mu2 = mu2 + (k - 1) * Histogram(k);
        end
        k_opt(i) = power(mu1, 2) + power(mu2, 2);
    end
    [maxValue1, threshold1] = max(k_opt);
    
    % 2 找到对应sigmaB的最大值索引减去1 即为所求阈值
    [maxValue, threshold] = max(sigma_B);
    finalThreshold = threshold - 1;
    disp([maxValue, threshold]);

    % 3 绘制目标函数图像，图像直方图
    % 3.1 为了便于观察sigmaB所构成的曲线（目标函数曲线），对sigmaB的值进行归一化处理
    sigmaB_Normal = (sigma_B - min(sigma_B)) ./ (max(sigma_B) - min(sigma_B));

    % 3.2 为了便于观察灰度值出现的频率构成的曲线（灰度直方图），将Histogram值进行了归一化[0,1]
    % 可能有问题
    frequencyNormal = (Histogram - min(Histogram)) ./ (max(Histogram) - min(Histogram));

    figure, hold on,
    plot(0 : (L - 1), sigmaB_Normal(:), 'r-'),
    plot([finalThreshold, finalThreshold], [0.0 1.0], 'r-.'),% 标记计算的阈值的位置
    plot(0 : (L - 1), frequencyNormal),
    xlim([0 (L - 1)]),
    title('类间方差变化曲线及其最优阈值'),
    text(finalThreshold, 0.5, ['\leftarrow' num2str(finalThreshold)], 'HorizontalAlignment', 'left'),
    hold off;
end
