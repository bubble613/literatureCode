function [image_hsv, HSV_H_image, Hist_D_ACW_max, D_ACW_max_level] = CircleHistogramToLinearizedHistogram(image)
% 函数功能：利用累计概率分布的最大方差将H通道环形直方图逆时针破碎成线性化的直方图
% 返回值说明：
%   image：RGB彩色图像
%   HSV_H_image：HSV彩色图像的H通道图像
%   Hist_D_ACW_max：逆时针累积概率分布方差最大的线性化直方图
%   D_ACW_max_level：使得逆时针累积概率分布方差最大线性化直方图的断点
%--------------------------------------------------------------------------------------------

% 函数调用示例：[HSV_H_image, Hist_D_ACW_max, D_ACW_max_level] = CircleHistogramToLinearizedHistogram(image)
    
    % 1、图像选择
%     %    要求：彩色图像
%     [fileName, pathName] = uigetfile({'*.*'; '*.bmp'; '*.jpg'}, 'Select the  original image file');
%     fileName = strcat(pathName, fileName);
%     image = imread(fileName);
    
    % 2、彩色图像的H通道图像线性直方图至环形直方图的演变
    %    2.1、RGB图像转换为HSV图像并提取H通道
    image_hsv = rgb2hsv(image);
    image_hsv_h = image_hsv(:, :, 1);
    
    [pixel, gray] = imhist(image_hsv_h);
    gray = gray * 360;
    figure,
    bar(gray, pixel, 'k');
    xlim([0 gray(end)]);
    
    [pixelCount, grayLevels] = imhist(image_hsv_h, 256);
    HSV_H_image = image_hsv_h * 255;  % 量化为256个灰度级
    grayLevels = grayLevels * 255;  % [0, 255]
    
    %    2.2、展示图像
    figure, subplot(2, 3, 1),
    imshow(image), title('RGB彩色图像');
    subplot(2, 3, 2),
    imshow(image_hsv), title('HSV彩色图像');
    subplot(2, 3, 3),
    imshow(HSV_H_image, []), title('HSV彩色图像H通道图像')
    subplot(2, 3, 4),
    bar(grayLevels, pixelCount),
    %title('H通道图像直方图')
    xlim([0 grayLevels(end)]);
    
    %    2.3、通过H通道直方图绘制环形直方图
    %       要求：这一步只能接在bar(grayLevels, pixelCount)(线性直方图)后面
    h = get(gca, 'children');
    xdata = get(h(1), 'xdata');  % xdata即灰度级
    ydata = get(h(1), 'ydata');  % ydata即每个灰度级对应的像素值
    xm = max(abs(xdata(:)));  % xm表示最大的灰度值
    xm = round(xm);  % round函数用于舍入到最接近的整数。
    xt = linspace(0, 2 * pi, xm);
    x = cos(xt);
    y = sin(xt);
    z = zeros(1, xm);
    for i = 1 : length(ydata) - 1
        z(round(xdata(i)) + 1) = ydata(i);
    end
    z(end) = ydata(end);
    
    %    2.4、显示环形直方图
    figure, hold on, view(3),  % 设置视点的函数view。其调用格式为：view(az,el)az是azimuth（方位角）的缩写，EL是elevation（仰角）的缩写。
    for i = 1 : length(x)
        x_t = floor([x(i) x(i)] * 255);
        y_t = floor([y(i) y(i)] * 255);
        z_t = floor([0 z(i)] * 255);
        plot3(x_t, y_t, z_t, 'g-');
        plot3(x_t, y_t, z_t, 'c.');
        %title('环形直方图')
    end
    axis off

    % 3、依据环形直方图选择累积概率分布方差最大的线性化直方图
    %    3.1、直方图归一化
    pixelCount = pixelCount ./ sum(pixelCount);

    %   3.2、循环所有可能的断点选择使得累积概率分布方差最大的线性化直方图
    %       注意：方差永远大于零
    D_ACW_max = 0;
%     D_CW_max = 0;

    for i = 0 : 255
        t1 = i;

        %       3.2.1、计算得出以t1为起点的线性化的直方图
        for j = 0 : 255
            t = j;

            r_ACW = mod((t + t1), 256);
            LinearizedHist_ACW(t + 1) = pixelCount(r_ACW + 1);

%             r_CW = mod((256 - (t - t1)), 256);
%             LinearizedHist_CW(t + 1) = pixelCount(r_CW + 1);
        end

        %       3.2.2、计算得出以t1为起点的线性化直方图的累积概率分布和
        for k = 1 : length(LinearizedHist_ACW)
            Prt1_ACW(k) = sum(LinearizedHist_ACW(1 : k));
        end
%         for k = 1 : length(LinearizedHist_CW)
%             Prt1_CW(k) = sum(LinearizedHist_CW(1 : k));
%         end

        %       3.2.3、计算并保留当前以t1为起点的线性化直方图的累积概率分布和的均值和方差（修正后的方差）
        E_ACW(i + 1) = sum(Prt1_ACW) / 256;
        D_ACW(i + 1) = sum(power(Prt1_ACW - E_ACW(i + 1), 2)) / 255;
%         E_CW(i + 1) = sum(Prt1_CW) / 256;
%         D_CW(i + 1) = sum(power(Prt1_CW - E_CW(i + 1), 2)) / 255;
        
        %       3.2.4、保留逆时针方向最大和最小方差的线性化直方图
        if D_ACW(i + 1) > D_ACW_max
            D_ACW_max = D_ACW(i + 1);
            Hist_D_ACW_max = LinearizedHist_ACW;
        end
        %       3.2.5、保留顺时针方向最大和最小方差的线性化直方图
