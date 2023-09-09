function [ DataBaseFeatures ] = HistFeatureExtraction( NumOfImg,FileName )
% UNTITLED2 此处显示有关此函数的摘要
% 
% 此处显示详细说明
ImagePath = 'imagepath';% 图像文件夹路径 
DATA=xlsread('数据（对应检索图片库）.xlsx');
NumOfImg=92;
for n =1:NumOfImg
     FileName=['',num2str(n),'.bmp'];
     ImageRead = imread([ImagePath,FileName]);
     ImageRead = ImageRead(:,:,1:3);          %读取图像RGB值
     ImageRead = rgb2gray(ImageRead);         %灰度化图像
     [Count,x] = imhist(ImageRead);           %提取直方图
     DataBaseFeatures{n,1}=FileName;
     DataBaseFeatures{n,2}=Count;             %用元胞数组储存特征
     DataBaseFeatures{n,3}=DATA(n,1);
end
    save('HISTFeatures.mat','DataBaseFeatures');  %保存特征为数据文件
end
% 得到所有图像历史特征数据库的代码