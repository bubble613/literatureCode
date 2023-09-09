function filePath = OpenFile(imgfilePath)
% 打开文件
% 输出参数：
% filePath——文件路径

if nargin < 1
    imgfilePath = fullfile(pwd, 'hehua.jpeg');
end

[filename, pathname, ~] = uigetfile( ...
    { '*.jpg','All jpg Files';...
    '*.png','All png Files';...
    '*.*',  '所有文件 (*.*)'}, ...
    '选择文件', ...
    'MultiSelect', 'off', ...
    imgfilePath);
filePath = 0;
if isequal(filename, 0) || isequal(pathname, 0)
    return;
end
filePath = fullfile(pathname, filename);
