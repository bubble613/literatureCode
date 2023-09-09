clc
clear 
close all
load fisheriris;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rng(0,'twister');
cp = cvpartition(species,'k',5);      %% K-fold with K=5;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
train_data=meas(1:150,3); %% all of 3rd column
nb=NaiveBayes.fit(train_data,species,'Distribution','normal'); %%normal dist
predict1=nb.predict(meas(1:150,3));
class = confusionmat(species,predict1)
bad = ~strcmp(predict1,species);
a=sum(bad)/150  %%%%%%%% number of wrong classification
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
nbGauClassFun = @(xtrain,ytrain,xtest)...
               (predict(NaiveBayes.fit(xtrain,ytrain), xtest));
                      
nbGauCVErr  = crossval('mcr',meas(1:150,3),species,...
           'predfun', nbGauClassFun,'partition',cp)
       for i=1:150
       [post(i,:),cpre(i,:),logp(i,:)] = posterior(nb,meas(i,3));
       end
       %%%%%%%%% cpre is the class assignment
       stem(post);
       xlabel('Data in Iris dataset (3rd column)')
       ylabel('Probability of each data')
       title('Posteroir distribution of each class')
       legend('class 1','class 2','class 3')
       z=double(~bad(1:50));
       u=double(~bad(51:100));
       f=double(~bad(101:150));
       figure
       subplot(311);
       stem(z,'b');
       xlabel('Data in Iris dataset (3rd column)')
       title('Classification of Iris dataset with bayes approach')
       legend('class 1')
       subplot(312);
       stem(u,'r');
       legend('class 2')
       xlabel('Data in Iris dataset (3rd column)')
       subplot(313);
       stem(f,'k')
       legend('class 3')
       xlabel('Data in Iris dataset (3rd column)')
       
       