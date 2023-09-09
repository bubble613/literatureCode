clc
clear 
close all
Rand_1_21=textread('D:\Course\Course_92_1\Pattern\Homework\Rand_data 1_21\1_21.txt');
Rand_1_101=textread('D:\Course\Course_92_1\Pattern\Homework\Rand_data 1_21\1_101.txt');

for n=1:15
    clf
x_1=0:0.05:1;
y_1=sin(20*x_1);
y_1_n=y_1+Rand_1_21;
pc1=polyfit(x_1,y_1_n,n);

x_2=0:0.01:1;
y_2=sin(20*x_2);
y_2_n=y_2+Rand_1_101;
pc2=polyfit(x_2,y_2_n,n);

poly_value1=polyval(pc1,x_1);

poly_value1_res=polyval(pc1,x_2);
y_1_res=sin(20*x_2);

poly_value2=polyval(pc2,x_2);


subplot(211);
plot(x_2,poly_value1_res,'r',x_2,y_1_res,'b--');
xlabel('x');
ylabel('Amplitude');
title ('Over-fitting becuase of small amount of train data')
hold on
plot(x_1,y_1_n,'ko');
legend('Estimated curve','Data without noise','Real data','location','southeastoutside');

subplot(212);
plot(x_2,poly_value2,'r',x_2,y_2,'b--');
xlabel('x');
ylabel('Amplitude');
title ('Increased data set prevents over-fitting')
hold on
plot(x_2,y_2_n,'ko');
legend('Estimated curve','Data without noise','Real data','location','southeastoutside');
pause(1)

end


