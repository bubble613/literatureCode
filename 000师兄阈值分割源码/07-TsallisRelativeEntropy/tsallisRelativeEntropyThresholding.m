function [finalThreshold] = tsallisRelativeEntropyThresholding(q, Histogram)

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
        PB = 1 - PA;
        
        miuA = sum((startLevel + 1 : i + 1) .* Histogram(startLevel + 1 : i + 1)) / PA;
        miuB = sum((i + 2 : endLevel + 1) .* Histogram(i + 2 : endLevel + 1)) / PB;
        
        sigmaA = sum(power((startLevel + 1 : i + 1) - miuA, 2)) / PA;
        sigmaB = sum(power((i + 2 : endLevel + 1) - miuB, 2)) / PB;
        
        for j = 0 : L - 1
           pA(j + 1) = exp(power((j - miuA), 2) / (-2 * sigmaA + eps)) / sqrt(2 * pi * sigmaA + eps);
           pB(j + 1) = exp(power((j - miuB), 2) / (-2 * sigmaB + eps)) / sqrt(2 * pi * sigmaB + eps);
        end
        
        r = (PA .* pA(:) + PB .* pB(:)) ./ sum(PA .* pA(:) + PB .* pB(:));

        J(i - startLevel + 1) = (sum(Histogram(:) .* power((r(:) ./ (Histogram(:) + eps)), q) + r(:) .* power((Histogram(:) ./ (r(:) + eps)), q)) - 2) / (q - 1);

    end

    % 对应最大熵的索引-1即为所求阈值
    [minValue, threshold] = min(J);
    finalThreshold = startLevel + threshold - 1;
    disp([minValue, finalThreshold]);
    
    entropyTotal(1 : L) = max(J);
    entropyTotal(startLevel + 1 : endLevel) = J;

    % 为了便于观察entropyTotal值构成的曲线，将entropyTotal的值进行了归一化[0,1]
    entropyTotalNormal = (entropyTotal - min(entropyTotal)) ./ (max(entropyTotal) - min(entropyTotal));

    % 为了便于观察灰度值出现的频率构成的曲线（灰度直方图），将frequency值进行了归一化[0,1]
    frequencyNormal = (Histogram - min(Histogram)) ./ (max(Histogram) - min(Histogram));

    figure,hold on,
    plot(0 : L - 1, entropyTotalNormal(:), '-r'),
    plot([finalThreshold, finalThreshold],[0.0 1.0], 'r-.'),  % 标记处计算的阈值的位置，注意此处的阈值是按MATLAB中加1的
    plot(0 : L - 1, frequencyNormal),  % 显示归一化的图像直方图
    xlim([0 L - 1]),
    title('Tsallis相对熵变化曲线及其最优阈值'),
    text(finalThreshold, 0.5, ['\leftarrow' num2str(finalThreshold)], 'HorizontalAlignment', 'left'),
    hold off;
end
