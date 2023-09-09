function result = Dot2D( localImage, filter )
%图像局部数据与滤波器的内积
result = sum( sum( localImage .* filter ) );
if result < 0
    result = -result;
elseif result > 255
    result = 255;
end