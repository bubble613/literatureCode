clc;clear;close all;

img = imread('/Users/liwangyang/Desktop/matlab_doc/图片集/lena_std.tif');

h = imhist(img);
figure,
bar(h);
axis([0 255 0 4000]);
set(gca, 'xtick', 0:100:255);
set(gca, 'ytick', 0:1500:4000);
xlabel('x axis', 'FontSize', 15, 'FontWeight','bold','Color','cyan', 'FontName', 'Monaco');
ylabel('y axis', 'FontSize', 15, 'FontWeight','bold','Color','magenta', 'FontName', 'Monaco');
title('直方图');
legend('频率', 'Color','cyan');