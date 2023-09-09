%% ��������
clear;
close all;

%% ����ͼ��ֻ֧�ֻҶ�ͼ��
[fileName, pathName] = uigetfile({'*.*'; '*.bmp'; '*.jpg'}, 'Select the  original image file');
fileName = strcat(pathName, fileName);
image = imread(fileName);
tic;

[M, N] = size(image);
figure,
imshow(image),
title('ԭʼͼ��');
%% ����ƽ������Ҷȵ�һά�Ҷ�ֱ��ͼ
% f�洢ԭͼ
f = double(image);
% g�洢ƽ������Ҷȵ�һά�Ҷ�ֱ��ͼ
g = zeros(M, N);
% ���ڴ�СΪ1
w = 1;
for i = 1 : M
    for j = 1 : N
        % ����(i, j)�µ�ƽ������Ҷȣ������СΪw * w
        for k = -w : w
            for m = -w : w
                p = i + k;
                q = j + m;
                % �߽�ֵ����
                if(p < 1 || p > M)
                    p = i;
                end
                if(q < 1 || q > N)
                    q = j;
                end
                g(i, j) = g(i, j) + f(p, q);
            end
        end
        g(i, j) = (1 / 9) * g(i, j);
    end
end
g = uint8(g);
figure,
imshow(g),
title('ƽ������ҶȺ��ͼ��');

%% ���㲢չʾ��άֱ��ͼ
f = uint8(f);
% h�洢��άֱ��ͼ��ע��ά�ȴ�СΪ�Ҷȿ��ܳ��ֵ����ֵ
h = zeros(256, 256);
for i = 1 : M
    for j = 1 : N
        p = f(i, j) + 1;
        q = g(i, j) + 1;
        h(p, q) = h(p, q) + 1;
    end
end

figure,
mesh(h),
xlim([0 256]),
ylim([0 256]),
title('��ά�Ҷ�ֱ��ͼ');

%% ����P0
% ��һ����άֱ��ͼ
h = h / (M * N);
% P0�洢Ŀ���������
P0 = zeros(256, 256);

% ��������P0
P0(1, 1) = h(1, 1);
% �ȼ���������ۻ�����
for i = 2 : 256
    P0(1, i) = P0(1, i - 1) + h(1, i);
end
for i = 2 : 256
    P0(i, 1) = P0(i - 1, 1) + h(i, 1);
end
for i = 2 : 256
    for j = 2 : 256
        P0(i, j) = P0(i - 1, j) + P0(i, j - 1) - P0(i - 1, j - 1) + h(i, j);
    end
end
P1 = ones(256, 256) - P0;

% ����ȫ��Tsallis�ؼ�������ֵ
q = 0.1;
for i = 1 : 255
    for j = 1 : 255
        if P0(i, j) == 0
            H_A(i, j) = 0;
        else
            H_A(i, j) = (1 - sum(sum(power(h(1 : i, 1 : j) ./ P0(i, j), q)))) / (q - 1);
        end
        
        if P1(i, j) == 0
            H_B(i, j) = 0;
        else
            H_B(i, j) = (1 - sum(sum(power(h(i + 1 : 256, j + 1 : 256) ./ P1(i, j), q)))) / (q - 1);
        end
        
        H_T(i, j) = H_A(i, j) + H_B(i, j) + (1 - q) * H_A(i, j) * H_B(i, j); 
    end
end

HT_max = 0;
% HT_max�洢���Tsaliis��
HT_max = max(H_T(:));
s = 0;
t = 0;
for i = 1 : 255
    for j = 1 : 255
        if H_T(i, j) == HT_max
            s = i - 1;
            t = j - 1;
            continue;
        end
    end
end

HT_max
s
t

%% չʾͼ��
seg = ones(M, N);
for i = 1 : M
    for j = 1 : N
        if f(i, j) <= s && g(i, j) <= t
            seg(i, j) = 0;
        end
    end
end
figure,
imshow(seg);
toc