function [finalThreshold] = OTSU2D(image)

%{
函数说明： 利用二维OTSU对灰度图的直方图进行阈值选择
函数参数：
        image：灰度图
函数返回值：
        finalThreshold：OTSU阈值化的最佳阈值
-------------------------------------------------------------------
调用实例：
        [finalThreshold] = OTSU2D(image)；
%}
    
    % 只使用replicate和symmetric 必须使用both来扩展图像四周边界 [1 1]表示图像每条边向外扩展1个像素
    imgpad1 = padarray(image, [1 1], 'replicate', 'both');
    
    Histogram = imhist(image);
    TrMax = 0.0; % 用于存放矩阵的秩（矩阵对角线之和）
    [height, width] = size(image);
    N = height * width;
    L = length(Histogram);
%     image1 = zero(height + 4, width + 4);
%     for i = 3 : height + 2
%         for j = 3 : width + 2
%             image1(i, j) = image(i - 2, j - 2);
%         end
%     end
    Histogram1 = zeros(L);
    mean_gray = 0;
    img1 = zeros(height, width);
    for i = 2 : height + 1
        for j = 2 : width + 1
            
            for m = i - 1 : i + 1
                for n = j - 1 : j + 1
                    mean_gray = mean_gray + imgpad1(m, n);
                end
            end
            
            mean_gray = mean_gray / 9;
            img1(i - 1, j - 1) = mean_gray;
            
            Histogram1(imgpad1(i, j) - 1, mean_gray - 1) = Histogram1(imgpad1(i, j) - 1, mean_gray - 1) + 1;
            
        end
    end
    
    Histogram1 = Histogram1 / N; % 归一化的每一个二元组的概率分布
    
    S = zeros(1, 256); %统计前i行概率的数组
	N1 = zeros(1, 256); %统计遍历过程中前景区i分量的值
	N2 = zeros(1, 256); %统计遍历过程中前景区j分量的值
	
	for i = 1 : 255
		x = 0; n1 = 0; n2 = 0;
		for j = 1 : 255
		
			x = x + Histogram1(i, j + 1);
			n1 = n1 + ((i) * Histogram1(i, j + 1)); % 遍历过程中前景区i分量的值
			n2 = n2 + (j * Histogram1(i, j + 1)); % 遍历过程中前景区j分量的值
            
        end
		S(i + 1) = x + S(i);
		N1(i + 1) = n1 + N1(i);
		N2(i + 1) = n2 + N2(i);
    end

    
    Fgi = 0.0;    %前景区域均值向量i分量
	Fgj = 0.0;    %前景区域均值向量j分量
	Bgi = 0.0;    %背景区域均值向量i分量
	Bgj = 0.0;    %背景区域均值向量j分量
    
	Pai = 0.0;    %全局均值向量i分量 panorama(全景)
	Paj = 0.0;    %全局均值向量j分量
	w0 = 0.0;     %前景区域联合概率密度
	w1 = 0.0;     %背景区域联合概率密度
    
	num1 = 0.0;   %遍历过程中前景区i分量的值
	num2 = 0.0;   %遍历过程中前景区j分量的值
	num3 = 0.0;   %遍历过程中背景区i分量的值
	num4 = 0.0;   %遍历过程中背景区j分量的值
    
	Threshold_s = 0; %阈值s
	Threshold_t = 0; %阈值t
    
    M = 0;
	temp = 0.0;   %存储矩阵迹的最大值
	for i = 1 : L
        for j = 1 : L
			Pai = Pai + i * Histogram1(i, j);   %全局均值向量i分量计算
			Paj = Paj + j * Histogram1(i, j);   %全局均值向量j分量计算
        end
    end
    
    for i = 1 : L
        if i > 1
            w0 =w0 + S(i - 1);
			num1 =num1 + N1(i - 1);
			num2 =num2 + N2(i - 1);
        end
        
        for j = 1 : L
            w0 = w0 + Histogram1(i, j); % 前景的概率
            num1 = num1 + i * Histogram1(i, j); % 遍历过程中前景区i分量的值
            num2 = num2 + j * Histogram1(i, j); % 遍历过程中前景区j分量的值
            
            w1 = 1 - w0; % 背景的概率
            num3 = Pai - num1; % 遍历过程中背景区i分量的值
            num4 = Paj - num2; % 遍历过程中背景区j分量的值
        end
        
        Fgi = num1 / w0;              
        Fgj = num2 / w1;
        Bgi = num3 / w0;
        Bgj = num4 / w1;
        TrMax = ((w0 * Pai - num1)*(w0 * Pai - num1) + ...
                    (w0 * Paj - num2)*(w0 * Paj - num2)) / ...
                    (w0 * w1);

        if (TrMax > temp)
            temp = TrMax;
            Threshold_s = i;
            Threshold_t = j;
        end
    end
    
    finalThreshold = Threshold_s;

end
