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

    % ��Ӧ����ص�����-1��Ϊ������ֵ
    [minValue, threshold] = min(J);
    finalThreshold = startLevel + threshold - 1;
    disp([minValue, finalThreshold]);
    
    entropyTotal(1 : L) = max(J);
    entropyTotal(startLevel + 1 : endLevel) = J;

    % Ϊ�˱��ڹ۲�entropyTotalֵ���ɵ����ߣ���entropyTotal��ֵ�����˹�һ��[0,1]
    entropyTotalNormal = (entropyTotal - min(entropyTotal)) ./ (max(entropyTotal) - min(entropyTotal));

    % Ϊ�˱��ڹ۲�Ҷ�ֵ���ֵ�Ƶ�ʹ��ɵ����ߣ��Ҷ�ֱ��ͼ������frequencyֵ�����˹�һ��[0,1]
    frequencyNormal = (Histogram - min(Histogram)) ./ (max(Histogram) - min(Histogram));

    figure,hold on,
    plot(0 : L - 1, entropyTotalNormal(:), '-r'),
    plot([finalThreshold, finalThreshold],[0.0 1.0], 'r-.'),  % ��Ǵ��������ֵ��λ�ã�ע��˴�����ֵ�ǰ�MATLAB�м�1��
    plot(0 : L - 1, frequencyNormal),  % ��ʾ��һ����ͼ��ֱ��ͼ
    xlim([0 L - 1]),
    title('Tsallis����ر仯���߼���������ֵ'),
    text(finalThreshold, 0.5, ['\leftarrow' num2str(finalThreshold)], 'HorizontalAlignment', 'left'),
    hold off;
end
