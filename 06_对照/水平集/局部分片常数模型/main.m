clear all; close all; clc;

[filename, pathname] = uigetfile({'*.jpg;*.tif;*.png;*.gif;*.bmp','All Image Files';'*.*','All Files' },'mytitle');
filename = strcat(pathname, filename);

Img=imread(filename); Img=double(Img(:,:,1));
figure(1);
imagesc(Img,[0, 255]); axis off; axis equal; colormap(gray);
%初始化零水平集
c0=2;
bw=roipoly;%手动输入任意多边形
phi0=-c0*bw+c0*(1-bw);
phi=phi0;
figure(2);
imagesc(Img,[0, 255]); axis off; axis equal; colormap(gray); hold on;
contour(phi, [0,0], 'w','LineWidth',2); title('初始零水平集');
%算法相关参数设置
timestep = 0.1;% 时间步长
mu = 1;% 正则化项参数
nu=0.003*255*255;%长度项参数
lambda1=1; lambda2=1;%拟合项参数
epsilon = 1.0;% 光滑Heaviside函数参数

sigma=3.0; % 高斯核尺度参数
K=fspecial('gaussian',round(2*sigma)*2+1,sigma); % 高斯核
iter=10;%内循环次数
max_its=20;%最大迭代次数
its=0;
while (its <= max_its)
    phi_new = RSF_Li(phi,Img,K,nu,timestep,mu,lambda1,lambda2,epsilon,iter);
    if mod(its,2)==0
        figure(3) %-- 中间迭代结果输出
        imagesc(Img,[0, 255]); axis off; axis equal; colormap(gray); hold on;
        contour(phi, [0,0], 'w','LineWidth',2); str=['零水平集第', num2str(its), '次迭代']; title(str);
        pause(1);
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