clear all;
close all;
clc

D=xlsread('LOCAL_INPUT_FILE');

D_t=D(1:3500,:);
X=[];
D_p=[];
D_Filter=[];
[m,n]=size(D_t);
for i=1:n
    [B1,A1] = butter(3,[0.005,0.45],'bandpass');   %定义带通滤波器参数
    D_Filter(:,i)= filtfilt(B1,A1,D_t(:,i));  %滤波
     %去均值
     D_mean(i)=mean(D_Filter(:,i));          %求均值
     D_Demean(:,i)=D_Filter(:,i)-D_mean(i);
     D_p(:,i)=resample(D_Demean(:,i),3072,m);
end


M=1536; %观测值个数     Nc
N=3072; %信号x的长度(固定)
K=800; %信号x的稀疏度
CF=M/N; %压缩率

%Psi=dctmtx(N)/sqrt(N);  %离散余弦变换矩阵
   [cc,rr]=meshgrid(0:N-1);
   Psi=sqrt(2/(N+1))*sin(pi*(cc+1).*(rr+1)/(N+1));
  Psi=eye(N);    %单位阵 
 Psi=DHartleyTmtx(N); 
Psi=dftmtx(N)/sqrt(N);  %离散傅里叶变换矩阵
%wtype='sym4';
%wlev=7;
% Psi = dwtmtx(N,wtype,wlev); %小波变换矩阵
% Psi=DWangTmtx(N,4);

%Phi=PartHadamardMtx(M,N); % 测量矩阵为部分阿达玛矩阵
%Phi=BernoulliMtx(M,N ); % 测量矩阵为伯努利矩阵
% Phi=ToeplitzMtx(M,N);   %托普利兹矩阵
 %Phi=CirculantMtx(M,N);   %循环矩阵
 Phi=SparseRandomMtx(M,N,16);%稀疏随机测量矩阵
%Phi=BPBDMtx(M,N);%二进制伪随机测量矩阵
% Phi=randn(M,N);%高斯随机矩阵
A=Phi*Psi;  %传感矩阵
Y=Phi*D_p;  %得到观测向量y


p=2;
J=1000;
tic;    % 在恢复信号处理之前开始计时

[hat_y,hat_y_norm] = OMP_MMV(Y,A,J,p);
% [hat_y] = SP_MMV(Y,A,J,K);
 D_r=Psi*hat_y; 
 
elapsedTime = toc;        % 停止计时并显示所需时间
disp(['恢复多通道信号处理所需时间为: ', num2str(elapsedTime), ' 秒']);

 SNR=20*log10(norm(D_p)/norm(D_p-D_r))
