clear all;
close all;
clc;

% 加载.mat文件
load('LOCAL_INPUT_FILE');  % 假定emg变量包含数据

% 原始采样率和目标采样率
original_sampling_rate = 2000;  % Hz
target_sampling_rate = 1000;  % Hz

D_t = emg(:,1:3);  % 使用加载的数据
[m, n] = size(D_t);  % m为样本数，n为通道数
D_Filter = zeros(m, n);
D_Demean = zeros(m, n);
D_p = [];  % 用于存储重采样后的数据

for i = 1:n
    [B1, A1] = butter(3, [20, 450] / (original_sampling_rate / 2), 'bandpass');  % 调整滤波器设计
    D_Filter(:, i) = filtfilt(B1, A1, D_t(:, i));  % 滤波
    D_Demean(:, i) = D_Filter(:, i) - mean(D_Filter(:, i));  % 去均值
    % 重采样
    if original_sampling_rate ~= target_sampling_rate
        [P, Q] = rat(target_sampling_rate / original_sampling_rate);
        D_p(:, i) = resample(D_Demean(:, i), P, Q);
    else
        D_p(:, i) = D_Demean(:, i);
    end
end

% 调整信号长度和观测值个数
N = target_sampling_rate * 5;  % 假设分析每个5秒动作的信号长度
M = N / 2;  % 观测值个数，这里假设压缩率为50%
K = 300;  % 假设的稀疏度，需要根据实际情况调整

Psi = dctmtx(N) / sqrt(N);  % 使用离散余弦变换矩阵作为转换基

%Phi = randn(M, N);  % 使用高斯随机矩阵作为测量矩阵
Phi = double(rand(M, N) > 0.5) * 2 - 1;  % 生成伯努利分布的测量矩阵

A = Phi * Psi;  % 传感矩阵

% 进行信号恢复
Y = Phi * D_p(1:N, :);  % 取信号的一个片段进行恢复，需要对每个片段重复此过程

% 调用 OMP_MMV 函数进行信号恢复
p = 2;  % 设置p范数为2
J = 1000;  % 迭代次数
[hat_y, hat_y_norm] = OMP_MMV1(Y, A, J, p);  % 使用OMP_MMV函数进行稀疏信号恢复


%[hat_y] = SP_MMV(Y, A, J, K);  % 使用适合的稀疏信号恢复算法
D_r = Psi * hat_y;  % 重构信号
SNR = 20 * log10(norm(D_p(1:N, :)) / norm(D_p(1:N, :) - D_r));  % 计算信噪比




