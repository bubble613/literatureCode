function u = RSF_Li(u0,Img,Ksigma,nu,timestep,mu,lambda1,lambda2,epsilon,numIter)
%局部分片常数模型自定义函数实现
%输入参数: u0--初始水平集函数; Img--待分割图像; Ksigma--局部高斯核函数; timestep--时间步长;
% nu--长度项参数; mu--正则化项参数; numIter--内循环次数; lamda1,lamda2--拟合项参数
% epsilon--光滑Heaviside函数参数
u=u0;
KI=conv2(Img,Ksigma,'same'); % 计算卷积（K*Img）
KONE=conv2(ones(size(Img)),Ksigma,'same'); %计算卷积（K*1）
for k1=1:numIter
    u=NeumannBoundCond(u);%Neumann边界条件
    K=curvature_central(u);%散度项计算
    DrcU=(epsilon/pi)./(epsilon^2.+u.^2);%光滑Heaviside函数微分
    [f1, f2] = localBinaryFit(Img, u, KI, KONE, Ksigma, epsilon);%局部分片常数更新
    s1=lambda1.*f1.^2-lambda2.*f2.^2; s2=lambda1.*f1-lambda2.*f2;
    dataForce=(lambda1-lambda2)*KONE.*Img.*Img+conv2(s1,Ksigma,'same') - 2.*Img.*conv2(s2,Ksigma,'same');
    A=-DrcU.*dataForce;%计算拟合项
    P=mu*(4*del2(u)-K);%正则化项
    L=nu.*DrcU.*K;%长度项
    u=u+timestep*(L+P+A);%水平集函数更新
end
function [f1, f2]= localBinaryFit(Img, u, KI, KONE, Ksigma, epsilon)
%局部分片常数计算子函数
Hu=0.5*(1+(2/pi)*atan(u./epsilon));%光滑Heaviside函数
I=Img.*Hu;
c1 = conv2(Hu,Ksigma,'same'); c2=conv2(I,Ksigma,'same');
f1=c2./(c1); f2=(KI-c2)./(KONE-c1);
function g = NeumannBoundCond(f)
% Neumann边界条件子函数
[nrow,ncol] = size(f); g = f;
g([1 nrow],[1 ncol]) = g([3 nrow-2],[3 ncol-2]);
g([1 nrow],2:end-1) = g([3 nrow-2],2:end-1);
g(2:end-1,[1 ncol]) = g(2:end-1,[3 ncol-2]);
function k = curvature_central(u)
%散度项计算子函数
[ux,uy] = gradient(u); normDu = sqrt(ux.^2+uy.^2+1e-10);
Nx = ux./normDu; Ny = uy./normDu;
[nxx,~] = gradient(Nx); [~,nyy] = gradient(Ny);
k = nxx+nyy;
