%%% 颜色特征区域的提取
%选取S分量
clc;clear;close;

img = imread('/Users/liwangyang/Desktop/matlab_doc/图片集/lena_std.tif');
img = im2double(img);
r = img(:, :, 1);
g = img(:, :, 2);
b = img(:, :, 3);
tmp1 = min(min(r, g), b);
tmp2 = r + g + b;
tmp2(tmp2 == 0) = eps;
S = 1 - 3 .* tmp1 ./ tmp2;
%阈值分割
level = graythresh(S);%使用最大类间方差法找到图片的一个合适的阈值
BW = im2bw(S,level); %Otsu阈值进行分割 
%滤波
x = medfilt2(BW, [5 5], 'symmetric');%中值滤波
%中心点坐标
Ibw = bwareaopen(x, 100);%删除二值图像x中面积小于100的连通对象
hold on;
[L, m] = bwlabel(Ibw,8);%标注二进制图像中连通部分
stats = regionprops(L,'Centroid');%求质心 
centroids = cat(1, stats.Centroid);%获取每个连通域的质心坐标值
a = centroids(:,1);  %将质心坐标值x赋给a
b = centroids(:,2);  %将质心坐标值y赋给b
c = a(a>600&a<700&b>600&b<700);
d = b(a>600&a<700&b>600&b<700);
for i=1:m
    plot(c,d,'R+');
end
hold off;
%截取128×128的图片
[height,width]=size(x);
m=width/10; %剪切图像显示区域的1/x（以图像中心向四周剪切）
n=height/7.5;
rect=[c-m/2 d-n/2 m n];%计算裁剪区域：(以图像中心点为裁剪中心)
% f = imcrop(BW, rect);% 用imcrop裁剪

% imshow(f);
% set(handles.axes2,'units','pixels');
% pos=get(handles.axes2,'pos');
% pos(3:4)=[128 128];
% set(handles.axes2,'pos',pos);

R=mean(r(:)); %计算RGB三个矩阵的均值
G=mean(g(:));
B=mean(b(:));
H=mean(H(:)); %计算HSI三个矩阵的均值
S=mean(S(:));
I=mean(I(:));
