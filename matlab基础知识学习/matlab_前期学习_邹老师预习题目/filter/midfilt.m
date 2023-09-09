%自编的中值滤波函数。x是需要滤波的图像,n是模板大小(即n×n)
function d=midfilt(x,n)
p=size(x); %输入图像是p×q的,且p>n,q>n
x1=double(x);
x2=x1;
for i=1:p(1)-n+1 
    for j=1:p(2)-n+1 
        c=x1(i:i+(n-1),j:j+(n-1)); %取出x1中从(i,j)开始的n行n列元素,即模板(n×n的)
        e=c(1,:); %是c矩阵的第一行
        for u=2:n
            e=[e,c(u,:)]; %将c矩阵变为一个行矩阵
        end
        mm=median(e); %mm是中值
        x2(i+(n-1)/2,j+(n-1)/2)=mm; %将模板各元素的中值赋给模板中心位置的元素
    end
end

%未被赋值的元素取原值 
d=uint8(x2);
        