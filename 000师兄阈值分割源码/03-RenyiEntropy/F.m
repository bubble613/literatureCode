function [Res] = F(originImage, resultImage) 
% ����˵����F�������ָ�ͼ�������
% ����˵����
%   originImage��ԭʼͼ��
%   resultImage����ֵͼ��
% ����ֵ˵����
%   F������ֵ��ֵԽСԽ�á�
%----------------------------------------------------------------------------------

% ����ʾ����[Res] = F(originImage, resultImage) 

    % 1������ͼ��Ĵ�С��������ͼ����������
    [M, N] = size(originImage);
    maxValue = max(max(originImage));
    originImage = im2double(originImage);
    resultImage = im2double(resultImage);
    originImage = originImage * double(maxValue);
    
    % 2������ǰ���ͱ���ͼ��
    foregroundImage = originImage .* resultImage;
    backgroundImage = originImage .* ~resultImage;
    
    % 3������ǰ���ͱ���ͼ������ظ���
    foregroundImage_size = nnz(resultImage);
    backgroundImage_size = nnz(~resultImage);
    
    % 4������ǰ���ͱ���ͼ����ܵĻҶ�����ֵ
    foregroundImage_value_sum = sum(sum(foregroundImage));
    backgroundImage_value_sum = sum(sum(backgroundImage));
    
    % 5������ǰ���ͱ���ͼ��ĻҶȾ�ֵ
    foregroundImage_value_average = foregroundImage_value_sum / foregroundImage_size;
    backgroundImage_value_average = backgroundImage_value_sum / backgroundImage_size;
    
    % 6������ǰ���ͱ���ͼ��ľ�ֵ����
    foregroundImage_average_matrix = resultImage .* foregroundImage_value_average;
    backgroundImage_average_matrix = ~resultImage .* backgroundImage_value_average;
    
    % 7������ǰ���ͱ���ͼ��Ĳ�ֵ����
    foregroundImage_diff_matrix = foregroundImage - foregroundImage_average_matrix;
    backgroundImage_diff_matrix = backgroundImage - backgroundImage_average_matrix;
    
    % 8������ǰ���ͱ���ͼ���ƽ����ɫ���
    e1_2 = sum(sum(power(foregroundImage_diff_matrix, 2)));
    e2_2 = sum(sum(power(backgroundImage_diff_matrix, 2)));
    
    % 9������Fֵ
    Res = (sqrt(2) / (N * M)) * ((e1_2 / sqrt(foregroundImage_size)) + (e2_2 / sqrt(backgroundImage_size)));
end