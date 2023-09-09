clear,
clc;

image = double(imread('hehua.jpeg'));

img = double(rgb2gray(image));

% thresh = minerrthresh(img) returns minimum error threshold for the input image
% thresh = minerrthresh(img,'Gaussian') will use Gaussian instead of Poisson model in determining the threshold
% thresh = minerrthresh(img,'bin',num) will use the bin number specified by
% num instead of the default, 128指定二进制
% [thresh, stats] = minerrthresh(img) will also return stastistics including the alpha values and prior probablities for foreground and background 

%---------------------------------------------------------------------------

% min_err_thresh(image ,varargin)

[num_histogramBins, errorFunction, use] = min_err_thresh(img,'Gaussian');

binMultiplier = double(num_histogramBins)/(max(img(:))-min(img(:)));

[relativeFrequency, totalMean] = His_Normalization(img, num_histogramBins);

[result] = Min_ErrThresh(num_histogramBins, relativeFrequency, use, totalMean);

ii = calcu_ii(result, use);

minErrorThreshold = double(min(img(:))) + ii/binMultiplier;

calcu_threshold(ii, binMultiplier, img)


