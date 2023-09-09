
N=10000;   %Number of samples
Nb_bins=30; %Number of bins for the histogram computation

%Distribution parameters
type=input('Please specify the distribution : \n','s');   %set 'exp','unif' or 'chi2'
%set number of iteration
iteration=input('Please specify the number of iterations : \n');   
parameter1=1;
parameter2=2;

x=zeros(1,N); %initialisation of x
number_of_variables=0;

for i=1:iteration
    
    switch type
        case 'exp'
            random_vector=random('exp',parameter1,1,N);
            original_distribution_mean=(1/parameter1);
            original_distribution_var=1/(parameter1^2);
            distrib_name='exponential';
        case 'unif'   
            random_vector=random('unif',parameter1,parameter2,1,N);
            original_distribution_mean=0.5*(parameter2+parameter1);
            original_distribution_var=(1/12)*(parameter2-parameter1)^2;
            distrib_name='uniform';
        case 'chi2'
            random_vector=random('chi2',parameter1,1,N);
            original_distribution_mean=parameter1;
            original_distribution_var=2*parameter1;
            distrib_name='chi2';
    end        
    x=x+random_vector;
    
    %Value of z=(x1+...+xn)/n
    number_of_variables=number_of_variables+1;
    z=x/number_of_variables;
    
    %Histogram of z
    [n,axis_x]=hist(z,Nb_bins);
    deltaX=axis_x(2)-axis_x(1);
    pdf_estimate=n/(N*deltaX);    
    
    
    %Gaussian pdf
    mean_estimate=original_distribution_mean; 
    var_estimate=original_distribution_var/number_of_variables;
    [pdf_gaussian]=pdf('norm',axis_x,mean_estimate,sqrt(var_estimate));
    
    %Display the two pdfs
    plot(axis_x,pdf_estimate);
    hold on;
    plot(axis_x,pdf_gaussian,'r');
    hold off;
    ylim([0 max([pdf_estimate pdf_gaussian])+1]);
    legend(sprintf('Sum of %d i.i.d variables z=(x1+...xn)/n',number_of_variables),'Gaussian pdf');
    xlabel('Random variable: X');
    ylabel('Probability density fonction f_X(x)');
    title(sprintf('Central Limit Theorem (CLT) (%s distribution)',distrib_name)); 
    pause(0.01)
end