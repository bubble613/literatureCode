%----------------------------------------- 
%      键盘字符识别
%----------------------------------------
warning off %执行时有时会出现警告，关掉警告
clc, close all, clear all %clc清空命令行窗口；close all关闭所有的Figure窗口；clear all清除工作空间的所有变量，（函数，和MEX文件）
% 读入图像
imagen=imread('7.jpg');%结尾加分号可是读取的数据直接保存进变量，不用显示在命令行窗口
% 显示图像
figure,imshow(imagen);%主要是为了防止imshow自动覆盖了当前的figure窗口，如果imshow前面加上了figure可以另取一个独立的figure窗口来显示图像
title('输入图像')
% 转换为灰度图像
if size(imagen,3)==3 %返回m第三个维度的长度，并赋值给num，如果m的维度等于3则返回1。 判断图片是否为真彩图（Truecolor image）。图像数据分成两类：一类是真彩图，对应的三维数组，其中前两维为图像的高度和宽度，第三维则分别为RGB（红绿蓝）三种基色的值，所以长度必然为3。
    imagen=rgb2gray(imagen);%I = rgb2gray(RGB)，意思是将真彩色图像RGB转换为灰度强度图像I 。
end
% 二值化
%图像二值化（ Image Binarization）就是将图像上的像素点的灰度值设置为0或255，也就是将整个图像呈现出明显的黑白效果的过程。在数字图像处理中，二值图像占有非常重要的地位，图像的二值化使图像中数据量大为减少，从而能凸显出目标的轮廓。
g_max=double(max(max(imagen))); %G3是个二维，max(G3)是对G3的每一列求最大，(max(max(G3)))就是求二维G3中最大的数
g_min=double(min(min(imagen))); %在自然中每一种颜色都有一个值，通常由RGB（即红、绿、蓝三原色）按比例混合就会得到各种不同的颜色。阈值处理图片是对颜色进行特殊处理的一种方法。
T=round(g_max-(g_max-g_min)/3);%round的功能为四舍五入 %最佳阈值二值化，灰度的最大值减去（最大值与最下值的1/3梯度）。详细说，阈值是一个转换临界点，不管你的图片是什么样的彩色，它最终都会把图片当黑白图片处理，也就是说你设定了一个阈值之后，它会以此值作标准，凡是比该值大的颜色就会转换成白色，低于该值的颜色就转换成黑色，所以最后的结果是，你得到一张黑白的图片。
[a,b]=size(imagen);%imagen为三维，a为imagen的第一维，b为imagen的第二维
imagen=im2bw(imagen,T/256);%把灰度图像变为二值图像，T/256作为参考值，如果imagen大于imagen*(T/256)，则为255，反之为0。BW = im2bw(I, level)，level范围为(0,1)
figure,imshow(imagen);
title('分割后图像')
% 删除小面积对象
imagen = bwareaopen(imagen,150);%BW2 = bwareaopen(BW,P,conn)，删除二值图像BW中面积小于P的对象，默认情况下conn使用8邻域。消除0.
figure,imshow(imagen);
title('删除小面积对象后')
%储存图像矩阵
word=[ ];
re=imagen;
%载入模板
load templates
global templates %global定义全局变量，在不同的m文件中值都是一样，但是在不同的m文件中，都需要定义。
% 计算模板文件中的字母数
num_letras=size(templates,2);
while 1%ctrl+c退出正在运行
    %分行
  
    %-----------------------------------------------------------------     
    % 标记和计数连接的组件
    [L Ne] = bwlabel(imgn);%[L,num] = bwlabel(BW,n)这里num返回的就是BW中连通区域的个数。返回一个和BW大小相同的L矩阵。n的值为4或8，表示是按4连通寻找区域，还是8连通寻找，默认为8
    for n=1:Ne
        [r,c] = find(L==n);
        % 提取字母
        n1=imgn(min(r):max(r),min(c):max(c));% min(r)行到max(r)行,min(c)行到max(c)行
        % 调整字母大小（相同大小的模板）
        img_r=imresize(n1,[42 24]);%对图形进行缩放
        %-------------------------------------------------------------------
        % 调用fcn将图像转换为文本
        letter=read_letter(img_r,num_letras);%将图片中字母提取出来并经过缩放后的数据，将与数据库中作对比后相似的字符写出来
        % 字母连接
        word=[word letter];
    end
    function letter=read_letter(imagn,num_letras)
%计算模板和输入图像之间的相关性，其输出是包含字母的字符串
% “imagn”的大小必须为42 x 24像素
% Example:
% imagn=imread('D.bmp');
% letter=read_letter(imagn)
global templates
comp=[ ];
for n=1:num_letras
    sem=corr2(templates{1,n},imagn);%分块矩阵调用，用{}；corr2()是求两个矩阵相似度的函数，两个矩阵越相似，值越大，最大为1。（有时为相同时为NaN）
    comp=[comp sem];%矩阵相加
end
vd=find(comp==max(comp));%comp=[1 2 3 4 5 6 7 8];vd=find(comp==max(comp));返回值vd =8
%*-*-*-*-*-*-*-*-*-*-*-*-*-
letter=[A B C D E F G H I J K L M...
    N O P Q R S T U V W X Y Z];%一般在编辑器里一行代码太长写不下了，用...表示续行，下一行的代码和上一行是连着的。但在字符串里不能这样。
number=[one two three four five...
    six seven eight nine zero];
character=[letter number];
templates=mat2cell(character,42,[24 24 24 24 24 24 24 ...%数字后面换行空格加三点，字母后面换行不用空格加三点
    24 24 24 24 24 24 24 ...
    24 24 24 24 24 24 24 ...
    24 24 24 24 24 24 24 ...
    24 24 24 24 24 24 24 24]);%mat2cell矩阵啊分块函数，在mat2cell函数中，有三个参数，第一个参数是想要分解的矩阵，第二个和第三个参数一般都是集合的形式，表示分解的尺度。
save ('templates','templates')%直接在文件夹中生成templates目录。前面那个templates是是文件名。