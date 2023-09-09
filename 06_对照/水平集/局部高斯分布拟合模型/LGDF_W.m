function u=LGDF_W(u0,Img, Ksigma, nu,timestep,mu,epsilon, numIter)

%局部高斯分布拟合模型自定义函数实现。输入参数: u0--初始水平集函数; Img--待分割图像; Ksigma--局部高斯核函数; timestep--时间步长;
% nu--长度项参数; mu--正则化项参数; epsilon--光滑Heaviside函数参数; numIter--内循环次数

u=u0;
Hu=Heaviside(u,epsilon);
M(:,:,1)=Hu; M(:,:,2)=1-Hu;
N_class=size(M,3);

for kk=1:N_class
    
    K_M(:,:,kk)=conv2(M(:,:,kk),Ksigma,'same')+eps; %计算卷积Ksigma*M
    K_IM(:,:,kk)=conv2(Img.*M(:,:,kk),Ksigma,'same'); %计算卷积Ksigma*(Img·M)
    K_I2M(:,:,kk)=conv2((Img.^2).*M(:,:,kk),Ksigma,'same'); %计算卷积Ksigma*[Img^2·M]
    uiy(:,:,kk)=K_IM(:,:,kk)./K_M(:,:,kk); %更新局部均值
    sigma_2(:,:,kk)=((uiy(:,:,kk).^2).*K_M(:,:,kk)-2*uiy(:,:,kk).*K_IM(:,:,kk) + K_I2M(:,:,kk)) ./ K_M(:,:,kk) + eps; %更新局部方差
    K_logsigma2(:,:,kk)=conv2(0.5*log(sigma_2(:,:,kk)),Ksigma,'same'); %计算卷积Ksigma*log(sigma^2)
    K_sigma2_1(:,:,kk)=conv2(1./sigma_2(:,:,kk),Ksigma,'same'); %计算卷积Ksigma*(1/sigma^2)
    K_sigma2_ui(:,:,kk)=conv2(uiy(:,:,kk)./sigma_2(:,:,kk),Ksigma,'same'); %计算卷积Ksigma*(ui/sigma^2)
    K_sigma2_ui2(:,:,kk)=conv2((uiy(:,:,kk).^2)./sigma_2(:,:,kk),Ksigma,'same'); %计算卷积Ksigma*(ui^2/sigma^2)
    e(:,:,kk)=K_logsigma2(:,:,kk)+0.5*Img.*Img.*K_sigma2_1(:,:,kk)-Img.*K_sigma2_ui(:,:,kk) + 0.5*K_sigma2_ui2(:,:,kk); %计算ei
end

for kk=1:numIter
    
    u=NeumannBoundCond(u);%实现Neumann边界条件
    K=curvature_central(u);%散度项计算
    DiracU=Dirac(u,epsilon);%光滑Heaviside函数微分
    ImageTerm=-255*DiracU.*(e(:,:,1)-e(:,:,2));%拟合项
    penalizeTerm=mu*(4*del2(u)-K);%正则化项
    lengthTerm=nu.*DiracU.*K;%长度项
    %水平集函数更新
    u=u+timestep*(lengthTerm+penalizeTerm+ImageTerm);
end

function g = NeumannBoundCond(f) %Neumann边界条件子函数体实现
[nrow,ncol] = size(f);
g = f;
g([1 nrow],[1 ncol]) = g([3 nrow-2],[3 ncol-2]);
g([1 nrow],2:end-1) = g([3 nrow-2],2:end-1);
g(2:end-1,[1 ncol]) = g(2:end-1,[3 ncol-2]);

function k = curvature_central(u)
%散度项计算子函数体实现
[ux,uy] = gradient(u);
normDu = sqrt(ux.^2+uy.^2+1e-10);
Nx = ux./normDu;
Ny = uy./normDu;
[nxx,~] = gradient(Nx);
[~,nyy] = gradient(Ny);
k = nxx+nyy;

function h = Heaviside(x,epsilon)
%光滑Heaviside函数子函数体实现
h=0.5*(1+(2/pi)*atan(x./epsilon));

function f = Dirac(x, epsilon)
%光滑Heaviside函数微分子函数体实现
f=(epsilon/pi)./(epsilon^2.+x.^2);

