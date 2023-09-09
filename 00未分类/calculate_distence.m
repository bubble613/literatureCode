global k

[filename,PathName] = uigetfile({'*.BMP';'*.bmp';'*.tif';'*.jpg';'*.png'},'选择图像');
str = [PathName filename];
o=str2num(filename(1));
l=str2num(filename(2));
u=str2num(filename(3));
k=o*100+l*10+u;
if PathName ~=0
    OrginImage_O = imread(str);
    OrginImage = OrginImage_O(:,:,1:3); 
    
    imshow(OrginImage);
%     setappdata(handles.ChooseImage,'OrginImage',OrginImage);
end
distance_oh = 0; %计算图像直方图距离
                    % =1 计算欧氏距离

if distance_oh == 0
    IndexOfPoints=[];
%     OrginImage=getappdata(handles.ChooseImage,'OrginImage');
    load('HistFeatureExtraction.m');
    [m, n]=size(DataBaseFeatures);
    OrginImage_Gray = rgb2gray(OrginImage);
    [Count1,x] = imhist(OrginImage_Gray) ;%原始灰度图的每种灰度值的像素数Count1
    for index = 1:m
        Count2 = DataBaseFeatures{index,2};
        PathData = DataBaseFeatures{index,1};
        ComponentData = DataBaseFeatures{index,3};
        Sum1=sum(Count1);
        Sum2=sum(Count2);%阈值后灰度图的每种灰度值的像素数Count2
        Sumup = sqrt(Count1.*Count2); % 每个元素对应相乘再开平方根
        SumDown = sqrt(Sum1*Sum2); % 每幅图像像素总数相乘开平方根
        Sumup = sum(Sumup); 
        IndexOfBashi=1-sqrt(1-Sumup/SumDown); %计算图像直方图距离 %巴氏系数计算法
        IndexOfPoint{index,1}=IndexOfBashi;
        IndexOfPoint{index,2}=PathData;
        IndexOfPoint{index,3}=ComponentData;
    end
    
    IndexOfPoint=sortrows(IndexOfPoint);


    Serch = imread(IndexOfPoint{m,2});
    Serch = Serch(:,:,1:3);
    imshow(Serch);
    set(handles.text1,'string',IndexOfPoint{m,2});

    axes(handles.axes3); 
    Serch = imread(IndexOfPoint{(m-1),2});
    Serch = Serch(:,:,1:3);
    imshow(Serch);
    set(handles.text2,'string',IndexOfPoint{(m-1),2});
  
    axes(handles.axes4); 
    Serch = imread(IndexOfPoint{(m-2),2});
    Serch = Serch(:,:,1:3);
    imshow(Serch);
    set(handles.text3,'string',IndexOfPoint{(m-2),2});

    axes(handles.axes5); 
    Serch = imread(IndexOfPoint{(m-3),2});
    Serch = Serch(:,:,1:3);
    imshow(Serch);
    set(handles.text4,'string',IndexOfPoint{(m-3),2});
    
elseif distance_oh ~= 0
    Datadis=[];
    OrginImage=getappdata(handles.ChooseImage,'OrginImage');
    load('HISTFeatures.mat');
    [m,n]=size(DataBaseFeatures);
    x=rgb2gray(OrginImage) ;                      %将图片转为灰度图
    h=imhist(x);
    for n =1:m
        Count = DataBaseFeatures{n,2};
        FileName = DataBaseFeatures{n,1};
        ComponentData = DataBaseFeatures{n,3};
        EulerDistance=sqrt(sum((h-Count).*(h-Count)));      %计算欧氏距离
        Datadis{n,1}=EulerDistance;
        Datadis{n,2}=FileName ;%用元胞数组储存特征
        Datadis{n,3}=ComponentData;
    end
        
        Datadis=sortrows(Datadis)
        
        axes(handles.axes2); 
        Serch = imread(Datadis{1,2});
        Serch = Serch(:,:,1:3);
        imshow(Serch);
        set(handles.text1,'string',Datadis{1,2});

        axes(handles.axes3); 
        Serch = imread(Datadis{2,2});
        Serch = Serch(:,:,1:3);
        imshow(Serch);
        set(handles.text2,'string',Datadis{2,2});

        axes(handles.axes4); 
        Serch = imread(Datadis{3,2});
        Serch = Serch(:,:,1:3);
        imshow(Serch);
        set(handles.text3,'string',Datadis{3,2});
        
        axes(handles.axes5); 
        Serch = imread(Datadis{4,2});
        Serch = Serch(:,:,1:3);
        imshow(Serch);
        set(handles.text4,'string',Datadis{4,2});

end