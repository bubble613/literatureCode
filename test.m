clc;
clear;
%% ����ԭͼ
% ָ��ͼ���·��
imgPath = '/Users/liwangyang/Desktop/�о���-ͼ��ָ�/���ݼ�/BSDS500/BSDS500/data/groundTruth'; 
% ָ����Ҫ���ص��ļ���ʽ��jpg
imgDir  = dir([imgPath '*.jpg']);

%% ����ԭͼgroundtruthͼ��
% ָ��groundtruthͼ���·��
% gtPath = 'E:/����/����ѧϰ/��һƪ����׫дʵ������/����ʵ��ͼ������/06-ʵ����/Ƥ����ָ�ʵ��/09-��ʵͼ��/';
% ָ����Ҫ���ص��ļ���ʽ��jpg
% gtDir = dir([gtPath '*.jpg']);

%% ����ͼ���ָ�ͼ��
% ��������ͼ��⣬˳�����ļ��е�����Ϊ׼
for i = 1 : length(imgDir)
    % ��ȡͼ��ע�����ļ�����ͬ�������¶���gt��
    img = imread([imgPath imgDir(i).name]);
    % gt = imread([gtPath gtDir(i).name]);
    
    % ���˵��Ҷ�ͼ�񣬸����������Թ��˵���ɫͼ�񣬿����ǵ�����
    % if size(img,3) == 1
    %     continue;
    % end
    
    % ��ȡ�ļ�����Ϊ�ָ��ͼ�񱣴���ļ���
    name = imgDir(i).name;
    % �ָ���������ǵķָ������Ҫ������в����������
    [Label01, Label02, time] = main(img);
    
    % �ر���ʾ��ͼ��
    close all;
    
    % д��excel�ļ�
    xlswrite('ECT�ָ�����02.xlsx',[time, ME, SSIMVALUE],['A',num2str(i),':C',num2str(i)]);
    
    % ����ָ��ͼ��
    imwrite(Label01, strcat('ECT��Ĥ�ָ�01/',name));
    imwrite(Label02, strcat('ECT��Ĥ�ָ�02/',name));
end
