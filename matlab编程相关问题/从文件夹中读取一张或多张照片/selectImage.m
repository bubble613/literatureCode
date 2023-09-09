%% 一次读取多张图片

[FileName,PathName,FilterIndex] = uigetfile({'*.tif';'*.txt';'*.jpg'},...
    'File Selector','MultiSelect','on');  %此处文件类型可自行定义
if FilterIndex == 1 
    w_load = waitbar(0,'Please wait...','Name','Phase load'); %定义waitbar
    if (iscell(FileName) == 0) %若只选择一张图片，将图片存入矩阵ImageSingle中
        FileNum = 1;
        ImageSingle = imread(strcat(PathName,FileName));
    else
        FileNum = length(FileName);%若选择多张图片，将多张图片存入元胞数组ImageCell{ }里
        for sn1 = 1:FileNum
            ImageCell{sn1} = imread(strcat(PathName,FileName{sn1}));
            waitbar(sn1/FileNum,w_load,strcat('Please wait...',...
                num2str(fix(sn1*100/FileNum)),'%'));
        end
        close (w_load);
    end
end

%% 对上方读取的照片集中的图片进行一系列操作

for i = 1:sn1
    I = im2gray(im2double(ImageCell{i}));
    
    % 相关图像操作
    
end

%% 从固定文件路径读取某种图片类型，并进行图像操作

file_path =  '/Users/liwangyang/Desktop/matlab_doc/图片集/';% 图像文件夹路径
% filepath = '';
img_path_list = dir(strcat(file_path,'*.bmp'));%获取该文件夹中所有tif格式的图像
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
        fprintf('%d %d %s\n',i, j, strcat(file_path,image_name));% 显示正在处理的图像名
        
        %图像处理过程 省略  
%         figure(j),
%         
%         subplot(221); imhist(I{j}); 
%         subplot(222); imhist(histeq(I{j}));
%         subplot(223); imshow(histeq(I{j}));
%         subplot(224); imshow(histeq(I{j}), []);
        %这里直接可以访问细胞元数据的方式访问数据
        
%         I0 = edge(I{j}, 'sobel'); %自动选择阈值
%         I1 = edge(I{j}, 'sobel', 0.08); % 指定阈值 0.08
%         I2 = edge(I{j}, 'sobel', 0.02); %指定阈值 0.02

%         figure(j)
%         subplot(221); imshow(I{j}); title('原图');
%         subplot(222); imshow(I0); title('默认阈值');
%         subplot(223); imshow(I1); title('阈值:0.08');
%         subplot(224); imshow(I2); title('阈值:0.02');
        
    end
end