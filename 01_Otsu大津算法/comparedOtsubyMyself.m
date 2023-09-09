function [] = comparedOtsubyMyself(fwrite)
%��������:����Otsu�����ģ��Լ����ֱ�д��Otsu���������Һ�Matlab7.0�ṩ��Otsu���������˱Ƚ�
%�ο����ף�
%Otsu, N., "A Threshold Selection Method from Gray-Level Histograms," IEEE
%Transactions on Systems, Man, and Cybernetics, Vol. 9, No. 1, 1979, pp. 62-66.
%--------------------------------------------------------------------------

%��������ʾ����
%ʾ��1�� close all;comparedOtsubyMyself(true);
%ʾ��2�� close all;comparedOtsubyMyself(false);
    
    [fileName,pathName] = uigetfile({'*.bmp';'*.tif';'*.*'},...
                                'Select the original image file');
    fileName = strcat(pathName,fileName);
    img = imread(fileName);
    if (size(img,3) == 3)%�������ͨ��ͼ�񣬽���ת��Ϊ��ͨ��ͼ��
        figure,imshow(img),title('Original Color Image');
        img = rgb2gray(img);
    end
    figure,imshow(img),title('Original Image');
    figure,imhist(img),title('Image histogram');
   
    tic;
    threshold = localComputeThreshold(img);%���þֲ���������ͼ�����ֵ
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
    
    %���漸����matlab�Դ���otsu��ֵ�ָ��㷨�����ں�localMethodX�ıȽ�
    level = graythresh(img);
    disp(strcat('�Դ�Otsu��ֵΪ', num2str(level * 255)));
    
    BW = imbinarize(img, level);
    figure,imshow(im2double(BW));
   
    
function [finalThreshold] = localComputeThreshold(img)
    minGraylevel = uint16(min(min(img)));
    maxGraylevel = uint16(max(max(img)));
    elementNumbers = length(img(:));%���ͼ���ܵ����ظ���
        for ii = 0:255
            [imgbw] = im2bw(img,ii/255); %��ÿ���Ҷ�ֵ��ʹ�������һ����ֵͼ��
            A = img(imgbw);
            B = img(~imgbw);
            if (isempty(A) || isempty(B))
                sigma(ii+1) = 0;
            else
                sigma(ii+1) = (mean(A) - mean(B))^2*(numel(A)/elementNumbers)*(numel(B)/elementNumbers);
            end
        end
   
    %Ϊ�˱��ڹ۲�sigmaֵ���ɵ����ߣ���sigma��ֵ�����˹�һ��[0,1]
    sigmaNormal = (sigma - min(sigma))/(max(sigma)-min(sigma));
    [maxValue,threshold] = max(sigmaNormal);
    finalThreshold = threshold - 1;
    disp([maxValue,finalThreshold]);
    
    [frequency,xout]=imhist(img);
    %Ϊ�˱��ڹ۲�Ҷ�ֵ���ֵ�Ƶ�ʹ��ɵ����ߣ��Ҷ�ֱ��ͼ������frequencyֵ�����˹�һ��[0,1]
    frequencyNormal = (frequency-min(frequency))./(max(frequency)-min(frequency));
    
    figure(100),hold on,
    plot(minGraylevel:maxGraylevel,sigmaNormal(minGraylevel+1:maxGraylevel+1),'-r'),
    plot([threshold, threshold],[0.0 1.0],'r-.'),%��Ǵ��������ֵ��λ��
    plot(xout,frequencyNormal),
    text(threshold,0.5,['\leftarrow' num2str(threshold)],'HorizontalAlignment','left'),
    hold off;
