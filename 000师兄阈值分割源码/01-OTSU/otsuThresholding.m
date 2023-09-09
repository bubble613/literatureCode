function [finalThreshold] = otsuThresholding(Histogram)
% ����˵��������OTSU����ֱ��ͼ������ֵѡ��
% ����˵����
%   Histogram����һ��ֱ��ͼ
% ����ֵ˵����
%   finalThreshold�������ֵ
%----------------------------------------------------------------------------------

% ����ʾ����[finalThreshold] = otsuThresholding(Histogram)

    % 1��OTSU�����˴������ۼӵķ�����
    wk = 0;
    uk = 0;
    L = length(Histogram);
    uT = sum((0 : L - 1) .* Histogram);

    for k = 1 : L
        wk = wk + Histogram(k);
        uk = uk + (k - 1) * Histogram(k);
        eta(k) = (wk * uT - uk)^2 / (wk * (1 - wk));
    end

    % 2���ó���Ӧ���ֵ������-1��Ϊ������ֵ
    [maxValue, threshold] = max(eta);
    finalThreshold = threshold - 1;
    disp([maxValue, finalThreshold]);

    % 3�����Ʋ�չʾͼ��
    %   3.1��Ϊ�˱��ڹ۲�etaֵ���ɵ����ߣ���eta��ֵ�����˹�һ��[0,1]
    etaNormal = (eta - min(eta)) ./ (max(eta) - min(eta));
    
    %   3.2��Ϊ�˱��ڹ۲�Ҷ�ֵ���ֵ�Ƶ�ʹ��ɵ����ߣ��Ҷ�ֱ��ͼ������Histogramֵ�����˹�һ��[0,1]
    frequencyNormal = (Histogram - min(Histogram)) ./ (max(Histogram) - min(Histogram));

    figure, hold on,
    plot(0 : (L - 1), etaNormal(:), '-r'),
    plot([finalThreshold, finalThreshold],[0.0 1.0],'r-.'),  % ��Ǵ��������ֵ��λ��
    plot(0 : (L - 1), frequencyNormal),
    xlim([0  (L - 1)]),
    title('��䷽��仯���߼���������ֵ'),
    text(finalThreshold, 0.5, ['\leftarrow' num2str(finalThreshold)], 'HorizontalAlignment', 'left'),
    hold off;
end