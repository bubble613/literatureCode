% I = imread('rice.png');
I = imread('/Users/liwangyang/Desktop/matlab_doc/图片集/Cameraman.tif');
% I = rgb2gray(I);

[width,height] = size(I);
T0 = 1; %设置门限
T1= 128; %初始阈值T1
%设置G1，G2两个列向量，各自统计<T和>T的值
gray_level_1 = 1;
gray_level_2 = 1;
while 1
    for i = 1:width
        for j = 1:height
            if I(i, j) > T1
                G1(gray_level_1) = I(i, j);
                gray_level_1 = gray_level_1 + 1;
            else
                G2(gray_level_2) = I(i, j);
                gray_level_2 = gray_level_2 + 1;
            end
        end
    end
    avg1 = mean(G1);
    avg2 = mean(G2);
    T2 = (avg1 + avg2) / 2;
    if abs(T2 - T1) < T0
        break;
    end
    T1 = T2;
    gray_level_1 = 1;
    gray_level_2 = 1;
end

% T1=uint8(T1);
for i = 1:width
    for j = 1:height
        if(I(i, j)< T1)
            BW1(i, j) = 0;
        else
            BW1(i, j) = 1;
        end
    end
end
T1 = T1 / 255
figure(1),
subplot(1,3,1);imshow(I);
subplot(1,3,2);imshow(BW1);title('阈值分割');

T3=graythresh(I)
BW2=imbinarize(I,T3);%Otus阈值分割
subplot(1,3,3);imshow(BW2);title('Otus阈值分割');
