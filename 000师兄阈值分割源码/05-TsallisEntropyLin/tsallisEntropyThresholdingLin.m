function [finalThreshold] = tsallisEntropyThresholdingLin(q, Histogram)
% 函数说明：利用Lin改进的Tsallis Entropy阈值选择标准对直方图进行阈值选择
% 参数说明：
%   q：Tsallis熵熵参数
%   Histogram：归一化直方图
% 返回值说明：
%   finalThreshold：最佳阈值
%----------------------------------------------------------------------------------

% 调用示例：[finalThreshold] = tsallisEntropyThresholdingLin(q, Histogram)

    % 1、去除直方图前后为0的像素点
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
    
    % 2、遍历可能的阈值点
    for i = startLevel : endLevel - 1
        
        %   2.1、计算目标类的熵值
        PA = sum(Histogram(startLevel + 1 : i + 1));
        HA = (1 - sum(power(Histogram(startLevel + 1 : i + 1) / PA, q))) / (q - 1);
        
        %   2.2、计算背景类的熵值
        PB = 1 - PA;
        HB = (1 - sum(power(Histogram(i + 2 : endLevel + 1) / PB, q))) / (q - 1);
        
        %   2.3、保存当前阈值下的最大熵值
        if HA < HB
            HAB = HA;
        else
            HAB = HB;
        end
        entropyTotalTemp(i - startLevel + 1) = HAB;

    end

     % 3、得出对应最大熵值的索引-1即为所求阈值
    [maxValue, threshold] = max(entropyTotalTemp);
    finalThreshold = startLevel + threshold - 1;
    disp([maxValue, finalThreshold]);
    
    entropyTotal(1 : L) = 0;
    entropyTotal(startLevel + 1 : endLevel) = entropyTotalTemp;

    % 4、绘制并展示图像
    %   4.1、为了便于观察entropyTotal值构成的曲线，将entropyTotal的值进行了归一化[0,1]
    entropyTotalNormal = (entropyTotal - min(entropyTotal)) ./ (max(entropyTotal) - min(entropyTotal));
    
    %   4.2、为了便于观察灰度值出现的频率构成的曲线（灰度直方图），将frequency值进行了归一化[0,1]
    frequencyNormal = (Histogram - min(Histogram)) ./ (max(Histogram) - min(Histogram));

    figure,hold on,
    plot(0 : (L - 1), entropyTotalNormal(:), '-r'),
    plot([finalThreshold, finalThreshold],[0.0 1.0], 'r-.'),  % 标记处计算的阈值的位置，注意此处的阈值是按MATLAB中加1的
    plot(0 : (L - 1), frequencyNormal),  % 显示归一化的图像直方图
    xlim([0 (L - 1)]),
    title('Lin改进的Tsallis熵变化曲线及其最优阈值'),
    text(finalThreshold, 0.5, ['\leftarrow' num2str(finalThreshold)], 'HorizontalAlignment', 'left'),
    hold off;
end
