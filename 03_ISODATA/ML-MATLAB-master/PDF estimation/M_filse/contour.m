clc
clear
close all
%%%%%%%%%%%%%%%%
% mean and covarince
mu = [1 3];
Sigma = [1 0; 0 1];   %% Contours are circle
%%%%%%%%%%%%%%%%%%%%%%%%%%
x1 = -4:.2:10; x2 = -4:.2:10;
[X1,X2] = meshgrid(x1,x2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
F = mvnpdf([X1(:) X2(:)],mu,Sigma); %%% multivariative guassian pdf
F = reshape(F,length(x2),length(x1));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
contour(x1,x2,F);
ylim([0 6]);
xlim([0 4]);
axis equal
xlabel('X');
ylabel('f_{X,Y}(x,y)');
title('Contour of Normal Distribution \Sigma=\sigma^2I ');
figure
%%%%%%%%%%%%%%%%%%%%%%%%%%
mesh(x1,x2,F);
xlabel('x1'); 
ylabel('x2'); 
zlabel('Probability Density');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
y=mvnrnd(mu,Sigma,1000);
figure
plot(y(:,1),y(:,2),'*');
xlabel('X');
ylabel('Y');
title('Random number with \mu=[3.5 3] and \Sigma=[8 0; 0 8] ');