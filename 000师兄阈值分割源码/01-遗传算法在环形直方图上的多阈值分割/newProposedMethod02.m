function [finalThreshold] = newProposedMethod02(q, Histogram)
% ����˵����Tsallis Entropy�������ȵ�ǿ�����Ż�01��ֱ��ͼ������ֵ�ָ�
% ����˵����
%   q��Tsallis Entropy�ز���
%   Histogram�����Ի�ֱ��ͼ
% ����ֵ˵����
%   finalThreshold�������ֵ
%   HA��һ���������ֵ
%   HB�������������ֵ
%----------------------------------------------------------------------------------

% ����ʾ����[finalThreshold, HA, HB] = newProposedMethod02(q, Histogram)

    % 1��ȥ��ֱ��ͼǰ��Ϊ0�����ص�
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
    
    % 2���������ܵ���ֵ��
    for i = startLevel : endLevel - 1
        
        %   2.1�����������ڵĹȵ�ƫ��
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
        
        %   2.2��OTSU��׼���������ڷ���
        wk = wk + Histogram(i + 1);
        uk = uk + i * Histogram(i + 1);
        eta(i - startLevel + 1) = (wk * uT - uk)^2 / (wk * (1 - wk));
        
        %   2.3��Tsallis�ر�׼���������Tsallis��
        PA = sum(Histogram(startLevel + 1 : i + 1));
        HA = (1 - sum(power(Histogram(startLevel + 1 : i + 1) / PA, q))) / (q - 1);
        PB = 1 - PA;
        HB = (1 - sum(power(Histogram(i + 2 : endLevel + 1) / PB, q))) / (q - 1);
        
        %   2.4���ȵ�ǿ�����Ż�01���Tsallis��
        entropyTotalTemp(i - startLevel + 1) = (HA + HB + (1 - q) * HA * HB) * ((1 - p) * eta(i - startLevel + 1));
    end

    % 3���ó���Ӧ�����ֵ������-1��Ϊ������ֵ
    [maxValue, threshold] = max(entropyTotalTemp);
    finalThreshold = startLevel + threshold - 1;
    
    % 4�����������ֵ������������ֵ
%     PA = sum(Histogram(startLevel + 1 : finalThreshold + 1));
%     HA = (1 - sum(power(Histogram(startLevel + 1 : finalThreshold + 1) / PA, q))) / (q - 1);
%     
%     PB = 1 - PA;
%     HB = (1 - sum(power(Histogram(finalThreshold + 2 : endLevel + 1) / PB, q))) / (q - 1);
    
    entropyTotal(1 : L) = 0;
    entropyTotal(startLevel + 1 : endLevel) = entropyTotalTemp;

    % 6�����Ʋ�չʾͼ��
    %   6.1��Ϊ�˱��ڹ۲�entropyTotalֵ���ɵ����ߣ���entropyTotal��ֵ�����˹�һ��[0,1]
    entropyTotalNormal = (entropyTotal - min(entropyTotal)) ./ (max(entropyTotal) - min(entropyTotal));

    %   6.2��Ϊ�˱��ڹ۲�Ҷ�ֵ���ֵ�Ƶ�ʹ��ɵ����ߣ��Ҷ�ֱ��ͼ������frequencyֵ�����˹�һ��[0,1]
    frequencyNormal = (Histogram - min(Histogram)) ./ (max(Histogram) - min(Histogram));

    figure,hold on,
    plot(0 : 255, entropyTotalNormal(:), '-r'),
    plot([finalThreshold, finalThreshold],[0.0 1.0], 'r-.'),  % ��Ǵ��������ֵ��λ�ã�ע��˴�����ֵ�ǰ�MATLAB�м�1��
    plot(0 : 255, frequencyNormal),  % ��ʾ��һ����ͼ��ֱ��ͼ
    xlim([0 255]),
    %title('Tsallis�ر仯���߼���������ֵ'),
    text(finalThreshold, 0.5, ['\leftarrow' num2str(finalThreshold)], 'HorizontalAlignment', 'left'),
    hold off;
end
