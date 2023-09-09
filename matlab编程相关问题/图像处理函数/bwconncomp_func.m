% bwconncomp函数

CC = bwconncomp(imgbw,4);	% imgbw为二值化后的图像
%{
CC中返回内容:

    Connectivity: 4   --> 4连通
    ImageSize: [5 5]  -> 图像大小
    NumObjects: 3     -> 找到连通区域数量
    PixelIdxList:    -->连通区域序索引列号
%}