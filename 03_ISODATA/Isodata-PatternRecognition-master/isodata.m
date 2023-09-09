% clc;clear;close;

function isodata

global N;
global n;
global Nc;
global C_data;
%读数据文件，样本数目为N，特征数为n
n=2;
file=fopen('data_iso.txt','r');
C_data=textscan(file,[repmat('%f',[1,n])],'CollectOutput',1);
C_data=cell2mat(C_data);
fclose(file);
[N,n]=size(C_data(:,:));

global Theta_N;
global Theta_S;
global Theta_C;
global L;
global I;
global K;
%function parameter
%设置控制参数(一)
Nc=1;
K=2;Theta_N=1;Theta_S=1;Theta_C=4;L=1;I=4;
if K>=Nc
    temp=K;
else
    temp=Nc;
end

% parameter;

%华丽的分割线，一堆空间---------------------------------------------------------
global class;
global class_num_samples;
global Center;
global D_mean;
global delete;
global D_temp;
global D_mean_total_temp;
global Sigma;
global Sigma_temp;
global Sigma_max;
global D_total;
global D_total_compare;
global new_Center;
global D_mean_total;
global iteration_num;
global D_temp_num;
global k0;
global Num_Center;
global Num_new_Center;
global temp_judge_fenlie;
global judge_end;
class_num_samples=zeros(temp,1);%很重要的参数，每个类别中有多少样本

%给中心初始值，并且第一列标定是否这个空间为空。1为是，0为空，-1为删除了
Center=zeros(temp,n+1);
Center(1:Nc,2:n+1)=C_data(1:Nc,:);
Center(1:Nc,1)=1;%有,

delete=zeros(Nc*999,1);
D_mean=zeros(Nc*999,1);%设置存储平均距离的空间，最多有Nc类。每类最多有N个样本
D_temp=zeros(N,1);
D_mean_total_temp=zeros(N,1);
Sigma=zeros(temp,n);
Sigma_temp=zeros(N,n);
Sigma_max=zeros(temp,1);
D_total=zeros(Nc*999,Nc*999);
D_total_compare=zeros(Nc*Nc,3);
new_Center=zeros(999*Nc,n+1);
new_Center(:,1)=-1;%第一列标志一下是否被占用。-1为空，1为占了
D_mean_total=0;
iteration_num=0;
D_temp_num=1;
k0=0.5;%分裂系数
Num_Center=0;  %中心数目



class=zeros(N+1,n,K);%每个类别中样本数最多是Num_samples,故肯定不会t个类别全占满的
class(1,:,:)=-1;
%注意，class中第一行是中心。
for i=1:Nc
    class(1,:,i)=Center(i,2:n+1);%随便选C_data,Class中的每类的第一行是中心.
end


step2_7;%基本运算与重新分类

%step8_10;%分裂
%step11_14;%合并
figure;

plot(class(1,1,1),class(1,2,1),'r*',class(2:end,1,1),class(2:end,2,1),'r.');
hold on;
plot(class(1,1,2),class(1,2,2),'g*',class(2:end,1,2),class(2:end,2,2),'g.');
hold on;
plot(class(1,1,3),class(1,2,3),'b*',class(2:end,1,3),class(2:end,2,3),'b.');
axis([0 8 0 10]);
end