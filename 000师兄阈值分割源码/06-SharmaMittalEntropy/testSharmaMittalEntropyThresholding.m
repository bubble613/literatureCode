% ����Tsallis����ֵ�ָ�
close all;
[fileName,pathName] = uigetfile({'*.*'; '*.bmp'; '*.jpg'}, 'Select the original image file');
fileName = strcat(pathName, fileName);
image = imread(fileName);

if (size(image,3) == 3)  % �������ͨ��ͼ�񣬽���ת��Ϊ��ͨ��ͼ��
    figure,imshow(image),title('Original Color Image');
    image = rgb2gray(image);
end

Histogram = imhist(image);
Histogram = Histogram / sum(Histogram);
r = 0.8;
q = 0.9;

tic;
threshold = sharmaMittalEntropyThresholding(r, q, Histogram);
time = toc;
[imgbw] = subim2bw(image, threshold);

figure,subplot(2,2,1),
imshow(image),title('ԭʼͼ��');
subplot(2,2,2),
imhist(image),title('ԭʼͼ��ֱ��ͼ');
subplot(2,2,3),
imshow(imgbw),title('����Sharma-Mittal Entropy����ֵ�ָ���');
subplot(2,2,4),
gtext(strcat('�ز���r = ',num2str(r))),
gtext(strcat('�ز���q = ',num2str(q))),
gtext(strcat('�����ֵ��',num2str(threshold))),
gtext(strcat(strcat('��������ʱ�䣺',num2str(time)),'��')),
title('������ֵ�����������ʱ��');