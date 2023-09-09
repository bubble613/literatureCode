function T = func_Otsu(I1)
[m,n]=size(I1);
I1=double(I1);
count=zeros(256,1);
pcount=zeros(256,1);
for i=1:m
    for j=1:n
        pixel=I1(i,j);
        count(pixel+1)=count(pixel+1)+1; %计算每个灰度值的个数
    end
end
dw=0;
for i=0:255
    pcount(i+1)=count(i+1)/(m*n);%计算每个灰度值在总矩阵中所占的比例，存放在pcount中
    dw=dw+i*pcount(i+1);%计算出图像总体的灰度均值
end
Th=0;%初始化阈值从0开始遍历
Thbest=0;%初始化最佳阈值为0
dfc=0;
dfcmax=0;
while(Th>=0 && Th<=255)%while循环找出最佳阈值
    dp1=0;
    dw1=0;
    for i=0:Th
        dp1=dp1+pcount(i+1);%计算出小于Th阈值的比例
        dw1=dw1+i*pcount(i+1);%算出小于阈值Th部分的灰度均值
    end
    if dp1>0%如果小于Th阈值的比例不为0
        dw1=dw1/dp1;
    end
    dp2=0;
    dw2=0;
    for i=Th+1:255
        dp2=dp2+pcount(i+1);%计算出大于Th阈值的比例
        dw2=dw2+i*pcount(i+1);%算出大于阈值Th部分的灰度均值
    end
    if dp2>0
        dw2=dw2/dp2;
    end
    dfc=dp1*(dw1-dw)^2+dp2*(dw2-dw)^2;%计算类间方差
    if dfc>=dfcmax %去类间方差的最大值作为最佳阈值
        dfcmax=dfc;
        Thbest=Th;
    end
    Th=Th+1;
end
T=Thbest;
end

