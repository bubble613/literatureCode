% ����Otsu��ֵ�ָ�ĳ���
close all;
clear;

% 1��ѡȡͼ���޶��Ҷ�ͼ��
[fileName,pathName] = uigetfile({'*.*'; '*.bmp'; '*.jpg'}, 'Select the original image file');
fileName = strcat(pathName, fileName);
image = imread(fileName);

%   1.1������ǲ�ɫͼ��ֱ��ת��Ϊ�Ҷ�ͼ��
if (size(image, 3) == 3)  % �������ͨ��ͼ�񣬽���ת��Ϊ��ͨ��ͼ��
    figure, imshow(image), title('Original Color Image');
    image = rgb2gray(image);
end

% 2������ֱ��ͼ����һ��
Histogram = imhist(image);
Histogram = (Histogram / sum(Histogram))';

% 3������OTSU��������ֵѡ�񲢼�¼ʱ��
tic;
threshold = otsuThresholding(Histogram);
time = toc;

% 4������ѡȡ����ֵ���ж�ֵ������
[imgbw] = subim2bw(image, threshold);

NU = RegionNonuniformity(image, imgbw);
QQ = Q(image, imgbw);
Res = F(image, imgbw);

% 5�����Ʋ�չʾͼ��
figure, 
subplot(2, 2, 1),
imshow(image), title('ԭʼͼ��');
subplot(2, 2, 2),
imhist(image), title('ԭʼͼ��ֱ��ͼ');
subplot(2, 2, 3),
imshow(imgbw), title('����Otsu����ֵ�ָ���');
subplot(2, 2, 4),
gtext(strcat('�����ֵthreshold = ', num2str(threshold))),
gtext(strcat(strcat('��������ʱ�䣺', num2str(time)), '��')),
gtext(strcat('���򲻾�����NU = ', num2str(NU))),
gtext(strcat('Q = ', num2str(QQ))),
gtext(strcat('F = ', num2str(Res))),
title('������ֵ�����������ʱ��');