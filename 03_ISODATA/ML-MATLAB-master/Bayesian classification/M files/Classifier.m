clc
clear 
close all
load fisheriris;
x=meas(1:150,3);               %% Data in 3rd coloumn
%%%%%%%%%%%%%%%%%%%%%%%%
mu_set1=mean(meas(1:50,3));              %% mean of Setosa (Petal length)
sig_2_set1=var(meas(1:50,3));           %% variance of Setosa (Petal length)
p_d_set1=sum(normpdf(meas(1:50,3),mu_set1,sqrt(sig_2_set1))); 
y_set1=normpdf(meas(91:120,3),mu_set1,sqrt(sig_2_set1));
P_set1=y_set1/p_d_set1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mu_set2=mean(meas(51:100,3));       %% mean of versicolor (Petal length)
sig_2_set2=var(meas(51:100,3));   %% variance of versicolor (Petal length)
p_d_set2=sum(normpdf(meas(51:100,3),mu_set2,sqrt(sig_2_set2)));
y_set2=normpdf(meas(91:120,3),mu_set2,sqrt(sig_2_set2));
P_set2=y_set2/p_d_set2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mu_set3=mean(meas(121:150,3));       %% mean of virginica (Petal length)
sig_2_set3=var(meas(121:150,3));     %% variance of virginica (Petal length)
p_d_set3=sum(normpdf(meas(121:150,3),mu_set3,sqrt(sig_2_set3)));
y_set3=normpdf(meas(91:120,3),mu_set3,sqrt(sig_2_set3));
P_set3=y_set3/p_d_set3;
for i=1:30
    if (P_set1(i,:) > P_set2(i,:) && P_set1(i,:) > P_set3(i,:))
        a(i,:)=1;
    else
        a(i,:)=0;
    end
    
      if (P_set2(i,:) > P_set1(i,:) && P_set2(i,:) > P_set3(i,:))
        b(i,:)=1;
    else
        b(i,:)=0;
    end
    
      if (P_set3(i,:) > P_set1(i,:) && P_set3(i,:) > P_set2(i,:))
        c(i,:)=1;
    else
        c(i,:)=0;
    end
    
end
subplot(211)
bar(a,'b');
hold on
bar(2*b,'r')
hold on 
bar(3*c,'k')
xlim([0 31]);
xlabel('Data in Iris dataset (3rd column)')
title('Classification of Iris dataset with Bayes approach')
legend('class 1','class 2','class 3','Location','NorthWest');
subplot(212)
stem(P_set1)
hold on
stem(P_set2,'r')
hold on
stem(P_set3,'k')
xlabel('Data in Iris dataset (3rd column)')
title('A posterior probabilty of dataset')
legend('class 1','class 2','class 3','Location','NorthWest');
