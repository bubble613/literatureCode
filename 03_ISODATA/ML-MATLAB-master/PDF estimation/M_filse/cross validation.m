clc
clear 
close all
load fisheriris
y=meas(:,3);
n=0;
i=1;
r=0.1;
k=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% Histogram
[f,x]=hist(y,10);
[fi,xi] = ksdensity(y); 
bar(x,f/sum(f)/abs(x(2)-x(1)),'b','EdgeColor','b');
z=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% KDE
for d=-2:0.01:8
    o=abs(y-d);
    a=find(o<=0.5);
    p(z,:)=length(a)/(0.5*150);
    z=z+1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
a=linspace(-2,8,length(p));
hold on
plot(a,p,'r','LineWidth',3);
hold on
plot(xi,fi,'k','LineWidth',3);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% KNN
for s=-2:.01:8
   r=.1;
R=abs(y-s);
while r<=7
        
     z=find(R<=r);
      
    if length(z)>=8
           break
    end
    
       r=r+0.1;
       end
P(k,:)=length(z)/(2*pi*150*r);
k=k+1;
end
t=linspace(-2,8,1001);
hold on
plot(t,P,'g','LineWidth',3);
xlabel('Samples of iris Dataset (all of 3rd column)');
title('Probability density estimation(PDE) with Histogram, KDE & KNN');
legend('Histogram','KDE','Matlab KDE','KNN');