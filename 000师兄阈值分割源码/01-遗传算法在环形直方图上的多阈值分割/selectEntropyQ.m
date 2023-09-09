function [q] = selectEntropyQ(pixelCount)
% 函数功能：根据q冗余得出线性直方图的最佳q值
% 返回值说明：
%   q：Tsallis Entropy的熵参数
%-------------------------------------------------------------------------

% 函数调用示例：q = selectEntropyQ(pixelCount);

    % 1、以0.01为步长，从0循环到10，选择使得熵冗余最大的q值
    i = 1;
    for q = 0 : 0.01 : 10
        %   1.1、注意，当q=1时，Tsallis Entropt退化为Boltzmann–Gibbs Entropy
        if q == 1
            temp = pixelCount .* log(pixelCount);
            temp(isnan(temp)) = 0;
            temp(isinf(temp)) = 0;
            ST(i) = -sum(temp);
            %   1.2、当q=1时，最大熵为一个定值，具体可从数学公式上进行推导
            ST_MAX(i) = log(256);
        else
            %   1.3、其余q!=1时，则还是按照Tsallis Entropy进行计算
            ST(i) = (1 - sum(power(pixelCount(:), q))) / (q - 1);
            %   1.4、q!=1时，最大熵则是一个随着q值变化的函数
            ST_MAX(i) = (1 - power(256, 1 - q)) / (q - 1);
        end
        
        %   1.5、保留每一个q值下的熵冗余
        RT(i) = 1 - (ST(i) / ST_MAX(i));
        i = i + 1;
    end

    % 2、得出最大熵冗余对应的索引并将索引转化为对应的q值
    [RT_MAX_Value, RT_MAX_Level] = max(RT);
    q = (RT_MAX_Level - 1) / 100;
end

