clc;
clear;
%% 导入原图
% 指定图像库路径
imgPath = '/Users/liwangyang/Desktop/研究生-图像分割/数据集/BSDS500-master/BSDS300/images/test/'; 
% 指定需要加载的文件格式：jpg
imgDir  = dir([imgPath '*.jpg']);
tic;
length_dir = length(imgDir);
r1 = zeros(length_dir, 6);

% 遍历图像库分割图像
% 遍历整个图像库，顺序以文件夹的排序为准
for i = 1 : length_dir
    % 读取图像，注意在文件名相同的情形下读入gt，
    image = imread([imgPath imgDir(i).name]);
    % gt = imread([gtPath gtDir(i).name]);
    
    % 过滤掉灰度图像，根据条件可以过滤掉彩色图像，看你们的需求
%     if size(img,3) == 3
%         continue;
%     end
    if size(image, 3) == 3
        image = rgb2gray(image);
    end
    
    % 获取文件名作为分割后图像保存的文件名
    name = imgDir(i).name;
    % 分割函数，即你们的分割方法，需要对其进行参数输出设置
%     [Label01, Label02, time] = main(img);
    
    % 2 直方图归一化
    Histogram = imhist(image);
    Histogram = Histogram / sum(Histogram);
    q = 0.8;

    % 3 利用Tsallis熵进行阈值选择并记录运行时间
    tic;
    threshold = tsallisEntropyThresholding(q, Histogram);
    runTime = toc;

    % 4 根据选取的阈值进行二值化处理
    imgbw = subim2bw(image, threshold);

    NU = RegionNonuniformity(image, imgbw);
    QQ = Q(image, imgbw);
    Res = F(image, imgbw);

    % 5 绘制结果图像
%     figure,
%     subplot(221), imshow(image), title('Original gray-level image');
%     subplot(222), imhist(image), title('原始灰度直方图');
%     subplot(223), imshow(imgbw), title('熵阈值分割后的图像');
    
    str1 = strcat('Tsallis熵参数q：', num2str(q));
    str2 = strcat('最佳阈值：', num2str(threshold));
    str3 = strcat(strcat('程序运行时间：', num2str(runTime)), '秒');
    str4 = strcat('区域不均匀性NU：', num2str(NU));
    str5 = strcat('Q = ', num2str(QQ));
    str6 = strcat('F = ', num2str(Res));
    
    str(1) = q;
    str(2) = threshold;
    str(3) = runTime;
    str(4) = NU;
    str(5) = QQ;
    str(6) = Res;
    
    % 关闭显示的图像
    close all;
    
    for j = 1:6
        r1(i, j) = str(j);
    end
    % 写入excel文件
    % csvwrite(filename, [q, runTime, NU], sheet, ['A', num2str(i+1), ':C', num2str(i+1)])
    
    % 保存分割的图像
    imwrite(imgbw, strcat('Seg01/',name));
    % imwrite(Label02, strcat('ECT掩膜分割02/',name));
end
Time = sum(r(:,3));
BD1=1:i;
BD2=BD1.';
% 列名称
title = {'NO', '阈值', '程序运行时间', '区域不均匀性NU'};
filename = '分割数据02.csv';      
result_table = table(BD2, r1(:,2), r1(:,3), r1(:,4), 'VariableNames', title);
writetable(result_table, filename);