function [imgbw] = subim2bw(img, threshold)
% ����˵������ֵ������
% ����˵����
%   img������ֵ������ĻҶ�ͼ��
%   threshold����ֵ
% ����ֵ˵����
%   imgbw����ֵͼ��
%----------------------------------------------------------------------------------

% ����ʾ����[imgbw] = subim2bw(img, threshold)

    imgbw = false(size(img));  % �����������ͼ��ȫ����Ϊ0/False
    imgbw(img > threshold) = true;  % ͼ����������ֵ������ֵ����Ϊ1/True