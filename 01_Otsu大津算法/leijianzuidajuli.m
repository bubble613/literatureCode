clc;clear;close;

I = rgb2gray(imread('/Users/liwangyang/Desktop/matlab_doc/图片集/lena_std.tif'));%转换为灰度图像 
I = double(I); 
[m, n] = size(I); 
[t_otsu, em] = graythresh(mat2gray(I));

Smax = 0; 
for T = 0:255              
    sum1 = 0; num1 = 0;                   
    sum2 = 0; num2 = 0;                    
    for i = 1:m       
        for j = 1:n      
            if I(i, j) >= T  
                sum2 = sum2 + I(i, j); % 目标灰度值总和    
                num2 = num2 + 1; % 目标像素数目                
            else
                sum1 = sum1 + I(i, j); % 背景灰度值总和        
                num1 = num1 + 1; % 背景像素数               
            end
        end
    end
    ave1 = sum1/num1; % 背景像素均值    
    ave2 = sum2/num2; % 目标像素均值   
    S = ((ave2 - T) * (T - ave1)) / (ave2 - ave1)^2;  
    if(S > Smax)  
        % 记录类间最大距离 相对应的阈值Th
        Smax = S;        
        Th = T;       
    end
end
disp(Th);
% for i=1:m     
%     for j=1:n         
%         if I(i,j)>=Th         
%             I(i,j)=255;       
%         else
%             I(i,j)=0;       
%         end
%     end
% end
ts = Th / 255;
I_t = im2double(imbinarize(I, Th));


imshow(I_t,[]),title('类间最大距离法阈值分割效果图');