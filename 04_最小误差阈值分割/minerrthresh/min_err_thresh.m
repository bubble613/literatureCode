function [num_histogramBins, errorFunction, use] = min_err_thresh( img,varargin )

if any(strcmpi(varargin,'bin'))
    
    num_histogramBins = varargin{find(strcmpi(varargin,'bin'))+1};
    
else
    
    num_histogramBins = 128;
    
end

if any(strcmpi(varargin,'Gaussian'))
    
    errorFunctionGaus = zeros(num_histogramBins);
    errorFunction = errorFunctionGaus;
    useGaussian = 1;
    use = useGaussian;
else
    
    errorFunctionPois = zeros(num_histogramBins);
    errorFunction = errorFunctionPois;
    useGaussian = 0;
    use = useGaussian;
end