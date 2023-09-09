%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Saber Hosseini Moghaddam                        %
% Date : 1392/9/26                                %
% Clustering of Iris flower Dataset using ISODATA %
% Pattern Recognition Course                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc,
close all
clear

load fisheriris;
Data=meas; % Data
TARGET=[zeros(50,1) ones(50,1)  zeros(50,1)
       ;zeros(50,1) zeros(50,1) ones(50,1)
       ;ones(50,1)  zeros(50,1) zeros(50,1)]; %Target vector in Matrix format
   
%Prameters Based on Power point
%{
Sigma_2_s  ====> Max seperation
N_D        ====> number of clusters (approximate)
N_Min_Ex   ====> Min number of data in each cluster
D_Merg     ====> Min distance for cluster Merging
N          ====> Max number of combining Clusters
%}
sima_s_2=0.4; 
N_D=3; 
N_Min_Ex=30; 
D_Merg=1; 
N=5; 
iteration_Number=0; 
%Step-1: initialize clusters
Nc=6; %initialize number of clusters
Nc_old=6; %initialize new number of clusters in each iteration
u=Data(1:Nc,:); %initialize means of clusters
Nk=zeros(1,Nc); %column of Nk is number of data in each cluster
combine=zeros(1,Nc); %which clusters are combined
%
while iteration_Number<20

iteration_Number=iteration_Number+1;disp...
    (['iteration [',num2str(iteration_Number),']:'])
%Step-2: K-means clustering
%We can use MATLAB K-means or our function based on last exercise or we can write
%new codes
Nc_old=Nc;
bit2=1;
r=zeros(150,Nc);
          for n=1:150
              d=zeros(1,Nc);
                      for j=1:Nc
                         d(j)=norm(Data(n,:)-u(j,:));
                      end
                      [value column]=min(d); %minimum distance
                      r(n,column)=1; %150 * binary code
         end
Nk=sum(r);
%Step-3: delet clusters those have data less than N_Min_Ex
         while(1)
              disp(['number of data in each cluster: '...
                  ,num2str(Nk)])
              [num cluster]=min(Nk);
              if num<N_Min_Ex
              u=[u(1:(cluster-1),:) %delet cluster mean
              u((cluster+1):Nc,:)];
              Nc=Nc-1; %decrease number of clusters
              u=u(1:Nc,:); %define new mean matrix
              n1=Nk(cluster);
              Nk(cluster)=[];
%reassignment deleted cluster data to other clusters by K-means:
              data=find(r(:,cluster)==1);
              r(:,cluster)=[];
              for n=1:n1
                  d=zeros(1,Nc);
                  for k=1:Nc
                      d(k)=norm(Data(data(n))-u(k,:));
                  end
                  [value column]=min(d);
                   Nk(column)=Nk(column)+1;
                   r(data(n),column)=1;
              end
              else
      break
              end
            end
%Step-4: calculating means
              for k=1:Nc
              data=find(r(:,k)==1); %select data in 
              sumx=zeros(1,4);
              for j=1:Nk(k)
              sumx=sumx+Data(data(j),:);
              end
              u(k,:)=(1/Nk(k))*sumx; %calculation cluster mean
              end
%calculating dk & davg Based on Power Point
d_k=zeros(1,k);
d_Avg=0;
              for k=1:Nc
              sum1=0;
              data=find(r(:,k)==1); %select data in the selected cluster
              for j=1:Nk(k)
              sum1=norm(Data(data(j),:)-u(k,:))+sum1;
              end
              d_k(k)=(1/Nk(k))*sum1;
              d_Avg=d_Avg+Nk(k)*d(k);
              end
              d_Avg=d_Avg/150;
%Step-5 Seperation of clusters
a=zeros(1,Nc);
sigma_max=zeros(1,Nc);
sigma=zeros(Nc,4);
   for k=1:Nc
   if (Nc<=2 || (Nk(k)>2*N_Min_Ex+1 && d_k(k)>d_Avg))
   s1=zeros(1,4);
   sum1=0;
   data=find(r(:,k)==1); %select data
   sigma(k,:)=var(Data(data,:));
   [sigma_max(k) a(k)]=max(sigma(k,:));
         if sigma_max(k)>sima_s_2
            u(k,a(k))=u(k,a(k))+0.5*sigma_max(k);
            Nc=Nc+1;
            u(Nc,:)=u(k,:);
            u(Nc,a(k))=u(k,a(k))-sigma_max(k);
            combine(Nc)=0;
          r=zeros(150,Nc);
          for i=1:150
           d=zeros(1,Nc);
          for j=1:Nc
          d(j)=norm(Data(i,:)-u(j,:));
          end
          [value column]=min(d); %minimum distance
          r(i,column)=1; %150 * binary code
          end
          Nk=sum(r);
         end
   end
        end
%Step-6:
     if Nc>N_D
        D=zeros(Nc,Nc); 
          Dsort=zeros(Nc^2,2); 

           for i=1:Nc
               for j=1:Nc
                  D(i,j)=norm(u(i,:)-u(j,:));
               end
           end

D_D=D;
           for i=1:Nc^2
           [vals rows]=max(D_D);
           [Dmax column]=max(vals);
           row=rows(column);
           D_D(row,column)=0;
           Dsort(i,:)=[row column];
           end
%check distances
           for c=1:Nc^2
           i=Dsort(c,1);
           j=Dsort(c,2);
           if D(i,j)<D_Merg && combine(i)==0 && combine(j)==0
           combine(i)=1;combine(j)=[];
           u_new=Nk(i)*u(i,:)+Nk(j)*u(j,:); 
           u_new=u_new/(Nk(i)+Nk(j)); 
           u(i,:)=u_new;
           u(j,:)=[];
           Nc=Nc-1;
           end
           end
     end
if Nc==Nc_old
break
end
end

%Evaluate Conditional Entropy:
Prior=zeros(1,3); %prior probabilities 
Joint_probability=zeros(3,3); %joint probabilities 
H=0; 
Prior(1)=sum(r(:,2));
Prior(2)=sum(r(:,3));
Prior(3)=sum(r(:,1));
for c=1:3
    for k=1:3
        Joint_probability(c,k)=sum(sum (r(50*(c-1)+1:50*c,:)...
            & TARGET(50*(k-1)+1:50*k,:)) );
        if Joint_probability(c,k)~=0
        H=H+ (Joint_probability(c,k)/150) * log10(Joint_probability(c,k)/Prior(k));
        end
    end
end
    H=-1*H;
    disp(['Conditional Entropy= ',num2str(H)])