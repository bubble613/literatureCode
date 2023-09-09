function [finalThreshold] = tsallisEntropyThresholding(q, Histogram)
% ����˵��������Tsallis Entropy��ֱ��ͼ������ֵѡ��
% ����˵����
%   q��Tsallis���ز���
%   Histogram����һ��ֱ��ͼ
% ����ֵ˵����
%   finalThreshold�������ֵ
%----------------------------------------------------------------------------------

% ����ʾ����[finalThreshold] = tsallisEntropyThresholding(q, Histogram)

    % 1��ȥ��ֱ��ͼǰ��Ϊ0�����ص�
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
    
    % 2���������ܵ���ֵ��
    for i = startLevel : endLevel - 1
        
        %   2.1������Ŀ�������ֵ
        PA = sum(Histogram(startLevel + 1 : i + 1));
        HA = (1 - sum(power(Histogram(startLevel + 1 : i + 1) / PA, q))) / (q - 1);
        
        %   2.2�����㱳�������ֵ
        PB = 1 - PA;
        HB = (1 - sum(power(Histogram(i + 2 : endLevel + 1) / PB, q))) / (q - 1);
        
        %   2.3�����浱ǰ��ֵ�µ������ֵ
        entropyTotalTemp(i - startLevel + 1) = HA + HB + (1 - q) * HA * HB;
    end

    % 3���ó���Ӧ�����ֵ������-1��Ϊ������ֵ
    [maxValue, threshold] = max(entropyTotalTemp);
    finalThreshold = startLevel + threshold - 1;
    disp([maxValue, finalThreshold]);
    
    entropyTotal(1 : L) = 0;
    entropyTotal(startLevel + 1 : endLevel) = entropyTotalTemp;

    % 4�����Ʋ�չʾͼ��
    %   4.1��Ϊ�˱��ڹ۲�entropyTotalֵ���ɵ����ߣ���entropyTotal��ֵ�����˹�һ��[0,1]
    entropyTotalNormal = (entropyTotal - min(entropyTotal)) ./ (max(entropyTotal) - min(entropyTotal));

    %   4.2��Ϊ�˱��ڹ۲�Ҷ�ֵ���ֵ�Ƶ�ʹ��ɵ����ߣ��Ҷ�ֱ��ͼ������frequencyֵ�����˹�һ��[0,1]
    frequencyNormal = (Histogram - min(Histogram)) ./ (max(Histogram) - min(Histogram));

    figure,hold on,
    plot(0 : (L - 1), entropyTotalNormal(:), '-r'),
    plot([finalThreshold, finalThreshold],[0.0 1.0], 'r-.'),  % ��Ǵ��������ֵ��λ�ã�ע��˴�����ֵ�ǰ�MATLAB�м�1��
    plot(0 : (L - 1), frequencyNormal),  % ��ʾ��һ����ͼ��ֱ��ͼ
    xlim([0 (L - 1)]),
    title('Tsallis�ر仯���߼���������ֵ'),
    text(finalThreshold, 0.5, ['\leftarrow' num2str(finalThreshold)], 'HorizontalAlignment', 'left'),
    hold off;
end
