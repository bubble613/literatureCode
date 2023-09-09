% 功能：填充图像或填充数组
% B = padarray(A,padsize,padval,direction);
%{
% A为输入图像，B为填充后的图像，padsize给出了给出了填充的行数和列数，通常用[r c]来表示。
% padval和direction分别表示填充方法和方向。它们的具体值和描述如下：

padval：

    'symmetric'表示图像大小通过围绕边界进行镜像反射来扩展；
    'replicate'表示图像大小通过复制外边界中的值来扩展；
    'circular'图像大小通过将图像看成是一个二维周期函数的一个周期来进行扩展。
direction：

    'pre'表示在每一维的第一个元素前填充；
    'post'表示在每一维的最后一个元素后填充；
    'both'表示在每一维的第一个元素前和最后一个元素后填充，此项为默认值。
若参量中不包括`direction，则默认值为'both'。

若参量中不包括任何参数，则默认填充为零且方向为'both'。

在计算结束时，图像会被修剪成原始大小。
%}

A = [3, 4, 1; 2,5 , 6 ];
B = padarray(A,[3 4],'replicate','pre');
