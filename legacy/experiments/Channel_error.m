clear all;
close all;
clc;

% 加载数据
load('LOCAL_INPUT_FILE'); % 假定变量名为emg，此路径需根据实际情况调整

% 原始采样率和目标采样率
original_sampling_rate = 2000; % Hz
target_sampling_rate = 1000; % Hz

D_t = emg; % 使用加载的数据
[m, n] = size(D_t); % m为样本数，n为通道数

% 预处理：滤波和去均值
D_Filter = zeros(m, n);
D_Demean = zeros(m, n);
for i = 1:n
    [B1, A1] = butter(3, [20, 450] / (original_sampling_rate / 2), 'bandpass');
    D_Filter(:, i) = filtfilt(B1, A1, D_t(:, i));
    D_Demean(:, i) = D_Filter(:, i) - mean(D_Filter(:, i));
end

% 重采样
D_p = [];
if original_sampling_rate ~= target_sampling_rate
    for i = 1:n
        [P, Q] = rat(target_sampling_rate / original_sampling_rate);
        D_p(:, i) = resample(D_Demean(:, i), P, Q);
    end
else
    D_p = D_Demean;
end

% 选择信号片段和构建转换矩阵
N = target_sampling_rate * 5; % 分析每个5秒动作的信号长度
M = N / 2; % 观测值个数
Psi = dctmtx(N)'/sqrt(N); % 使用离散余弦变换矩阵作为转换基
Phi = double(rand(M, N) > 0.5) * 2 - 1; % 生成伯努利分布的测量矩阵
A = Phi * Psi; % 传感矩阵

% 多通道信号恢复
Y_multi = Phi * D_p(1:N, :); % 选择信号的一个片段进行恢复
[hat_y_multi, hat_y_norm_multi] = OMP_MMV(Y_multi, A, 1000, 2); % 使用提供的OMP_MMV进行多通道恢复
D_r_multi = Psi * hat_y_multi;
SNR_multi = calculate_snr(D_p(1:N, :), D_r_multi); % 计算多通道信噪比

% 单通道信号恢复和误差计算
SNR_single = zeros(n, 1);
for i = 1:n
    Y_single = Phi * D_p(1:N, i);
    [hat_y_single, hat_y_norm_single] = OMP_MMV(Y_single, A, 1000, 2); % 使用OMP_MMV进行单通道恢复
    D_r_single = Psi * hat_y_single;
    SNR_single(i) = calculate_snr(D_p(1:N, i), D_r_single); % 计算单通道信噪比
end

% SNR比较
SNR_avg_single = mean(SNR_single);
disp(['多通道SNR: ', num2str(SNR_multi)]);
disp(['单通道平均SNR: ', num2str(SNR_avg_single)]);

% 计算信噪比的辅助函数
function SNR = calculate_snr(D_original, D_reconstructed)
    SNR = 20 * log10(norm(D_original, 'fro') / norm(D_original - D_reconstructed, 'fro'));
end


