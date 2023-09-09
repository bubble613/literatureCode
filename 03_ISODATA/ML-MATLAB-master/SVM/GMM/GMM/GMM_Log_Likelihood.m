%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Saber Hosseini Moghaddam                        %
% Date : 1392/9/30                                %
% Evaluating of Log-Likelihood function of GMM    %
% Pattern Recognition Course                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
close all
clear

load fisheriris; %Loading database
Data=meas; % Data
L=zeros(1,10);
TARGET=[zeros(50,1) zeros(50,1) ones(50,1)
       ;zeros(50,1) ones(50,1)  zeros(50,1)
       ;ones(50,1)  zeros(50,1) zeros(50,1)];
   
     for K=1:10 % Number Mixtures====> 2 to 10
             iteration=0; 
             u=zeros(K,4);
               for k=1:K
                   u(k,:)=Data(k,:);
               end

             cov=zeros(4,4*K);
                        for k=1:K
                            cov(:,4*(K-1)+1:4*K)=eye(4,4);
                        end
            %Mixture Coeff
            pi_coeff=ones(1,K);
            pi_coeff=pi_coeff/K;
            %Evaluating log-likelihood
            gama=zeros(150,K);
            log_likelihood=0;
            p=zeros(1,K);
                           for n=1:150
                               x=Data(n,:);
                                 for k=1:K
      p(k)=pi_coeff(k)*((1/(2*pi)^2)* (1/det(cov(:,4*(K-1)+1:4*K)))^0.5...
    * exp( -0.5* (x-u(k,:))* (cov(:,4*(K-1)+1:4*K)\(x-u(k,:))') ));
                                 end
                              log_likelihood=...
                              log_likelihood+log(sum(p));
                           end
           log_likelihood_old=log_likelihood;


    while iteration<30
          iteration=iteration+1;
%E step

   for n=1:150
   x=Data(n,:);
      for k=1:K
          p(k)=pi_coeff(k)*((1/(2*pi)^2)* (1/det(cov(:,4*(K-1)+1:4*K)))^0.5*...
          exp( -0.5* (x-u(k,:))* (cov(:,4*(K-1)+1:4*K)\(x-u(k,:))') ));
      end
           for k=1:K
           gama(n,k)=p(k)/sum(p);
           end
   end

%M step

         Nk=sum(gama);

         for k=1:K
         sum1=0;
               for n=1:150
               sum1=sum1+gama(n,k)*Data(n,:);
               end
         u(k,:)=sum1/Nk(k);
         end

         sum1=zeros(4,4*K);
                  for k=1:K
                       for n=1:150
                       sum1(:,4*(K-1)+1:4*K)=sum1(:,4*(K-1)+1:4*K)...
                           +gama(n,k)*((Data(n,:)-u(k,:))'*...
                           (Data(n,:)-u(k,:)));
                       end
                  end
         for k=1:K
         cov(:,4*(K-1)+1:4*K)=sum1(:,4*(K-1)+1:4*K)/Nk(k);
         end
%Mixture Coeff
for k=1:K
pi_coeff(k)=Nk(k)/150;
end

%Evaluate the log-likelihood
log_likelihood_old=log_likelihood;
log_likelihood=0;
       for n=1:150
           x=Data(n,:);
             for k=1:K
                 p(k)=pi_coeff(k)*((1/(2*pi)^2)*...
                (1/det(cov(:,4*(K-1)+1:4*K)))^0.5*...
                exp( -0.5* (x-u(k,:))* (cov(:,4*(K-1)+1:4*K)\(x-u(k,:))') ));
             end
           log_likelihood=log_likelihood+log(sum(p));
       end
  if log_likelihood_old==log_likelihood
      break
  end
    end
   L(K)=log_likelihood;
     end
 %plot 
figure
plot(L)
hold on
plot (L,'^r')
title ('Log Likelihood(Mixtures=2 to 10)')
xlabel ('Number of Mixtures')
ylabel ('log-likelihood')
