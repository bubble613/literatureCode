function [finalThreshold] = sharmaMittalEntropyThresholding(r, q, Histogram)
% 函数说明：利用Sharama-Mittal Entropy对直方图进行阈值选择
% 参数说明：
%   r：Sharama-Mittal Entropy参数之一
%   q：Sharama-Mittal Entropy参数之一
%   Histogram：线性化直方图
% 返回值说明：
%   finalThreshold：最佳阈值
%----------------------------------------------------------------------------------

% 调用示例：[finalThreshold] = sharmaMittalEntropyThresholding(r, q, Histogram)

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

    % 2、根据参数的不同选择不同的分割标准
    %   2.1、如果r = q = 1，Sharma-Mittal Entropy转变为香农熵进行图像分割
    if(r == 1 && q == 1)
        finalThreshold = shannonEntropyThresholding(Histogram);
    %   2.2、如果r = 1，Sharma-Mittal Entropy转变为Renyi熵进行图像分割
    elseif(r == 1)
        finalThreshold = renyiEntropyThresholding(q, Histogram);
    %   2.3、如果r = q，Sharma-Mittal Entropy转变为Tsallis熵进行图像分割
    elseif(r == q)
        finalThreshold = tsallisEntropyThresholding(q, Histogram);
    %   2.4、最后，r != q != 1则是用的Sharma-Mittal Entropy进行图像分割
    else
        % 3、遍历可能的阈值点
        for i = startLevel : endLevel - 1
            PA = sum(Histogram(startLevel + 1 : i + 1));
            HA = (power(sum(power(Histogram(startLevel + 1 : i + 1) ./ PA, q)), ((1 - r) / (1 - q))) - 1) / (1 - r);

            PB = 1 - PA;
            HB = (power(sum(power(Histogram(i + 2 : endLevel + 1) ./ PB, q)), ((1 - r) / (1 - q))) - 1) / (1 - r);
            
            %   3.1、保存当前阈值下的最大熵
            entropyTotalTemp(i - startLevel + 1) = HA + HB + (1 - r) * HA * HB;
        end

        % 4、得出对应最大熵值的索引-1即为所求阈值
        [maxValue, threshold] = max(entropyTotalTemp);
        finalThreshold = startLevel + threshold - 1;
        disp([maxValue, finalThreshold]);

        entropyTotal(1 : L) = 0;
        entropyTotal(startLevel + 1 : endLevel) = entropyTotalTemp;

        % 6、绘制并展示图像
        %   6.1、为了便于观察entropyTotal值构成的曲线，将entropyTotal的值进行了归一化[0,1]
        entropyTotalNormal = (entropyTotal - min(entropyTotal)) ./ (max(entropyTotal) - min(entropyTotal));

        %   6.2、为了便于观察灰度值出现的频率构成的曲线（灰度直方图），将frequency值进行了归一化[0,1]
        frequencyNormal = (Histogram - min(Histogram)) ./ (max(Histogram) - min(Histogram));

        figure,hold on,
        plot(0 : (L - 1), entropyTotalNormal(:), '-r'),
        plot([finalThreshold, finalThreshold],[0.0 1.0], 'r-.'),  % 标记处计算的阈值的位置，注意此处的阈值是按MATLAB中加1的
        plot(0 : (L - 1), frequencyNormal),  % 显示归一化的图像直方图
        xlim([0 (L - 1)]),
        title('Sharma-Mittal Entropy值变化曲线及其最优阈值'),
        text(finalThreshold, 0.5, ['\leftarrow' num2str(finalThreshold)], 'HorizontalAlignment', 'left'),
        hold off;
    end
end
