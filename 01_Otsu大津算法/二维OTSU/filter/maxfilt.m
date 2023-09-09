%自编的最大化滤波函数。x是需要滤波的图像,n是模板大小(即n×n) 
function d=maxfilt(x,n) 
a(1:n,1:n)=1;   %a即n×n模板,元素全是1 
p=size(x); 
%输入图像是p×q的,且p>n,q>n
x1=double(x); 
x2=x1; 

%A(a:b,c:d)表示A矩阵的第a到b行,第c到d列的所有元素 
for i=1:p(1)-n+1 
    for j=1:p(2)-n+1 
        c=x1(i:i+(n-1),j:j+(n-1)); 
        %取出x1中从(i,j)开始的n行n列元素,即模板(n×n的)
        max_num = max(max(c))
        
        x2(i+(n-1)/2,j+(n-1)/2)=max_num; 
        %将模板各元素的最大值赋给模板中心位置的元素
        
    end
end
%未被赋值的元素取原值 
d=uint8(x2);