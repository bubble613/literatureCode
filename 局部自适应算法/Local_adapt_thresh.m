clc; 
clear;
% imageFiles = {'file1', 'file2'};
imageFiles = {'/Users/liwangyang/Desktop/matlab_doc/图片集/lena_std.tif'};

for nImage = 1 : length(imageFiles)
    % Load image
    img = im2double(imread(imageFiles{nImage}));
    figure(1); clf;
    imshow(img);
    
    % 灰度化
    if ndims(img) == 3
        img = rgb2gray(img);
    else
        img = img;
    end
    
    [height, width] = size(img); %高度与宽度
    % [pathStr, name, ext] = fileparts(imageFiles{nImage});
    
    % Global thresholding
    globalThresh = graythresh(img); %matlab自带Otsu方法
    
    %Convert image to binary image, based on threshold
    imgBinGlobal = imbinarize(img, globalThresh);
    figure(2); clf;
    imshow(imgBinGlobal);
    
    figure(3); clf; set(gcf, 'Color', 'w');
    imhist(img); hold on;
    histCounts = imhist(img);
    h = plot(globalThresh * ones(1, 100), linspace(0,max(histCounts)), 'r-');
    set(h, 'LineWidth', 2);
    set(gca, 'FontSize', 26);
     
    h = text(globalThresh+0.01, max(histCounts)/4, ...
        sprintf('T = %.2f', globalThresh));
    set(h, 'FontSize', 26);
    ylabel('Frequency_频率');
    % imwrite(imgBinGlobal, ['Global_' name '.jpg']);
    
    % Locally adaptive thresholding 局部自适应阈值划分
    imgBinLocal = imgBinGlobal;
    winHalfWidth = 1; %滑动窗口大小
    localVarThresh = 0.002;
    for col = 1 : width %从col 在图像宽度方向循环
        inCols = max(1, col - winHalfWidth) : min(width, col + winHalfWidth);
        inRows = 1:height;
        inTile = img(inRows, inCols);
        localThresh = graythresh(inTile);
        %localMean = mean2(inTile);
        localVar = std(inTile( : )) ^2;    %方差
        if localVar > localVarThresh
            imgBinLocal( : , col) = imbinarize(img(:, col), localThresh);
        else
            imgBinLocal( : , col) = 1;
        end
    end % col
    
    figure(4); clf;
    imshow(imgBinLocal);
    
    % imwrite(imgBinLocal, ['Local_' name '.jpg']);
    
    if nImage == 1
        pause
    end
end % nImage