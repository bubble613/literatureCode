% ����Renyi����ֵ�ָ�ĳ���
close all;

% 1��ѡȡͼ���޶��Ҷ�ͼ��
[fileName,pathName] = uigetfile({'*.*'; '*.bmp'; '*.jpg'}, 'Select the original image file');
fileName = strcat(pathName, fileName);
image = imread(fileName);

%   1.1������ǲ�ɫͼ��ֱ��ת��Ϊ�Ҷ�ͼ��
if (size(image,3) == 3)  % �������ͨ��ͼ�񣬽���ת��Ϊ��ͨ��ͼ��
    figure,imshow(image),title('Original Color Image');
    image = rgb2gray(image);
end

% 2������ֱ��ͼ����һ��
Histogram = imhist(image);
Histogram = Histogram / sum(Histogram);
alpha = 1.1;

% 3������Renyi�ؽ�����ֵѡ�񲢼�¼ʱ��
tic;
threshold = renyiEntropyThresholding(alpha, Histogram);
time = toc;

% 4������ѡȡ����ֵ���ж�ֵ������
[imgbw] = subim2bw(image, threshold);

% 5�����Ʋ�չʾͼ��
figure, subplot(2, 2, 1),
imshow(image), title('ԭʼͼ��');
subplot(2, 2, 2),
imhist(image), title('ԭʼͼ��ֱ��ͼ');
subplot(2, 2, 3),
imshow(imgbw), title('����Renyi�ص���ֵ�ָ���');
subplot(2, 2, 4),
gtext(strcat('�ز���alpha = ', num2str(alpha))),
gtext(strcat('�����ֵthreshold = ', num2str(threshold))),
gtext(strcat(strcat('��������ʱ�䣺', num2str(time)), '��')),
title('������ֵ�����������ʱ��');