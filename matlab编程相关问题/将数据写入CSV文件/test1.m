clc,clear;close all;

%% csvwrite方法
% csvwrite(FILENAME,M);
% writes matrix M into FILENAME as comma-separated values.
% csvwrite(FILENAME,M,R,C);
%writes matrix M starting at offset row R, and column C in the file.
r = -5 + (5+5)*rand(10,1);

csvwrite('1.csv',r);% csv是从（0，0）开始写入数据 在表格中显示为（1，1）
% csvwrite('1.csv',r, 1, 1);% R,C分别表示写入的行数R和列数C，并且左上角被认为是(0,0)

%% dlmwrite方法

r1 = randi([10 50],10,15);
% 将第一行加到test.csv中，并且以逗号为分隔符
% dlmwrite('1.csv',r1(1,:),'delimiter',',');
% 将第二行加到test.csv中，并且从行后添加
% dlmwrite('1.csv',r1(2,:),'delimiter',',','-append');
% 将第三行加到test.csv中，并且以相对于已有数据偏移的方式
dlmwrite('1.csv',r1(3,:),'delimiter',',','-append',...
            'roffset',2,'coffset',2);

%% writetable方法 *****
 
% writetable方法给予了很大的发展空间，按列进行保存。
% 可以设置行名称
% 首先创建一个1-n的列向量，具体为行向量的转置
BD1=1:10;
BD2=BD1.';
r1 = randi([10 50],10,15);

% 列名称
title = {'NO','obj1','obj2'};

%生成表格，按列生成
% VariableNames 参数用于设置列头
result_table = table(BD2,r1(:,1), r1(:,2), 'VariableNames', title)

% 保存数据
writetable(result_table, '2.csv');

%% fprintf方法

%{ 
fprintf函数不仅可以向csv文件中输入数据，还可以向各种文件中输入数据，
是最万能的方法！也是灵活程度最高的方法。
%}

% 注意fprintf不支持元胞数组
% title={'NO','obj1','obj2'};%这样写会报错
% fprintf(fid,'%s,%s,%s\n',title(1),title(2),title(3));
% fprintf(fid,'%s,%s,%s\n',cell2mat(title(1)),...
%         cell2mat(title(2)),cell2mat(title(3)));

% Create a csv file
% 查阅 fopen文档
fid = fopen('3.csv','a'); %打开或创建要写入的新文件。追加数据到文件末尾。
BD1 = 1 : size(r1, 1);% size(x,1)表示行数，size(x,2)表示列数
if fid<0
	errordlg('File creation failed','Error');
end
title = {'NO', 'obj1', 'obj2'};
fprintf(fid,'%s,%s,%s\n',cell2mat(title(1)),cell2mat(title(2)),...
                            cell2mat(title(3)));
% r1 数据一共有10行
for i = 1:size(r1, 1)
	fprintf(fid, '%d,%d,%d\n', BD1(i), r1(i, 1), r1(i, 2));
end
fclose(fid);

%% writematrix方法
M = magic(5);
M2 = [5 10 15 20 25; 30 35 40 45 50];
fibonacci1 = [1 1 2 3; 5 8 13 21; 34 55 89 144];
fibonacci2 = [233 377 610 987];
% WriteMode txt 选择append 否则默认 overwrite
%           xls 选择inplace append overwritesheet replacefile
% Delimiter ',' 'comma'--' ' 'space'--'\t' 'tab'--';' 'semi'--'|' 'bar'
% sheet 工作区 1, 2, .....

% writematrix(M);
% type 'M.txt';

% writematrix(M, 'M_tab.txt', 'delimiter', 'tab');
% type 'M_tab.txt'

% writematrix(M, 'M.xls', 'sheet', 2, 'range', 'A3:E7');
% readmatrix('M.xls', 'sheet', 2, 'range', 'A3:E7');

% writematrix(M, 'M.xlsx', 'sheet', 2, 'range', 'A3:E7', 'UseExcel', true);

writematrix(M, 'M1.xlsx', 'sheet', 2, 'range', 'A3:E7');
writematrix(M2,'M1.xlsx','WriteMode','append', 'sheet', 2);
writematrix(fibonacci1,'fibonacci.txt')
writematrix(fibonacci2, 'fibonacci.txt', 'WriteMode', 'append');
readmatrix('fibonacci.txt')

% readmatrix('M1.xlsx', 'sheet', 2);

