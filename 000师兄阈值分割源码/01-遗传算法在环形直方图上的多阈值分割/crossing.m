function cross_pop = crossing(pop, pc, thsld_len)
[row list] = size(pop);
% ��������ĵ��㽻��
 
% �����ж��ٸ�������Ҫ����
cross_mount = fix(row * pc) ;          % ����ȡ��
if rem( cross_mount,2) ~= 0            % ��ż�� ������������
    cross_mount = cross_mount + 1;     % ���ڿ�ʼ����ȡ������1������Խ��
end
% ����Ⱥ�������ȡcross_mount��������н���
cross_num = randperm(row, cross_mount);% ��1~row�У�ѡ��cross_mount�����ظ��������
% fprintf('cross_num:%s\n',num2str(cross_num));
% ������������
for i = 1 : 2 : cross_mount
    % ÿ����ֵ�����㽻��
    while 1
        % ÿ����ֵ���������в�ͬ�̶ȵ��㽻��
        cross_pos = randi(thsld_len,1,list);
        % ��ʮ���Ʊ���ɶ�����
        x = dec2base(pop(cross_num(i), :), 2, thsld_len);     % 8λ2���Ʊ�ʾ���ַ�������
        y = dec2base(pop(cross_num(i + 1), :), 2, thsld_len);
        for j = 1 : list
            for k = cross_pos(j) : thsld_len
                temp = x(j,k);
                x(j,k) = y(j,k);
                y(j,k) = temp;
            end
        end
        % ��������ת����ʮ����
        pop(cross_num(i),:) = base2dec(x, 2)';
        pop(cross_num(i + 1),:) = base2dec(y, 2)';
        % ���һ���Ӵ�����û�в�����ͬ����ֵ
        ux = length(pop(cross_num(i),:))-length(unique(pop(cross_num(i),:)));
        uy = length(pop(cross_num(i+1),:))-length(unique(pop(cross_num(i+1),:)));
        if ux == 0 && uy == 0 && sum(pop(cross_num(i),:)>256)==0 ...
                  && sum(pop(cross_num(i+1),:)>256)==0
            break;
        end
    end
%ֻ��һ�������ĵ��㽻��
%       while 1
%           r = randi(list * thsld_len,1);
%           %��ʮ���Ʊ���ɶ�����
%           x = dec2base(pop(cross_num(i),:),2,thsld_len);   %8λ2���Ʊ�ʾ���ַ�������
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
%               if j == cross_row   %����ǰ�е������Ƚ���
%                   for k = cross_list:thsld_len
%                       temp = x(j,k);
%                       x(j,k) = y(j,k);
%                       y(j,k) = temp ;
%                   end
%               else
%                 for k = 1:thsld_len   %�����������ݽ��н���
%                       temp = x(j,k);
%                       x(j,k) = y(j,k);
%                       y(j,k) = temp;
%                 end
%               end
%           end
% 
%           %��������ת����ʮ����
%           %���һ���Ӵ�����û�в�����ͬ����ֵ
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