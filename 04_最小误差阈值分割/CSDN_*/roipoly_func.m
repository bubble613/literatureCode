clear;
clc;

I = imread('hehua.jpeg');

% 灰度化
if ndims(I) == 3
    I = rgb2gray(I);
else
    I = I;
end

c = [222 272 300 270 221 194];
r = [21 21 75 121 121 75];
BW = roipoly(I,c,r);
figure, imshow(I), figure, imshow(BW)

Imag = I(:,:,1);

% func_hist('hehua.jpeg')
% 
% c = [500 800 1000 800 500 300];
% 
% r = [300 300 550 800 800 550];
% 
% BW = roipoly(I,c,r);
% 
% figure, imshow(BW);
% 
% phi=2*2*(0.5-BW);
% 
% figure;
% imagesc(Imag,[0,255]);
% colormap(gray);
% 
% hold on
% axis off;
% axis equal;
% 
% [c,h] = contour(phi,[0 0],'r');
% 
% hold off;

% figure;
% imagesc(Imag,[0,255]);
% colormap(gray);
% 
% hold on
% axis off;
% axis equal;
% 
% text(150,60,'Left click to get points, right click to get end point','FontSize',[12],'Color', 'r');
% 
% BW=roipoly;
% 
% phi=2*2*(0.5-BW);
% 
% hold on;
% [c,h] = contour(phi,[0 0],'r');
% hold off;
% 
% [B,c,r]=roipoly;


