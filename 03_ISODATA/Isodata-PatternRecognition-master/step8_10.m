function step8_10
global N;
global n;
global Nc;
global Theta_N;
global Theta_S;
global Theta_C;
global L;
global I;
global K;
global class_num_samples;
global Center;
global D_mean;
global delete;
global D_temp;
global D_mean_total_temp;
global Sigma;
global class;
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
global temp_judge_fenlie;


%第(八)步 计算聚类中样本距离的标准差向量 每个类有特征数个标准差。
Sigma(:,:)=0;
Sigma_temp(:,:)=0;
for i=1:Nc
    if delete(i,1)~=1
        for ii=1:n  %循环特征
            for j=1:class_num_samples(i)
%                 a=class(:,n,i);
                a=class(j+1,ii,i);%第i类第j个样本的ii特征
                b=Center(i,ii+1);%i类的中心的第ii特征
                Sigma_temp(j,ii)=(a-b)*(a-b);
            end
            Sigma(i,ii)=sqrt(sum(Sigma_temp(:,ii))/class_num_samples(i,1));
        end
    end
end
%(九)求每一个标准差向量中的最大分量，用存起来。
for i=1:Nc
    if delete(i,1)~=1
    [Temp_I,Temp_M]=max(Sigma(i,:)');
    Sigma_max(i,1)=Temp_I;
    end
%(十)在任一最大分良机中，若有Sigma_max>Theta_S,又同时满足两个条件之一，则分类成两个新的聚类中心。
%这里有问题，Nc的值和K的值，到底类别数目最大有多少？

if Sigma_max(i,1)>Theta_S
    if class_num_samples(i,1)>2*(Theta_N+1)&&D_mean(i,1)>D_mean_total
        temp_judge_fenlie=1;
        Center(i,1)=-1;%本身分裂的话，这个类也就没了
        %分裂的第一类。
        for ii=1:999*Nc
            
            if (new_Center(ii,1)~=1)
                new_Center(ii,2:n+1)=Center(i,2:n+1);
                new_Center(ii,Temp_M+1)=Center(i,Temp_M+1)-k0*Sigma_max(i,1);
                new_Center(ii,1)=1;
                break;
            end
        end
        %分裂的第二类。
        for jj=ii+1:999*Nc
            if new_Center(jj,1)~=1
                new_Center(jj,2:n+1)=Center(i,2:n+1);
                new_Center(jj,Temp_M+1)=Center(i,Temp_M+1)+k0*Sigma_max(i,1);
                new_Center(jj,1)=1;
                Nc=Nc+1;
                break;
            end
        end
    end
    
    

if Nc<=K/2
    temp_judge_fenlie=1;
    Center(i,1)=-1;%本身分裂的话，这个类也就没了,-1是删除
    %分裂的第一类。
        for ii=1:999*Nc
            
            if (new_Center(ii,1)~=1)
                new_Center(ii,2:n+1)=Center(i,2:n+1);
                new_Center(ii,Temp_M+1)=Center(i,Temp_M+1)-k0*Sigma_max(i,1);
                new_Center(ii,1)=1;
                break;
            end
        end
        %分裂的第二类。
        for jj=ii+1:999*Nc
            if new_Center(jj,1)~=1
                new_Center(jj,2:n+1)=Center(i,2:n+1);
                new_Center(jj,Temp_M+1)=Center(i,Temp_M+1)+k0*Sigma_max(i,1);
                new_Center(jj,1)=1;
                Nc=Nc+1;
                break;
            end
        end
end

if temp_judge_fenlie==1
    step2_7;
end

end
end
end