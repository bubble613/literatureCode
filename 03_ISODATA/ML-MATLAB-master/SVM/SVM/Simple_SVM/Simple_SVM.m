%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Saber Hosseini Moghaddam                        %
% Date : 1392/9/17                                %
% Classification Iris dataset using Simple SVM    %
% Pattern Recognition Course                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
clear
close all
load fisheriris %loading data set
xdata = meas(51:end,3:4);  %train data
group = species(51:end);   %Target data
svmStruct = svmtrain(xdata,group,'showplot',true); %Train data
species = svmclassify(svmStruct,[5 2],'showplot',true) %Classification
hold on;
plot(5,2,'ro','MarkerSize',12);

