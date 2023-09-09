clc; 
clear;
% imageFiles = {'file1', 'file2'};
imageFiles = {'lena_std.tif'};

for nImage = 1 : length(imageFiles)
    % Load image
    image = im2double(imread(imageFiles{nImage}));
    figure(1); clf;
    imshow(image);
    
    % 灰度化
    if ndims(image) == 3
        image = rgb2gray(image);
    else
        image = image;
    end
    
    [th, Peakfound] = GetMinimumThreshold(image);
%     th = th / 255
    img_th = imbinarize(image, th);
    figure(2),
    subplot(121);
    imshow(img_th,[]);
    subplot(122);
    imhist(img_th);
    
    
%     if nImage == 1
%         pause
%     end
end % nImage

function [th, Peakfound] = GetMinimumThreshold(image)
 
    Iter = 0;
    HistGramC = zeros(1, 256);          
    % 基于精度问题，一定要用浮点数来处理，否则得不到正确的结果
    HistGramCC = zeros(1, 256);          
    % 求均值的过程会破坏前面的数据，因此需要两份数据
    HistGram = imhist(image);
    
    for i = 1:256
        HistGramC(i) = HistGram(i);
        HistGramCC(i) = HistGram(i);
    end

    % 通过三点求均值来平滑直方图
    while(~IsDimodal(HistGramCC)) % 判断是否已经是双峰的图像了
        HistGramCC(1) = (HistGramC(1) + HistGramC(1) + HistGramC(2)) / 3;% 第一点
        for i = 2:255
            HistGramCC(i) = (HistGramC(i) + HistGramC(i) +...
                HistGramC(i + 1)) / 3; %中间的点
        end

        for i = 1:256
            HistGramC(i) = HistGramCC(i);
        end

        Iter = Iter + 1;
        if (Iter > 1000)
            break;
        end
    end

    Peakfound = 0;

    for i = 2:255
        if ((HistGramCC(i-1) - HistGramCC(i) < 0) && (HistGramCC(i + 1) - HistGramCC(i) < 0)) 
            Peakfound = 1;
        end
        if (Peakfound == 1 && (HistGramCC(i - 1) >= HistGramCC(i)) && (HistGramCC(i + 1) >= HistGramCC(i)))
            th = i - 1;
        end
    end
    
end

function [tag] = IsDimodal(HistGram)

    tag = 0;
    Count = 0;
    for i = 2:255
        if((HistGram(i - 1) < HistGram(i)) && (HistGram(i + 1) < HistGram(i)))
            Count = Count + 1;
            if (Count > 2) 
                tag = 0;
            end
        end

        if(Count == 2)
            tag = 1;
        else
            tag = 0;
        end
        
    end
end