% clc;clear;close;

function isodata

global N;
global n;
global Nc;
global C_data;
%�������ļ���������ĿΪN��������Ϊn
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
%���ÿ��Ʋ���(һ)
Nc=1;
K=2;Theta_N=1;Theta_S=1;Theta_C=4;L=1;I=4;
if K>=Nc
    temp=K;
else
    temp=Nc;
end

% parameter;

%�����ķָ��ߣ�һ�ѿռ�---------------------------------------------------------
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
class_num_samples=zeros(temp,1);%����Ҫ�Ĳ�����ÿ��������ж�������

%�����ĳ�ʼֵ�����ҵ�һ�б궨�Ƿ�����ռ�Ϊ�ա�1Ϊ�ǣ�0Ϊ�գ�-1Ϊɾ����
Center=zeros(temp,n+1);
Center(1:Nc,2:n+1)=C_data(1:Nc,:);
Center(1:Nc,1)=1;%��,

delete=zeros(Nc*999,1);
D_mean=zeros(Nc*999,1);%���ô洢ƽ������Ŀռ䣬�����Nc�ࡣÿ�������N������
D_temp=zeros(N,1);
D_mean_total_temp=zeros(N,1);
Sigma=zeros(temp,n);
Sigma_temp=zeros(N,n);
Sigma_max=zeros(temp,1);
D_total=zeros(Nc*999,Nc*999);
D_total_compare=zeros(Nc*Nc,3);
new_Center=zeros(999*Nc,n+1);
new_Center(:,1)=-1;%��һ�б�־һ���Ƿ�ռ�á�-1Ϊ�գ�1Ϊռ��
D_mean_total=0;
iteration_num=0;
D_temp_num=1;
k0=0.5;%����ϵ��
Num_Center=0;  %������Ŀ



class=zeros(N+1,n,K);%ÿ������������������Num_samples,�ʿ϶�����t�����ȫռ����
class(1,:,:)=-1;
%ע�⣬class�е�һ�������ġ�
for i=1:Nc
    class(1,:,i)=Center(i,2:n+1);%���ѡC_data,Class�е�ÿ��ĵ�һ��������.
end


step2_7;%�������������·���

%step8_10;%����
%step11_14;%�ϲ�
figure;

plot(class(1,1,1),class(1,2,1),'r*',class(2:end,1,1),class(2:end,2,1),'r.');
hold on;
plot(class(1,1,2),class(1,2,2),'g*',class(2:end,1,2),class(2:end,2,2),'g.');
hold on;
plot(class(1,1,3),class(1,2,3),'b*',class(2:end,1,3),class(2:end,2,3),'b.');
axis([0 8 0 10]);
end