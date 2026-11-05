clear all;
close all;
clc

D=xlsread(["LOCAL_INPUT_FILE"]);
D_t=D(1:5000,:);%取前3500行数据
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
     D_p(:,i)=resample(D_Demean(:,i),5000,m);
end
M=2500; %观测值个数
N=5000; %信号x的长度(固定)
K=1000; %信号x的稀疏度
CF=M/N; %压缩率


%Psi=dctmtx(N)/sqrt(N);  %离散余弦变换矩阵
   [cc,rr]=meshgrid(0:N-1);
Psi=sqrt(2/(N+1))*sin(pi*(cc+1).*(rr+1)/(N+1));%离散正弦矩阵
%Psi=eye(N);    %单位阵 
%Psi=DHartleyTmtx(N);   %离散哈特利变换
%Psi=dftmtx(N)/sqrt(N);  %离散傅里叶变换矩阵
 %wtype='sym4';
 %wlev=7;
%Psi = dwtmtx(N,wtype,wlev); %小波变换矩阵
%Psi=DWangTmtx(N,4);

%Phi=PartHadamardMtx(M,N); % 测量矩阵为部分阿达玛矩阵
%Phi=BernoulliMtx(M,N ); % 测量矩阵为伯努利矩阵
% Phi=ToeplitzMtx(M,N);   %托普利兹矩阵
% Phi=CirculantMtx(M,N);   %循环矩阵
% Phi=SparseRandomMtx(M,N,16);%稀疏随机矩阵
 Phi=BPBDMtx(M,N);
% Phi=randn(M,N);%高斯随机矩阵

A=Phi*Psi;  %传感矩阵
Y=Phi*D_p;  %得到观测向量y

tic;    % 在恢复信号处理之前开始计时

p=1;
J=1000;
[hat_y,hat_y_norm] = OMP_MMV(Y,A,J,p);
% [hat_y] = SP_MMV(Y,A,J,K);

elapsedTime = toc;        % 停止计时并显示所需时间
disp(['恢复多通道信号处理所需时间为: ', num2str(elapsedTime), ' 秒']);

D_r=Psi*hat_y; 
 %SNR=20*log10(norm(D_p)/norm(D_p-D_r))


%SNR计算
%  D_p 为原始信号矩阵, D_r 为重构信号矩阵
% 原始信号和重构信号的行数N代表信号长度，列数代表通道数
N = size(D_p, 1); % 信号长度
n = size(D_p, 2); % 通道数
% 初始化SNR变量
SNR = zeros(1, n);
% 对每个通道计算SNR
for i = 1:n
    signal_power = sum(abs(D_p(:, i)).^2); % 使用绝对值处理复数
    noise_power = sum(abs(D_p(:, i) - D_r(:, i)).^2); % 使用绝对值处理复数
    SNR(i) = 10 * log10(signal_power / noise_power); % 计算当前通道的SNR
end
% 计算整体SNR
overall_SNR = mean(SNR); % 对所有通道的SNR取平均
% 显示结果
disp(['整体信噪比 (SNR) 为: ', num2str(overall_SNR), ' dB']);


%MSE计算
% 原始信号和重构信号的行数N代表信号长度，列数代表通道数
N = size(D_p, 1); % 信号长度
n = size(D_p, 2); % 通道数
% 初始化MSE变量
MSE = zeros(1, n);
% 对每个通道计算MSE
for i = 1:n
    % 确保在计算误差的平方和时，使用绝对值避免复数影响
    numerator = sqrt(sum(abs(D_p(:, i) - D_r(:, i)).^2)); % 分子：误差的平方和的平方根
    denominator = sqrt(sum(abs(D_p(:, i)).^2)); % 分母：原始信号的功率的平方根
   MSE(i) = (numerator / denominator) * 100; % 计算当前通道的MSE，并转换为百分比
end
% 计算整体MSE
overall_MSE = mean(MSE); % 对所有通道的MSE取平均
% 显示结果
disp(['整体均方误差 (MSE) 百分值为: ', num2str(overall_MSE), '%']);







% ERP计算
% 原始信号和重构信号的行数N代表信号长度，列数代表通道数
N = size(D_p, 1); % 信号长度
n = size(D_p, 2); % 通道数
% 初始化ERP变量
ERP = zeros(1, n);
% 对每个通道计算ERP
for i = 1:n
    recovered_energy = sum(abs(D_r(:, i)).^2); % 重构信号的能量
    original_energy = sum(abs(D_p(:, i)).^2); % 原始信号的能量
    ERP(i) = (recovered_energy / original_energy) * 100; % 计算当前通道的ERP，并转换为百分比
end
% 计算整体ERP
overall_ERP = mean(ERP); % 对所有通道的ERP取平均
% 显示结果
disp(['整体能量恢复百分比 (ERP) 为: ', num2str(overall_ERP), '%']);

