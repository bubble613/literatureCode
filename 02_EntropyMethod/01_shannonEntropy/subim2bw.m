function [imgbw] = subim2bw(img, threshold)
%{
函数说明： 二值化处理函数
参数说明： 
	img：待二值化处理的图像
	threshold：阈值
返回值说明：
    imgbw：分割后的二值图像
---------------------------------------------------------------------------

调用示例：[imgbw] = subim2bw(img, threshold)
%}
    imgbw = false(size(img));  % 将整幅输入的图像全部置为0/False
    imgbw(img > threshold) = true;  % 图像矩阵的像素值大于阈值的置为1/True