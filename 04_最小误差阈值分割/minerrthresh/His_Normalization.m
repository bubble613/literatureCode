function [relativeFrequency, totalMean] = His_Normalization(img, num_histogramBins)

if exist('histcounts')
    [relativeFrequency, edges] = histcounts(img,num_histogramBins,...
        'BinLimits', [min(img(:)),max(img(:))],'Normalization', 'probability');
else
    binRange = min(img(:)): range(img(:))/(num_histogramBins-1) : max(img(:));
    relativeFrequency = histc(img(:),binRange)/numel(img);
end

totalMean = sum((1: num_histogramBins).*relativeFrequency);