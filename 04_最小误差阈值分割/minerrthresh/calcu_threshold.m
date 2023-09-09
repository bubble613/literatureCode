function calcu_threshold(ii, binMultiplier, image)

    % Compute threshold
    
    if nargout > 1

        stats.priorLeft = double(0);
        stats.alphaLeft = double(0);
        stats.priorRight = double(0);
        stats.alphaRight = double(0);

        for jj = 1:ii+1

            stats.priorLeft = stats.priorLeft + relativeFrequency(jj);
            stats.alphaLeft = stats.alphaLeft + jj*relativeFrequency(jj);
        end

        stats.alphaLeft = stats.alphaLeft / stats.priorLeft;

        for jj = ii+2 : num_histogramBins

            stats.priorRight = stats.priorRight + relativeFrequency(jj);
            stats.alphaRight = stats.alphaRight + jj*relativeFrequency(jj);
        end

        stats.alphaRight = stats.alphaRight / stats.priorRight;

        if useGaussian == 1

            stats.varLeft = double(0);
            for jj = 1:ii+1

                stats.varLeft = stats.varLeft + ...
                    (jj-stats.alphaLeft)^2 + relativeFrequency(jj);
            end

            stats.varLeft = stats.varLeft / stats.priorLeft;
            stats.stdLeft = sqrt(stats.varLeft);

            stats.varRight = double(0);

            for jj = ii+2 : num_histogramBins

                stats.varRight = stats.varRight + ...
                    (jj-stats.alphaRight)^2 + relativeFrequency(jj);
            end

            stats.varRight = stats.varRight / stats.priorRight;
            stats.stdRight = sqrt(stats.varRight);

            stats.alphaLeft = double(min(image(:))) + ...
                (stats.alphaLeft+1)/binMultiplier;

            stats.alphaRight = double(min(image(:))) + ...
                (stats.alphaRight+1)/binMultiplier;

            stats.stdLeft = stats.stdLeft / binMultiplier;
            stats.stdRight = stats.stdRight / binMultiplier;
        end
        
        varargout{1} = stats;
        
    end

end
