function [finalThreshold] = TsallisHavrdaCharvatentropyThresholding(q, Histogram)
% �����Ի���ֱ��ͼ����������Renyi�ؽ��м�����ֵ
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
        % tsallis��
        PB = 1 - PA;
        HB = (1 - sum(power(Histogram(i + 2 : endLevel + 1) / PB, q))) / (1 - power(2, (1 - q)));
        entropyTotalTemp(i - startLevel + 1) = HA + HB + (1 - q) * HA * HB;

    end

    % ��Ӧ����ص�����-1��Ϊ������ֵ
    [maxValue, threshold] = max(entropyTotalTemp);
    finalThreshold = startLevel + threshold - 1;
    disp([maxValue, finalThreshold]);
    
    entropyTotal(1 : L) = 0;
    entropyTotal(startLevel + 1 : endLevel) = entropyTotalTemp;

    % Ϊ�˱��ڹ۲�entropyTotalֵ���ɵ����ߣ���entropyTotal��ֵ�����˹�һ��[0,1]
    entropyTotalNormal = (entropyTotal - min(entropyTotal)) ./ (max(entropyTotal) - min(entropyTotal));

    % Ϊ�˱��ڹ۲�Ҷ�ֵ���ֵ�Ƶ�ʹ��ɵ����ߣ��Ҷ�ֱ��ͼ������frequencyֵ�����˹�һ��[0,1]
    frequencyNormal = (Histogram - min(Histogram)) ./ (max(Histogram) - min(Histogram));

    figure,hold on,
    plot(0 : 255, entropyTotalNormal(:), '-r'),
    plot([finalThreshold, finalThreshold],[0.0 1.0], 'r-.'),  % ��Ǵ��������ֵ��λ�ã�ע��˴�����ֵ�ǰ�MATLAB�м�1��
    plot(0 : 255, frequencyNormal),  % ��ʾ��һ����ͼ��ֱ��ͼ
    xlim([0 255]),
    title('Tsallis�ر仯���߼���������ֵ'),
    text(finalThreshold, 0.5, ['\leftarrow' num2str(finalThreshold)], 'HorizontalAlignment', 'left'),
    hold off;
end
