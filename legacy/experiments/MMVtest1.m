clear all;
close all;
clc

D=xlsread('LOCAL_INPUT_FILE');
D_t=D;
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
M=1500; %观测值个数
N=3072; %信号x的长度(固定)
K=800; %信号x的稀疏度
CF=M/N; %压缩率

Psi=dctmtx(N)/sqrt(N);
%     [cc,rr]=meshgrid(0:N-1);
%     Psi=sqrt(2/(N+1))*sin(pi*(cc+1).*(rr+1)/(N+1));
 % Psi=eye(N);    %单位阵 
% Psi=DHartleyTmtx(N); 
% Psi=dftmtx(N)/sqrt(N);  %离散傅里叶变换矩阵
% wtype='sym4';
% wlev=7;
% Psi = dwtmtx(N,wtype,wlev); %小波变换矩阵
% Psi=DWangTmtx(N,4);

% Phi=PartHadamardMtx(M,N); % 测量矩阵为部分阿达玛矩阵
Phi=BernoulliMtx(M,N ); % 测量矩阵为伯努利矩阵
% Phi=ToeplitzMtx(M,N);   %托普利兹矩阵
% Phi=CirculantMtx(M,N);   %循环矩阵
% Phi=SparseRandomMtx(M,N,16);
% Phi=BPBDMtx(M,N);
%Phi=randn(M,N);
A=Phi*Psi;  %传感矩阵
Y=Phi*D_p;  %得到观测向量y

p=1;
J=1000;
% [hat_y,hat_y_norm] = OMP_MMV(Y,A,J,p);
[hat_y] = OMP_MMV1(Y,A,J,K);
 D_r=Psi*hat_y; 
 SNR=20*log10(norm(D_p)/norm(D_p-D_r))