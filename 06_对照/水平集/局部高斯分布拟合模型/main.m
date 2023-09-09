close all; clear all; clc;

[filename, pathname] = uigetfile({'*.jpg;*.tif;*.png;*.gif;*.bmp','All Image Files';'*.*','All Files' },'mytitle');
filename = strcat(pathname, filename);

Img=imread(filename); Img=double(Img(:,:,1));
figure(1);
imagesc(Img,[0, 255]); colormap(gray); axis off; axis equal

%初始化水平集函数
c0=2;
bw=roipoly;%手动输入任意多边形
phi0=-c0*bw+c0*(1-bw);
phi=phi0;
figure(2);
imagesc(Img,[0, 255]); colormap(gray); axis off; axis equal; hold on;
contour(phi,[0 0], 'w','LineWidth',2); title('初始零水平集');

%相关参数设置
nu=0.006*255^2; %长度项参数
sigma = 5;% 高斯核的尺度参数
iter_inner=10; % 内循环的次数
timestep=.1;% 时间步长
mu=1;% 正则化项参数

epsilon=1;%光滑Heaviside函数参数
K=fspecial('gaussian',round(2*sigma)*2+1,sigma);% 高斯核
max_its=100;%最大迭代次数
its=0;

%主循环体
while (its <= max_its)
    phi_new= LGDF_W(phi,Img, K, nu,timestep,mu,epsilon,iter_inner);
    if mod(its,2)==0
        figure(3) %输出中间迭代结果
        imagesc(Img,[0, 255]); axis off; axis equal; colormap(gray); hold on;
        contour(phi, [0,0], 'w','LineWidth',2);
        str=['零水平集第', num2str(its), '次迭代']; title(str);
    end
    if norm((phi_new-phi),'fro')<0.000001%判断水平集函数是否收敛
        break;
    else
        phi=phi_new; its=its+1;
    end
end

figure(4),
imagesc(Img,[0, 255]); axis off; axis equal; colormap(gray); hold on;
contour(phi_new, [0,0], 'w','LineWidth',2);
str=['最终零水平集共', num2str(its), '次迭代'];
title(str);