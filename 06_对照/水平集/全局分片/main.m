clear all; close all; clc;

[filename, pathname] = uigetfile({'*.jpg;*.tif;*.png;*.gif;*.bmp','All Image Files';'*.*','All Files' },'mytitle');
filename = strcat(pathname, filename);

Img=imread(filename); Img=double(Img(:,:,1));
figure(1),
imagesc(Img,[0, 255]); axis off; axis equal; colormap(gray); hold on;

%%水平集函数初始化
c0=2;
bw=roipoly;%手动输入初始零水平集
initialLSF=c0*bw-c0*(1-bw);
phi=initialLSF;
figure(2);
imagesc(Img,[0, 255]); axis off; axis equal; colormap(gray); hold on;
contour(phi, [0,0], 'w','LineWidth',2);
title('初始零水平集');

%相关参数设置
timestep=0.1;%时间步长
epsilon=1;% 光滑Heaviside函数参数
lamda1=1; lamda2=1;%拟合项参数
mu=0.001*255*255;%长度项参数
nu=1;%正则化项参数
max_its=5;%最大迭代次数
iter=10;%内循环次数
its=0;
while (its <= max_its)
    phi_new = CV(phi,Img,timestep,mu,nu,epsilon,lamda1,lamda2,iter);%更新水平集函数
    if mod(its,1)==0
        figure(3); %输出中间迭代结果零水平集
        imagesc(Img,[0, 255]); axis off; axis equal; colormap(gray); hold on;
        contour(phi_new, [0,0], 'w','LineWidth',2);
        str=['零水平集第', num2str(its), '次迭代']; title(str); pause(1);
    end
    if norm((phi_new-phi),'fro')<0.000001 %判断水平集函数是否收敛
        break;
    else
        phi=phi_new; its=its+1;
    end
end

%显示最终分割结果
figure(4);
imagesc(Img,[0, 255]); axis off; axis equal; colormap(gray); hold on;
contour(phi_new, [0,0], 'w','LineWidth',2);
str=['最终零水平集共', num2str(its), '次迭代']; title(str);