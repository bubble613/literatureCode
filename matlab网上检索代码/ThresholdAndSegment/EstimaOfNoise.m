function varn=EstimaOfNoise(NI)
% ͼ��תΪdouble�ͺ���������
h1=fspecial('laplacian',0);%�˲���L1
h2=fspecial('laplacian',1);%�˲���L2
N=(h2-h1)*2;
imI=imfilter(NI,N);
%������������
varn=sum(abs(imI(:)))./(size(imI,1)-2)./(size(imI,2)-2)./6.*sqrt(pi/2);
varn=varn.^2;
end