function phi = CV(phi,img,timestep,mu,nu,epsilon,lamda1,lamda2,iter)

%全局分片常数模型自定义函数实现
%输入参数说明：phi--初始水平集函数；img--待分割图像
% timestep--时间步长； mu--长度项参数
% nu--正则化项参数；epsilon--光滑Heaviside函数参数
% lamda1,lamda2--拟合项参数； iter--内循环次数

for i=1:iter
    phi = NeumannBoundCond(phi);%Neumann边界条件
    heavf=0.5.*(1+2/pi.*atan(phi./epsilon));%光滑Heaviside函数
    deltf=(epsilon/pi)./(epsilon^2.+phi.^2);%光滑Heaviside函数微分
    c1=sum(sum(img.*heavf))/sum(sum(heavf)+eps);%常数c1更新
    c2=sum(sum(img.*(1-heavf)))/sum(sum(1-heavf)+eps);%常数c2更新
    divphi=curvature_central(phi);%散度项计算
    region=deltf.*((-lamda1*(img-c1).^2)+lamda2*(img-c2).^2);%拟合项
    length=mu*deltf.*divphi;%长度项
    regu=nu*4*del2(phi)-divphi;%正则化项
    phi=phi+timestep*(region+length+regu);%水平集函数更新
end

%-- Neumann边界处理子函数
function g = NeumannBoundCond(f)
[nrow,ncol] = size(f);
g = f;
g([1 nrow],[1 ncol]) = g([3 nrow-2],[3 ncol-2]);
g([1 nrow],2:end-1) = g([3 nrow-2],2:end-1);
g(2:end-1,[1 ncol]) = g(2:end-1,[3 ncol-2]);

%--散度计算子函数
function k = curvature_central(u)
[ux,uy] = gradient(u);
normDu = sqrt(ux.^2+uy.^2+1e-10);
Nx = ux./normDu;
Ny = uy./normDu;
[nxx,~] = gradient(Nx);
[~,nyy] = gradient(Ny);
k = nxx+nyy; % 散度计算