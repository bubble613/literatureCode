clc
clear
close all

mu1 = [1 1];
SIGMA1 = [1 0; 0 1];
r1 = mvnrnd(mu1,SIGMA1,100);
plot(r1(:,1),r1(:,2),'r+');

hold all

mu2 = [5 5];
SIGMA2 = [1 0; 0 1];
r2 = mvnrnd(mu2,SIGMA2,100);
plot(r2(:,1),r2(:,2),'bo');

mean_class_1=mean(r1);
mean_class_2=mean(r2);

plot(mean_class_1(1,1),mean_class_1(1,2),'k*');

plot(mean_class_2(1,1),mean_class_2(1,2),'k*');



cov_class_1=cov(r1);
cov_class_2=cov(r2);

Cov=cov_class_2+cov_class_1;

Covinv=inv(Cov);

W=Covinv * ((mean_class_2-mean_class_1)');

for i=1:100   
y1(i,:)=W'*r1(i,:)';
y2(i,:)=W'*r2(i,:)';
end

figure

hist(y1);
set(get(gca,'child'),'FaceColor','r','EdgeColor','b')
hold on
hist(y2)
