function [result] = Min_ErrThresh(num_histogramBins, relativeFrequency, use, totalMean)

% Compute Minimum Error Threshold that minimizes the error criterion function

    for jj = 2:num_histogramBins-1

        % Compute current parameters for left(background) mixture components
        % use machine epsilon to avoid zero divisor
        priorLeft = eps; 
        meanLeft = double(0);
        varLeft = double(0);

        for ii = 1:jj

            priorLeft = priorLeft + relativeFrequency(ii);
            meanLeft = meanLeft + (ii-1)*relativeFrequency(ii);
        end

        meanLeft = meanLeft/priorLeft;

        for ii = 1:jj

            varLeft = varLeft + (ii-1-meanLeft)^2 * relativeFrequency(ii);
        end

        varLeft = varLeft/priorLeft;
        stdLeft = sqrt(varLeft)+eps;

        % Compute current parameters for right(foreground) mixture components
        % use machine epsilon to avoid zero divisor
        priorRight = eps; 
        meanRight = double(0);
        varRight = double(0);

        for ii = jj+1 : num_histogramBins

            priorRight = priorRight + relativeFrequency(ii);
            meanRight = meanRight + (ii-1)*relativeFrequency(ii);

        end

        meanRight = meanRight/priorRight;

        for ii = jj+1 : num_histogramBins
            varRight = varRight + (ii-1-meanRight)^2 * relativeFrequency(ii);
        end

        varRight = varRight/priorRight;
        stdRight = sqrt(varRight)+eps;

        % Compute values of error function at the current threshold (jj)

        if use == 0
            % 没有使用Gaussian Poison
            errorFunctionPois(jj) = totalMean...
                - priorLeft*(log(priorLeft)+meanLeft*log(meanLeft))...
                - priorRight*(log(priorRight)+meanRight*log(meanRight));
            result(jj) = errorFunctionPois(jj)
        else
            %使用Gaussian
            errorFunctionGaus(jj) = 1 + 2*...
                (priorLeft*log(stdLeft)+priorRight*log(stdRight))...
                - 2*(priorLeft*log(priorLeft)+priorRight*log(priorRight));
            result(jj) = errorFunctionGaus(jj)
        end
    end
end
