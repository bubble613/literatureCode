clc;close;clear;

fig = imread('/Users/liwangyang/Desktop/matlab_doc/图片集/lena_std.tif');
% fig = im2double(fig);

figgray = im2gray(fig);

MethodName='Cluster_Kittler';

T = ThresholdMethod(reshape(double(figgray),[],1),'Method',MethodName);

I4 = imbinarize(mat2gray(figgray), T/255);
imshow(I4);

[P_new,label]=Local_Yanowitz(figgray,...
            hsize,MaxInterNum,InterTreshhold,GradTresh);

%%%%%%%%%一次读取多张图片
% [FileName,PathName,FilterIndex] = uigetfile({'*.tif';'*.txt';'*.jpg'},...
%     'File Selector','MultiSelect','on');  %此处文件类型可自行定义
% if FilterIndex == 1 
%     w_load = waitbar(0,'Please wait...','Name','Phase load'); %定义waitbar
%     if (iscell(FileName) == 0) %若只选择一张图片，将图片存入矩阵ImageSingle中
%         FileNum = 1;
%         ImageSingle = imread(strcat(PathName,FileName));
%     else
%         FileNum = length(FileName);%若选择多张图片，将多张图片存入元胞数组ImageCell{ }里
%         for sn1 = 1:FileNum
%             ImageCell{sn1} = imread(strcat(PathName,FileName{sn1}));
%             waitbar(sn1/FileNum,w_load,strcat('Please wait...',...
%                 num2str(fix(sn1*100/FileNum)),'%'));
%         end
%         close (w_load);
%     end
% end
% for i = 1:sn1
%     fig = im2double(ImageCell{i});
%     figgray = mat2gray(fig);
% 
%     MethodName='Entropy_Kapur';
% 
%     T = Cluster_Threshold(reshape(double(figgray),[],1),'Method',MethodName);
%     
% end