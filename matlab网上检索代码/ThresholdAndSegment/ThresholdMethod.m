function T = ThresholdMethod(I,varargin)
% reference:Sezgin M, Sankur B. Survey over image thresholding techniques
% and quantitative performance evaluation[J]. 
% Journal of Electronic Imaging, 2004, 13(1): 146-168.

p_names = { 'Method', 'FuzzinessIndex','MaxInterNum',...
            'Threshold','HistogramLevel','ClusterNum'};
        
defaults =  {'Cluster_Jawahar1',2,500,10e-9,256,2}; %默认参数

[Method, FuzzinessIndex, MaxInterNum, Threshold, HistogramLevel, ClusterNum] ...
                = internal.stats.parseArgs(p_names, defaults, varargin{:});
            
MethodNames = {'Cluster_Jawahar1','Cluster_Jawahar2',...
                'Cluster_Lloyd','Cluster_Ostu',...
                'Cluster_Kittler','Cluster_EM',...
                'Entropy_Kapur','Entropy_Yen'};
 
Method = internal.stats.getParamVal(Method, MethodNames, '''Method''');

Trange = 0 : HistogramLevel-1;
X = reshape(I, [], 1);
% hg = histogram(X, Trange); %图像中每种灰度级像素个数
hg = hist(X, Trange); 
pg = hg ./ sum(hg, 1); %每种灰度级在图像中的概率
Ti = 0; 
JT = zeros(length(Trange), 1);

switch Method
    case 'Cluster_Ostu'
        [~,~,T] = otsu(I, ClusterNum);
        
    case 'Cluster_Kittler'
        T = Cluster_Kittler(X, Trange);
        
    case 'Cluster_EM'
        [Tp, train] = EM_CD(X, MaxInterNum, Threshold);
        T = Tp(Tp >= min(train.mean) & Tp <= max(train.mean));
        
    case 'Cluster_Lloyd'
        T = Cluster_Lloyd(X, Trange);
        
    case 'Cluster_Jawahar1'
        InterNum=0;
        
        %intialization thresholded description
        uf = rand(1, length(Trange)); % 随机生成1 x 256 介于0到1之间均匀分布的随机数组
        % ub = bsxfun(@minus,1,uf); %对两个数组应用按元素运算
        ub = 1 - uf; % 
        uf_last = uf + 1; 
        ub_last = ub + 1;
        while(min(abs(uf_last - uf)) > Threshold || min(abs(ub_last - ub)) > Threshold)
            InterNum = InterNum + 1;
            fprintf('--------------the %d interation--------------------\n', InterNum);
            %             update mean of forground mf and background mb 
            mf = sum(Trange .* pg .* uf) ./ sum(pg .* uf); % 目标像素均值
            mb = sum(Trange .* pg .* ub) ./ sum(pg .* ub); % 背景像素均值
            %             update Euclidean distance between gray value and mean for
            %             forground df and backgound db
            %             前景和背景的灰度值和其均值的欧几里得距离
            df = (Trange - mf).^2;
            db = (Trange - mb).^2;
            uf_last = uf;
            ub_last = ub;
            %             update fuzzyindex of forground uf and background ub
            %             note that fuzzyindex>=2 and when fuzzyindex==1 this method
            %             is equal to kmeans cluster   
            uf = 1 ./ (1 + (df ./ db) .^ (2/(FuzzinessIndex - 1)));
            ub = 1 - uf;
            if InterNum > MaxInterNum
                printf('Interitation is up to MaxNum!')
                break;
            end
        end
        [~, Tind] = min(abs(uf - 0.5));
        T = Trange(Tind);
        
    case 'Cluster_Jawahar2'
        InterNum = 0;
        %intialization thresholded description
        uf = rand(1,length(Trange));
        ub = bsxfun(@minus,1,uf);
        uf_last = uf+1;
        ub_last = ub+1;
        while(min(abs(uf_last - uf)) > Threshold || min(abs(ub_last - ub)) > Threshold)
            InterNum = InterNum + 1;
            fprintf('--------------the %d interition--------------------\n',InterNum);
            %             update mean of forground mf and background mb
            mf = sum(Trange .* pg .* uf) ./ sum(pg .* uf);
            mb = sum(Trange .* pg .* ub) ./ sum(pg .* ub);
            betaf = sum(pg .* uf) ./ sum(pg .* (uf + ub));
            betab = sum(pg .* ub) ./ sum(pg .* (uf + ub));
            thetaf2 = sum(pg .* uf .* (Trange - mf).^2) ./ sum(uf .* pg);
            thetab2 = sum(pg .* ub .* (Trange - mb).^2) ./ sum(ub .* pg);
            %             update Euclidean distance between gray value and mean for
            %             forground df and  backgound db
            df = (pg-mf).^2 ./ thetaf2 ./ 2 + log10(sqrt(thetaf2)) - log10(betaf);
            db = (pg-mb).^2 ./ thetab2 ./ 2 + log10(sqrt(thetab2)) - log10(betab);
            uf_last = uf;
            ub_last = ub;
            %             update fuzzyindex of forground uf and background ub
            %             note that fuzzyindex>=2 and when fuzzyindex==1 this method
            %             is equal to kmeans cluster
            uf = 1 ./ (1 + (df ./ db) .^ (2 / (FuzzinessIndex - 1)));
            ub = 1 - uf;
            if InterNum > MaxInterNum
                printf('Interitation is up to MaxNum!')
                break;
            end
        end
        %           Tind=ismember(uf,ub);
        [~, Tind] = min(abs(uf - 0.5));
        T = Trange(Tind);
        
    case 'Entropy_Kapur'
        T=Entropy_Kapur(X,Trange);
        
    case 'Entropy_Yen'
        T=Entropy_Yen(X,Trange);
end
end