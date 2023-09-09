function [] = comparedShannonEntropy(fwrite)
%�ο����� A new method for gray-level picture thresholding using the entropy of
%the histogram ����A novel generalized entropy and its application in image
%thresholding�Ĺ�ʽ��7��-��10��
%--------------------------------------------------------------------------
%�ú�����Ч����comparedShannonEntropy2�ǵ�ͬ�ģ�
%���ߴ���վ���أ�
%https://cn.mathworks.com/matlabcentral/fileexchange/35158-thresholding-
%the-maximum-entropy
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%����˵����
%fwrite���Ƿ񽫽�����б��棬true��ʾ���棬false��ʾ������

%��������ʾ����
% close all;comparedShannonEntropy(false);
% close all;comparedShannonEntropy(true);


%   Copyright 2017-2020 Yaobin Zou, CTGU.
%   Copyright 
%   $Revision: 1.0 $  $Date: 2017/10/12 at Technical University of Dresden $
    
    [fileName, pathName] = uigetfile({'*.*'; '*.bmp'; '*.jpg'}, 'Select the original image file');
    fileName = strcat(pathName, fileName);
    img = imread(fileName);
    if(size(img, 3) == 3)
        figure, imshow(img), title('Original color image');
        img = rgb2gray(img);
    end
    
    figure, imshow(img), title('original  gray-level Image');
    figure, imhist(img), title('Image Histogram');
    
    threshold = localMethodX(img);
    [imgbw] = imbinarize(img, threshold/255);
    

    if(fwrite)
        location = strfind(fileName, '.tif');
        fileSaved = strcat(fileName(1 : location - 1), '_ShannonEntropy(', type, ')_T=', num2str(threshold), '.tif');
        imwrite(imgbw, fileSaved);
        
    end
    figure, imshow(imgbw);
end
    
function [finalThreshold] = localMethodX(img, q)

    minGraylevel = uint16(min(min(img)));
    maxGraylevel = uint16(max(max(img)));
    
    
    for ii = 0 : 255
        [imgbw] = imbinarize(img, ii / 255);
        A = img(imgbw);
        B = img(~imgbw);
        [PA, x] = imhist(A, 256);
        [PB, x] = imhist(B, 256);
        
        PA = PA ./ sum(PA);
        PB = PB ./ sum(PB);
        
        HAT = 0;
        if(~isempty(A))
            HATTemp = PA .* log(PA);
            HATTemp(isnan(HATTemp)) = 0;
            HAT = -sun(HATTemp);
        end
        HBT = 0;
        if(~isempty(B))
            HBTTemp = PB .* log(PB);
            HBTTemp(isnan(HBTTemp)) = 0;
            HBT = -sum(HBTTemp);
        end
        entropyTotal(ii + 1) = HAT + HBT;
        entropyHAT(ii + 1) = HAT;
        entropyHBT(ii + 1) = HBT;
        
    end
    [maxValue, threshold] = max(entropyTotal);
    finalThreshold = threshold - 1;
    disp([maxValue, threshold]);
    
    figure(100), 
        hold on, 
        plot(minGraylevel : maxGraylevel, entropyHAT(minGraylevel + 1 : maxGraylevel + 1), '-r.'),
        hold off;
    figure(100), 
        hold on, 
        plot(minGraylevel : maxGraylevel, entropyHBT(minGraylevel + 1 : maxGraylevel + 1), '-g.'),
        hold off;
    figure(100), 
        hold on, 
        plot(minGraylevel : maxGraylevel, entropyTotsl(minGraylevel + 1 : maxGraylevel + 1), '-b.'),
        hold off;
        
    entropyTotalNormal = (entropyTotal - min(entropyTotal)) ./ (max(entropyTotal) - min(entropyTotal));
    
    [frequency, xout] = imhist(img);
    % Ϊ�˷���۲�Ҷ�ֵ���ֵ�Ƶ�ʹ��ɵ����ߣ��Ҷ�ֱ��ͼ������frequency��ֵ���й�һ������
    frequencyNormal = (frequency - min(frequency)) ./ (max(frequency) - min(frequency));
    
    figure(101), 
        hold on,
        plot(minGraylevel : maxGraylevel, entropyTotalNormal(minGraylevel + 1 : maxGraylevel + 1), '-r'),
        plot([threshold, threshold], [0.0, 1.0], 'r-.'), % ��Ǽ��������ֵ��λ��
        plot(xout, frequencyNormal),
        text(threshold, 0.5, ['\leftarrow' num2str(threshold)], 'HorizontalAlignment', 'left'),
        hold off;
        
end
    
function [imgbw] = subim2bw(img, threshold)
    imgbw = false(size(img));
    imgbw(img > threshold) = true;
end
