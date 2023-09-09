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
%(十一)计算全部聚类中心的距离

for i=1:Nc-1
    if delete(i,1)~=1;
    for j=i+1:Nc
        D_total(i,j)=sqrt((Center(i,2:n+1)-Center(j,2:n+1))*(Center(i,2:n+1)-Center(j,2:n+1))');
        %十二、比较Dij和Theta_c的值，将Dij <θc 的值按最小距离次序递增排列，即
        %sort(D_total_compare);排序卵子用？
        
        %合并i,j类,j类删除了，i类留着呢
        if D_total(i,j)<Theta_C
            for ii=1:999*Nc  %遍历new_Center找到空间
                if new_Center(ii,1)~=1
                    new_Center(i,2:n+1)=(class_num_samples(a)*Center(a,2:n+1)+class_num_samples(b)*Center(b,2:n+1))/(class_num_samples(a)+class_num_samples(b));
                end
            end
            i_temp=1;
%十三、将距离为Dikjk的两个聚类中心Zik和ZjkZjk合并，得新的中心为：
            for jj=class_num_samples(i,1)+1:N%合并，把j类的元素全给了i类
                class(1,:,i)=new_Center(i,2:n+1);
                class(jj+1,:,i)=class(i_temp+1,:,j);
                i_temp=i_temp+1;
                if i_temp>class_num_samples(j,1)
                break;
                end
            end
            Nc=Nc-1;
            Center(j,1)=-1;
            %如果出现中心是-1，样本全是0，证明此类为空。
            class(2:end,:,j)=0;
            class(1,:,j)=-1;
        end
    end
    end
end




%十四、黎明前的黑暗。
if iteration_num==I
    judge_end=1;
    return ;
    %结束
end
%iteration_num=iteration_num+1;
if Nc<K
    step2_7;
end
%这一块应该放在最上面的，每次迭代到11-14都会问一次-----------------------------------------------
input_number=input('是否需要改变参数,需要输入1，不需要输入2:  ');
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
%跳与不跳
end