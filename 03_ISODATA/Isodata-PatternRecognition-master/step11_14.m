function step11_14
global class;
global N;
global K;
global n;
global Nc;
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
global temp_judge_fenlie;
global judge_end;

temp_judge_fenlie=0;
%(ʮһ)����ȫ���������ĵľ���

for i=1:Nc-1
    if delete(i,1)~=1;
    for j=i+1:Nc
        D_total(i,j)=sqrt((Center(i,2:n+1)-Center(j,2:n+1))*(Center(i,2:n+1)-Center(j,2:n+1))');
        %ʮ�����Ƚ�Dij��Theta_c��ֵ����Dij <��c ��ֵ����С�������������У���
        %sort(D_total_compare);���������ã�
        
        %�ϲ�i,j��,j��ɾ���ˣ�i��������
        if D_total(i,j)<Theta_C
            for ii=1:999*Nc  %����new_Center�ҵ��ռ�
                if new_Center(ii,1)~=1
                    new_Center(i,2:n+1)=(class_num_samples(a)*Center(a,2:n+1)+class_num_samples(b)*Center(b,2:n+1))/(class_num_samples(a)+class_num_samples(b));
                end
            end
            i_temp=1;
%ʮ����������ΪDikjk��������������Zik��ZjkZjk�ϲ������µ�����Ϊ��
            for jj=class_num_samples(i,1)+1:N%�ϲ�����j���Ԫ��ȫ����i��
                class(1,:,i)=new_Center(i,2:n+1);
                class(jj+1,:,i)=class(i_temp+1,:,j);
                i_temp=i_temp+1;
                if i_temp>class_num_samples(j,1)
                break;
                end
            end
            Nc=Nc-1;
            Center(j,1)=-1;
            %�������������-1������ȫ��0��֤������Ϊ�ա�
            class(2:end,:,j)=0;
            class(1,:,j)=-1;
        end
    end
    end
end




%ʮ�ġ�����ǰ�ĺڰ���
if iteration_num==I
    judge_end=1;
    return ;
    %����
end
%iteration_num=iteration_num+1;
if Nc<K
    step2_7;
end
%��һ��Ӧ�÷���������ģ�ÿ�ε�����11-14������һ��-----------------------------------------------
input_number=input('�Ƿ���Ҫ�ı����,��Ҫ����1������Ҫ����2:  ');
if input_number==1
    K=input('K:');
    Theta_N=input('Theta_N:  ');
    Theta_S=input('Theta_S:  ');
    Theta_C=input('Theta_C:  ');
    L=input('L:  ');
    I=input('I:  ');
    step2_7;
end
if input_number==2
    step2_7;
end
if input_number~=1&&input_number~=2
    disp('error!Input again.\n!');
    return;
end
%-----------------------------------------------
%���벻��
end