function cross_pop = crossing(pop, pc, thsld_len)
[row list] = size(pop);
% 多个交叉点的单点交叉
 
% 计算有多少个个体需要交叉
cross_mount = fix(row * pc) ;          % 向下取整
if rem( cross_mount,2) ~= 0            % 凑偶数 方便两两交叉
    cross_mount = cross_mount + 1;     % 由于开始向下取整，加1不担心越界
end
% 从种群总随机抽取cross_mount个个体进行交配
cross_num = randperm(row, cross_mount);% 从1~row中，选择cross_mount做不重复随机排列
% fprintf('cross_num:%s\n',num2str(cross_num));
% 进行两两交叉
for i = 1 : 2 : cross_mount
    % 每个阈值都单点交叉
    while 1
        % 每个阈值分量都进行不同程度单点交叉
        cross_pos = randi(thsld_len,1,list);
        % 将十进制编码成二进制
        x = dec2base(pop(cross_num(i), :), 2, thsld_len);     % 8位2进制表示的字符串数组
        y = dec2base(pop(cross_num(i + 1), :), 2, thsld_len);
        for j = 1 : list
            for k = cross_pos(j) : thsld_len
                temp = x(j,k);
                x(j,k) = y(j,k);
                y(j,k) = temp;
            end
        end
        % 将二进制转换成十进制
        pop(cross_num(i),:) = base2dec(x, 2)';
        pop(cross_num(i + 1),:) = base2dec(y, 2)';
        % 检查一个子代中有没有产生相同的阈值
        ux = length(pop(cross_num(i),:))-length(unique(pop(cross_num(i),:)));
        uy = length(pop(cross_num(i+1),:))-length(unique(pop(cross_num(i+1),:)));
        if ux == 0 && uy == 0 && sum(pop(cross_num(i),:)>256)==0 ...
                  && sum(pop(cross_num(i+1),:)>256)==0
            break;
        end
    end
%只有一个交叉点的单点交叉
%       while 1
%           r = randi(list * thsld_len,1);
%           %将十进制编码成二进制
%           x = dec2base(pop(cross_num(i),:),2,thsld_len);   %8位2进制表示的字符串数组
%           y = dec2base(pop(cross_num(i+1),:),2,thsld_len);
%           
%           cross_row = ceil(r/(thsld_len));
%           if rem(r,thsld_len) == 0
%               cross_list = thsld_len;
%           else
%               cross_list = rem(r,thsld_len);
%           end
% 
%           for j = cross_row:list
%               if j == cross_row   %将当前行的数据先交叉
%                   for k = cross_list:thsld_len
%                       temp = x(j,k);
%                       x(j,k) = y(j,k);
%                       y(j,k) = temp ;
%                   end
%               else
%                 for k = 1:thsld_len   %将其他行数据进行交叉
%                       temp = x(j,k);
%                       x(j,k) = y(j,k);
%                       y(j,k) = temp;
%                 end
%               end
%           end
% 
%           %将二进制转换成十进制
%           %检查一个子代中有没有产生相同的阈值
%           ux = length(pop(cross_num(i),:))-length(unique(pop(cross_num(i),:)));
%           uy = length(pop(cross_num(i+1),:))-length(unique(pop(cross_num(i+1),:)));
%           if ux == 0 && uy == 0 && sum(pop(cross_num(i),:)>256)==0 ...
%                   && sum(pop(cross_num(i+1),:)>256)==0
%               break;
%           end   
%       end
% end
cross_pop = pop;
end