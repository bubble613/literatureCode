clc;
close all;
X = imread('q1.tif');%             读取图像
Y=imread('q2.tif');
figure;%                           展示图像
subplot(1, 3, 1); imshow(X); title('q1');
subplot(1, 3, 2); imshow(Y); title('q2');
%                                  使得图像每个像素值为浮点型
X = double(X);
Y = double(Y);
 
A = Y-X;
B = X.*Y;
subplot(1,3,3);imshow(A);title('作差');
MSE = sum(A(:).*A(:))/numel(Y);%  均方根误差MSE，numel()函数返回矩阵元素个数
SNR = 10*log10(sum(X(:).*X(:))/MSE/numel(Y));%信噪比SNR
PSNR = 10*log10(255^2/MSE);%      峰值信噪比PSNR
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%以下为结构相似度SSIM
ux=sum(X(:).*X(:))/numel(X);
uy=sum(Y(:).*Y(:))/numel(Y);
sigmoidx=sum(X(:).*X(:)-ux)/numel(X);
sigmoidy=sum(Y(:).*Y(:)-uy)/numel(Y);
sigmoidxy=sum(B(:).*B(:))/(numel(B)*ux*uy)-ux*uy;
SSIM=(2*ux*uy)*(2*sigmoidxy)/(ux*ux+uy*uy)/(sigmoidx*sigmoidx+sigmoidy*sigmoidy);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
display(MSE);%均方根误差MSE
display(SNR);%信噪比SNR
display(PSNR);%峰值信噪比PSNR
display(SSIM);%结构相似性SSIM