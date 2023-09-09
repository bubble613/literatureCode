clc
clear 
close all
x_train=0:0.05:1;
y_train=sin(20*x_train);
i=input('Please inpute the begin of interval:(1,2,3 or 4)\n');
N=input('Please input the order of polynomial:\n');
        
for n=1:N
poly_coeff=polyfit(x_train,y_train,n);
poly_value_train=polyval(poly_coeff,x_train);

% x1=linspace(0,1,100);
% x2=linspace(i,i+1,100);

poly_res=polyval(poly_coeff,x1);

x_test_1=i:0.05:i+1;
y_test=sin(20*x_test_1);

% y1=sin(20*x1);
% y2=sin(20*x2);

E0(n,:)=sum((poly_value_train-y_train).^2);

q0(n,:)=sqrt(E0(n,:)/21);

E(n,:)=sum((poly_value_train-y_test).^2);

q(n,:)=sqrt(E(n,:)/21);

l=length(q);
z=1:l;

end

      figure
plot(z,q,'r--s',z,q0,'b--s');
xlabel('Order of polynomial');
ylabel('Amount of error of trained polynomial for diffrent orders');
title(['Error of trained polynomial for interval (' num2str(i) ',' num2str(i+1) ')']);
 
