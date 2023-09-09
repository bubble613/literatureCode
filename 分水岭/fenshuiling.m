rgb = imread('/Users/liwangyang/Desktop/matlab_doc/图片集/lena_std.tif');
I = rgb2gray(rgb);
imshow(I) %读入彩色图像，将其转化成灰度图像

hy = fspecial('sobel');
hx = hy';
Iy = imfilter(double(I), hy, 'replicate');
Ix = imfilter(double(I), hx, 'replicate');
gradmag = sqrt(Ix.^2 + Iy.^2);
figure, imshow(gradmag,[]), title('梯度幅值图像')% 使用梯度级作为细分功能
se = strel('disk', 20);
Io = imopen(I, se);
figure, imshow(Io), title('图像开操作')
Ie = imerode(I, se);
Iobr = imreconstruct(Ie, I);
figure, imshow(Iobr), title('基于开的重建图像') % 直接使用分水岭变换
Ioc = imclose(Io, se);
figure, imshow(Ioc), title('闭操作图像') %消除黑斑和标志干细胞
Iobrd = imdilate(Iobr, se);
Iobrcbr = imreconstruct(imcomplement(Iobrd), imcomplement(Iobr));
Iobrcbr = imcomplement(Iobrcbr);
figure, imshow(Iobrcbr), title('基于重建的开闭操作图像')
fgm = imregionalmax(Iobrcbr);
figure, imshow(fgm), title('腐蚀操作')
I2 = I;
I2(fgm) = 255;
figure, imshow(I2), title('局部极大叠加到原图像')% 去除小瑕疵，使局部极大叠加到原图像上。
se2 = strel(ones(5,5));
fgm2 = imclose(fgm, se2);
fgm3 = imerode(fgm2, se2);
fgm4 = bwareaopen(fgm3, 20);
I3 = I;
I3(fgm4) = 255;
figure, imshow(I3)
title('fgm4 superimposed on original image')% 标记前景对象

figure, imshow(bgm), title('bgm')
gradmag2 = imimposemin(gradmag, bgm | fgm4);
L = watershed(gradmag2);
I4 = I;
I4(imdilate(L == 0, ones(3, 3)) | bgm | fgm4) = 255;
figure, imshow(I4)
title('标记和对象边缘叠加在原始图像')
Lrgb = label2rgb(L, 'jet', 'w', 'shuffle');
figure, imshow(Lrgb)
title('彩色分水岭标记矩阵')
figure, imshow(I), hold on
himage = imshow(Lrgb);
set(himage, 'AlphaData', 0.3);
title('标记矩阵叠加到原图像')