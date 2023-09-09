A0=imread('/Users/liwangyang/Desktop/matlab_doc/图片集/lena_std.tif');
I=rgb2gray(A0);%转换为灰度图像
h=imhist(I);          
h1=h; 
len=length(h);     
[m,n]=size(I);     
h1=h1/(m*n);         
for i=1:(len-1)  
   if h(i)~=0  
       P1=sum(h1(1:i)); 
       P2=sum(h1((i+1):len));
   else
       continue;  
   end
   H1(i)=-(sum(P1.*log(P1)));  
   H2(i)=-(sum(P2.*log(P2))); 
   H(i)=H1(i)+H2(i);
end
m1=max(H);
Th=find(H==m1); 
Th; 
for i=1:m     
   for j=1:n     
       if I(i,j)>=Th    
           I(i,j)=255;     
       else
           I(i,j)=0;    
       end
   end
end

imshow(I),title('最大熵法阈值分割效果图');