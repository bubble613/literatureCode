function [image_hsv, HSV_H_image, Hist_D_ACW_max, D_ACW_max_level] = CircleHistogramToLinearizedHistogram(image)
% �������ܣ������ۼƸ��ʷֲ�����󷽲Hͨ������ֱ��ͼ��ʱ����������Ի���ֱ��ͼ
% ����ֵ˵����
%   image��RGB��ɫͼ��
%   HSV_H_image��HSV��ɫͼ���Hͨ��ͼ��
%   Hist_D_ACW_max����ʱ���ۻ����ʷֲ������������Ի�ֱ��ͼ
%   D_ACW_max_level��ʹ����ʱ���ۻ����ʷֲ�����������Ի�ֱ��ͼ�Ķϵ�
%--------------------------------------------------------------------------------------------

% ��������ʾ����[HSV_H_image, Hist_D_ACW_max, D_ACW_max_level] = CircleHistogramToLinearizedHistogram(image)
    
    % 1��ͼ��ѡ��
%     %    Ҫ�󣺲�ɫͼ��
%     [fileName, pathName] = uigetfile({'*.*'; '*.bmp'; '*.jpg'}, 'Select the  original image file');
%     fileName = strcat(pathName, fileName);
%     image = imread(fileName);
    
    % 2����ɫͼ���Hͨ��ͼ������ֱ��ͼ������ֱ��ͼ���ݱ�
    %    2.1��RGBͼ��ת��ΪHSVͼ����ȡHͨ��
    image_hsv = rgb2hsv(image);
    image_hsv_h = image_hsv(:, :, 1);
    
    [pixel, gray] = imhist(image_hsv_h);
    gray = gray * 360;
    figure,
    bar(gray, pixel, 'k');
    xlim([0 gray(end)]);
    
    [pixelCount, grayLevels] = imhist(image_hsv_h, 256);
    HSV_H_image = image_hsv_h * 255;  % ����Ϊ256���Ҷȼ�
    grayLevels = grayLevels * 255;  % [0, 255]
    
    %    2.2��չʾͼ��
    figure, subplot(2, 3, 1),
    imshow(image), title('RGB��ɫͼ��');
    subplot(2, 3, 2),
    imshow(image_hsv), title('HSV��ɫͼ��');
    subplot(2, 3, 3),
    imshow(HSV_H_image, []), title('HSV��ɫͼ��Hͨ��ͼ��')
    subplot(2, 3, 4),
    bar(grayLevels, pixelCount),
    %title('Hͨ��ͼ��ֱ��ͼ')
    xlim([0 grayLevels(end)]);
    
    %    2.3��ͨ��Hͨ��ֱ��ͼ���ƻ���ֱ��ͼ
    %       Ҫ����һ��ֻ�ܽ���bar(grayLevels, pixelCount)(����ֱ��ͼ)����
    h = get(gca, 'children');
    xdata = get(h(1), 'xdata');  % xdata���Ҷȼ�
    ydata = get(h(1), 'ydata');  % ydata��ÿ���Ҷȼ���Ӧ������ֵ
    xm = max(abs(xdata(:)));  % xm��ʾ���ĻҶ�ֵ
    xm = round(xm);  % round�����������뵽��ӽ���������
    xt = linspace(0, 2 * pi, xm);
    x = cos(xt);
    y = sin(xt);
    z = zeros(1, xm);
    for i = 1 : length(ydata) - 1
        z(round(xdata(i)) + 1) = ydata(i);
    end
    z(end) = ydata(end);
    
    %    2.4����ʾ����ֱ��ͼ
    figure, hold on, view(3),  % �����ӵ�ĺ���view������ø�ʽΪ��view(az,el)az��azimuth����λ�ǣ�����д��EL��elevation�����ǣ�����д��
    for i = 1 : length(x)
        x_t = floor([x(i) x(i)] * 255);
        y_t = floor([y(i) y(i)] * 255);
        z_t = floor([0 z(i)] * 255);
        plot3(x_t, y_t, z_t, 'g-');
        plot3(x_t, y_t, z_t, 'c.');
        %title('����ֱ��ͼ')
    end
    axis off

    % 3�����ݻ���ֱ��ͼѡ���ۻ����ʷֲ������������Ի�ֱ��ͼ
    %    3.1��ֱ��ͼ��һ��
    pixelCount = pixelCount ./ sum(pixelCount);

    %   3.2��ѭ�����п��ܵĶϵ�ѡ��ʹ���ۻ����ʷֲ������������Ի�ֱ��ͼ
    %       ע�⣺������Զ������
    D_ACW_max = 0;
%     D_CW_max = 0;

    for i = 0 : 255
        t1 = i;

        %       3.2.1������ó���t1Ϊ�������Ի���ֱ��ͼ
        for j = 0 : 255
            t = j;

            r_ACW = mod((t + t1), 256);
            LinearizedHist_ACW(t + 1) = pixelCount(r_ACW + 1);

