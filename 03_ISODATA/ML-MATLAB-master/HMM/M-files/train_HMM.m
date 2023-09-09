%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Saber Hosseini Moghaddam                          %
% Date : 1392/10/20                                 %
% Classification of spoken digits using HMM         %
% Pattern Recognition Course                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc
clear 
close all;

% load train dataset:
load('D:\University\Course\3_Third_Semester\Pattern\Homework\CHW_7_91123002\Train&Test\Train_Arabic_Digit');

%initilization of Pi vectore________ Uniform
pi_vector=[0.25 0.25 0.25 0.25]'; 

A=cell(1,10);
Mean=A; 
Sigma=A; 
Gamma=cell(1,660);
kesi=cell(1,660);
N=zeros(1,660);
likelihood=cell(1,10);
const1=1/(2*pi)^(13/2);

% initialization
X(1:660)=train_data(1:660);
for dd=1:10
    %A_matrix======> initilized uniformly=======> left 2 right
         A{dd}=[0.25 0.25 0.25 0.25;0 0.25 0.25 0.5;0 0 0.5 0.5;0 0 0 1];
         Sigma{dd}=zeros(13,13,4);
         for kk=1:4
             Sigma{dd}(:,:,kk)=eye(13,13);
             Mean{dd}(:,kk)=mean(X{kk})';
        end
end



for dd=1:10% 0 =====> 9
    iteration=1; 
    likelihood{dd}=ones(660,9);
    X(1:660)=train_data((dd-1)*660+1:dd*660);
    while iteration<=9
%Expectation
      for rr=1:660
          N(rr)=length(X{rr}(:,1));
          % Emission function =======> Gaussian
          p_emission=zeros(4,N(rr));
          const=zeros(1,4);
            for kk=1:4
                const(kk)=const1*(1/det(Sigma{dd}(:,:,kk)))^0.5;
            end
                for n=1:N(rr)
                    for kk=1:4
                    p_emission(kk,n)=const(kk)*...
                        exp(-0.5*(X{rr}(n,:)-Mean{dd}(:,kk)')...
                    *(Sigma{dd}(:,:,kk)\(X{rr}(n,:)-Mean{dd}(:,kk)')'));
                    end
                end
   
         alpha=zeros(4,N(rr));
         alpha(:,1)=[0.25 0.25 0.25 0.25].'; % uniform
         %  cn_m_alpha  ======> cn multiplied by alpha
         cn_m_alpha=zeros(4,N(rr));
         c=zeros(1,N(rr)); c(1)=p_emission(1,1);
         for n=2:N(rr)
             for j=1:4
                 Sum=0;
                 for kk=1:4
                 Sum=Sum+alpha(kk,n-1)*A{dd}(kk,j);
                 end
                 cn_m_alpha(j,n)=p_emission(j,n)*Sum;
             end
             %Summation on [zn {cn.alpha(zn)}]=cn
              c(n)=sum(cn_m_alpha(:,n));
              alpha(:,n)=cn_m_alpha(:,n)/c(n);
         end
              % Beta
              Beta=zeros(4,N(rr));
              Beta(:,N(rr))=[1 1 1 1]';
              for n=N(rr)-1:-1:1
                   for j=1:4
                       Sum=0;
                         for kk=1:4
                           Sum=Sum+Beta(kk,n+1)*...
                               p_emission(kk,n+1)*A{dd}(j,kk);
                         end
                       Beta(j,n)=Sum/c(n+1);
                   end
              end
             %Likelihood p(X)
              for n=1:N(rr)
                  likelihood{dd}(rr,iteration)=likelihood{dd}(rr,iteration)*c(n);
              end 
             %Gamma
                  Gamma{rr}=alpha.*Beta;
             %kesi
             for n=2:N(rr)
                 for kk=1:4
                     for j=1:4
                     kesi{rr}(kk,j,n)=alpha(kk,n-1)...
                         *p_emission(j,n)*A{dd}(kk,j)*Beta(j,n);
                     end
                 end
                 kesi{rr}(:,:,n)=kesi{rr}(:,:,n)/c(n);
             end
      end
% Maximization { evaluation of A, pi and phi (for gaussian)}
for j=1:4
    for kk=1:4
    
        Sum=0;
        for rr=1:660
            for n=2:N(rr)
                Sum=Sum+kesi{rr}(j,kk,n);
            end
        end
        
       Sum_2=0;
       for rr=1:660
           for l=1:4
               for n=2:N(rr)
                   Sum_2=Sum_2+kesi{rr}(j,l,n);
               end
           end
       end
       A{dd}(j,kk)=Sum/Sum_2; % Ajk based on 13.19 Bishop
    end
end

 for kk=1:4
     
       Sum=0;
         for rr=1:660
             for n=1:N(rr)
                 Sum=Sum+Gamma{rr}(kk,n)*X{rr}(n,:);
             end
         end
         
         Sum_2=0;
         for rr=1:660
             for n=1:N(rr)
                 Sum_2=Sum_2+Gamma{rr}(kk,n);
             end
         end
                 Mean{dd}(:,kk)=Sum/Sum_2; % Mean based on 13.20 Bishop
 end
  
                for kk=1:4
                    
                     Sum=zeros(13,13);
                     for rr=1:660
                         for n=1:N(rr)
                             xn=X{rr}(n,:);
                             uk=Mean{dd}(:,kk);
                              Sum=Sum+Gamma{rr}(kk,n)...
                                  *((xn'-uk)*(xn'-uk)');
                         end
                     end
                     
                     Sum_2=0;
                     for rr=1:660
                         for n=1:N(rr)
                             Sum_2=Sum_2+Gamma{rr}(kk,n);
                         end
                     end
                     Sigma{dd}(:,:,kk)=Sum/Sum_2; % Sigma Matrix based on 13.21
                end
                iteration=iteration+1;
    end
  end
% save parameters: {A, Mean, Covariance}
% save('D:\Course\3_Third_Semester\Pattern\Homework\CHW_7_91123002\A' ,'A');
% save('D:\Course\3_Third_Semester\Pattern\Homework\CHW_7_91123002\Mean' ,'u');
% save('D:\Course\3_Third_Semester\Pattern\Homework\CHW_7_91123002\covariance' ,'sigma');