%% 
% [length, width] = size(img);
% tag1 = mod(length, 2);
% tag2 = mod(width, 2);
% if tag
%     me =
% else
%     me = 
% end


%% function MisclassificationError
% clc;clear;close;
% fig = imread('/Users/liwangyang/Desktop/matlab_doc/ͼƬ��/lena_std.tif');
% fig = im2double(fig);
[fileName,pathName] = uigetfile({'*.*';'*.jpg';'*.*'},'File Selector');
fileName = strcat(pathName,fileName);
standard = imread(fileName);

% figgray = im2gray(fig);
% otsu = graythresh(figgray);
% t_otsu = otsu * 255;
% standard = imbinarize(figgray);
segImage1 = binaryImg;
segImage2 = binaryImg2;
segImage3 = binaryImg3;

ME1 = MisclassificationError(standard, segImage1);
ME2 = MisclassificationError(standard, segImage2);
ME3 = MisclassificationError(standard, segImage3);

function [ME] = MisclassificationError(groundtruthImage, segmentedImage)
% ����˵����Misclassification error (��ָ����
% ����˵����
%   groundtruthImage��ԭʼͼ�� BO+FO
%   segmentedImage���ָ�õ�ͼ�񣨲���ͼ�� 
% ����ֵ˵����
%   ME����ָ������
%----------------------------------------------------------------------------------

% ����ʾ����[ME] = MisclassificationError(groundtruthImage, segmentedImage)
    ME = 1 - (nnz(~groundtruthImage & ~segmentedImage) + ...
        nnz(groundtruthImage & segmentedImage)) / numel(groundtruthImage);
end
%% 
% function [ME] = MisclassificationError(standardImage, segImage)
% % ����˵����Misclassification error (��ָ����
% % ����˵����
% %   groundtruthImage��ԭʼͼ�� BO+FO
% %   segmentedImage���ָ�õ�ͼ�񣨲���ͼ�� 
% % ����ֵ˵����
% %   ME����ָ������
% %----------------------------------------------------------------------------------
% 
% % ����ʾ����[ME] = MisclassificationError(groundtruthImage, segmentedImage)
%     ME = 1 - (nnz(~standardImage & ~segImage) + ...
%         nnz(standardImage & segImage)) / numel(standardImage);
%     [m, n] = size(segImage);
% end
