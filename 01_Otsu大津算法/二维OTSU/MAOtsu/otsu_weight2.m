function [threshold] = otsu_weight(Histogram)
% 直方图版本

% Histogram = Histogram / (m * n);

for i = 1:256
    muI(i) = (i - 1) * Histogram(i);
end

% Otsu
for k = 1:256
    mu1 = 0; mu2 = 0;
    w1(k) = sum(Histogram(1:k));
    w2(k) = sum(Histogram(k+1 : 256));
    
    for i = 1 : k
        if w1(k) ~= 0
            mu1 = mu1 + ((i - 1) * Histogram(i) / w1(k));
        end
    end
    mu1_k(k) = mu1;
%     if w1(k+1) ~= 0
%         mu1_k(k+1) = sum(((0 : k) .* p(1 : k+1) / w1(k+1)));
%     end
    
    for i = k + 1 : 256
        if w2(k) ~= 0
            mu2 = mu2 + ((i - 1) * Histogram(i) / w2(k));
        end
    end
    mu2_k(k) = mu2;
%     if w2(k+1) ~= 0
%         mu2_k(k) = sum(((k+1 : 255) .* p(k+2 : 256) / w2(k+1)));
%     end
    
end

% sigma = (w1 .* power(mu1_k, 2)) + (w2 .* power(mu2_k, 2));
% sigma = W * ((w1 .* power(mu1_k, 2)) + (w2 .* power(mu2_k, 2)));
% 加权值 W
% sigam_weight1 = (1 - Histogram') .* ((w1 .* power(mu1_k, 2)) + (w2 .* power(mu2_k, 2)));

% [sigma_max, index] = max(sigma);
% [sigma_weight1_max, index_weight1] = max(sigam_weight1);

% imgbw1 = imbinarize(image, index);
% imgbw2 = imbinarize(image, index_weight1);

for i = 1:256
    HnTemp = 0;
    if Histogram(i) ~= 0
        HnTemp = HnTemp - (Histogram(i) * log(Histogram(i)));
    end
    Hn = HnTemp;
end
for k = 1:256
    
    HkTemp = 0;
    Pk(k) = sum(Histogram(1:k));
    % Hn(k) = -Pk * log(Pk) - (1 - Pk) * log(1 - Pk);
    
    % 最大化Hn 得到Pk = 1 - Pk = 1/2
    
    for i = 1 : k
        if Histogram(i) ~= 0
            HkTemp = HkTemp - (Histogram(i) * log(Histogram(i)));
        end
    end
    Hk(k) = HkTemp;
    
end
% 准则函数
Fk = log(Pk .* (1 - Pk)) + Hk ./ Pk + (Hn - Hk) ./ (1 - Pk);
[Fk_max, index_Fk] = max(Fk); % index_Fk 为Shannon熵准则函数最大时得出
% 将准则函数 Fk 作为Otsu权值 W
sigam_weight2 = Fk .* ((w1 .* power(mu1_k, 2)) + (w2 .* power(mu2_k, 2)));
[sigma_weight2_max, index_weight2] = max(sigam_weight2);
threshold = index_weight2 - 1;
