function level = my_otsu2(I)

img = I;%读取图像

[height, width] = size(img); %图像矩阵大小 

N = height * width;  %图像像素个数 

L = 256; %制定凸显灰度级为256 

count = imhist(img); %直方图统计

count = count / N; %各级灰度出现概率

%循环语句实现寻找出现概率不为0的最小灰度值
for i = 1 : L 
    if count(i) == 0 
        continue
    else
        minvalue = i - 1;         
        break
    end
end

%实现找出出现概率不为0的最大灰度值
for i = L : -1 : 1 
    if count(i) == 0
        continue
    else
        maxvalue = i - 1;  
        break   
    end 
end 

f = count(minvalue + 1 : maxvalue + 1); 

%p和q分别是灰度的起始和结束值
p = minvalue;
q = maxvalue - minvalue; 

mu = 0;
for i = 1 : q  
    mu = mu + f(i) * (p + i - 1); %mu是像素的平均值
    mu_a(i) = mu;  %mu_a（i）是前i+p个像素的平均灰度值 (前p个无取值)
end 

%计算图像的平均灰度值
for i = 1 : q 
    w(i) = sum(f(1 : i)); % w（i）是前i个像素的累加概率,对应公式中P0
end 

%计算出选择不同k的时候，A区域的概率 
w = w + eps;
d = ((mu .* w - mu_a) .^2) ./(w .* (1 - w)); %求出不同k值时类间方差 

%可以取出数组的最大值及取最大值点的索引
[~, tp] = max(d); %求出最大方差对应的灰度值

level = tp + p - 1;

