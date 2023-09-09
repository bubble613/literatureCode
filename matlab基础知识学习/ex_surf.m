x=-8:0.5:8;
y=x;
[X,Y]=meshgrid(x,y);
R=sqrt(X.^2+Y.^2)+eps;
Z=2*sin(R)./R;
surf(X,Y,Z) 