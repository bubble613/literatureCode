clc; clear; close all;

[filename, pathname] = uigetfile({'*.jpg;*.tif;*.png;*.gif;*.bmp','All Image Files';'*.*','All Files' },'mytitle');
filename = strcat(pathname, filename);

Img = imread(filename);
Img = double(Img(:,:,1));
[nx,ny] = size(Img);
figure,
subplot(2,3,1); imshow(Img,[]); title('待分割图像');
clust_n = input('Input the Number to be clustered\n'); % 命令窗口输入总的聚类子类个数

%类隶属度随机初始化
pm = initfcm(clust_n, nx * ny);
U0 = zeros(nx, ny, clust_n);
for i = 1 : clust_n
    U0(:,:,i) = reshape(pm(i, :), nx, ny);
end
V0 = 255 * rand(1, clust_n);%聚类中心随机初始化
iter = 1000;%算法最大迭代次数
sigma = 150;%核函数宽度
U = U0; V = V0;

while iter
    [V_new, U_new] = KFCM(Img, U, V, sigma, clust_n);%调用核化FCM算法子函数程序
    if norm(V_new-V, 'fro') < 0.001
        Uopt = U_new;
        Vopt = V_new;
        break;
    else
        U = U_new;
        V = V_new;
        iter = iter - 1;
    end
end
%显示图像分割结果
for i = 1:clust_n
    compo = U_new(:,:,i);
    compo = (compo>=0.5);%去模糊处理
    subplot(2,3,i+1); imshow(compo,[]); title(['图像分割第' int2str(i) '子类'])
end
