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
for i=1:Num_new_Center+Num_Center %给新创建的Center赋值。
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
end%结束新类别的赋值。
new_Center(:,:)=0;


class_num_samples(:,1)=0;%重新数
class(:,:,:)=0;
D=zeros(N,Nc);
%（二）分给最近的聚类
for i=1:N
    for j=1:Nc    %！！！！！！！！！！！！！ 这里可能有错，因为Nc和K不等
        if Center(j,1)==1
            a=C_data(i,:);
            b=Center(j,2:n+1);
            D(i,j)=sqrt((a-b)*(a-b)');
        end
    end
    [temp_M,temp_I]=min(D(i,:)');%属于第temp_I类
    class_num_samples(temp_I,1)=class_num_samples(temp_I,1)+1;
    class(class_num_samples(temp_I,1)+1,:,temp_I)=C_data(i,:);%给样本根据最小距离分类.之所以加一是因为第一行是中心
end
    %由于第一行存了类别中心，所以+1

%（三）取消样本集与否,并且修正中心（一起搞才避免再计算的麻烦）。
for i=1:Nc
    if class_num_samples(i,1)<Theta_N%第i类中的样本个数
        %Nc=Nc-1;!!!!!!!!!!!!!!这里不减一，以后仍然Nc次循环，遇到删除了的类别跳过去.
        delete(i,1)=1;%应该delete第i个类
        Center(i,1)=-1;%delete标志。
    else
        %修正聚类中心
        Center(i,2:n+1)=sum(class(2:end,:,i))/class_num_samples(i,1);%新的聚类中心
        class(1,:,i)=Center(i,2:n+1);
    end
end

%（五）计算各聚类中模式样本与各聚类中心间的平均距离
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

%（六）计算全部模式样本和对应聚类中心的总平均值。

%D_mean_total=0;
for i=1:Nc
    if delete(i,1)~=1%恩，自以为很吊，注意到了求的是非删除的全部总平均距离.
    D_mean_total_temp(i,1)=class_num_samples(i,1)*D_mean(i,1);
    end
end
D_mean_total=sum(D_mean_total_temp(:,1))/N;
%(七)判别分裂、合并和迭代运算。

if iteration_num==I
    Theta_C=0;
    step11_14;%跳到十一步。
end
if Nc<=K/2
    step8_10;
    %跳到第八步
end
if Nc>=2*K   %求余数的函数rem
    step11_14;
    %十一步
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