%         if D_CW(i + 1) > D_CW_max
%             D_CW_max = D_CW(i + 1);
%             Hist_D_CW_max = LinearizedHist_CW;
%         end
    end
    

    %   3.3、得出使得环形直方图破碎成线性化直方图累积概率分布方差最大的t值，此t值即为最佳断点
    [D_ACW_max_Value, D_ACW_max_level] = max(D_ACW);
    [D_ACW_min_Value, D_ACW_min_level] = min(D_ACW);
    D_ACW_max_level = D_ACW_max_level - 1;
    D_ACW_min_level = D_ACW_min_level - 1;
    
%     [D_CW_max_Value, D_CW_max_level] = max(D_CW);
%     [D_CW_min_Value, D_CW_min_level] = min(D_CW);
%     D_CW_max_level = D_CW_max_level - 1;
%     D_CW_min_level = D_CW_min_level - 1;
    
    
    % 4、绘制逆/顺时针方差变化图和逆/顺时针最大方差破碎的线性化直方图
    
    %   4.2、逆时针累积概率分布方差最大
    figure, hold on,
    plot(0 : 255, D_ACW(:), 'k-'),
    plot([D_ACW_max_level, D_ACW_max_level], [0.0 D_ACW(D_ACW_max_level)], 'r-.'),
    %plot([D_ACW_min_level, D_ACW_min_level], [0.0 1.0], 'g-.'),
    text(D_ACW_max_level, D_ACW(D_ACW_max_level) / 2, ['\leftarrow' num2str(D_ACW_max_level)], 'HorizontalAlignment', 'left'),
    %text(D_ACW_min_level, 0.3, ['\leftarrow' num2str(D_ACW_min_level)], 'HorizontalAlignment', 'left'),
    %title('逆时针累积概率分布方差变化图'),
    xlabel('breakpoint','FontName','Times New Roman','FontSize',7.5);%设置x轴标签的字体和大小
    ylabel('variance','FontName','Times New Roman','FontSize',7.5); %设置y轴标签的字体和大小
    set(gca,'FontName','Times New Roman','FontSize',7.5);%设置x和y轴上刻度的字体和大小
    xlim([0 255]),
    hold off;
    
    figure,
    plot(0 : 255, Hist_D_ACW_max,'k-'),
    %title('逆时针以最大方差为断点的线性化直方图'),
    xlabel('intensity','FontName','Times New Roman','FontSize',7.5);%设置x轴标签的字体和大小
    ylabel('frequency','FontName','Times New Roman','FontSize',7.5); %设置y轴标签的字体和大小
    set(gca,'FontName','Times New Roman','FontSize',7.5);%设置x和y轴上刻度的字体和大小
    xlim([0 255]);
    
    %   4.3、顺时针累积概率分布方差最大
%     subplot(2, 2, 3),hold on,
%     plot(0 : 255, D_CW(:), 'b-'),
%     plot([D_CW_max_level, D_CW_max_level], [0.0 1.0], 'r-.'),
%     plot([D_CW_min_level, D_CW_min_level], [0.0 1.0], 'g-.'),
%     text(D_CW_max_level, 0.5, ['\leftarrow' num2str(D_CW_max_level)], 'HorizontalAlignment', 'left'),
%     text(D_CW_min_level, 0.3, ['\leftarrow' num2str(D_CW_min_level)], 'HorizontalAlignment', 'left'),
%     %title('顺时针累积概率分布方差变化图'),
%     xlim([0 255]),
%     hold off;
%     
%     subplot(2, 2, 4),
%     plot(0 : 255, Hist_D_CW_max,'k-'),
%     %title('顺时针以最大方差为断点的线性化直方图'),
%     xlim([0 255]);
    
%     % 5、测试
%       % 正式实验需要注释
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
%     %   4.2、逆时针累积概率分布方差最大
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
%     %title('逆时针累积概率分布方差变化图'),
%     xlabel('breakpoint','FontName','Times New Roman','FontSize',7.5);%设置x轴标签的字体和大小
%     ylabel('variance','FontName','Times New Roman','FontSize',7.5); %设置y轴标签的字体和大小
%     set(gca,'FontName','Times New Roman','FontSize',7.5);%设置x和y轴上刻度的字体和大小
%     xlim([0 255]),
%     hold off;
%     
%     figure,
%     plot(0 : 255, Hist_D_ACW_max, 'k-'),
%     %title('逆时针以最大方差为断点的线性化直方图'),
%     xlabel('intensity','FontName','Times New Roman','FontSize',7.5);%设置x轴标签的字体和大小
%     ylabel('frequency','FontName','Times New Roman','FontSize',7.5); %设置y轴标签的字体和大小
%     set(gca,'FontName','Times New Roman','FontSize',7.5);%设置x和y轴上刻度的字体和大小
%     xlim([0 255]);
%     
%     figure,
%     plot(0 : 255, Hist_D_CW_max,'k-'),
%     %title('顺时针以最大方差为断点的线性化直方图'),
%     xlabel('intensity','FontName','Times New Roman','FontSize',7.5);%设置x轴标签的字体和大小
%     ylabel('frequency','FontName','Times New Roman','FontSize',7.5); %设置y轴标签的字体和大小
%     set(gca,'FontName','Times New Roman','FontSize',7.5);%设置x和y轴上刻度的字体和大小
%     xlim([0 255]);
end

