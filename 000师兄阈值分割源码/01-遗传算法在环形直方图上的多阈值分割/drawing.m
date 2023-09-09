function [] = drawing(I)
    figure,
    imshow(I)             % 显示灰度图像
    thresholds= [45 65 84 108 134 157 174 189 206 228]; % 设置阈值
    G2C=grayslice(I,thresholds);   % 密度分层
    figure,
    mymap = [0 0 0                  % 黑色
        1 0 0                       % 红色
        0 1 0                       % 绿色
        0 0 1                       % 蓝色
        1 1 0                       % 黄色
        1 1 1];                     % 白色
    surf(peaks)
    imshow(G2C,colormap(mymap));    % 显示伪彩色图像
end

