%自编的高斯滤波函数，S是需要滤波的图象，n是均值，k是方差
function d=gaussfilt(k,n,s)
Img = double(s); 
n1=floor((n+1)/2);%计算图象中心 
for i=1:n 
    for j=1:n 
        b(i,j) =exp(-((i-n1)^2+(j-n1)^2)/(4*k))/(4*pi*k); 
    end
end
%生成高斯序列b。 
Img1=conv2(Img,b,'same'); 
%用生成的高斯序列卷积运算，进行高斯滤波 
d=uint8(Img1);