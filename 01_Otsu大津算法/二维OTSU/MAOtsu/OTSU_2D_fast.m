% ���ٶ�άֱ��ͼOTSU�ָ��������
% ���ߣ� �ƴ�
% Ŀ�꺯���������䷽��
%% ��������
clear;
close all;
clc;

%% ����ͼ��ֻ֧�ֻҶ�ͼ��
[fileName, pathName] = uigetfile({'*.*'; '*.bmp'; '*.jpg'}, 'Select the  original image file');
fileName = strcat(pathName, fileName);
image = imread(fileName);

if size(image, 3) == 3
    figure, imshow(image), title('Original Color Image');
    image = rgb2gray(image);
end

[M, N] = size(image);
% figure,
% imshow(image),
% title('ԭʼͼ��');

%% ����ƽ������Ҷȵ�һά�Ҷ�ֱ��ͼ
% f�洢ԭͼ����ʱתΪdouble���͵����ݱ��ڼ���
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
% figure,
% imshow(g),
% title('ƽ������ҶȺ��ͼ��');

%% ���㲢չʾ��άֱ��ͼ
% ��f����������ת������
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
colorbar,
% view(2),
% view(90,0),
title('��ά�Ҷ�ֱ��ͼ');


%% ʹ��������ļ���Ϊ����ָ�꣬����μ����ġ��Ҷ�ͼ��Ķ�άOtsu������ֵ�ָ��
% ��һ����άֱ��ͼ
h = h / (M * N);
% P0�洢Ŀ��������ʣ�u_T0��u_T1��ʾ��άֱ��ͼ��i��j�����ϵ��ܵľ�ֵʸ��
P0 = zeros(256, 256);
u_i = zeros(256, 256);
u_j = zeros(256, 256);

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

% ��������u_i
u_i(1, 1) = 0 * h(1, 1);  % ��ֵ = �� * ����
for i = 2 : 256
    u_i(1, i) = u_i(1, i - 1) + (1 - 1) * h(1, i);
end
for i = 2 : 256
    u_i(i, 1) = u_i(i - 1, 1) + (i - 1) * h(i, 1); 
end
for i = 2 : 256
    for j = 2 : 256
        u_i(i, j) = u_i(i - 1, j) + u_i(i, j - 1) - u_i(i - 1, j - 1) + (i - 1) * h(i, j);
    end
end

% ��������u_j
u_j(1, 1) = 0 * h(1, 1);  % ��ֵ = �� * ����
for i = 2 : 256
    u_j(1, i) = u_j(1, i - 1) + (i - 1) * h(1, i);
end
for i = 2 : 256
    u_j(i, 1) = u_j(i - 1, 1) + (1 - 1) * h(i, 1); 
end
for i = 2 : 256
    for j = 2 : 256
        u_j(i, j) = u_j(i - 1, j) + u_j(i, j - 1) - u_j(i - 1, j - 1) + (j - 1) * h(i, j);
    end
end

% ����u_T0��u_T1
u_T0 = 0;
u_T1 = 0;
for i = 1 : 256
    for j = 1 : 256
        u_T0 = u_T0 + (i - 1) * h(i, j);
        u_T1 = u_T1 + (j - 1) * h(i, j);
    end
end

%% ��䷽��ļ����������ֵ
% ��������������ļ���Ϊ������ɢ�Ȳ���
for i = 1 : 256
    for j = 1 : 256
        if P0(i, j) ~= 0 && P1(i, j) ~= 0
            trSB(i, j) = ((u_T0 * P0(i, j) - u_i(i, j))^2 + (u_T1 * P0(i, j) - u_j(i, j))^2) / (P0(i, j) * P1(i, j));
        else
            trSB(i ,j) = 0;
        end
    end
end

% trSB_max�洢������䷽��
trSB_max = max(trSB(:));
s = 0;
t = 0;
for i = 1 : 256
    for j = 1 : 256
        if trSB(i, j) == trSB_max
            s = i - 1;
            t = j - 1;
            continue;
        end
    end
end

trSB_max
s
t

%% չʾͼ��
seg1 = ones(M, N);
seg2 = ones(M, N);
% for i = 1 : M
%     for j = 1 : N
%         if double(f(i, j)) + double(g(i, j)) <= s+t
%             seg1(i, j) = 0;
%         end
%     end
% end
for i = 1 : M
    for j = 1 : N
        if f(i, j) <= s && g(i, j) <= t
            seg2(i, j) = 0;
        end
    end
end
figure,
% subplot(121), imshow(seg1, []), title('³���Ķ�άOtsu�ָ���ͼ��');
imshow(seg2), title('��άOtsu�ָ���ͼ��');
str1 = strcat('��άOtsu��䷽�����', num2str(trSB_max));
str2 = strcat('��ֵ��i����', num2str(s));
str3 = strcat('��ֵ��j����', num2str(t));
% str4 = strcat(strcat('��������ʱ�䣺', num2str(runTime)), '��');
fprintf('result��%s; %s; %s.\n', str1, str2, str3);