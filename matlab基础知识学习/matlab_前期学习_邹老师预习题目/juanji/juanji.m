clear,clc;
image = double(rgb2gray(imread('hehua.jpeg')));
[iHeight, iWidth] = size(image);
 
%四个滤波器
k1 = [1, 1, 1;1, 1, 1;1, 1, 1]/9;  %大小3X3的均值滤波器
%filter1 = [ 1, 1; 1, 1 ] * 0.25;
%filter1 = [1, 1, 1;1, 1, 1;1, 1, 1]/9;
% filter2 = [ 1, -1; 1, -1 ];
% filter3 = [ 1, -1; -1,1 ];
% filter4 = [ 1, 1; -1, -1 ];
 
%获取滤波器的长度、宽度、长度的一半、宽度的一半
[fWidth, fHeight, halfWidth, halfHeight ] = FilterRadius( k1 )
 
%根据滤波器的尺寸扩展图像像素
imData = ImageExtension( image, fWidth, fHeight, halfWidth, halfHeight );
%利用第一个滤波器对图像进行卷积
imageConv = ImageConvolution( imData, k1, iHeight, iWidth );
figure(1);  
subplot(121);
imshow( uint8(imData) );  title('原图像');
subplot(122);
imshow( imageConv );  title('卷积后的图像');


%利用第二个滤波器对图像进行卷积
% imageConv = ImageConvolution( image, filter2, iHeight, iWidth );
% figure(3);  imshow( imageConv );
% %利用第三个滤波器对图像进行卷积
% imageConv = ImageConvolution( image, filter3, iHeight, iWidth );
% figure(4);  imshow( imageConv );
% %利用第四个滤波器对图像进行卷积
% imageConv = ImageConvolution( image, filter4, iHeight, iWidth );
% figure(5);  imshow( imageConv );