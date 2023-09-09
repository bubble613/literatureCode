function [finalThreshold] = relatedEntropyThresholding(Histogram)
%{
函数说明： 利用相关熵对灰度图的直方图进行阈值选择
函数参数：
        
        Histogram：归一化直方图
函数返回值：
        finalThreshold：相关熵阈值化的最佳阈值
-----------------------------------------------------------------------------
调用实例：
        [finalThreshold] = relatedEntropyThresholding(Histogram);
%}

    % 1 去除直方图中前后为0的像素点
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
    
    % GA = Histogram;
    % GB = Histogram;
    GA = zeros(256, 1);
    GB = zeros(256, 1);
    GA = double(GA);
    GB = double(GB);
    P1 = zeros(256, 1);
    P2 = ones(256, 1);
    P1 = double(P1);
    P2 = double(P2);
    % 2 遍历可能的阈值点
    for i = startLevel : endLevel - 1
        % 2.1 计算目标类的熵值
        PA = sum(Histogram(startLevel + 1 : i + 1));
        PA1 = sum(power(Histogram(startLevel + 1 : i + 1), 2));
        CATemp = log(sum(power((Histogram(startLevel + 1 : i + 1) / PA), 2)));
        CATemp(isnan(CATemp)) = 0;
        CATemp(isinf(CATemp)) = 0;
        CA = - sum(CATemp);

        % 2.2 计算背景类的熵值
        PB = 1 - PA;
        PB1 = sum(power(Histogram(i + 2 : endLevel + 1), 2));
        CBTemp = log(sum(power((Histogram(i + 2 : endLevel + 1) / PB), 2)));
        CBTemp(isnan(CBTemp)) = 0;
        CBTemp(isinf(CBTemp)) = 0;
        CB = - sum(CBTemp);
        
        GA(i + 1, 1) = PA1;
        GB(i + 1, 1) = PB1;
        P1(i + 1, 1) = PA;
        P2(i + 1, 1) = PB;
        % 2.3 保存当前阈值下的最大熵值
        entropyTotalTemp(i - startLevel + 1) = CA + CB;
        
    end
    
    % TC = -(log(GA .* GB)) + 2 * log(PA .* PB);
        
    % 3 求出对应的最大熵值的索引，-1后即为所求阈值
    [maxValue, threshold] = max(entropyTotalTemp);
    finalThreshold = startLevel + threshold - 1;
    disp([maxValue, finalThreshold]);
    
    entropyTotal(1 : L) = 0;
    entropyTotal(startLevel + 1 : endLevel) = entropyTotalTemp;
    
    % 4 绘制并展示图像及其相关细节
    % 4.1 为了便于观察entropyTotal值构成的曲线，将entropyTotal的值进行了归一化[0,1]
    entropyTotalNormal = (entropyTotal - min(entropyTotal)) ./ (max(entropyTotal) - min(entropyTotal));
    
    % 4.2 为了便于观察灰度值出现的频率构成的曲线（灰度直方图），将frequency值进行了归一化[0,1]
    frequencyNormal = (Histogram - min(Histogram)) ./ (max(Histogram) - min(Histogram));

    figure,hold on,
    plot(0 : (L - 1), entropyTotalNormal(:), '-r'),
    plot([finalThreshold, finalThreshold],[0.0 1.0], 'r-.'),  % 标记处计算的阈值的位置，注意此处的阈值是按MATLAB中加1的
    plot(0 : (L - 1), frequencyNormal),  % 显示归一化的图像直方图
    xlim([0 (L - 1)]),
    title('相关熵值变化曲线及其最优阈值'),
    text(finalThreshold, 0.5, ['\leftarrow' num2str(finalThreshold)], 'HorizontalAlignment', 'left'),
    hold off;
    
end
