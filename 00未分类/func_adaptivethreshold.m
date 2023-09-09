function bw = func_adaptivethreshold(IM,ws,C,tm)
% 功能：自适应图像分割
% IM－待分割的原始图像　　ｗs平均滤波时的窗口大小
% C 常量 根据经验选择合适的参数
% tm -开关变量 1=中值滤波 0=均值滤波
% bw- 图像分割后的二值图像
% 输入参数处理
if (nargin<3)
    error('You must provide the image IM, the window size ws, and C');
elseif(nargin==3)
        tm=0;
elseif(tm~=0&&tm~=1)
    error('tm must be 0 or 1');
end

IM = double(IM);

if tm == 0
    %图像均值滤波
    mIM = imfilter(IM,fspecial('average', ws), 'replicate'); 
    % replicate数组边界之外的输入数组值假定为等于最近的数组边界值。
    % 平均值滤波器 窗口大小为ws
else
    %图像进行中值滤波
    mIM = medfilt2(IM, [ws,ws]);
end
sIM = mIM - IM -255; % 滤波后的图像 与原图相减
t_otsu = graythresh(mat2gray(IM));
bw = imbinarize(mat2gray(sIM), t_otsu); 
bw = imcomplement(bw); %反转灰度
imshow(bw,[]);
