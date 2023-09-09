function [finalThreshold] = newProposedMethod02(q, Histogram)
% 函数说明：Tsallis Entropy结合领域谷点强调法优化01对直方图进行阈值分割
% 参数说明：
%   q：Tsallis Entropy熵参数
%   Histogram：线性化直方图
% 返回值说明：
%   finalThreshold：最佳阈值
%   HA：一分类最大熵值
%   HB：二分类最大熵值
%----------------------------------------------------------------------------------

% 调用示例：[finalThreshold, HA, HB] = newProposedMethod02(q, Histogram)

    % 1、去除直方图前后为0的像素点
    L = length(Histogram);
    wk = 0;
    uk = 0;
    uT = sum((0 : L - 1) .* Histogram);
    
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
        
        %   2.1、计算邻域内的谷点偏差
        if((i + 1) == 1)
            p = sum(Histogram(1 : 6));
        elseif ((i + 1) == 2)
            p = sum(Histogram(1 : 7));
        elseif ((i + 1) == 3)
            p = sum(Histogram(1 : 8));
        elseif ((i + 1) == 4)
            p = sum(Histogram(1 : 9));
        elseif ((i + 1) == 5)
            p = sum(Histogram(1 : 10));
        elseif ((i + 1) == 6)
            p = sum(Histogram(1 : 11));
        elseif ((i + 1) == 256)
            p = sum(Histogram(251 : 256));
        elseif ((i + 1) == 255)
            p = sum(Histogram(250 : 256));
        elseif ((i + 1) == 254)
            p = sum(Histogram(249 : 256));
        elseif ((i + 1) == 253)
            p = sum(Histogram(248 : 256));
        elseif ((i + 1) == 252)
            p = sum(Histogram(247 : 256));
        elseif ((i + 1) == 251)
            p = sum(Histogram(246 : 256));
        else
            p = sum(Histogram((i - 4) : (i + 6)));
        end
        
        %   2.2、OTSU标准计算其类内方差
        wk = wk + Histogram(i + 1);
        uk = uk + i * Histogram(i + 1);
        eta(i - startLevel + 1) = (wk * uT - uk)^2 / (wk * (1 - wk));
        
        %   2.3、Tsallis熵标准计算其最大Tsallis熵
        PA = sum(Histogram(startLevel + 1 : i + 1));
        HA = (1 - sum(power(Histogram(startLevel + 1 : i + 1) / PA, q))) / (q - 1);
        PB = 1 - PA;
        HB = (1 - sum(power(Histogram(i + 2 : endLevel + 1) / PB, q))) / (q - 1);
        
        %   2.4、谷点强调法优化01结合Tsallis熵
        entropyTotalTemp(i - startLevel + 1) = (HA + HB + (1 - q) * HA * HB) * ((1 - p) * eta(i - startLevel + 1));
    end

    % 3、得出对应最大熵值的索引-1即为所求阈值
    [maxValue, threshold] = max(entropyTotalTemp);
    finalThreshold = startLevel + threshold - 1;
    
    % 4、保存最佳阈值处两个类别的熵值
%     PA = sum(Histogram(startLevel + 1 : finalThreshold + 1));
%     HA = (1 - sum(power(Histogram(startLevel + 1 : finalThreshold + 1) / PA, q))) / (q - 1);
%     
%     PB = 1 - PA;
%     HB = (1 - sum(power(Histogram(finalThreshold + 2 : endLevel + 1) / PB, q))) / (q - 1);
    
    entropyTotal(1 : L) = 0;
    entropyTotal(startLevel + 1 : endLevel) = entropyTotalTemp;

    % 6、绘制并展示图像
    %   6.1、为了便于观察entropyTotal值构成的曲线，将entropyTotal的值进行了归一化[0,1]
    entropyTotalNormal = (entropyTotal - min(entropyTotal)) ./ (max(entropyTotal) - min(entropyTotal));

    %   6.2、为了便于观察灰度值出现的频率构成的曲线（灰度直方图），将frequency值进行了归一化[0,1]
    frequencyNormal = (Histogram - min(Histogram)) ./ (max(Histogram) - min(Histogram));

    figure,hold on,
    plot(0 : 255, entropyTotalNormal(:), '-r'),
    plot([finalThreshold, finalThreshold],[0.0 1.0], 'r-.'),  % 标记处计算的阈值的位置，注意此处的阈值是按MATLAB中加1的
    plot(0 : 255, frequencyNormal),  % 显示归一化的图像直方图
    xlim([0 255]),
    %title('Tsallis熵变化曲线及其最优阈值'),
    text(finalThreshold, 0.5, ['\leftarrow' num2str(finalThreshold)], 'HorizontalAlignment', 'left'),
    hold off;
end
