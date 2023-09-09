%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Saber Hosseini Moghaddam                        %
% Date : 1392/9/20                                %
% Classification of Iris flower Dataset using SVM %
% Pattern Recognition Course                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
clear
close all

load fisheriris;

Data=meas; % loading Dataset
Mu=0;      %Mean of true classification
Correct_Class=0;
%{
One Versue the Rest
C1 not && C2 not ===> C3
C2 not && C3 not ===> C1
C1 not && C3 not ===> C2

Attention ==> Ambiguous Region ;)
%}

Setosa = [ones(50,1);zeros(50,1);zeros(50,1)]; %class 1 

Versicolor =[zeros(50,1);ones(50,1);zeros(50,1)]; %class 2

for i=1:5
    

True_classification=0; %Number of true classification

classification=zeros(1,30);

subset=ones(150,1);
subset(10*(i-1)+1:10*i,1)=zeros(10,1);
subset(51+10*(i-1):50+10*i,:)=zeros(10,1);
subset(101+10*(i-1):100+10*i,:)=zeros(10,1);
Nselect=~subset;


Target_vector=[ones(10,1) zeros(10,1) zeros(10,1)...
    ;zeros(10,1)   ones(10,1)  zeros(10,1)...
    ;zeros(10,1)   zeros(10,1) ones(10,1)]; %Target vector in matrix form

TrainData=logical(subset);%index of train data
TestData=logical(Nselect);%index of test data

%%%%%%%%%%////SVM training and testing for calss 1\\\\%%%%%%%%%
SVMS_train_setosa =svmtrain(Data(TrainData,:),Setosa(TrainData,:),...
    'method','QP','kernel_function','rbf');
classify_setosa = svmclassify(SVMS_train_setosa,Data(TestData,:));


%%%%%%%%%////SVM training and testing for calss 1\\\\%%%%%%%%%%
SVMS_train_versicolor =svmtrain(Data(TrainData,:),Versicolor(TrainData),...
    'method','QP','kernel_function','rbf');
classify_versicolor = svmclassify(SVMS_train_versicolor,Data(TestData,:));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

classes_virginica=~(classify_setosa+classify_versicolor);
Class_of_data=[classify_setosa classify_versicolor classes_virginica];

for n=1:30
    
Sum_of_row=sum(Class_of_data(n,:));
      if Sum_of_row==1 %Finding ambiguous regions
          
         [value_1 index]=find(Class_of_data(n,:)==1) ;
         [value_2 TrueClass]=find(Target_vector(n,:)==1);
         
         classification(n)=index;
         
                    if index==TrueClass 
                       figure(i);
                       bar (n,classification(n),'b');
                       title(['classification(fold-',num2str(i),')']);
                       xlim([0 31])
                       hold on
                       True_classification=True_classification+1;
                    else
                       figure(i);
                       bar (n,classification(n),'r');
                       
                       hold on
                    end
    else %data is classified in more than one class
       classification(n)=0.5; 
       figure(i);
       bar(n,classification(n),'k');
       hold on
      end
end
Correct_Class=True_classification/30*100;
Percent(i,:)=Correct_Class;
Mu=(Mu+Correct_Class);
disp(['CorrectRate(fold-',num2str(i),')=',num2str(Correct_Class),'%'])
end
Mu=Mu/5;
figure
hBar=bar(1:5,[Percent 100-Percent],0.5,'stacked');%Create a stacked histogram
set(hBar,{'FaceColor'},{'b';'r'});
ylim([0 150]);
xlabel('Fold number');
ylabel('Percent (%)')
title('Percent of classification')

