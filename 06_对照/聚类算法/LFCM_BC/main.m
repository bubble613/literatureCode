clc;clear all;close all;

[filename, pathname] = uigetfile({'*.jpg;*.tif;*.png;*.gif;*.bmp','All Image Files';'*.*','All Files' },'mytitle');
filename = strcat(pathname, filename);

Img=imread(filename);
Img=double(Img(:,:,1));
Img_log=log(Img+1+eps);%图像对数变换
[nx,ny]=size(Img);
clust_n = input('Input the Number to be clustered\n');%命令窗口输入总的聚类子类个数
b0=0.01*ones(nx,ny);%初始化偏移场
%初始化类隶属度
pm=initfcm(clust_n,nx*ny);
U0=zeros(nx,ny,clust_n);

for i=1:clust_n
    U0(:,:,i)=reshape(pm(i,:),nx,ny);
end

Ksize=15;%局部邻域尺寸
sigma=4;%核函数标准差
K=fspecial('gaussian',Ksize,sigma);%高斯截断核函数
C0=log(256)*rand(1,clust_n);%初始化聚类中心
U=U0; C=C0; b=b0; iter=300;%最大迭代次数

while iter
    [C_new,b_new,U_new]=LFCM_BC(Img_log,K,U,b,clust_n);%调用局部FCM自定义子函数
    if max(abs(C_new-C))<0.0001
        Uopt=U_new; Copt=C_new; bopt=b_new; break;
    else
        U=U_new; b=b_new; C=C_new; iter=iter-1;
    end
end

figure(1),
subplot(2,3,1); imshow(Img,[]);

for i=1:clust_n
    compo=U_new(:,:,i)>=0.5;
    subplot(2,3,i+1); imshow(compo,[])
    title(['图像分割第' int2str(i) '子类'])
end

figure(2),
imagesc(exp(b_new)); colormap(gray); axis off; axis equal; title('偏移场');
Img_corrected=exp(Img_log-b_new);
figure(3);
imagesc(Img_corrected); colormap(gray); axis off; axis equal; title('偏移场校正图像');