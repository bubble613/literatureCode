function [NU] = RegionNonuniformity(originImage, resultImage)
% ����˵��������ָ�ͼ������򲻾�����
% ����˵����
%   originImage��ԭʼͼ��
%   resultImage����ֵͼ��
% ����ֵ˵����
%   NU�����򲻾��ȳ̶�
%----------------------------------------------------------------------------------

% ����ʾ����[NU] = RegionNonuniformity(originImage, resultImage)

    % 1��ȡ�������������������һ��Ҫ��Ҫ��ǰ��ͼ�����ɰ�ɫ���ص㻹�Ǻ�ɫ���ص���ɵģ���ɫ����Ҫȡ����
    resultImage = ~resultImage;
    % 2��Ϊ�����˲����Ĵ���Ԥ��ת��Ϊdouble��������
    originImage = im2double(originImage);
    resultImage = im2double(resultImage);
    % 3������ǰ���ͱ������ص���Ŀ
    FT_num = nnz(resultImage);
    BT_num = nnz(~resultImage);
    % 4����������ͼ��ı�׼��
    sigma = std2(originImage);
    % 5������ǰ��ͼ��
    foregroundImage = originImage .* resultImage;
    % 6������ǰ��ͼ��ı�׼��
    foregroundImage(find(foregroundImage == 0)) = [];
    sigma_f = std(foregroundImage);
    % 7����������Ĳ����ȳ̶�
    NU = (FT_num / (FT_num + BT_num)) * power(sigma_f, 2) / power(sigma, 2);
end

