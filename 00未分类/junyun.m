clc;clear;

I=im2gray(imread('/Users/liwangyang/Desktop/matlab_doc/图片集/lena_std.tif')); %转换为灰度图像 
I=double(I); 
[m,n]=size(I); 

Smin=-1; 
tic;
for T = 0:255                    
sum1=0; num1=0;                        
sum2=0; num2=0;                       
for i=1:m         
    for j=1:n             
        if I(i,j)>=T                 
            sum2=sum2+I(i,j);                  
            num2=num2+1;                            
        else
            sum1=sum1+I(i,j);                 
            num1=num1+1;                            
        end
    end
end
ave1=sum1/num1;  
ave2=sum2/num2;    
d1=-1;    
d2=-1;     
for i=1:m        
    for j=1:n            
        if I(i,j)>=T             
            d=(I(i,j)-ave2)^2;        
            if d2==-1                 
                d2=d;               
            else
                d2=d2+d;              
            end
        else
            d=(I(i,j)-ave1)^2;   
            if d1==-1                
                d1=d;                 
            else
                d1=d1+d;             
            end
        end
    end
end
p1 = num1/(m*n);
p2 = num2/(m*n);
S = p1*d1+p2*d2;
if(Smin==-1)
    Smin=S;
else
    if(S < Smin)
        Smin = S;
        Th = T;
    end
end
end
Th = Th / 255;
% for i=1:m
%     for j=1:n
%         if I(i,j)>=Th
%             I(i,j)=255;
%         else
%             I(i,j)=0;
%         end
%     end
% end
I = imbinarize(mat2gray(I), Th);
toc;

imshow(I,[]);
% imwrite(im2uint8(I),'均匀图像.jpg');
% imwrite(I,'junyun1.tiff');
title('均匀性度量法阈值分割效果图');