clc
clear all
close all
load fisheriris
x=meas;
data1=([meas(1:50,1),meas(1:50,2),meas(1:50,3),meas(1:50,4)]);
data2=([meas(51:90,1),meas(51:90,2),meas(51:90,3),meas(51:90,4)]);
data3=([meas(121:150,1),meas(121:150,2),meas(121:150,3),meas(121:150,4)]);
mu1=mean(data1);
mu2=mean(data2);
mu3=mean(data3);
var1=cov(data1);
var2=cov(data2);
var3=cov(data3);
%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%
P_set1=mvnpdf(x(91:120,:),mu1,var1);
P_set2=mvnpdf(x(91:120,:),mu2,var2);
P_set3=mvnpdf(x(91:120,:),mu3,var3);
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
bar(a,'r');
hold on
bar(2*b,'b');
hold on
bar(3*c,'k');
xlim([0 31]);
xlabel('Data in Iris Data set');
title('clssification with FisherIris data set (S-fold S=5)');
title('clssification with FisherIris data set ');
legend('class1','class2','class3','location','northwest');
