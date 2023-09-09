%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Saber Hosseini Moghaddam                        %
% Date : 1392/9/28                                %
% Clustering of Iris flower Dataset using GMM     %
% Pattern Recognition Course                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc
close all
clear all;
%Loading database(150 datas in 3 classes)
load fisheriris;
Data=meas; % X is input matrix
iteration_number=0; % number of iterations
L=zeros(1,20); % value of log likelihood in each iteration
Target_vector=[zeros(50,1) zeros(50,1) ones(50,1)
       ;zeros(50,1) ones(50,1) zeros(50,1)
       ;ones(50,1) zeros(50,1) zeros(50,1)];%Target vector in mMatrix form
   
%Initialzation
%Means from K-means
Mu=[6.8538    3.0769    5.7154    2.0538;
    5.8836    2.7410    4.3885    1.4344;
    5.0060    3.4280    1.4620    0.2460];

u1=Mu(1,:);u2=Mu(2,:);u3=Mu(3,:);
u=[u1;u2;u3];
%covariance
cov1=eye(4,4);
cov2=cov1;
cov3=cov1;
%mixing (pi)
pi_1=1/3;pi_2=1/3;pi_3=1/3; % Equal
pi_=[pi_1 pi_2 pi_3];

%log likelihood:

gama=zeros(150,3);
log_likelihood=0;
for n=1:150
x=Data(n,:);
p(1)=(1/2*pi)^2*(1/det(cov1))^0.5*exp(-0.5*(x-u1)*((cov1)\(x-u1)'));
p(2)=(1/2*pi)^2*(1/det(cov2))^0.5*exp(-0.5*(x-u2)*((cov2)\(x-u2)'));
p(3)=(1/2*pi)^2*(1/det(cov3))^0.5*exp(-0.5*(x-u3)*((cov3)\(x-u3)'));
log_likelihood=log_likelihood+log(1/3*sum(p));
end
log_likelihood_old=log_likelihood;

% Expectation And Maximaization

 while iteration_number<30
       iteration_number=iteration_number+1;
% 2. E step

       for n=1:150
           x=Data(n,:);
           p(1)=(1/(2*pi)^2)* (1/det(cov1))^0.5*...
                exp( -0.5* (x-u(1,:))* (cov1\(x-u(1,:))') );
           p(2)=(1/(2*pi)^2)* (1/det(cov2))^0.5*...
                exp( -0.5* (x-u(2,:))* (cov2\(x-u(2,:))') );
           p(3)=(1/(2*pi)^2)* (1/det(cov3))^0.5*...
                 exp( -0.5* (x-u(3,:))* (cov3\(x-u(3,:))') );
            for k=1:3
                gama(n,k)=(pi_(k)*p(k))/(pi_(1)*...
                    p(1)+pi_(2)*p(2)+pi_(3)*p(3));
            end
        end

% 3. M step

Nk=sum(gama);
%means
                for k=1:3
                    sum1=0;
                    for n=1:150
                    sum1=sum1+gama(n,k)*Data(n,:);
                    end
                    u(k,:)=sum1/Nk(k);
                end
%covariances

                sum1=zeros(4,4);
                for n=1:150
                sum1=sum1+gama(n,1)*((Data(n,:)-u(1,:))'*...
                    (Data(n,:)-u(1,:)));
                end
                cov1=sum1/Nk(1);

                sum1=zeros(4,4);
                    for n=1:150
                    sum1=sum1+gama(n,2)*((Data(n,:)...
                        -u(2,:))'*(Data(n,:)-u(2,:)));
                    end
                     cov2=sum1/Nk(2);

                     sum1=zeros(4,4);
           for n=1:150
           sum1=sum1+gama(n,3)*((Data(n,:)-u(3,:))'...
               *(Data(n,:)-u(3,:)));
           end
           cov3=sum1/Nk(3);

           for k=1:3
           pi_(k)=Nk(k)/150;
           end

%log likelihood
log_likelihood_old=log_likelihood;
log_likelihood=0;
       for n=1:150
x=Data(n,:);
p(1)=(1/(2*pi)^2)* (1/det(cov1))^0.5*...
    exp( -0.5* (x-u(1,:))* (cov1\(x-u(1,:))') );
p(2)=(1/(2*pi)^2)* (1/det(cov2))^0.5*...
    exp( -0.5* (x-u(2,:))* (cov2\(x-u(2,:))') );
p(3)=(1/(2*pi)^2)* (1/det(cov3))^0.5*...
    exp( -0.5* (x-u(3,:))* (cov3\(x-u(3,:))') );
log_likelihood=log_likelihood+...
    log(pi_(1)*p(1)+pi_(2)*p(2)+pi_(3)*p(3));
       end
L(iteration_number)=log_likelihood;
if log_likelihood_old==log_likelihood
break
end
end

L(iteration_number:20)=[];
plot(L)
hold on
plot (L,'^r')
title ('Log Likelihood')
%plot
disp('////////////////Mixture coefficient\\\\\\\\\\\\\\')
disp 'Pi:'
disp(['pi1= ',num2str(pi_(1)),' , pi2= ',num2str(pi_(2)),' , pi3= ',num2str(pi_(3))])
disp('//////////////////////////Mean\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\')
disp 'Mu:'
disp (['mean of cluster[1]= ',num2str(u(1,:))])
disp (['mean of cluster[2]= ',num2str(u(2,:))])
disp (['mean of cluster[3]= ',num2str(u(3,:))])
disp('///////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\')
%Evaluate Conditional Entropy:
r=zeros(150,3);
for n=1:150
[val k]=max(gama(n,:));
r(n,k)=1;
end
prior=zeros(1,3); %prior probabilities for each clusters
joint_probability=zeros(3,3); %joint probabilities for each pairs of class & cluster*N
H=0; %Conditional Entropy
prior(1)=sum(r(:,3));
prior(2)=sum(r(:,2));
prior(3)=sum(r(:,1));
     for c=1:3
         for k=1:3
             joint_probability(c,k)=sum(sum (r(50*(c-1)+1:50*c,:) &...
                 Target_vector(50*(k-1)+1:50*k,:)) );
                    if joint_probability(c,k)~=0
            H=H+ (joint_probability(c,k)/150) *...
                log10(joint_probability(c,k)/prior(k));
                    end
         end
       end
H=-1*H;
disp(['Conditional Entropy= ',num2str(H)])