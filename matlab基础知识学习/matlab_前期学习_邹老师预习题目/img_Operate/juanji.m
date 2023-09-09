
function [ mF, nF, half_mF, half_nF ] = FilterRadius( filter )
%功能：
%   获取滤波器的维数信息
%输入参数： 
%   filter：滤波器
%输出参数： 
%   mF：高度
%   nF：宽度
%   half_mF：高度一半
%   half_nF：宽度一半
[mF, nF] = size( filter );
half_mF = mF / 2;
half_nF = nF / 2;
 
 
function imData = ImageExtension( image, fWidth, fHeight, fHalfWidht, fHalfHeight )
%功能：
%   在图像的四周扩展像素，得到扩展的图像，以方便图像卷积运算后图像的维数不变
%   扩展的图像像素值均为0
%输入参数：
%   image：图像数据
%   fWidth：滤波器的宽度
%   fHeight：滤波器的高度
%   fHalfWidht：滤波器的宽度的一半
%   fHalfHeight：滤波器的高度度的一半
%输出参数：
%   imData：扩展后的图像数据
 
[mI, nI] = size( image );
tempImage = zeros( mI + fHeight, nI + fWidth );
 
aUp = zeros( fHalfHeight, nI + fWidth );%
aLeft = zeros( mI, fHalfWidht );        %
aMiddle = [aLeft, image, aLeft];        %
tempImage = [aUp; aMiddle; aUp];        %扩展之后的图像数据
 
imData = tempImage;
 
 
%扩展之后的图像示意图：
%中间 ‘|’ 表示原始图像
%四周 ‘0’ 表示增加的数据
%00000000000000000000000000%
%00||||||||||||||||||||||00%
%00||||||||||||||||||||||00%
%00||||||||||||||||||||||00%
%00||||||||||||||||||||||00%
%00||||||||||||||||||||||00%
%00||||||||||||||||||||||00%
%00||||||||||||||||||||||00%
%00||||||||||||||||||||||00%
%00000000000000000000000000%
%00000000000000000000000000%
 
function result = Dot2D( localImage, filter )
%图像局部数据与滤波器的内积
result = sum( sum( localImage .* filter ) );
if result < 0
    result = -result;
elseif result > 255
    result = 255;
end
 
function imageConv = ImageConvolution( image, filter, initialHeight, intitialWidth )
%功能：
%   图像的卷积运算
%输入参数： 
%   image：扩展后的图像
%   filter：滤波器
%   initialHeight：原图像的高度
%   intitialWidth：原图像的宽度
%输出参数： 
%   imageConv：卷积后的图像
mI = initialHeight;
nI = intitialWidth;
[mF, nF] = size( filter );
 
convImage = zeros(mI, nI);
for i = 1:mI-1
    for j = 1:nI-1
        localImage = [];
        localImage = image(i:i+mF-1, j:j+nF-1);
        convImge(i, j) = Dot2D( localImage, filter );
    end
end
imageConv = uint8( convImge );
 
 
clear,clc;
image = double(rgb2gray(imread('hehua.jpeg')));
[iHeight, iWidth] = size(image);
 
%四个滤波器
filter1 = [ 1, 1; 1, 1 ] * 0.25;
filter2 = [ 1, -1; 1, -1 ];
filter3 = [ 1, -1; -1,1 ];
filter4 = [ 1, 1; -1, -1 ];
 
%获取滤波器的长度、宽度、长度的一半、宽度的一半
[fWidth, fHeight, halfWidth, halfHeight ] = FilterRadius( filter1 )
 
%根据滤波器的尺寸扩展图像像素
imData = ImageExtension( image, fWidth, fHeight, halfWidth, halfHeight );
figure(1);imshow( uint8(imData) ); 
%利用第一个滤波器对图像进行卷积
imageConv = ImageConvolution( image, filter1, iHeight, iWidth );
figure(2);  imshow( imageConv );
%利用第二个滤波器对图像进行卷积
imageConv = ImageConvolution( image, filter2, iHeight, iWidth );
figure(3);  imshow( imageConv );
%利用第三个滤波器对图像进行卷积
imageConv = ImageConvolution( image, filter3, iHeight, iWidth );
figure(4);  imshow( imageConv );
%利用第四个滤波器对图像进行卷积
imageConv = ImageConvolution( image, filter4, iHeight, iWidth );
figure(5);  imshow( imageConv );