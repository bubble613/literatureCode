function [finalThreshold] = sharmaMittalEntropyThresholding(r, q, Histogram)
% ����˵��������Sharama-Mittal Entropy��ֱ��ͼ������ֵѡ��
% ����˵����
%   r��Sharama-Mittal Entropy����֮һ
%   q��Sharama-Mittal Entropy����֮һ
%   Histogram�����Ի�ֱ��ͼ
% ����ֵ˵����
%   finalThreshold�������ֵ
%----------------------------------------------------------------------------------

% ����ʾ����[finalThreshold] = sharmaMittalEntropyThresholding(r, q, Histogram)

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

    % 2�����ݲ����Ĳ�ͬѡ��ͬ�ķָ��׼
    %   2.1�����r = q = 1��Sharma-Mittal Entropyת��Ϊ��ũ�ؽ���ͼ��ָ�
    if(r == 1 && q == 1)
        finalThreshold = shannonEntropyThresholding(Histogram);
    %   2.2�����r = 1��Sharma-Mittal Entropyת��ΪRenyi�ؽ���ͼ��ָ�
    elseif(r == 1)
        finalThreshold = renyiEntropyThresholding(q, Histogram);
    %   2.3�����r = q��Sharma-Mittal Entropyת��ΪTsallis�ؽ���ͼ��ָ�
    elseif(r == q)
        finalThreshold = tsallisEntropyThresholding(q, Histogram);
    %   2.4�����r != q != 1�����õ�Sharma-Mittal Entropy����ͼ��ָ�
    else
        % 3���������ܵ���ֵ��
        for i = startLevel : endLevel - 1
            PA = sum(Histogram(startLevel + 1 : i + 1));
            HA = (power(sum(power(Histogram(startLevel + 1 : i + 1) ./ PA, q)), ((1 - r) / (1 - q))) - 1) / (1 - r);

            PB = 1 - PA;
            HB = (power(sum(power(Histogram(i + 2 : endLevel + 1) ./ PB, q)), ((1 - r) / (1 - q))) - 1) / (1 - r);
            
            %   3.1�����浱ǰ��ֵ�µ������
            entropyTotalTemp(i - startLevel + 1) = HA + HB + (1 - r) * HA * HB;
        end

        % 4���ó���Ӧ�����ֵ������-1��Ϊ������ֵ
        [maxValue, threshold] = max(entropyTotalTemp);
        finalThreshold = startLevel + threshold - 1;
        disp([maxValue, finalThreshold]);

        entropyTotal(1 : L) = 0;
        entropyTotal(startLevel + 1 : endLevel) = entropyTotalTemp;

        % 6�����Ʋ�չʾͼ��
        %   6.1��Ϊ�˱��ڹ۲�entropyTotalֵ���ɵ����ߣ���entropyTotal��ֵ�����˹�һ��[0,1]
        entropyTotalNormal = (entropyTotal - min(entropyTotal)) ./ (max(entropyTotal) - min(entropyTotal));

        %   6.2��Ϊ�˱��ڹ۲�Ҷ�ֵ���ֵ�Ƶ�ʹ��ɵ����ߣ��Ҷ�ֱ��ͼ������frequencyֵ�����˹�һ��[0,1]
        frequencyNormal = (Histogram - min(Histogram)) ./ (max(Histogram) - min(Histogram));

        figure,hold on,
        plot(0 : (L - 1), entropyTotalNormal(:), '-r'),
        plot([finalThreshold, finalThreshold],[0.0 1.0], 'r-.'),  % ��Ǵ��������ֵ��λ�ã�ע��˴�����ֵ�ǰ�MATLAB�м�1��
        plot(0 : (L - 1), frequencyNormal),  % ��ʾ��һ����ͼ��ֱ��ͼ
        xlim([0 (L - 1)]),
        title('Sharma-Mittal Entropyֵ�仯���߼���������ֵ'),
        text(finalThreshold, 0.5, ['\leftarrow' num2str(finalThreshold)], 'HorizontalAlignment', 'left'),
        hold off;
    end
end
