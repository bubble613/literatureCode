function [] = comparedOtsubyMyself(fwrite)
%函数功能:根据Otsu的论文，自己动手编写的Otsu方法，并且和Matlab7.0提供的Otsu方法进行了比较
%参考文献：
%Otsu, N., "A Threshold Selection Method from Gray-Level Histograms," IEEE
%Transactions on Systems, Man, and Cybernetics, Vol. 9, No. 1, 1979, pp. 62-66.
%--------------------------------------------------------------------------

%函数调用示例：
%示例1： close all;comparedOtsubyMyself(true);
%示例2： close all;comparedOtsubyMyself(false);
    
    [fileName,pathName] = uigetfile({'*.tif';'*.tif';'*.*'},...
                                'Select the original image file');
    fileName = strcat(pathName,fileName);
    img = imread(fileName);
    if (size(img,3) == 3)%如果是三通道图像，将其转化为单通道图像
        figure,imshow(img),title('Original Color Image');
        img = rgb2gray(img);
    end
    figure,imshow(img),title('Original Image');
    figure,imhist(img),title('Image histogram');
   
    tic;
    threshold = localComputeThreshold(img);%调用局部函数计算图像的阈值
    % [imgbw] = subim2bw(img, threshold);
    [imgbw] = mat2gray(imbinarize(img, threshold / 255));
    toc;
    disp(threshold);
   
    location = strfind(fileName, '.tif');
    fileSaved = strcat(fileName(1:location-1),'_Otsu_T=',...
                    num2str(threshold),'.bmp');
    if (fwrite)
        imwrite(imgbw,fileSaved);
    end
    figure,imshow(imgbw,[]);
    
    %下面几行是matlab自带的otsu阈值分割算法，用于和localMethodX的比较
    level = graythresh(img);
    disp(strcat('matlab自带Otsu函数阈值为', num2str(level * 255)));
    
    BW = imbinarize(img, level);
    figure,imshow(im2double(BW));
   
    
function [finalThreshold] = localComputeThreshold(img)
    minGraylevel = uint16(min(min(img)));
    maxGraylevel = uint16(max(max(img)));
    elementNumbers = length(img(:));%获得图像总的像素个数
    
    for ii = 0:255
        [imgbw] = im2bw(img,ii/255); %对每个灰度值，使用它获得一幅二值图像。
        A = img(imgbw);
        B = img(~imgbw);
        if (isempty(A) || isempty(B))
            sigma(ii+1) = 0;
        else
            sigma(ii+1) = (mean(A) - mean(B))^2*(numel(A)/elementNumbers)*(numel(B)/elementNumbers);
        end
    end
   
    %为了便于观察sigma值构成的曲线，将sigma的值进行了归一化[0,1]
    sigmaNormal = (sigma - min(sigma))/(max(sigma)-min(sigma));
    [maxValue,threshold] = max(sigmaNormal);
    finalThreshold = threshold - 1;
    disp([maxValue,finalThreshold]);
    
    [frequency,xout]=imhist(img);
    %为了便于观察灰度值出现的频率构成的曲线（灰度直方图），将frequency值进行了归一化[0,1]
    frequencyNormal = (frequency-min(frequency))./(max(frequency)-min(frequency));
    
    figure(100),hold on,
    plot(minGraylevel:maxGraylevel,sigmaNormal(minGraylevel+1:maxGraylevel+1),'-r'),
    plot([threshold, threshold],[0.0 1.0],'r-.'),%标记处计算的阈值的位置
    plot(xout,frequencyNormal),
    text(threshold,0.5,['\leftarrow' num2str(threshold)],'HorizontalAlignment','left'),
    hold off;
