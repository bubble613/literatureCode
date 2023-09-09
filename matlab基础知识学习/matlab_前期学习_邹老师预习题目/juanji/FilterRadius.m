function [ mF, nF, half_mF, half_nF ] = FilterRadius( filter )
%功能：
%   获取滤波器的维数信息
%输入参数： 
%   filter：滤波器
%输出参数： 
%   mF：高度
%   nF：宽度
%   half_mF：高度一半
%   half_nF：宽度一半
[mF, nF] = size( filter );
half_mF = ceil(mF / 2);
half_nF = ceil(nF / 2);