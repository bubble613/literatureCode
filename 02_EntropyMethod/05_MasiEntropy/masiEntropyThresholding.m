function [finalThreshold] = masiEntropyThresholding(r, Histogram)
%{
函数说明： 利用Tsallis熵对灰度图的直方图进行阈值选择
函数参数：
        q：Tsallis熵参数
        Histogram：归一化直方图
函数返回值：
        finalThreshold：Tsallis熵阈值化的最佳阈值
-----------------------------------------------------------------------------
调用实例：
        [finalThreshold] = tsallisEntropyThresholding(q, Histogram)；
%}
    % 1 去除直方图前后为0的像素点
    L = length(Histogram);
    for i = 1 : L
        if Histogram(i) ~= 0
            startLevel = i - 1;
            break;
        end
    end
    for i = L : -1 : 1
        if Histogram(i) ~= 0
            endLevel = i - 1;
            break;
        end
    end
    
    % 2 遍历可能的阈值点
    for i = startLevel : endLevel - 1
       
        % 2.1 计算目标类的熵
        w0 = sum(Histogram(startLevel + 1 : i + 1));
        Er0 = log(1 - (1 - r) * sum((Histogram(startLevel + 1 : i + 1) / w0) .* log(Histogram(startLevel + 1 : i + 1) / w0))) / (1 - r);
        Er0(isnan(Er0)) = 0;
        % 2.2 计算背景类的熵
        w1 = sum(Histogram(i + 2 : endLevel + 1));
        Er1 = log(1 - (1 - r) * sum((Histogram(i + 2 : endLevel + 1) / w1) .* log(Histogram(i + 2 : endLevel + 1) / w1))) / (1 - r);
        Er1(isnan(Er1)) = 0;

        % 2.3 保存当前阈值下的最大熵值
        entropyTotalTemp(i - startLevel + 1) = Er0 + Er1;
        
    end
    
    % 3 得到最大熵值所对应的索引， -1为所求阈值
    [maxValue, threshold] = max(entropyTotalTemp);
    finalThreshold = startLevel + threshold - 1;
    disp([maxValue, finalThreshold]);
    
    entropyTotal(1 : L) = 0;
    entropyTotal(startLevel + 1 : endLevel) = entropyTotalTemp;
    
    
    % 4 绘制函数曲线并展示结果
    % 4.1 为了方便观察entropyTotal值构成的曲线，将entropyTotal的值进行归一化处理
    entropyTotalNormal = (entropyTotal - min(entropyTotal)) ./ (max(entropyTotal) - min(entropyTotal));
    
    % 4.2 为了便于观察灰度值出现的频率构成的曲线（灰度直方图），将frequency值进行归一化处理
    frequencyNormal = (Histogram - min(Histogram)) ./ (max(Histogram) - min(Histogram));
    
    figure, hold on,
    plot(0 : (L - 1), entropyTotalNormal(:), 'r-'),
    plot([finalThreshold, finalThreshold], [0.0, 1.0], 'r-.'),
    plot(0 : (L - 1), frequencyNormal, 'b:'),
    xlim([0 (L - 1)]),
    title('Masi熵变化曲线及最优阈值'),
    text(finalThreshold, 0.5, ['\leftarrow' num2str(finalThreshold)], 'HorizontalAlignment', 'left'),
    hold off;

end