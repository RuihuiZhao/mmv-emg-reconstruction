clear all;
close all;
clc;

% 读取数据
D = xlsread("LOCAL_INPUT_FILE");
D_t = D(1:3500,:);
X = [];
D_p = [];
D_Filter = [];
[m, n] = size(D_t);

% 数据预处理
for i = 1:n
    [B1, A1] = butter(3, [0.005, 0.45], 'bandpass'); % 定义带通滤波器参数
    D_Filter(:, i) = filtfilt(B1, A1, D_t(:, i)); % 滤波
    
    % 去均值
    D_mean(i) = mean(D_Filter(:, i)); % 求均值
    D_Demean(:, i) = D_Filter(:, i) - D_mean(i);
    D_p(:, i) = resample(D_Demean(:, i), 5000, m);
end

% 设置参数
M = 2500; % 观测值个数
N = 5000; % 信号x的长度(固定)
K = 1000; % 信号x的稀疏度

% 构建传感矩阵和基
Psi = dftmtx(N) / sqrt(N); % 离散傅里叶变换矩阵
Phi = SparseRandomMtx(M, N, 16); % 稀疏随机测量矩阵
A = Phi * Psi; % 传感矩阵
Y = Phi * D_p; % 得到观测向量y

% 恢复信号
D_r = zeros(size(D_p)); % 预分配恢复后数据空间

tic; % 开始计时

for i = 1:n
    x_hat = CS_OMP(Y(:, i), A, K);
    D_r(:, i) = Psi * x_hat;
end

elapsedTime = toc; % 停止计时

% 显示恢复时间
disp(['恢复多通道信号处理所需时间为: ', num2str(elapsedTime), ' 秒']);




                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
% 计算指标
N = size(D_p, 1); % 信号长度
n = size(D_p, 2); % 通道数

% 初始化变量
MSE = zeros(1, n);
ERP = zeros(1, n);
SNR = zeros(1, n);

% 开始计算指标
for i = 1:n
    % MSE的计算
    numerator = norm(D_p(:, i) - D_r(:, i)); % 分子：误差向量的L2范数
    denominator = norm(D_p(:, i)); % 分母：原始信号向量的L2范数
    MSE(i) = (numerator / denominator) * 100; % 转换为百分比
    
    % ERP的计算
    ERP(i) = sum(abs(D_r(:, i)).^2) / sum(abs(D_p(:, i)).^2) * 100;

    % 调整SNR的计算方式以使用总能量
    signal_power = sum(abs(D_p(:, i)).^2); % 使用总信号能量
    noise_power = sum(abs(D_p(:, i) - D_r(:, i)).^2); % 使用总噪声能量
    SNR(i) = 10 * log10(signal_power / noise_power); % 计算当前通道的SNR
end

% 计算整体指标
overall_MSE = mean(MSE);
overall_ERP = mean(ERP);
overall_SNR = mean(SNR);

% 显示结果
disp(['整体均方误差 (MSE) 百分值为: ', num2str(overall_MSE, '%.2f'), '%']);
disp(['整体能量恢复百分比 (ERP) 为: ', num2str(overall_ERP, '%.2f'), '%']);
disp(['整体信噪比 (SNR) 为: ', num2str(overall_SNR, '%.2f'), ' dB']);
