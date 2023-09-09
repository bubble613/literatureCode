clc
clear 
close all
Rand_1_21=textread('D:\Course\Course_92_1\Pattern\Homework\Rand_data 1_21\1_21.txt');
x=linspace(0,1,100);
y=sin(20*x);
y1=y+rand(1,100)/4;
N=length(x);
M=input('Please inpute the order of polynomial:\n');
z=input('Do you want to use Regulalarization ?(y/n)\n','s');
if z=='y'
    lm=input('Please input the natural log of lambda(e.g. -18):\n');
else
    lm=-inf;
end
m=12;
    clf
    I=m;
for n=1:I
for i=1:I
    A(n,i)=sum(x.^(i+n-2));
end
end
A(1,1)=length(x);
lambda=exp(lm);
A=lambda*eye(I)+A;
for z=1:I
B(z,:)=sum(x.^(z-1).*y1);
end
w=(A)\B;

w=flipud(w);

p=polyval(w,x);
plot(x,y,'r');
hold on
plot(x,p,'b',x,y1,'ko');
xlabel('x');
ylabel('Amplitude');
title('Using Regularization coffecient to eliminate over-fitting');
legend('Data without noise','Fitted curve','Noisy data');


