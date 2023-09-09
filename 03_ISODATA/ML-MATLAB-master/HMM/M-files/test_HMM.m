%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Saber Hosseini Moghaddam                          %
% Date : 1392/10/21                                 %
% Classification of spoken digits using HMM         %
% Pattern Recognition Course                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
clear
close all;
% load test data set:
load('D:\Course\3_Third_Semester\Pattern\Homework\CHW_7_91123002\Train&Test\Test_Arabic_Digit');
% load parameters {A, Mean, Covariance}
load('D:\Course\3_Third_Semester\Pattern\Homework\CHW_7_91123002\A');
load('D:\Course\3_Third_Semester\Pattern\Homework\CHW_7_91123002\Mean');
load('D:\Course\3_Third_Semester\Pattern\Homework\CHW_7_91123002\covariance');

const1=1/(2*pi)^(6.5);    % 13 Dimension
Likelihood=ones(10,2200);

for rr=1:2200
    X=test_data{rr};
       for dd=1:10
           N=length(X(:,1));
           % Emission matrix (Gaussian)
           p_xn_zn=zeros(4,N);
           const=zeros(1,4);
                for kk=1:4
                const(kk)=const1*(1/det(sigma{dd}(:,:,kk)))^0.5;
                end
                    for nn=1:N
                        for kk=1:4
                            p_xn_zn(kk,nn)=const(kk)*exp(-0.5*(X(nn,:)-u{dd}(:,kk)')...
                            *(sigma{dd}(:,:,kk)\(X(nn,:)-u{dd}(:,kk)')'));
                        end
                    end
                    %Alpha & cn:
                    Alpha=zeros(4,N);
                    Alpha(:,1)=[0.25 0.25 0.25 0.25]'; % initializing Alpha
                    %cn_m_alpha  cn multiplied by Alpha
                    cn_m_Alpha=zeros(4,N);
                    c=zeros(1,N); c(1)=p_xn_zn(1,1);
                          for nn=2:N
                              for jj=1:4
                                  sum1=0;
                                  for kk=1:4
                                      sum1=sum1+Alpha(kk,nn-1)...
                                          *A{dd}(kk,jj);
                                  end
                                  cn_m_Alpha(jj,nn)=p_xn_zn(jj,nn)*sum1;
                              end
                              %Summation on [zn {cn.alpha(zn)}]=cn
                              c(nn)=sum(cn_m_Alpha(:,nn)); 
                              Alpha(:,nn)=cn_m_Alpha(:,nn)/c(nn);%  Alpha
                          end
                        % LikeLihood
                          for nn=1:N
                              Likelihood(dd,rr)=Likelihood(dd,rr)*c(nn);
                          end
       end
end
% test claasification:
[a class]=max(Likelihood);
true_classification=zeros(1,2200);
True=zeros(1,10);
               for dd=1:10
                   for nn=1:220
                       true_classification(1,(dd-1)*220+nn)=...
                           true_classification(1,(dd-1)*220+nn)+dd;

if class(1,(dd-1)*220+nn)==true_classification(1,(dd-1)*220+nn)
True(dd)=True(dd)+1;
end
                   end
               end
%classification rate
CorrectRate=(True/220)*100;
for dd=1:10
disp(['CorrectRate for digit(',num2str(dd-1),')= ',num2str(CorrectRate(dd)),'%'])
end
disp('//////////////Correction Rate\\\\\\\\\\\')
average=mean(CorrectRate);
disp(['mean of CorrectRate= ',num2str(average),'%'])