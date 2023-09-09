% 测试香农熵阈值分割程序
close all;
clc, clear;

% 1 选取图像（仅限灰度图像）
% 从固定文件路径读取某种图片类型，并进行图像操作
% file_path =  '/Users/liwangyang/Desktop/matlab_doc/图片集/';% 图像文件夹路径
% img_path_list = dir(strcat(file_path, '*.tif'));%获取该文件夹中所有tif格式的图像
% img_num = length(img_path_list);%获取图像总数量
% I = cell(1, img_num);
% if img_num > 0 %有满足条件的图像  
%     for j = 1 : img_num%逐一读取图像
%         image_name = img_path_list(j).name;%图像名
%         image = imread(strcat(file_path, image_name));
%         % 1.1 如果为彩色图像则之间转换为灰度图像
%         if (size(image, 3)==3)
%             figure,imshow(image),title('origin color image');
%             image = rgb2gray(image);
%         end
%         fprintf('%d %d %s\n',i, j, strcat(file_path,image_name));% 显示正在处理的图像名
%     end
% end

[fileName,pathName] = uigetfile({'*.*'; '*.bmp'; '*.jpg'; '*.tif'}, 'Select the original image file');
fileName = strcat(pathName, fileName);
image = imread(fileName);

if (size(image,3) == 3)  % 如果是三通道图像，将其转化为单通道图像
    figure,imshow(image),title('Original Color Image');
    image = rgb2gray(image);
end

% 2 计算直方图，并且归一化直方图
Histogram = imhist(image);
Histogram = Histogram / sum(Histogram);

% 3 利用香农熵分割图像，并记录程序运行时间
tic;
threshold = relatedEntropyThresholding(Histogram);
runTime = toc;

% 4 根据选取的阈值进行二值化处理，显示评价此分割方法优度的度量
[imgbw] = subim2bw(image, threshold);

NU = RegionNonuniformity(image, imgbw);

% 5 绘制并展示相关函数及图像
figure, 
subplot(221), imshow(image), title('原始灰度图');
subplot(222), imhist(image), title('原始灰度直方图');
subplot(223), imshow(imgbw), title('基于相关熵分割后的二值图像');

str1 = strcat('最佳阈值：', num2str(threshold));
str2 = strcat(strcat('程序运行时间：', num2str(runTime)), '秒');
str3 = strcat('区域不均匀性NU=', num2str(NU));
disp('result：');
fprintf('result：%s;\n%s;\n%s.\n', str1, str2, str3);