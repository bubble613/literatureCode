clc;clear;close;

% 可能出错！！！！！！待定
img = rgb2gray(imread('/Users/liwangyang/Desktop/matlab_doc/图片集/lena_std.tif'));
T = Entropy_Kapur(img);

function T = Entropy_Kapur(X)

% hg = histogram(X,Trange);
hg = imhist(X);
pg = hg ./ sum(hg);
Ti = 0;
Trange = 0 : 255;

TrangeSpan = Trange(pg > 0);
JT = zeros(length(TrangeSpan), 1);

for Tk = TrangeSpan
    Ti = Ti+1;
    PT = sum(pg(Trange <= Tk));
    H = -pg ./ PT .* log10(pg ./ PT); % !!!
    isnanind = ~isnan(H); %确定哪些数组元素为 NaN  1对应的为NaN
    Hf = sum(H(Trange <= (Tk & isnanind(Tk))));
    Hb = sum(H(Trange > (Tk & isnanind(Tk))));
    JT(Ti) = Hf + Hb;
end
[~, Tind] = max(JT);
T = TrangeSpan(Tind);
end