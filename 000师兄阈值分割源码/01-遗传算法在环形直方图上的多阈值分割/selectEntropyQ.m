function [q] = selectEntropyQ(pixelCount)
% �������ܣ�����q����ó�����ֱ��ͼ�����qֵ
% ����ֵ˵����
%   q��Tsallis Entropy���ز���
%-------------------------------------------------------------------------

% ��������ʾ����q = selectEntropyQ(pixelCount);

    % 1����0.01Ϊ��������0ѭ����10��ѡ��ʹ������������qֵ
    i = 1;
    for q = 0 : 0.01 : 10
        %   1.1��ע�⣬��q=1ʱ��Tsallis Entropt�˻�ΪBoltzmann�CGibbs Entropy
        if q == 1
            temp = pixelCount .* log(pixelCount);
            temp(isnan(temp)) = 0;
            temp(isinf(temp)) = 0;
            ST(i) = -sum(temp);
            %   1.2����q=1ʱ�������Ϊһ����ֵ������ɴ���ѧ��ʽ�Ͻ����Ƶ�
            ST_MAX(i) = log(256);
        else
            %   1.3������q!=1ʱ�����ǰ���Tsallis Entropy���м���
            ST(i) = (1 - sum(power(pixelCount(:), q))) / (q - 1);
            %   1.4��q!=1ʱ�����������һ������qֵ�仯�ĺ���
            ST_MAX(i) = (1 - power(256, 1 - q)) / (q - 1);
        end
        
        %   1.5������ÿһ��qֵ�µ�������
        RT(i) = 1 - (ST(i) / ST_MAX(i));
        i = i + 1;
    end

    % 2���ó�����������Ӧ��������������ת��Ϊ��Ӧ��qֵ
    [RT_MAX_Value, RT_MAX_Level] = max(RT);
    q = (RT_MAX_Level - 1) / 100;
end

