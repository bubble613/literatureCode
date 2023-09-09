
I = mat2gray(img3);%转换为灰度图像
[width, height]=size(I);
for i=1:width
    for j=1:height       
         if(I(i,j) < (110/255))         
            RC(i,j)=0;     
         else                     
             
             RC(i,j)=1; 
         end                    
    end
end
subplot(121),
imshow(RC);title('双峰法阈值分割效果图');
subplot(122),
RC = im2uint8(RC);
imhist(uint8(RC));title('直方图');
