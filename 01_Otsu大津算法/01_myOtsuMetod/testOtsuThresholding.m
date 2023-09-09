%% 测试Otsu阈值分割
clc,clear; close all;

%% 选取图像
% 此处文件类型可自行定义
[FileName,PathName,FilterIndex] = uigetfile({'*.tif'; '*.txt'; '*.jpg'; '*.bmp'}, ...
                                'File Selector', 'MultiSelect', 'on');  
if FilterIndex == 1
    %定义waitbar
%     w_load = waitbar(0,'Please wait...','Name','Phase load'); 
    if (iscell(FileName) == 0) %若只选择一张图片，将图片存入矩阵ImageSingle中
        FileNum = 1;
%         ImageSingle = imread(strcat(PathName,FileName));
        ImageCell{1} = imread(strcat(PathName,FileName));
    else
        %若选择多张图片，将多张图片存入元胞数组ImageCell{}里
        FileNum = length(FileName);
        for num_image = 1 : FileNum
            ImageCell{num_image} = imread(strcat(PathName,FileName{num_image}));
%             waitbar(num_image / FileNum, w_load, strcat('Please wait...', num2str(fix(num_image * 100/FileNum)), '%'));
        end
%         close (w_load);
    end
end

%% 执行操作
for i = 1 : FileNum
%     Image = im2gray(im2double(ImageCell{i}));
    Image = double(ImageCell{i});
    
    % 1 如果是彩色图像直接转化为灰度图像
%     if (size(image, 3) == 3)  % 如果是三通道图像，将其转化为单通道图像
%         figure, imshow(image), title('Original Color Image');
%         image = rgb2gray(image);
%     end
    if ndims(Image) == 3
        figure, imshow(Image), title('The Original Color Image');
        Image = rgb2gray(Image);
    end
    % 相关图像操作
    
    % 2 计算直方图，并归一化直方图
    Histogram = imhist(Image);% 图像每个灰度级的像素数
    Histogram = (Histogram / sum(Histogram))';% 归一化 将竖轴显示为每种灰度级的概率
    
    % 3 使用OTSU方法进行阈值分割，并记录运行时间
    tic;
    threshold = myOtsu(Histogram);
    runTime = toc;
    
    % 4 根据选择的阈值进行二值化处理
    [imgbw] = subim2bw(Image, threshold);
    
    NU = RegionNonuniformity(Image, imgbw);
    QQ = Q(Image, imgbw);
    Res = F(Image, imgbw);
    
    % 5 绘制结果图像
    figure(i),
    subplot(2, 2, 1), imshow(Image), title('原始图像');
    subplot(2, 2, 2), imhist(Image), title('原始图像直方图');
    subplot(2, 2, 3), imshow(imgbw), title('基于Otsu的阈值分割结果');
    subplot(2, 2, 4);
%     gtext(strcat('最佳阈值threshold = ', num2str(threshold))),
%     gtext(strcat(strcat('程序运行时间：', num2str(time)), '秒')),
%     gtext(strcat('区域不均匀性NU = ', num2str(NU))),
%     gtext(strcat('Q = ', num2str(QQ))),
%     gtext(strcat('F = ', num2str(Res))),
%     title('最优阈值及其程序运行时间');
end