%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Saber Hosseini Moghaddam                %
%       Date : 1392/8/22                        %
%       Classification of Pima indianes Dataset %
%       With Least square                       % 
%       Pattern Recognition Course              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
Descreption: first we seperate the data and target from each other.
then we seperate train data (first 20%) from all of the data and target vector.
After we agument 1 into Train_data to generate X Matrix.
to compute W_tilda we use the equation of (4.16) of pattern recognition
book (bishop). 
then we test the algorithm with the remaining data (remaining 80%)
%}
%%
clc
clear
close all
load Diabet.mat



%Seperation of Data and target
Diabet_data=Diabet(:,1:8);
Diabet_Target=Diabet(:,9);
%Train data 20% of all of the data 
Train_data=Diabet_data(1:154,1:8);
Train_Target=Diabet_Target(1:154,:);


% 
X=[ones(154,1),Train_data];
W_tilda=pinv(X)*[Train_Target,~Train_Target];

% test data with remaining data (80%)
m=1;
 for i=155:768
 y=W_tilda'*[1;Diabet_data(i,:)'];
            if(y(1,1)>y(2,1))
                k(m,:)=1;
            else
                k(m,:)=0;
            end
 m=m+1;
end
d=0;
x=155;
% find the wrong classified data
for n=1:length(k)
         if (k(n,:)~=Diabet_Target(x,:))
             d=d+1;
         end
         x=x+1;
end

class_1_classifier=find(k==1);
class_0_classifier=find(k==0);

target=Diabet_Target(155:768);

TP=0;
FN=0;
TN=0;
FP=0;
%{
True positive: Sick people correctly diagnosed as sick
False positive: Healthy people incorrectly identified as sick
True negative: Healthy people correctly identified as healthy
False negative: Sick people incorrectly identified as healthy

Sensitivity=TP/(TP+FN);
Specificity=TN/(TN+FP);
Precision=TP/(TP+FP);
Accuracy=(TP+TN)/(TP+FN+FP+TN);
%}
for h=1:614
    if k(h,:)==1 & target(h,:)==1
       TP=TP+1;
    end
    
    
    if k(h,:)==0 & target(h,:)==1
       FN=FN+1;
    end
    
    
    if k(h,:)==0 & target(h,:)==0
       TN=TN+1;
    end
    
    
    if k(h,:)==1 & target(h,:)==0
       FP=FP+1;
    end
     
end

Sensitivity=TP/(TP+FN);
Specificity=TN/(TN+FP);
Precision=TP/(TP+FP);
Accuracy=(TP+TN)/(TP+FN+FP+TN);



class_1_dataset=find(Diabet_Target(155:768)==1);
class_0_dataset=find(Diabet_Target(155:768)==0);



%plot of the precent of Sick people and Healthy people in all data set
Diabet_Target_1=length(class_1_dataset);
Diabet_Target_0=length(class_0_dataset);
h=pie([Diabet_Target_1,Diabet_Target_0],[0,1]);
colormap jet


textObjs = findobj(h,'Type','text');
oldStr = get(textObjs,{'String'});
val = get(textObjs,{'Extent'});
oldExt = cat(1,val{:});
Names = {'Sick(Dataset): ';'Healthy(Dataset):'};
newStr = strcat(Names,oldStr);
set(textObjs,{'String'},newStr)

set(h(1),'FaceColor','y')
set(h(3),'FaceColor','r')



figure(2);

%plot of the precent of Sick people and Healthy people in test data set
Diabet_class_1=length(class_1_classifier);
Diabet_class_0=length(class_0_classifier);
p=pie([Diabet_class_1,Diabet_class_0],[0,1]);
colormap jet

textObjs = findobj(p,'Type','text');
oldStr = get(textObjs,{'String'});
val = get(textObjs,{'Extent'});
oldExt = cat(1,val{:});
Names = {'Sick(Classifier): ';'Healthy(classifier):'};
newStr = strcat(Names,oldStr);
set(textObjs,{'String'},newStr)
set(p(1),'FaceColor','y')
set(p(3),'FaceColor','r')