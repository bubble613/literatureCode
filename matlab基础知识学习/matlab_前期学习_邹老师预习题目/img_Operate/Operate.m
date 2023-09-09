function img = Operate(binimg,str)
%strcmp()判断两个字符串是否相等，若相等返回1，否则为0
if strcmp(str , 'dilate')
    SE = [0 1 0;1 1 1;0 1 0];
    %调用matlab操作膨胀对应的函数
    img = imdilate(binimg,SE);
elseif strcmp(str , 'erode')
    SE = strel('disk',5);
    %调用matlab操作腐蚀对应的函数
    img = imerode(binimg,SE);
elseif strcmp(str ,'open')
    SE = strel('square',5);
    %调用matlab操作开运算对应的函数
    img = imopen(binimg,SE);
elseif strcmp(str ,'close')
    SE = strel('square',5);
    %调用matlab操作闭运算对应的函数
    img = imclose(binimg,SE);
else 
    '操作输入错误';
    img = 0;
    endif
end