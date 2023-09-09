function [] = func_hist(name)
% 输入要读取的图像文件名 返回原始图像的灰度图和灰度直方图

img = imread(name);

% 灰度化
if ndims(img) == 3
    img = rgb2gray(img);
else
    img = img;
end

row = size(img, 1);  % 行
column = size(img, 2); %列 
N = zeros(1, 256); % N是1*256的行向量
for i = 1:row
   for j = 1:column
      k = img(i, j); 
      N(k+1) = N(k+1) + 1; 
   end
end
subplot(121), imshow(img); 
subplot(122), bar(N);  %绘制直方图
axis tight; % 使坐标系的最大值和最小值和你的数据范围一致