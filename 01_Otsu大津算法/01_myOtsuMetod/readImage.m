function [ImageCell, FileNum, num_image] = readImage(FileName, PathName, FilterIndex)
% 不使用
% 读取图像的函数
% 此处文件类型可自行定义
[FileName,PathName,FilterIndex] = uigetfile({'*.tif';'*.txt';'*.jpg'},...
                                         'File Selector','MultiSelect','on'); 

if FilterIndex == 1
    %定义waitbar
    w_load = waitbar(0, 'Please wait...', 'Name', 'Phase load');
    %若只选择一张图片，将图片存入矩阵ImageSingle中
    if (iscell(FileName) == 0) 
        FileNum = 1;
        % ImageSingle = imread(strcat(PathName, FileName));
        ImageCell{1} = imread(strcat(PathName, FileName));
    else
        %若选择多张图片，将多张图片存入元胞数组ImageCell{ }里
        FileNum = length(FileName);
        for num_image = 1 : FileNum
            ImageCell{num_image} = imread(strcat(PathName,FileName{num_image}));
            waitbar(num_image / FileNum, w_load, ...
                strcat('Please wait...', num2str(fix(num_image*100/FileNum)), '%'));
        end
        close (w_load);
    end
end