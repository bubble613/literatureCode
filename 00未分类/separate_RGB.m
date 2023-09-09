
clc;close;clear;
im = imread('/Users/liwangyang/Desktop/matlab_doc/图片集/lena_std.tif');
% im=imread(str);  

imshow(im);  
 
%图像处理部分

r=im(:,:,1);
imshow(r); 

g=im(:,:,2);
imshow(g);

b=im(:,:,3);
imshow(b);

% 调整RGB值
global R
global G
global B
global val1
global val2
global val3

% val1=get(hObject,'Value');
% val2=get(hObject,'Value');
% val3=get(hObject,'Value');

val1 = 0.5; val2 = 0.5; val3 = 0.5;
imshow(val1*R);

imshow(val2*G);

imshow(val3*B);

I=cat(3,val1*R,val2*G,val3*B);
imshow(I);