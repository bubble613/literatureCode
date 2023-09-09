%下例为读取文件夹中的所有图片；

folder='filename';

filepaths = dir(fullfile(folder,'*.bmp'));
% 列出该文件夹下所有.bmp格式的文件（其中包括文件的名字、日期、像素等）；

for i = 1 : length(filepaths)

    image = imread(fullfile(folder,filepaths(i).name));%读入第i个图片；
    image = rgb2ycbcr(image);
    image = im2double(image(:, :, 1));%获得图像的y通道；
    
    im_label = modcrop(image, scale);%保证图像被scale整除；
    [hei,wid] = size(im_label);
    %对图像用’bicubic’先下采样再上采样；
    im_input = imresize(imresize(im_label,1/scale,'bicubic'),[hei,wid],'bicubic');
    %提取数据；
    for x = 1 : stride : hei-size_input+1
        for y = 1 :stride : wid-size_input+1
            %子图像尺寸33*33；
            subim_input = im_input(x : x+size_input-1, y : y+size_input-1);
            subim_label = im_label(x+padding : x+padding+size_label-1,...
                y+padding : y+padding+size_label-1);%子图像类别尺寸21*21；
            
            %subim_input和subim_label的中心一致；
            count=count+1;
            
            data(:, :, 1, count) = subim_input;
            label(:, :, 1, count) = subim_label;
        end
    end
end