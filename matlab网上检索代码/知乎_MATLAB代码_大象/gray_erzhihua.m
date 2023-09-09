% 

clc, clear, close all

number_Image = 1; %用于处理的原图像编号.
mkdir image; %新建子文件夹.
addpath(genpath(pwd)); %将所有子文件夹添加到路径中.

OriginalImage = imread(['image',num2str(number_Image),'.png']);
figure
subplot(211),imshow(OriginalImage),title('OriginalImage');
hsvImage = rgb2hsv(OriginalImage);  %彩色图像转HSV以消除亮度和背景的影响.
subplot(212),imshow(hsvImage),title('HsvImage');
hsv1 = hsvImage(:,:,1);
hsv2 = hsvImage(:,:,2);
hsv3 = hsvImage(:,:,3);
figure  %显示HSV三层图像
subplot(311),imshow(hsv1),title('Hsv1');
subplot(312),imshow(hsv2),title('Hsv2');
subplot(313),imshow(hsv3),title('Hsv3');
[m, n] = size(hsv1);
d1 = zeros(m, n); 
d2 = zeros(m, n);
for i = 1:m
    for j = 1:n
        if hsv3(i, j)<0.7  %hsv3层用来提取数字
            d1(i, j) = 1;
        else 
            d1(i, j) = 0;
        end
        if hsv2(i, j)>0.7  %hsv2层用来提取方格
            d2(i, j) = 1;
        else 
            d2(i, j) = 0;
        end
    end
end
figure
% subplot(211),imshow(d2);
bw1 = logical(d1);%double转logical型.
thinImage = bwmorph(bw1, 'thin', Inf); %提取骨架.
cleanImage = bwmorph(thinImage, 'clean', Inf); %去除孤立点.
subplot(311),imshow(bw1),title('logicalImage of hsv2');
subplot(312),imshow(thinImage),title('thinImage');
subplot(313),imshow(cleanImage),title('cleanImage');
% SpurImage = bwmorph(g,'spur',3); %去毛刺.
% figure 
% imshow(SpurImage);
sum_rows = zeros(m,1);
sum_columns = zeros(1,n);
for i = 1:m
    for j = 1:n
        if d2(i,j)==1
            sum_rows(i) = sum_rows(i) + 1;
        end
    end
end
boundary_rows_up = find(sum_rows>0, 1, 'first'); %上边界行标.
boundary_rows_down = find(sum_rows>0, 1, 'last' ); %下边界行标.
height = boundary_rows_down - boundary_rows_up +1; %方格高度.

for i = 1:n
    for j = 1:m
        if d2(j,i)==1
            sum_columns(i) = sum_columns(i) + 1;
        end
    end
end
boundary = zeros(m,n); %粗提左右边框
for i = boundary_rows_up:boundary_rows_down
    for j = 1:n
        if sum_columns(j)>m/2
            boundary(i,j) = 1;
        end
    end
end
thinImage_boundary = bwmorph(boundary, 'thin', Inf); %提取左右边框骨架.

n_boundary_c = zeros(1,n); %设立零矩阵存放图像每列的和.
for i = 1:n
    for j = 1:m
        if thinImage_boundary(j,i)==1
            n_boundary_c(i) =  n_boundary_c(i) + 1;
        end
    end
end
boundary_columns = find(n_boundary_c>0);  %提取方格左右边界.
% len = size(boundary_columns); %必有12条边界
sum_boundary = 0; %求方格宽度.
for i = 1:12
    if mod(i,2)==0
        sum_boundary = sum_boundary + boundary_columns(i) - boundary_columns(i-1);
    end
end
width = ceil(sum_boundary/6); %求平均宽度并向上取整.
 
%提取每个方格并显示.
figure
for i = 1:12 %从原图中提取每个方格数据.
    if mod(i,2)==1
        ExtractImage(:, :, (i+1)/2) = OriginalImage(boundary_rows_up:boundary_rows_down, boundary_columns(i):boundary_columns(i)+width);   
    end
end
for i = 1:6
    subplot(3,2,i); imshow(ExtractImage(:, :, i)); title(['number',num2str(i)]);
    BwImage_etc = ~im2bw(ExtractImage(:, :, i),0.7); %灰度图像二值化.
    ThinImage_etc = bwmorph(BwImage_etc, 'thin', Inf); %提取骨架.
%     SpurImage_etc = bwmorph(ThinImage_etc,'spur',4); %去毛刺.
    CleanImage_etc(:,:,i) = bwmorph(ThinImage_etc, 'clean'); %移除孤立点,若去毛刺则将ThinImage_etc改为SpurImage_etc.
    imwrite(CleanImage_etc(:,:,i), ['image/n',num2str(i),'.tif']);
end
function [dir,n] = connex(x1,x2) %x1为数字图,x2为端点图
[end_r,end_c] = find(x2==1); %看端点位置.
n = length(end_r);
dir = zeros(1,n);

end
end