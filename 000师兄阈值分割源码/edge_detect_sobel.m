clc;clear;close all;

% 边缘检测 sobel算子
% I = im2double(rgb2gray(imread(...
%     '/Users/liwangyang/Desktop/matlab_doc/图片集/lena_std.tif')));
% I = rgb2gray(imread('/Users/liwangyang/Desktop/matlab_doc/图片集/lena_std.tif'));

file_path =  '/Users/liwangyang/Desktop/matlab_doc/图片集/';% 图像文件夹路径
% filepath = '';
img_path_list = dir(strcat(file_path, '*.tif'));%获取该文件夹中所有tif格式的图像
img_num = length(img_path_list);%获取图像总数量
I = cell(1, img_num);
if img_num > 0 %有满足条件的图像  
    for j = 1:img_num%逐一读取图像
        image_name = img_path_list(j).name;%图像名
        image = imread(strcat(file_path, image_name));
        if ndims(image) == 3
            I{j} = rgb2gray(image);
        else
            I{j} = image;
        end
%         I{j} = im2gray(image);
        fprintf('%d %d %s\n',i,j,strcat(file_path,image_name));% 显示正在处理的图像名
        
        %图像处理过程 省略  
%         figure(j),
%         
%         subplot(221); imhist(I{j}); 
%         subplot(222); imhist(histeq(I{j}));
%         subplot(223); imshow(histeq(I{j}));
%         subplot(224); imshow(histeq(I{j}), []);
        %这里直接可以访问细胞元数据的方式访问数据
        
        I0 = edge(I{j}, 'sobel'); %自动选择阈值
        I1 = edge(I{j}, 'sobel', 0.08); % 指定阈值 0.08
        I2 = edge(I{j}, 'sobel', 0.02); %指定阈值 0.02

        figure(j)
        subplot(221); imshow(I{j}); title('原图');
        subplot(222); imshow(I0); title('默认阈值');
        subplot(223); imshow(I1); title('阈值:0.08');
        subplot(224); imshow(I2); title('阈值:0.02');
        
    end
end

for i = 1:sn1
    I = im2gray(im2double(ImageCell{i}));

% figure(1),
% subplot(121);
% imhist(I); title('原图直方图');
% subplot(122);
% imshow(I); title('原图灰度图');

%     I0 = edge(I, 'sobel'); %自动选择阈值
%     I1 = edge(I, 'sobel', 0.08); % 指定阈值 0.08
%     I2 = edge(I, 'sobel', 0.02); %指定阈值 0.02
% 
%     figure(i)
%     subplot(221); imshow(I); title('原图');
%     subplot(222); imshow(I0); title('默认阈值');
%     subplot(223); imshow(I1); title('阈值:0.08');
%     subplot(224); imshow(I2); title('阈值:0.02');

%     subplot(221); imhist(I); 
%     subplot(222); imhist(histeq(I));
%     subplot(223); imshow(histeq(I));
%     subplot(224); imshow(histeq(I), []);
end