 % 基于模糊集理论的一种图像二值化算法的原理、实现效果及代码

function [threshold] = GetHuangFuzzyThreshold(image)

x = 0;
y = 0;
first = 0;
last = 0;
threshold = -1;

[m, n] = size(image);
count = imhist(image);
L = 256;
num = m*n;
count = count / num;

% double BestEntropy = Double.MaxValue, Entropy;
% 找到第一个和最后一个非0的色阶值
for i = 1:L
    if count(i) == 0
        continue;
    else
        minvalue = i - 1;
        break;
    end
end

for i = L : -1 : 1
    if count(i) == 0
        continue;
    else
        maxvalue = i - 1;
        break;
    end
end

f = count(minvalue + 1 : maxvalue + 1);
p = minvalue;
q = maxvalue - minvalue;
S = zeros(1, q);
W = zeros(1, q);
for i = 1 : q
    mu = mu + f(i) * (p + i - 1);
    mu_a(i) = mu;
end

for i = 1 : q
    w(i) = sum(f(1 : i));
end

w = w + eps;

for i = 1 : q
    sum = - mu_a(i) * log(mu_a(i)) - (1 - mu_a(i)) * log(1 - mu_a(i));
end

for i = 1 : q
    entropy = 0;

    for j = 1:n
        
    if (first < num && image(i) == 0)
    for (First = 0; First < HistGram.Length && HistGram[First] == 0; First++) ;
    for (Last = HistGram.Length - 1; Last > First && HistGram[Last] == 0; Last--) ;
    if (First == Last) return First;                // 图像中只有一个颜色
    if (First + 1 == Last) return First;            // 图像中只有二个颜色

    // 计算累计直方图以及对应的带权重的累计直方图
    int[] S = new int[Last + 1];
    int[] W = new int[Last + 1];            // 对于特大图，此数组的保存数据可能会超出int的表示范围，可以考虑用long类型来代替
    S[0] = HistGram[0];
    for (Y = First > 1 ? First : 1; Y <= Last; Y++)
    {
        S[Y] = S[Y - 1] + HistGram[Y];
        W[Y] = W[Y - 1] + Y * HistGram[Y];
    }

    // 建立公式（4）及（6）所用的查找表
    double[] Smu = new double[Last + 1 - First];
    for (Y = 1; Y < Smu.Length; Y++)
    {
        double mu = 1 / (1 + (double)Y / (Last - First));               // 公式（4）
        Smu[Y] = -mu * Math.Log(mu) - (1 - mu) * Math.Log(1 - mu);      // 公式（6）
    }

    // 迭代计算最佳阈值
    for (Y = First; Y <= Last; Y++)
    {
        Entropy = 0;
        int mu = (int)Math.Round((double)W[Y] / S[Y]);             // 公式17
        for (X = First; X <= Y; X++)
            Entropy += Smu[Math.Abs(X - mu)] * HistGram[X];
        mu = (int)Math.Round((double)(W[Last] - W[Y]) / (S[Last] - S[Y]));  // 公式18
        for (X = Y + 1; X <= Last; X++)
            Entropy += Smu[Math.Abs(X - mu)] * HistGram[X];       // 公式8
        if (BestEntropy > Entropy)
        {
            BestEntropy = Entropy;      // 取最小熵处为最佳阈值
            Threshold = Y;
        }
    }
    return Threshold;
}