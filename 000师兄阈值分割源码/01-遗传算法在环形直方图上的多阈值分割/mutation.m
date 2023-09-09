function muta_pop = mutation(pop,pm,thsld_len)
[row list] = size(pop);
muta_mount = ceil(row * list * thsld_len * pm);   %�����ܹ�Ҫ����Ķ�����λ��
muta_num = randperm(row * list * thsld_len,muta_mount);
 
for i = 1 : muta_mount
    % muta_num(i)
    muta_row = ceil(muta_num(i) / (list * thsld_len));
    if rem(muta_num(i),list * thsld_len) == 0
        muta_list = list;
    else
        muta_list = ceil(rem(muta_num(i),list * thsld_len) / thsld_len);
    end
    %         
    % ��ʮ���Ʊ���ɶ�����
    z = dec2base(pop(muta_row,muta_list),2,thsld_len);   %8λ2���Ʊ�ʾ���ַ�������
    if rem(muta_num(i),list * thsld_len) == 0
        muta_bit = thsld_len;
    else
        muta_bit = rem(muta_num(i),list * thsld_len) - (muta_list-1) * thsld_len;
    end
    while 1
        if z(muta_bit) == '0'
            z(muta_bit) = '1';
        else
            z(muta_bit) = '0';
        end
        pop(muta_row,muta_list) = base2dec(z,2);
        %�������һ����������û����ͬ����ֵ
        uz = length(pop(muta_row,:))-length(unique(pop(muta_row,:)));
        if uz == 0 && sum(pop(muta_row,:)>256)==0
            break;
        else
            muta_bit = randi(thsld_len,1);
        end
    end
end
muta_pop = pop;
end