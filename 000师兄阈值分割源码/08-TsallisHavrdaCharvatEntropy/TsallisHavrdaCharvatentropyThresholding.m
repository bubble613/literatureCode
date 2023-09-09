function [finalThreshold] = TsallisHavrdaCharvatentropyThresholding(q, Histogram)
% 从线性化的直方图出发，利用Renyi熵进行计算阈值
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
    
    for i = startLevel : endLevel - 1
        PA = sum(Histogram(startLevel + 1 : i + 1));
        HA = (1 - sum(power(Histogram(startLevel + 1 : i + 1) / PA, q))) / (1 - power(2, (1 - q)));
        % HA = (1 - sum(power(Histogram(startLevel + 1 : i + 1) / PA, q))) / (q - 1);
        % tsallis熵
        PB = 1 - PA;
        HB = (1 - sum(power(Histogram(i + 2 : endLevel + 1) / PB, q))) / (1 - power(2, (1 - q)));
        entropyTotalTemp(i - startLevel + 1) = HA + HB + (1 - q) * HA * HB;

    end

    % 对应最大熵的索引-1即为所求阈值
    [maxValue, threshold] = max(entropyTotalTemp);
    finalThreshold = startLevel + threshold - 1;
    disp([maxValue, finalThreshold]);
    
    entropyTotal(1 : L) = 0;
    entropyTotal(startLevel + 1 : endLevel) = entropyTotalTemp;

    % 为了便于观察entropyTotal值构成的曲线，将entropyTotal的值进行了归一化[0,1]
    entropyTotalNormal = (entropyTotal - min(entropyTotal)) ./ (max(entropyTotal) - min(entropyTotal));

    % 为了便于观察灰度值出现的频率构成的曲线（灰度直方图），将frequency值进行了归一化[0,1]
    frequencyNormal = (Histogram - min(Histogram)) ./ (max(Histogram) - min(Histogram));

    figure,hold on,
    plot(0 : 255, entropyTotalNormal(:), '-r'),
    plot([finalThreshold, finalThreshold],[0.0 1.0], 'r-.'),  % 标记处计算的阈值的位置，注意此处的阈值是按MATLAB中加1的
    plot(0 : 255, frequencyNormal),  % 显示归一化的图像直方图
    xlim([0 255]),
    title('Tsallis熵变化曲线及其最优阈值'),
    text(finalThreshold, 0.5, ['\leftarrow' num2str(finalThreshold)], 'HorizontalAlignment', 'left'),
    hold off;
end
