function ii = calcu_ii(result, use)

    ii = 2;
    
    if use == 0

        for jj = 3 : 127

            if result(jj)<result(ii)
                ii = jj; 
            end
        end

    else

        for jj = 3 : 127

            if result(jj)<result(ii)

                ii = jj; 
            end
        end 
        
    end
    
end