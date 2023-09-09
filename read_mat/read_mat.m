% make_gt_seg_image.m
clc, clear, close all;

% bsdsRoot 变量的值为包含train、test、val文件夹的地址

%在处理时应当提前在groundTruth下新建文件夹seg，seg里需要新建train、test、val三个子文件夹

%将state依次修改为test、train、val，即可完成对groundTruth下三个文件夹的处理并生成相应的jpg文件 
state = 'val';
bsdsRoot = '/Users/liwangyang/Desktop/研究生-图像分割/数据集/BSDS500/BSDS500/data/groundTruth/';
file_list = dir(fullfile(bsdsRoot, state, '*.mat'));%获取该文件夹中所有.mat格式的图像
for i = 1 : length(file_list)
    mat = load(fullfile(bsdsRoot, state, file_list(i).name));
    [~, image_name, ~] = fileparts(file_list(i).name);
    gt = mat.groundTruth;
    for gtid = 1 : length(gt)
        % seg = double(gt{gtid}.Boundaries); % gt中有两个字段
        % Segmentation和Boundaries 根据需求解析图像
        seg = double(gt{gtid}.Boundaries);
        seg = seg / max(max(seg));
        if gtid == 1
            image = seg;
        else
            image = image + seg;
        end
    end
    image = image / length(gt);
    imwrite(double(image), fullfile(bsdsRoot, 'seg', state, [image_name '.jpg']));
end