%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Saber Hosseini Moghaddam                %
%       Date : 1392/8/24                        %
%       Classification of Pima indianes Dataset %
%       with fisher's Discriminant
%       Pattern Recognition Course              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
clc
clear
close all
load Diabet
%%%%%%%%%%%%%%%%%%%%%%%%
Diabet_data=Diabet(:,1:8);
Diabet_target=Diabet(:,9);


Train_data=Diabet_data(1:154,:);
Train_target=Diabet_target(1:154,:);

Test_data=Diabet_data(155:768,:);
Test_target=Diabet_target(155:768,:);

Train_data_class_0=Train_data(find(Train_target==0),:);
Train_data_class_1=Train_data(find(Train_target==1),:);

mean_class_0=mean(Train_data_class_0);
mean_class_1=mean(Train_data_class_1);

Cov_class_0=cov(Train_data_class_0);
Cov_class_1=cov(Train_data_class_1);


Within_Class_Cov=(Cov_class_0+Cov_class_1);

W= inv(Within_Class_Cov) * ((mean_class_1-mean_class_0)');

n=1;
for i=1:100
    y1(n,:)=W'*Train_data_class_0(i,:)';
    n=n+1;
end

m=1;
for z=1:54
    y2(m,:)=W'*Train_data_class_1(z,:)';
    m=m+1;
end

hist(y1,15);
set(get(gca,'child'),'FaceColor','r','EdgeColor','b')
hold on
hist(y2)
title('Histogram of Projected Train Data');
xlabel('Projected Data');
ylabel('Number of prjected data in each Bin');

k=1;
for u=155:768
   o(k,:)=W'*Diabet_data(u,:)'; 
   
   if o(k,:)>4
       G(k,:)=1;
       
   else
       G(k,:)=0;
   end
   k=k+1;
end

L=0;
   for g=1:614
       if (G(g,:)~=Test_target(g,:))
           L=L+1;
       end
   end
   
   
TP=0;
FN=0;
TN=0;
FP=0;

for h=1:614
    if G(h,:)==1 & Test_target(h,:)==1
       TP=TP+1;
    end
    
    
    if G(h,:)==0 & Test_target(h,:)==1
       FN=FN+1;
    end
    
    
    if G(h,:)==0 & Test_target(h,:)==0
       TN=TN+1;
    end
    
    
    if G(h,:)==1 & Test_target(h,:)==0
       FP=FP+1;
    end
     
end

Sensitivity=TP/(TP+FN);
Specificity=TN/(TN+FP);
Precision=TP/(TP+FP);
Accuracy=(TP+TN)/(TP+FN+FP+TN);


A=length(find(G==1));
B=length(find(G==0));
figure
h=pie([A,B],[0 1]);
textObjs = findobj(h,'Type','text');
oldStr = get(textObjs,{'String'});
val = get(textObjs,{'Extent'});
oldExt = cat(1,val{:});
Names = {'Sick(Classifier): ';'Healthy(classifier):'};
newStr = strcat(Names,oldStr);
set(textObjs,{'String'},newStr)
set(h(1),'FaceColor','y')
set(h(3),'FaceColor','r')



A1=length(find(Test_target==1));
B1=length(find(Test_target==0));
figure
p=pie([A1,B1],[0 1]);
textObjs = findobj(p,'Type','text');
oldStr = get(textObjs,{'String'});
val = get(textObjs,{'Extent'});
oldExt = cat(1,val{:});
Names = {'Sick(Dataset): ';'Healthy(Dataset):'};
newStr = strcat(Names,oldStr);
set(textObjs,{'String'},newStr)
set(p(1),'FaceColor','y')
set(p(3),'FaceColor','r')
 