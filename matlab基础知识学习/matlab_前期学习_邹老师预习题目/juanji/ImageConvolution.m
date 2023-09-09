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
        localImage = zeros(mF,nF);
        localImage = image(i:i+mF-1, j:j+nF-1);
        convImge(i, j) = Dot2D( localImage, filter );
    end
end
imageConv = uint8( convImge );