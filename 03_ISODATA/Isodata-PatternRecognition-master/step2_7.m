function step2_7
global class;
global N;
global n;
global Nc;
global K;
global Theta_N;
global Theta_S;
global Theta_C;
global L;
global I;
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
global C_data;
global Num_new_Center;
global temp_judge_fenlie;


iteration_num=iteration_num+1;
Num_Center=0;
Num_new_Center=0;
temp_Center=Center;
if temp_judge_fenlie==0
    new_Center(:,:)=0;
end
[rows_Center_total,aslkfjkslafjkl]=size(Center);
for i=1:rows_Center_total
    if Center(i,1)==1
    Num_Center=Num_Center+1;
    end
    if new_Center(i,1)==1
    Num_new_Center=Num_new_Center+1;
    end
end


if (Num_new_Center+Num_Center)>rows_Center_total
    Center=zeros(Num_new_Center/2+Num_Center,n+1);
for i=1:Num_new_Center+Num_Center %���´�����Center��ֵ��
    if i<=Num_Center
        Center(i,:)=temp_Center(1,:);
    else
        Center(i,:)=new_Center(i,:);
    end
end
else
    temp_i=1;
    for i=1:rows_Center_total
    if Center(i,1)~=1
        if new_Center(temp_i,1)==1
        Center(i,:)=new_Center(temp_i,:);
        end
        temp_i=temp_i+1;
    end
    end
end%���������ĸ�ֵ��
new_Center(:,:)=0;


class_num_samples(:,1)=0;%������
class(:,:,:)=0;
D=zeros(N,Nc);
%�������ָ�����ľ���
for i=1:N
    for j=1:Nc    %�������������������������� ��������д���ΪNc��K����
        if Center(j,1)==1
            a=C_data(i,:);
            b=Center(j,2:n+1);
            D(i,j)=sqrt((a-b)*(a-b)');
        end
    end
    [temp_M,temp_I]=min(D(i,:)');%���ڵ�temp_I��
    class_num_samples(temp_I,1)=class_num_samples(temp_I,1)+1;
    class(class_num_samples(temp_I,1)+1,:,temp_I)=C_data(i,:);%������������С�������.֮���Լ�һ����Ϊ��һ��������
end
    %���ڵ�һ�д���������ģ�����+1

%������ȡ�����������,�����������ģ�һ���ű����ټ�����鷳����
for i=1:Nc
    if class_num_samples(i,1)<Theta_N%��i���е���������
        %Nc=Nc-1;!!!!!!!!!!!!!!���ﲻ��һ���Ժ���ȻNc��ѭ��������ɾ���˵��������ȥ.
        delete(i,1)=1;%Ӧ��delete��i����
        Center(i,1)=-1;%delete��־��
    else
        %������������
        Center(i,2:n+1)=sum(class(2:end,:,i))/class_num_samples(i,1);%�µľ�������
        class(1,:,i)=Center(i,2:n+1);
    end
end

%���壩�����������ģʽ��������������ļ��ƽ������
D_temp(:,:)=0;
D_mean(:,:)=0;
for i=1:Nc
    if delete(i,1)~=1
    for j=1:class_num_samples(i,1)
        a=class(j+1,:,i);
        b=Center(i,2:n+1);
        D_temp(j,1)=sqrt((a-b)*(a-b)');
    end
    D_mean(i,1)=sum(D_temp(1:class_num_samples(i,1),1))/class_num_samples(i,1);
    end
end

%����������ȫ��ģʽ�����Ͷ�Ӧ�������ĵ���ƽ��ֵ��

%D_mean_total=0;
for i=1:Nc
    if delete(i,1)~=1%��������Ϊ�ܵ���ע�⵽������Ƿ�ɾ����ȫ����ƽ������.
    D_mean_total_temp(i,1)=class_num_samples(i,1)*D_mean(i,1);
    end
end
D_mean_total=sum(D_mean_total_temp(:,1))/N;
%(��)�б���ѡ��ϲ��͵������㡣

if iteration_num==I
    Theta_C=0;
    step11_14;%����ʮһ����
end
if Nc<=K/2
    step8_10;
    %�����ڰ˲�
end
if Nc>=2*K   %�������ĺ���rem
    step11_14;
    %ʮһ��
end
if (Nc>K/2)&&(Nc<2*K)
    if rem(iteration_num,2)==0
        step11_14;
    end
    if rem(iteration_num,2)~=0
        step8_10;
    end
end

end