%             r_CW = mod((256 - (t - t1)), 256);
%             LinearizedHist_CW(t + 1) = pixelCount(r_CW + 1);
        end

        %       3.2.2������ó���t1Ϊ�������Ի�ֱ��ͼ���ۻ����ʷֲ���
        for k = 1 : length(LinearizedHist_ACW)
            Prt1_ACW(k) = sum(LinearizedHist_ACW(1 : k));
        end
%         for k = 1 : length(LinearizedHist_CW)
%             Prt1_CW(k) = sum(LinearizedHist_CW(1 : k));
%         end

        %       3.2.3�����㲢������ǰ��t1Ϊ�������Ի�ֱ��ͼ���ۻ����ʷֲ��͵ľ�ֵ�ͷ��������ķ��
        E_ACW(i + 1) = sum(Prt1_ACW) / 256;
        D_ACW(i + 1) = sum(power(Prt1_ACW - E_ACW(i + 1), 2)) / 255;
%         E_CW(i + 1) = sum(Prt1_CW) / 256;
%         D_CW(i + 1) = sum(power(Prt1_CW - E_CW(i + 1), 2)) / 255;
        
        %       3.2.4��������ʱ�뷽��������С��������Ի�ֱ��ͼ
        if D_ACW(i + 1) > D_ACW_max
            D_ACW_max = D_ACW(i + 1);
            Hist_D_ACW_max = LinearizedHist_ACW;
        end
        %       3.2.5������˳ʱ�뷽��������С��������Ի�ֱ��ͼ
%         if D_CW(i + 1) > D_CW_max
%             D_CW_max = D_CW(i + 1);
%             Hist_D_CW_max = LinearizedHist_CW;
%         end
    end
    

    %   3.3���ó�ʹ�û���ֱ��ͼ��������Ի�ֱ��ͼ�ۻ����ʷֲ���������tֵ����tֵ��Ϊ��Ѷϵ�
    [D_ACW_max_Value, D_ACW_max_level] = max(D_ACW);
    [D_ACW_min_Value, D_ACW_min_level] = min(D_ACW);
    D_ACW_max_level = D_ACW_max_level - 1;
    D_ACW_min_level = D_ACW_min_level - 1;
    
%     [D_CW_max_Value, D_CW_max_level] = max(D_CW);
%     [D_CW_min_Value, D_CW_min_level] = min(D_CW);
%     D_CW_max_level = D_CW_max_level - 1;
%     D_CW_min_level = D_CW_min_level - 1;
    
    
    % 4��������/˳ʱ�뷽��仯ͼ����/˳ʱ����󷽲���������Ի�ֱ��ͼ
    
    %   4.2����ʱ���ۻ����ʷֲ��������
    figure, hold on,
    plot(0 : 255, D_ACW(:), 'k-'),
    plot([D_ACW_max_level, D_ACW_max_level], [0.0 D_ACW(D_ACW_max_level)], 'r-.'),
    %plot([D_ACW_min_level, D_ACW_min_level], [0.0 1.0], 'g-.'),
    text(D_ACW_max_level, D_ACW(D_ACW_max_level) / 2, ['\leftarrow' num2str(D_ACW_max_level)], 'HorizontalAlignment', 'left'),
    %text(D_ACW_min_level, 0.3, ['\leftarrow' num2str(D_ACW_min_level)], 'HorizontalAlignment', 'left'),
    %title('��ʱ���ۻ����ʷֲ�����仯ͼ'),
    xlabel('breakpoint','FontName','Times New Roman','FontSize',7.5);%����x���ǩ������ʹ�С
    ylabel('variance','FontName','Times New Roman','FontSize',7.5); %����y���ǩ������ʹ�С
    set(gca,'FontName','Times New Roman','FontSize',7.5);%����x��y���Ͽ̶ȵ�����ʹ�С
    xlim([0 255]),
    hold off;
    
    figure,
    plot(0 : 255, Hist_D_ACW_max,'k-'),
    %title('��ʱ������󷽲�Ϊ�ϵ�����Ի�ֱ��ͼ'),
    xlabel('intensity','FontName','Times New Roman','FontSize',7.5);%����x���ǩ������ʹ�С
    ylabel('frequency','FontName','Times New Roman','FontSize',7.5); %����y���ǩ������ʹ�С
    set(gca,'FontName','Times New Roman','FontSize',7.5);%����x��y���Ͽ̶ȵ�����ʹ�С
    xlim([0 255]);
    
    %   4.3��˳ʱ���ۻ����ʷֲ��������
