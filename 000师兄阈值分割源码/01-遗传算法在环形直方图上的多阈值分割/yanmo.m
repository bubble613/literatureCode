function [result] = yanmo(image, I)
% 添加掩膜
    I = ~I;
    I = uint8(I) * 255;
    I(I == 255) = 1;
    mask = I;
    R=image(:,:,1);
    G=image(:,:,2);
    B=image(:,:,3);
    result(:,:,1)=R .* uint8(mask);
    result(:,:,2)=G .* uint8(mask);
    result(:,:,3)=B .* uint8(mask);
end

