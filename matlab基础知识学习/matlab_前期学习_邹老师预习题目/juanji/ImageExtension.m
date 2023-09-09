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
 
aUp = zeros( fHalfHeight, nI + (fHalfWidht*2) );%
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