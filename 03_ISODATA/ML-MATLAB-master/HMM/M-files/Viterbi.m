%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Saber Hosseini Moghaddam                           %
% Date : 1392/10/21                                  %
% Classification of spoken digits using HMM (Viterbi)%
% Pattern Recognition Course                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
clear
close all;
% load test data set:
load('D:\Course\3_Third_Semester\Pattern\Homework\CHW_7_91123002\Train&Test\Test_Arabic_Digit');
%{A, Mean, Covariance}
load('D:\Course\3_Third_Semester\Pattern\Homework\CHW_7_91123002\A');
load('D:\Course\3_Third_Semester\Pattern\Homework\CHW_7_91123002\Mean');
load('D:\Course\3_Third_Semester\Pattern\Homework\CHW_7_91123002\covariance');

const_1=1/(2*pi)^(6.5);  % 13 Dimension
p_gauss=ones(10,2200);
for rr=1:2200
       o=test_data{rr};
          for d=1:10
              T=length(o(:,1));
              q=zeros(1,T);
              P=zeros(1,T);
              % Emission probability (Gaussian)
              p_emission=zeros(4,T);
              const=zeros(1,4);
              for nn=1:4
              const(nn)=const_1*(1/det(sigma{d}(:,:,nn)))^0.5;
              end
                        for tt=1:T
                            for nn=1:4
p_x(nn,tt)=const(nn)*exp(-0.5*...
    (o(tt,:)-u{d}(:,nn)')*...
    (sigma{d}(:,:,nn)\(o(tt,:)-u{d}(:,nn)')'));
                            end
                         end

Sai=zeros(4,T);
Score=zeros(4,T);
Score(1,1)=p_x(1,1);

               for tt=2:T
                   for nn=1:4
                        w=Score(:,tt-1).*A{d}(:,nn);
                        [a b]=max(w);
                              Score(nn,tt)=a*p_x(nn,tt);
                              Sai(nn,tt)=b;
                   end
               end
               
[P(T) q(T)]=max(Score(:,T));

            for tt=T-1:-1:1
                q(tt)=Sai(q(tt+1),tt+1);
            end
%LikeLihood
         for tt=1:T
             p_gauss(d,rr)=p_gauss(d,rr)*p_x(q(tt),tt);
         end
          end
end
 %claasification
      [a class]=max(p_gauss); % Max of Score
      true_classification=zeros(1,2200);
True=zeros(1,10);
               for d=1:10
                   for nn=1:220
true_classification(1,(d-1)*220+nn)...
    =true_classification(1,(d-1)*220+nn)+d;
% true_class
           if class(1,(d-1)*220+nn)==true_classification(1,(d-1)*220+nn)
                  True(d)=True(d)+1;
           end
                   end
               end
 %Correction Rate
CorrectRate=(True/220)*100;
for d=1:10
disp(['CorrectRate for digit(',num2str(d-1),')= ',num2str(CorrectRate(d)),'%'])
end
mean_class=mean(CorrectRate);
disp(['mean of CorrectRate= ',num2str(mean_class),'%'])