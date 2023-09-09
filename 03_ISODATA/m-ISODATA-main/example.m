clc
clear
close all
rng(1);  % Seed for reproducibility
%
%% Simulation parameters
% Loading historical data
load('data/demand-2wind.mat', 'data');
X = data;
%
% options structure
options = struct(...
    'SimName', 'mISODATA_demand-2wind',...  % Simulation name used to save the scenarios in a .csv file
    'ResultsPath', 'results/',...  % Path to results folder
    'Display', 'off', ...  % No displays
    'SaveFlag', true);  % Flag to save scenarios data as a .csv file
%
%% Selecting series
% Series from Merrick paper are 1 demand, 3 wind and 7 solar
% so, to extract 1 demand and 2 wind historical series we need to extract
% series from 1 to 3

%% Calling m-ISODATA
[IDX, C, PROB, OUTPUT] = misodata(X, options);