%Matlab计算信噪比，程序如下

function snr=SNR_function(I,In)

% 计算信号噪声比函数

% by Qulei

% I :original signal

% In:noisy signal(ie. original signal + noise signal)

% snr=10*log10(sigma2(I2)/sigma2(I2-I1))

[row,col,nchannel]=size(I);

snr=0;

if nchannel==1%gray image

Ps=sum(sum((I-mean(mean(I))).^2));%signal power

Pn=sum(sum((I-In).^2));%noise power

snr=10*log10(Ps/Pn);

elseif nchannel==3%color image

for i=1:3

Ps=sum(sum((I(:,:,i)-mean(mean(I(:,:,i)))).^2));%signal power

Pn=sum(sum((I(:,:,i)-In(:,:,i)).^2));%noise power

snr=snr+10*log10(Ps/Pn);

end

snr=snr/3;

end