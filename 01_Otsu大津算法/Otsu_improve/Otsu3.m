clear;clc;close;
% 最小化类方差的(MCVT)Minimum class variance thresholding method

[fileName,pathName] = uigetfile({'*.*';'*.tif';'*.tiff';'.bmp';'.jpg'},...
                                'Select the original image file');
fileName = strcat(pathName,fileName);
img = imread(fileName);
if (size(img,3) == 3)%如果是三通道图像，将其转化为单通道图像
    figure,imshow(img),title('Original Color Image');
    % img = rgb2gray(img);
end
figure,imshow(img),title('Original Image');
figure,imhist(img),title('Image histogram');
image = double(img);
[m,n]=size(image);

p = imhist(img);
p = p / (m * n);

for i = 1:256
    muI(i) = (i - 1) * p(i);
end

for k = 1:256
    mu1 = 0; mu2 = 0;
    w1(k) = sum(p(1:k));
    w2(k) = sum(p(k+1 : 256));
    
    for i = 1 : k
        if w1(k) ~= 0
            mu1 = mu1 + ((i - 1) * p(i) / w1(k));
        end
    end
    mu1_k(k) = mu1;
%     if w1(k+1) ~= 0
%         mu1_k(k+1) = sum(((0 : k) .* p(1 : k+1) / w1(k+1)));
%     end
    
    for i = k + 1 : 256
        if w2(k) ~= 0
            mu2 = mu2 + ((i - 1) * p(i) / w2(k));
        end
    end
    mu2_k(k) = mu2;
%     if w2(k+1) ~= 0
%         mu2_k(k) = sum(((k+1 : 255) .* p(k+2 : 256) / w2(k+1)));
%     end
    
end

%% main
% for k = 1 : L
%     wk = wk + Histogram(k);
%     muk = muk + (k - 1) * Histogram(k);
%     sigma_B(k) = (muT * wk - muk)^2 / (wk * (1 - wk));
%     
% end

for t = 1 : 256
    for k = 1 : t
        Temp0 = 0; w0 = 0; mu0 = 0;
        w0 = w0 + p(k);
        mu0 = mu0 + (k - 1) * p(k);
        Temp0 = Temp0 + p(k) * power((k - mu0), 2);
        % mu2 = mu2 + (L - k + 1) * Histogram(k + 1);
    end
    for k = L : -1 : t+1
        Temp1 = 0; w1 = 0; mu1 = 0;
        w1 = w1 + p(k);
        mu1 = mu1 + (k - 1) * p(k);
        Temp1 = Temp1 + p(k) * power((k - mu1), 2);
    end
    
    D_opt(t) = (1 / w0) * Temp0 + (1 / w1) * Temp1;
    
end
D_opt(isnan(D_opt)) = 0;
[minValue, threshold] = min(D_opt);

