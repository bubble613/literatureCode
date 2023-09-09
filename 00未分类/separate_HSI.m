
global H
global S
global I
im = imread('/Users/liwangyang/Desktop/matlab_doc/图片集/lena_std.tif');
% im=imread(str);

imshow(im);
im = im2double(im);
r = im(:, :, 1);
g = im(:, :, 2);
b = im(:, :, 3);

%I
I = (r + g + b)/3;
%S
tmp1 = min(min(r, g), b);
tmp2 = r + g + b;
tmp2(tmp2 == 0) = eps;
S = 1 - 3.*tmp1./tmp2;
%H
tmp1 = 0.5*((r - g) + (r - b));
tmp2 = sqrt((r - g).^2 + (r - b).*(g - b));
theta = acos(tmp1./(tmp2 + eps));
H = theta;
H(b > g) = 2*pi - H(b > g);
H = H/(2*pi);
H(S == 0) = 0;

T = cat(3,H,S,I); % HSI模型图像
imshow(T);