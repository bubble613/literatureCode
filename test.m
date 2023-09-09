clc;
clear;
%% 导入原图
% 指定图像库路径
imgPath = '/Users/liwangyang/Desktop/研究生-图像分割/数据集/BSDS500/BSDS500/data/groundTruth'; 
% 指定需要加载的文件格式：jpg
imgDir  = dir([imgPath '*.jpg']);

%% 导入原图groundtruth图像
% 指定groundtruth图像库路径
% gtPath = 'E:/科研/科研学习/第一篇论文撰写实验数据/论文实验图像数据/06-实验三/皮肤痣分割实验/09-真实图像/';
% 指定需要加载的文件格式：jpg
% gtDir = dir([gtPath '*.jpg']);

%% 遍历图像库分割图像
% 遍历整个图像库，顺序以文件夹的排序为准
for i = 1 : length(imgDir)
    % 读取图像，注意在文件名相同的情形下读入gt，
    img = imread([imgPath imgDir(i).name]);
    % gt = imread([gtPath gtDir(i).name]);
    
    % 过滤掉灰度图像，根据条件可以过滤掉彩色图像，看你们的需求
    % if size(img,3) == 1
    %     continue;
    % end
    
    % 获取文件名作为分割后图像保存的文件名
    name = imgDir(i).name;
    % 分割函数，即你们的分割方法，需要对其进行参数输出设置
    [Label01, Label02, time] = main(img);
    
    % 关闭显示的图像
    close all;
    
    % 写入excel文件
    xlswrite('ECT分割数据02.xlsx',[time, ME, SSIMVALUE],['A',num2str(i),':C',num2str(i)]);
    
    % 保存分割的图像
    imwrite(Label01, strcat('ECT掩膜分割01/',name));
    imwrite(Label02, strcat('ECT掩膜分割02/',name));
end
