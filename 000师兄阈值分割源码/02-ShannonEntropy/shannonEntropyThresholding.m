function [finalThreshold] = shannonEntropyThresholding(Histogram)
% ����˵��������Shannon Entropy��ֱ��ͼ������ֵѡ��
% ����˵����
%   Histogram����һ��ֱ��ͼ
% ����ֵ˵����
%   finalThreshold�������ֵ
%----------------------------------------------------------------------------------

% ����ʾ����[finalThreshold] = shannonEntropyThresholding(Histogram)

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
        HATemp = (Histogram(startLevel + 1 : i + 1) / PA) .* log(Histogram(startLevel + 1 : i + 1) / PA);
        HATemp(isnan(HATemp)) = 0;
        HATemp(isinf(HATemp)) = 0;
        HA = - sum(HATemp);
        
        %   2.2�����㱳�������ֵ
        PB = 1 - PA;
        HBTemp = (Histogram(i + 2 : endLevel + 1) / PB) .* log(Histogram(i + 2 : endLevel + 1) / PB);
        HBTemp(isnan(HBTemp)) = 0;
        HBTemp(isinf(HBTemp)) = 0;
        HB = - sum(HBTemp);
        
        %   2.3�����浱ǰ��ֵ�µ������ֵ
        entropyTotalTemp(i - startLevel + 1) = HA + HB;
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
    title('��ũ��ֵ�仯���߼���������ֵ'),
    text(finalThreshold, 0.5, ['\leftarrow' num2str(finalThreshold)], 'HorizontalAlignment', 'left'),
    hold off;
end