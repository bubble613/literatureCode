clc;
clear;
close all;
A0=imread('/Users/liwangyang/Desktop/matlab_doc/图片集/lena_std.tif');
I = rgb2gray(imread('/Users/liwangyang/Desktop/matlab_doc/图片集/lena_std.tif'));

seed=[100,220];%选择起始位置
thresh=16;%相似性选择阈值
A=rgb2gray(A0);
A=imadjust(A,[min(min(double(A)))/255,max(max(double(A)))/255],[]);
A=double(A);
B=A;
[r,c]=size(B);%图像尺寸，r为行数，c为列数
n=r*c;%计算图像中所包含点的个数
pixel_seed=A(seed(1),seed(2));%原图起始点位置
q=[seed(1) seed(2)];%用q来装载起始位置
top=1;%循环判断flag
M=zeros(r,c);%建立一个与原图形同等大小的矩阵
M(seed(1),seed(2))=1;
count=1;%计数器
while top~=0 %循环结束条件
    r1=q(1,1);
    c1=q(1,2);
    p=A(r1,c1);
    dge=0;
    for i=-1:1
        for j=-1:1
            if r1+i<=r&&r1+i>0&&c1+j<=c&&c1+j>0
                if abs(A(r1+i,c1+j)-p)<=thresh&&M(r1+i,c1+j)~=1
                    top=top+1;
                    q(top,:)=[r1+i c1+j];
                    M(r1+i,c1+j)=1;
                    count=count+1;
                    B(r1+i,c1+j)=1;%满足判定条件将B中对应的点赋为1
                end
                if M(r1+i,c1+j)==0
                    dge=1;%将dge赋为1
                end
            else
                dge=1;%点在图像外，将dge赋为1
            end
        end
    end
    if dge~=1
        B(r1,c1)=A(seed(1),seed(2));%将原图像起始位置灰度值赋予B
    end
    if count >=n
        top =1;
    end
    q=q(2:top,:);
    top=top-1;
end
subplot(121)
imshow(A,[])
title('灰度图像')
subplot(122)
imshow(B,[])
title('区域生长法分割图像')

% qtdecomp函数可实现图像的四叉树分解
% S=qtdecomp(I,Threshold,[MinDim MaxDim])
% S=qtdecomp(I1,0.25);%其中0.25为每个方块所需要达到的最小差值
% I2=full(S);
% subplot(121);
% imshow(I1);
% title('原图像')
% subplot(122)
% imshow(I2)
% title('四叉树分解的图像')

% 得到稀疏矩阵S后，qtgetblk函数可进一步获得四叉树分解后所有指定大小的子块像素及位置信息
% [vals,r,c] = qtgetblk(I,S,dim);

S=qtdecomp(I, .26);%四叉树分解
blocks=repmat(uint8(0),size(S));%块
for dim=[512 256 128 64 32 16 8 4 2 1]
    numblocks=length(find(S==dim));
    if(numblocks>0)
        values=repmat(uint8(1),[dim dim numblocks]);
        values(2:dim,2:dim,:)=0;
        blocks=qtsetblk(blocks,S,dim,values);
    end
end
blocks(end,1:end)=1;
blocks(1:end,end)=1;
subplot(121)
imshow(I)
title('原始图像')
subplot(122)
imshow(blocks,[])
title('块状四叉树分解图像')