%     subplot(2, 2, 3),hold on,
%     plot(0 : 255, D_CW(:), 'b-'),
%     plot([D_CW_max_level, D_CW_max_level], [0.0 1.0], 'r-.'),
%     plot([D_CW_min_level, D_CW_min_level], [0.0 1.0], 'g-.'),
%     text(D_CW_max_level, 0.5, ['\leftarrow' num2str(D_CW_max_level)], 'HorizontalAlignment', 'left'),
%     text(D_CW_min_level, 0.3, ['\leftarrow' num2str(D_CW_min_level)], 'HorizontalAlignment', 'left'),
%     %title('˳ʱ���ۻ����ʷֲ�����仯ͼ'),
%     xlim([0 255]),
%     hold off;
%     
%     subplot(2, 2, 4),
%     plot(0 : 255, Hist_D_CW_max,'k-'),
%     %title('˳ʱ������󷽲�Ϊ�ϵ�����Ի�ֱ��ͼ'),
%     xlim([0 255]);
    
%     % 5������
%       % ��ʽʵ����Ҫע��
%     D_ACW_max_level = 57;
%     D_ACW_max_level01 = 100;
%     D_ACW_max_level02 = 150;
%     D_ACW_max_level03 = 178;
%     D_ACW_max_level04 = 200;
%     D_ACW_max_level05 = 250;
%     for j = 0 : 255
%         t = j;
%         
%         r_ACW = mod((t + 250), 256);
%         LinearizedHist_ACW(t + 1) = pixelCount(r_ACW + 1);
%         r_CW = mod((256 - (t - 57)), 256);
%         LinearizedHist_CW(t + 1) = pixelCount(r_CW + 1);
%     end
%     Hist_D_ACW_max = LinearizedHist_ACW;
%     Hist_D_CW_max = LinearizedHist_CW;
% 
%     figure,
%     %   4.2����ʱ���ۻ����ʷֲ��������
%     hold on,
%     plot(0 : 255, D_ACW(:), 'k-'),
%     plot([D_ACW_max_level, D_ACW_max_level], [0.0 D_ACW(58)], 'r-.'),
% %     plot([D_ACW_max_level01, D_ACW_max_level01], [0.0 D_ACW(101)], 'g-.'),
% %     plot([D_ACW_max_level02, D_ACW_max_level02], [0.0 D_ACW(151)], 'b-.'),
%     plot([D_ACW_max_level03, D_ACW_max_level03], [0.0 D_ACW(179)], 'c-.'),
% %     plot([D_ACW_max_level04, D_ACW_max_level04], [0.0 D_ACW(201)], 'm-.'),
% %     plot([D_ACW_max_level05, D_ACW_max_level05], [0.0 D_ACW(251)], 'y-.'),
%     %plot([D_ACW_min_level, D_ACW_min_level], [0.0 1.0], 'g-.'),
%     %text(D_ACW_max_level, 0.5, ['\leftarrow' num2str(D_ACW_max_level)], 'HorizontalAlignment', 'left'),
%     %text(D_ACW_min_level, 0.3, ['\leftarrow' num2str(D_ACW_min_level)], 'HorizontalAlignment', 'left'),
%     %title('��ʱ���ۻ����ʷֲ�����仯ͼ'),
%     xlabel('breakpoint','FontName','Times New Roman','FontSize',7.5);%����x���ǩ������ʹ�С
%     ylabel('variance','FontName','Times New Roman','FontSize',7.5); %����y���ǩ������ʹ�С
%     set(gca,'FontName','Times New Roman','FontSize',7.5);%����x��y���Ͽ̶ȵ�����ʹ�С
%     xlim([0 255]),
%     hold off;
%     
%     figure,
%     plot(0 : 255, Hist_D_ACW_max, 'k-'),
%     %title('��ʱ������󷽲�Ϊ�ϵ�����Ի�ֱ��ͼ'),
%     xlabel('intensity','FontName','Times New Roman','FontSize',7.5);%����x���ǩ������ʹ�С
%     ylabel('frequency','FontName','Times New Roman','FontSize',7.5); %����y���ǩ������ʹ�С
%     set(gca,'FontName','Times New Roman','FontSize',7.5);%����x��y���Ͽ̶ȵ�����ʹ�С
%     xlim([0 255]);
%     
%     figure,
%     plot(0 : 255, Hist_D_CW_max,'k-'),
%     %title('˳ʱ������󷽲�Ϊ�ϵ�����Ի�ֱ��ͼ'),
%     xlabel('intensity','FontName','Times New Roman','FontSize',7.5);%����x���ǩ������ʹ�С
%     ylabel('frequency','FontName','Times New Roman','FontSize',7.5); %����y���ǩ������ʹ�С
%     set(gca,'FontName','Times New Roman','FontSize',7.5);%����x��y���Ͽ̶ȵ�����ʹ�С
%     xlim([0 255]);
end

