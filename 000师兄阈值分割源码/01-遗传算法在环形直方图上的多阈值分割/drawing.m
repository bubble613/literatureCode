function [] = drawing(I)
    figure,
    imshow(I)             % ��ʾ�Ҷ�ͼ��
    thresholds= [45 65 84 108 134 157 174 189 206 228]; % ������ֵ
    G2C=grayslice(I,thresholds);   % �ܶȷֲ�
    figure,
    mymap = [0 0 0                  % ��ɫ
        1 0 0                       % ��ɫ
        0 1 0                       % ��ɫ
        0 0 1                       % ��ɫ
        1 1 0                       % ��ɫ
        1 1 1];                     % ��ɫ
    surf(peaks)
    imshow(G2C,colormap(mymap));    % ��ʾα��ɫͼ��
end

