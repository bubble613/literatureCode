
N=input('Please input the Polynomial oreder : \n');%
if N<0                                       %
    error('N must greartor or equal Zero :');%
end

n=N;
X_train=0:0.05:1;                            %
x=linspace(0,1,100);                         % for better resolution
Y_train=sin(X_train*20);                     % Input data with noise
y=sin(x*20);                                 % for better resolution
poly_coeff=polyfit(X_train,Y_train,n);       % polynomial coefficient calcualatin
Evaluated_data=polyval(poly_coeff,x);        % Evalution of ploy nomial
plot(x,Evaluated_data);                      % Plot Evaluated polynoiamial
hold on                                      %
plot(X_train,Y_train,'ro',x,y,'--g');        % Plot train data
xlabel('X');
ylabel('Train data and fitted curve');
Label=num2str(n);
title(['Evaluation of Curvefitting for order n=' Label]);
legend('Polynomial','Train Data','Location','NorthEast');
axis([0 1 -1.2 1.2]) 
