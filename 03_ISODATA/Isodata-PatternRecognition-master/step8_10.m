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


%��(��)�� �����������������ı�׼������ ÿ����������������׼�
Sigma(:,:)=0;
Sigma_temp(:,:)=0;
for i=1:Nc
    if delete(i,1)~=1
        for ii=1:n  %ѭ������
            for j=1:class_num_samples(i)
%                 a=class(:,n,i);
                a=class(j+1,ii,i);%��i���j��������ii����
                b=Center(i,ii+1);%i������ĵĵ�ii����
                Sigma_temp(j,ii)=(a-b)*(a-b);
            end
            Sigma(i,ii)=sqrt(sum(Sigma_temp(:,ii))/class_num_samples(i,1));
        end
    end
end
%(��)��ÿһ����׼�������е����������ô�������
for i=1:Nc
    if delete(i,1)~=1
    [Temp_I,Temp_M]=max(Sigma(i,:)');
    Sigma_max(i,1)=Temp_I;
    end
%(ʮ)����һ���������У�����Sigma_max>Theta_S,��ͬʱ������������֮һ�������������µľ������ġ�
%���������⣬Nc��ֵ��K��ֵ�����������Ŀ����ж��٣�

if Sigma_max(i,1)>Theta_S
    if class_num_samples(i,1)>2*(Theta_N+1)&&D_mean(i,1)>D_mean_total
        temp_judge_fenlie=1;
        Center(i,1)=-1;%������ѵĻ��������Ҳ��û��
        %���ѵĵ�һ�ࡣ
        for ii=1:999*Nc
            
            if (new_Center(ii,1)~=1)
                new_Center(ii,2:n+1)=Center(i,2:n+1);
                new_Center(ii,Temp_M+1)=Center(i,Temp_M+1)-k0*Sigma_max(i,1);
                new_Center(ii,1)=1;
                break;
            end
        end
        %���ѵĵڶ��ࡣ
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
    Center(i,1)=-1;%������ѵĻ��������Ҳ��û��,-1��ɾ��
    %���ѵĵ�һ�ࡣ
        for ii=1:999*Nc
            
            if (new_Center(ii,1)~=1)
                new_Center(ii,2:n+1)=Center(i,2:n+1);
                new_Center(ii,Temp_M+1)=Center(i,Temp_M+1)-k0*Sigma_max(i,1);
                new_Center(ii,1)=1;
                break;
            end
        end
        %���ѵĵڶ��ࡣ
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