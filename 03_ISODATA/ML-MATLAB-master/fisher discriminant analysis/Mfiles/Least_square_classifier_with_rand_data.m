
clc
clear
close all

mu1 = [1 1];
SIGMA1 = [1 0; 0 1];
r1 = mvnrnd(mu1,SIGMA1,100);
plot(r1(:,1),r1(:,2),'r+');

hold on;

mu2 = [5 5];
SIGMA2 = [1 0; 0 1];
r2 = mvnrnd(mu2,SIGMA2,100);
plot(r2(:,1),r2(:,2),'bo');

hold on
mu3 = [2.5 2.5];
SIGMA3 = [2 0; 0 2];
r3 = mvnrnd(mu3,SIGMA3,100);
plot(r3(:,1),r3(:,2),'k*');


R=[ones(200,1),[r1;r2]];
W=pinv(R)*[ones(100,1),zeros(100,1);zeros(100,1),ones(100,1)];

for i=1:100
    
y=W'*[1;r3(i,1);r3(i,2)];
if(y(1,1)>y(2,1))
    plot(r3(i,1),r3(i,2),'r*')
else
    plot(r3(i,1),r3(i,2),'b*')
end
end

figure
plot(r3(:,1),r3(:,2),'k*');
