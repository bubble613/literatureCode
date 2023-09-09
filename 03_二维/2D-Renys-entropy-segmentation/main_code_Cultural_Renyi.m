clear all;
% clc;
% close all;
I = imread('Norm_40_8.jpg');
figure,imshow(I),title('Original Image')

Number_of_levels = 8;

sgrays = double(I);
size_of_image = size(sgrays(:,:,1));
ssize_of_image = size(sgrays(:,:,1));

threshlevels = [];

n = 15;
for k=1:3
    E(k,:) = imhist(I(:,:,k));
    %%% threshold levels and minimum Entropy obtained
    [ values(k,:),Entp(k,:), xdata, ydata] = cultural_algorithm_Renyi(Number_of_levels,E(k,:))
    for i=1:Number_of_levels
        threshlevels(k,i) = threshExtractersc20(values(k,((i-1)*3)+1:3*i));
    end
    
    pE = E(k,:);
    figure,plot(pE),title('Probability Distribution Curve')
    xlabel('Pixel Values')
    ylabel('Respective values')
    hold on
    stem(threshlevels(k,:),(ones(1,length(threshlevels(k,:)))),'fill','r')
    hold off
end

for i=1:3
    figure();
    plot(xdata,ydata,'r','linewidth',2);
    
    grid on
    xlabel('Iteration Number');
    ylabel('Cultural Best');
    title('Cultural Algorithm');
end

fprintf('\nThe threshold values for %d levels:  \n',Number_of_levels)

threshlevels
%%------------------Segmenting out Image --------------------------%%
segimage = [];
for iv = 1:3
    for i=1:ssize_of_image(1)
        for j=1:ssize_of_image(2)
            if  sgrays(i,j,iv) <= threshlevels(iv,1)
                segimage(i,j,iv) = 0;
            end
        end
    end
    
    for t=2:Number_of_levels
        for i=1:ssize_of_image(1)
            for j=1:ssize_of_image(2)
                if  sgrays(i,j,iv) > threshlevels(iv,t-1) && sgrays(i,j,iv) <= threshlevels(iv,t)
                    segimage(i,j,iv) = threshlevels(iv,t-1);
                end
            end
        end
    end
    
    for i=1:ssize_of_image(1)
        for j=1:ssize_of_image(2)
            if  sgrays(i,j,iv) > threshlevels(iv,Number_of_levels) && sgrays(i,j,iv)< 256
                segimage(i,j,iv) = threshlevels(iv,Number_of_levels);
            end
        end
    end
end

main_image = uint8(segimage);
figure,imshow(main_image),title('Segmented Image')
imwrite(main_image,'whiteimage12.jpg');




