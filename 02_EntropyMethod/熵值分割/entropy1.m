clear;clc;
Imag = imread('rice.png');
[X, Y] = size(Imag);
figure ();
imhist(Imag); 
% 计算图像直方图
hist = imhist(Imag);
p = hist/(X*Y); % 各灰度概率
 
sumP = cumsum(p);
sumQ = 1-sumP;
 
%将256个灰度作为256个分割阈值，分别计算各阈值下的概率密度函数
c0 = zeros(256,256);
c1 = zeros(256,256);
for i = 1:256
    for j = 1:i
        if sumP(i) > 0
            c0(i,j) = p(j)/sumP(i); %计算各个阈值下的前景概率密度函数
        else
            c0(i,j) = 0;
        end
        for k = i+1:256
            if sumQ(i) > 0;
                c1(i,k) = p(k)/sumQ(i); %计算各个阈值下的背景概率密度函数
            else
                c1(i,k) = 0;
            end
        end
    end 
end
 
%计算各个阈值下的前景和背景像素的累计熵
H0 = zeros(256,256);
H1 = zeros(256,256);
for i = 1:256
   for j = 1:i
       if c0(i,j) ~=0
           H0(i,j) =  - c0(i,j).*log10(c0(i,j));  %计算各个阈值下的前景熵
       end
       for k = i+1:256
          if c1(i,k) ~=0
              H1(i,k) =  -c1(i,k).*log10(c1(i,k));  %计算各个阈值下的背景熵
          end
       end
   end  
end
HH0 = sum(H0,2);
HH1 = sum(H1,2);
H = HH0 + HH1; 
[value, Threshold] = max(H);
 
BW = im2bw(Imag, Threshold/255);
figure ();
imshow(BW);
xlabel(['最大熵', num2str(Threshold)]);