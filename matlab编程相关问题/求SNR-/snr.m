I=imread('/Users/liwangyang/Desktop/matlab_doc/图片集/lena_std.tif');%单引号里面是图片的绝对位置
I=rgb2gray(I);%彩色转灰度

% 把加噪声的图像减去原图得到噪声，然后两幅图比较得到信噪比
In=imread('/Users/liwangyang/Desktop/matlab_doc/图片集/lena_std.tif');
In=rgb2gray(In);
In1=imread('/Users/liwangyang/Desktop/matlab_doc/图片集/lena_std.tif');
In1=rgb2gray(In1);
 function snr=SNR1(I,In)
 
    [row,col,nchannel]=size(I);
    snr=0;
    if nchannel==1%gray image
    Ps=sum(sum((I-mean(mean(I))).^2));%signal power
    Pn=sum(sum((I-In).^2));%noise power
    snr=10*log10(Ps/Pn)
    elseif nchannel==3%color image
        for i=1:3
            Ps=sum(sum((I(:,:,i)-mean(mean(I(:,:,i)))).^2));%signal power
            Pn=sum(sum((I(:,:,i)-In(:,:,i)).^2));%noise power
            snr=snr+10*log10(Ps/Pn);
        end
        snr=snr/3;
     end
 end