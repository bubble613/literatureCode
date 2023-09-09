close all;%关闭所有窗口  
clear;%清除变量的状态数据  
clc;%清除命令行

img = imread('/Users/liwangyang/Desktop/matlab_doc/图片集/lena_std.tif');
MAXD = 100000;

img = img(:, :, 1);
[counts, x] = imhist(img); % counts are the histogram. x is the intensity level.
GradeI = length(x); % the resolusion of the intensity. i.e. 256 for uint8.
J_t = zeros(GradeI, 1); % criterion function
prob = counts ./ sum(counts); % Probability distribution
meanT = x' * prob; % Total mean level of the picture

% Initialization
w0 = prob(1); % Probability of the first class
miuK = 0; % First-order cumulative moments of the histogram up to the kth level.
J_t(1) = MAXD;
n = GradeI-1;

for i = 1 : n
    w0 = w0 + prob(i+1);
    miuK = miuK + i * prob(i+1); % first-order cumulative moment
    if (w0 == 0) || (w0 == 1)
        J_t(i+1) = MAXD; % T = i
    else
        miu1 = miuK / w0;
        miu2 = (meanT-miuK) / (1-w0);
        var1 = (((0 : i)' - miu1).^2)'  * prob(1 : i+1);
        var1 = var1 / w0; % variance
        var2 = (((i+1 : n)' -miu2).^2)'  * prob(i+2 : n+1);
        var2 = var2 / (1-w0);
        if var1 > 0 && var2 > 0 % in case of var1=0 or var2 =0
        J_t(i + 1) = 1 + 2 * w0 * log(var1) + 2 * (1 - w0) * log(var2) - ...
            2 * w0 * log(w0) - 2 * (1 - w0) * log(1 - w0);
        else
        J_t(i + 1) = MAXD;
        end
    end
end

minJ = min(J_t);
index = find(J_t == minJ);
th = mean(index);
th
threshold = (th-1)/n
I_bw = imbinarize(img, threshold);
figure, imshow(I_bw);